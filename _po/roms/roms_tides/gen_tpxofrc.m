function gen_tpxofrc(grid,model_files,run_path,frc_name,frc_title,constituints)
%GEN_TPXOFRC   Generate ROMS NetCDF tidal forcing files
%   This function will create tidal ROMS tidal forcing files from TPXO:
%   http://www.coas.oregonstate.edu/research/po/research/tide/index.html
%
%   Syntax:
%      GEN_TPXOFRC(GRID,MODEL_FILES,RUN_PATH,FILENAME,TITLE,CONSTITUENTS,VARIABLES)
%
%   Inputs:
%      GRID           ROMS NetCDF grid
%      MODEL_FILES    TPXO model files, structure with fields
%                     .elevation
%                     .transport
%                     .bathymetry
%      RUN_PATH       Path of the TPXO executable extract_HC
%      FILENAME       Name of the output NetCDF file ['frc_tides.nc']
%      TITLE          Title (NetCDF global attribute) ['Tidal Forcing']
%      CONSTITUENTS   Tidal constituents cell array, available are:
%                     m2, s2, n2, k2, k1, o1, p1 and q1
%                     (all are used by default)
%
%   Example:
%      grid                   = 'ocean_grd.nc';
%      model_files.elevation  = '/home/user/tpxo/DATA/h_NA';
%      model_files.transport  = '/home/user/tpxo/DATA/UV_NA';
%      model_files.bathymetry = '/home/user/tpxo/DATA/grid_NA';
%      run_path               = '/home/user/tpxo/';
%      gen_tpxofrc(grid,model_files,run_path);
%
%   MMA 10-5-2005, martinho@fis.ua.pt
%
%   See also READ_TPXO, PLOT_TIDALFRC

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 6
  constituents  = {'m2','s2','n2','k2','k1','o1','p1','q1'};
end
if nargin < 5
  frc_title = 'Tidal Forcing';
end
if nargin < 4
  frc_name = 'frc_tides.nc';
end
vars = {'z','u','v'};

% read TPXO:
out = read_tpxo(grid,model_files,run_path,constituents,vars);

[x,y,h,m] = roms_grid(grid);

n_constituents     = length(constituents);
tidal_constituents = [];
for i=1:n_constituents
  tidal_constituents = [tidal_constituents,constituents{i},','];
end
tidal_constituents = tidal_constituents(1:end-1);

% --------------------------------------------------------------------
% gen NetCDF file:
% --------------------------------------------------------------------
nc = netcdf(frc_name,'clobber');

% Global attributes:
nc.type       = ncchar('ROMS FORCING file');
nc.title      = ncchar(frc_title);
nc.grd_file   = ncchar(grid);
nc.components = ncchar(tidal_constituents);
nc.history    = ncchar(['FORCING file, ',datestr(now,0)]);

% Dimensions:
nc('xi_rho')      = n_filedim(grid,'xi_rho');
nc('eta_rho')     = n_filedim(grid,'eta_rho');;
nc('tide_period') = n_constituents;

% Variables and attributes:
nc{'tide_period'} = ncdouble('tide_period');
nc{'tide_period'}.long_name = ncchar('tide angular period');
nc{'tide_period'}.units = ncchar('hours');
nc{'tide_period'}.field = ncchar('tide_period, scalar');

nc{'tide_Ephase'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Ephase'}.long_name = ncchar('tidal elevation phase angle');
nc{'tide_Ephase'}.units = ncchar('degrees, time of maximum elevation with respect chosen time origin');
nc{'tide_Ephase'}.field = ncchar('tide_Ephase, scalar');

nc{'tide_Eamp'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Eamp'}.long_name = ncchar('tidal elevation amplitude');
nc{'tide_Eamp'}.units = ncchar('meter');
nc{'tide_Eamp'}.field = ncchar('tide_Eamp, scalar');

nc{'tide_Cphase'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cphase'}.long_name = ncchar('tidal current phase angle');
nc{'tide_Cphase'}.units = ncchar('degrees, time of maximum velocity with respect chosen time origin');
nc{'tide_Cphase'}.field = ncchar('tide_Cphase, scalar');

nc{'tide_Cangle'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cangle'}.long_name = ncchar('tidal current inclination angle');
nc{'tide_Cangle'}.units = ncchar('degrees between semi-major axis and East');
nc{'tide_Cangle'}.field = ncchar('tide_Cangle, scalar');

nc{'tide_Cmin'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cmin'}.long_name = ncchar('minimum tidal current, ellipse semi-minor axis');
nc{'tide_Cmin'}.units = ncchar('meter second-1');
nc{'tide_Cmin'}.field = ncchar('tide_Cmin, scalar');

nc{'tide_Cmax'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cmax'}.long_name = ncchar('maximum tidal current, ellipse semi-major axis');
nc{'tide_Cmax'}.units = ncchar('meter second-1');
nc{'tide_Cmax'}.field = ncchar('tide_Cmax, scalar');

close(nc);

% --------------------------------------------------------------------
% fill forcing file:
% --------------------------------------------------------------------
nc = netcdf(frc_name,'write');
for n=1:n_constituents
  zamp = ['out.',vars{1},'_',constituents{n},'_amp']; eval(['zamp = ',zamp,';']);
  zpha = ['out.',vars{1},'_',constituents{n},'_pha']; eval(['zpha = ',zpha,';']);
  uamp = ['out.',vars{2},'_',constituents{n},'_amp']; eval(['uamp = ',uamp,';']); uamp = uamp/100; % cm -> m
  upha = ['out.',vars{2},'_',constituents{n},'_pha']; eval(['upha = ',upha,';']);
  vamp = ['out.',vars{3},'_',constituents{n},'_amp']; eval(['vamp = ',vamp,';']); vamp = vamp/100;
  vpha = ['out.',vars{3},'_',constituents{n},'_pha']; eval(['vpha = ',vpha,';']);
  [sema,ecc,inc,pha]=ap2ep(uamp,upha,vamp,vpha);

  nc{'tide_Ephase'}(n,:) = nan2zero(zpha);
  nc{'tide_Eamp'}(n,:)   = nan2zero(zamp);
  nc{'tide_Cphase'}(n,:) = nan2zero(pha);
  nc{'tide_Cangle'}(n,:) = nan2zero(inc);
  nc{'tide_Cmin'}(n,:)   = nan2zero(ecc.*sema);
  nc{'tide_Cmax'}(n,:)   = nan2zero(sema);
  nc{'tide_period'}(n)   = 1/name2freq(constituents{n});
end
close(nc);
