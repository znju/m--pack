function [fcdl,fnc] = ncep_genfrc(type,grid,file,tstart,tend,pos,L,label,nc,fig)
%NCEP_GENFRC   Create NetCDF ROMS bulk forcing file
%
%   Syntax:
%      [FCDL,FNC] = NCEP_GENFRC(TYPE,GRID,FILE,TSTART,TEND,POS,L,LABLE,NC)
%
%   Inputs:
%      TYPE     Type of bulk flux forcing you want:
%                - wind
%                - cloud
%                - radiation
%                - humidity
%                - pressure
%                - precipitation
%                - temperature
%      GRID     The NetCDF grid file
%      FILE     NCEP NetCDF file; some forcings need more than one file,
%               like wind (required wind-u and wind-v files) and radiation;
%               in that case, use {file1,file2,... filen}
%      TSTART   Start date string [ <'D-M-Y'> ]
%      TEND     End date string [ <'D-M-Y'> ]
%      POS      Location around which data will be extracted [ <lon lat>]
%      L        Lxtracted square of data has side 2*L(1)+1 by 2*L(2)+1,
%               so data has range i-L(1):i+L(1),j-L(2):j+L(2), being
%               i (W-E) and j (S-N) location indices near POS
%      LABEL    Label to forcing files, as wind_label_nc
%      NC       NetCDF ncgen executable
%      FIG      If 1, some data is shown  [ {1} 0 ]
%               (data is plotted at tindice=1, and region average
%               time series is also shown)
%
%   Outputs:
%      FCDL   NetCDF cdl filename
%      FNC    NetCDF filename created
%
%   Example:
%      type = 'wind';
%      grid = '/home/user/ocean_grd.nc';
%      file = {'../uwnd.10m.gauss.1995.nc', '../vwnd.10m.gauss.1995.nc'};
%      tstart = '1-Feb-1995';
%      tend   = '1-Apr-1995';
%      pos    = [-9 41];
%      L=[3 3];
%      label = 'frc';
%      nc = '/usr/local/NetCDF/bin/ncgen';
%      ncep_genfrc(type,grid,file,tstart,tend,pos,L,label,nc)
%
%   MMA 5-2004, martinho@fis.ua.pt
%
%   See also NCEP_GENCDL, NCEP_VAR2GRID, NCEP_GEN

%   Department of Physics
%   University of Aveiro, Portugal

%   **-10-2004 - Some small changes
%   31-01-2005 - Rotate wind for curvilinear grids

eval('fig=fig;','fig = 1;'); % show some figures (used by func ncep_var2grid)

files = file; % needed if more than one

year = ''; % not needed
Y=num2str(year);

[ncep,ftp] = ncep_settings(Y,type);

time = [];
v    = [];
for i = 1:length(ncep)
  time_prev = time;
  v_prev    = v;

  var    = ncep(i).var;
  eval('file   = files{i};','file = files;');
  scale  = ncep(1).roms_scale;
  offset = ncep(1).roms_offset;

  [lonr,latr,v,time] = ncep_var2grid(grid,file,var,tstart,tend,pos,L,fig);

  % check time:
  if ~isempty(time_prev)
    if ~isequal(time,time_prev)
      disp(['## warning, time in ',var_prev,' differs from time in ',var,' !!??'])
    end
  end

  % check var size:
  if ~isempty(v_prev)
    if ~isequal(size(v_prev),size(v))
      disp(['## warning, size of ',var_prev,' differs from size of ',var,' !!??'])
    end
  end

  % convert scale and offset:
  disp(['---> applying scale and offset for ',type,' = ',num2str(scale),' -- ',num2str(offset)]);
  v = v*scale+offset;

  dims = size(v);

  eval(['var_',num2str(i),' = v;']);
end



% ------------------------- create cdl and nc file:
desc = ['; -- range: ',tstart,' to ',tend]; % added to forcing file global attribute description
[fcdl,fnc] = ncep_gencdl(type,dims,label,nc,desc);

% ------------------------- fill nc file:
if exist(fnc) ~= 2
  disp('## unable to complete forcing file generation...');
  return
end

nc=netcdf(fnc,'write');
switch type
  case 'wind'

    Uair = var_1;
    Vair = var_2;

    % rotate wind to xi,eta:
    % considering "good" orthogonality the grid variable angle can be used (from SEAGRID generated grids)
    % otherwise the angle between xi and eta would be also required
    % ps, the variable angle, angle between xi axis and east is not in degrees but in radians (SEAGRID
    % generated grids for ROMS show the angle units as degree but is not, radians is used, see seagrid2roms.

    if n_varexist(grid,'angle')
      angle = use(grid,'angle');
      disp('##  rotating wind to xi,eta...');

      for i=1:size(Uair,1)
        A  = squeeze(Uair(i,:,:));
        B  = squeeze(Vair(i,:,:));
        C  = -angle*180/pi;

        [Uair(i,:,:),Vair(i,:,:)] = rot2d(A,B,C);
      end
    end

    nc{'wind_time'}(:)  = time;     % days
    nc{'Uwind'}(:)      = Uair;     % m/s
    nc{'Vwind'}(:)      = Vair;     % m/s

  case 'cloud'
    cloud = var_1;
    nc{'cloud_time'}(:) = time;     % days
    nc{'cloud'}(:)      = cloud;    % 0 to 1

  case 'radiation'
    swrad    = var_1;
    lwrad    = var_2;
    latent   = var_3;
    sensible = var_4;
    shflux   = var_1 + var_2 + var_3 + var_4;
    nc{'srf_time'}(:)   = time;     % days
    nc{'lrf_time'}(:)   = time;     % days
    nc{'lhf_time'}(:)   = time;     % days
    nc{'sen_time'}(:)   = time;     % days
    nc{'shf_time'}(:)   = time;     % days

    nc{'swrad'}(:)      = swrad;    % W/m2
    nc{'lwrad'}(:)      = lwrad;    % W/m2
    nc{'latent'}(:)     = latent;   % W/m2
    nc{'sensible'}(:)   = sensible; % W/m2
    nc{'shflux'}(:)     = shflux;   % W/m2

  case 'humidity'
    Qair = var_1;
    nc{'qair_time'}(:)  = time;     % days
    nc{'Qair'}(:)       = Qair;     % percentage

  case 'pressure'
    Pair = var_1;
    nc{'pair_time'}(:)  = time;     % days
    nc{'Pair'}(:)       = Pair;     % mb

  case 'precipitation'
    rain = var_1;
    nc{'rain_time'}(:)  = time;     % days
    nc{'rain'}(:)       = rain;     % kg/m2/s

  case 'temperature'
    Tair = var_1;
    nc{'tair_time'}(:)  = time;     % days
    nc{'Tair'}(:)       = Tair;     % Celsius
end

nc=close(nc);

show(fnc,[1 1]);
