function tpxo2roms(frc,grd,gfile,hfile,ufile,varargin)
%TPXO2ROMS   Create ROMS tidal forcing file from TPXO data
%   Can also append data to ana existing file, like a forcing file.
%
%   Syntax:
%      TPXO2ROMS(FRC,GRD,GFILE,HFILE,UFILE,VARARGIN)
%
%   Inputs:
%      FRC    Forcing file where to put tidal data (may not exist)
%      GRD    Target ROMS netcdf grid file
%      GFILE  TPXO grid file
%      HFILE  TPXO tidal elevation file
%      UFILE  TPXO tidal transport file
%      VARARGIN:
%         'comps', {names}, cell array with tidal names, ex:
%            {'m2','s2'}, by default all components from TPXO files
%            are used
%         'hcut', <value>: due to possible bad currents values near
%            coast, remove all until hcut, default value is 30
%
%   Example:
%      frc='roms_frc.nc'
%      grd='roms_grd.nc'
%      gfile='grid_tpxo7.1.nc'
%      hfile='h_tpxo7.1.nc'
%      ufile='u_tpxo7.1.nc'
%      comps={'m2','s2','m4'}
%      tpxo2roms(frc,grd,gfile,hfile,ufile)
%      tpxo2roms(frc,grd,gfile,hfile,ufile,'comps',comps)
%
%   MMA 16-04-2009, mma@odyle.net
%
%   See also TPXO_EXTRACT

[x,y,h,m]=roms_grid(grd);
[eta,xi]=size(h);

% create tidal forcing file or add tidal data to existing roms file:
if exist(frc)~=2
  % create file with required dims:
  nc=netcdf(frc,'clobber');
  nc('xi_rho')=xi;
  nc('eta_rho')=eta;
  close(nc);
else
  if ~n_dimexist(frc,'xi_rho') | ~n_dimexist(frc,'eta_rho')
    fprintf(1,':: Dimensions xi or eta not found in frc file %s !!\n',frc);
    return
  end
end

% extract data from tpxo netcdf files:
[hamp,hpha,uamp,upha,vamp,vpha,C]=tpxo_extract(grd,gfile,hfile,ufile,varargin{:});

% only now can create/add tidal forcing since now I know C !!
components='';
for i=1:length(C)
  components=[components ' ' trim(C{i})];
end
components=trim(components);
%start_tide_mjd=mjd(Ymin,Mmin,Dmin);
start_tide_mjd=0;
nc_add_tides(frc,length(C),start_tide_mjd,components)

% convert uv amps and phases to tidal ellipse parameters:
[cmax,ecc,inc,pha]=ap2ep(uamp,upha,vamp,vpha);

% fill frc file:
nc=netcdf(frc,'w');
for i=1:length(C)
  nc{'tide_period'}(i)     = 1/name2freq(C{i});
  nc{'tide_Eamp'}(i,:,:)   = hamp(i,:,:);
  nc{'tide_Ephase'}(i,:,:) = hpha(i,:,:);
  nc{'tide_Cmax'}(i,:,:)   = cmax(i,:,:);
  nc{'tide_Cmin'}(i,:,:)   = ecc(i,:,:).*cmax(i,:,:);
  nc{'tide_Cangle'}(i,:,:) = inc(i,:,:);
  nc{'tide_Cphase'}(i,:,:) = pha(i,:,:);
end
close(nc);
