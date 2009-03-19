function minimal_roms_grd(g,Eta_Xi)
%MINIMAL_ROMS_GRD   Create ROMS NetCDF grid file with minimum variables
%
%   Syntax:
%      MINIMAL_ROMS_GRD(FNAME,RSIZE)
%
%   Inputs:
%      FNAME   Grid file name to create
%      RSIZE   Size of rho points, [xi eta]
%
%   MMA 18-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

Mp=Eta_Xi(1);
Lp=Eta_Xi(2);
L=Lp-1;
M=Mp-1;

% create grid:
nc=netcdf(g,'clobber');

%  Create dimensions
nc('xi_rho')  = Lp;
nc('eta_rho') = Mp;

nc('xi_u') = L;
nc('eta_u') = Mp;
nc('xi_v') = Lp;
nc('eta_v') = M;

nc('xi_psi') = L;
nc('eta_psi') = M;


nc('one') = 1;

%  Create variables and attributes
nc{'xl'} = ncdouble('one');
nc{'xl'}.long_name = ncchar('domain length in the XI-direction');
nc{'xl'}.long_name = 'domain length in the XI-direction';
nc{'xl'}.units = ncchar('meter');
nc{'xl'}.units = 'meter';

nc{'el'} = ncdouble('one');
nc{'el'}.long_name = ncchar('domain length in the ETA-direction');
nc{'el'}.long_name = 'domain length in the ETA-direction';
nc{'el'}.units = ncchar('meter');
nc{'el'}.units = 'meter';

nc{'spherical'} = ncchar('one');
nc{'spherical'}.long_name = ncchar('Grid type logical switch');
nc{'spherical'}.long_name = 'Grid type logical switch';
nc{'spherical'}.option_T = ncchar('spherical');
nc{'spherical'}.option_T = 'spherical';

nc{'angle'} = ncdouble('eta_rho', 'xi_rho');
nc{'angle'}.long_name = ncchar('angle between xi axis and east');
nc{'angle'}.long_name = 'angle between xi axis and east';
nc{'angle'}.units = ncchar('degree');
nc{'angle'}.units = 'degree';

nc{'h'} = ncdouble('eta_rho', 'xi_rho');
nc{'h'}.long_name = ncchar('Final bathymetry at RHO-points');
nc{'h'}.long_name = 'Final bathymetry at RHO-points';
nc{'h'}.units = ncchar('meter');
nc{'h'}.units = 'meter';

nc{'f'} = ncdouble('eta_rho', 'xi_rho');
nc{'f'}.long_name = ncchar('Coriolis parameter at RHO-points');
nc{'f'}.long_name = 'Coriolis parameter at RHO-points';
nc{'f'}.units = ncchar('second-1');
nc{'f'}.units = 'second-1';

nc{'pm'} = ncdouble('eta_rho', 'xi_rho');
nc{'pm'}.long_name = ncchar('curvilinear coordinate metric in XI');
nc{'pm'}.long_name = 'curvilinear coordinate metric in XI';
nc{'pm'}.units = ncchar('meter-1');
nc{'pm'}.units = 'meter-1';

nc{'pn'} = ncdouble('eta_rho', 'xi_rho');
nc{'pn'}.long_name = ncchar('curvilinear coordinate metric in ETA');
nc{'pn'}.long_name = 'curvilinear coordinate metric in ETA';
nc{'pn'}.units = ncchar('meter-1');
nc{'pn'}.units = 'meter-1';

nc{'lon_rho'} = ncdouble('eta_rho', 'xi_rho');
nc{'lon_rho'}.long_name = ncchar('longitude of RHO-points');
nc{'lon_rho'}.long_name = 'longitude of RHO-points';
nc{'lon_rho'}.units = ncchar('degree_east');
nc{'lon_rho'}.units = 'degree_east';

nc{'lat_rho'} = ncdouble('eta_rho', 'xi_rho');
nc{'lat_rho'}.long_name = ncchar('latitude of RHO-points');
nc{'lat_rho'}.long_name = 'latitude of RHO-points';
nc{'lat_rho'}.units = ncchar('degree_north');
nc{'lat_rho'}.units = 'degree_north';

nc{'lon_u'} = ncdouble('eta_u', 'xi_u');
nc{'lon_u'}.long_name = ncchar('longitude of U-points');
nc{'lon_u'}.long_name = 'longitude of U-points';
nc{'lon_u'}.units = ncchar('degree_east');
nc{'lon_u'}.units = 'degree_east';

nc{'lon_v'} = ncdouble('eta_v', 'xi_v');
nc{'lon_v'}.long_name = ncchar('longitude of V-points');
nc{'lon_v'}.long_name = 'longitude of V-points';
nc{'lon_v'}.units = ncchar('degree_east');
nc{'lon_v'}.units = 'degree_east';

nc{'lon_psi'} = ncdouble('eta_psi', 'xi_psi');
nc{'lon_psi'}.long_name = ncchar('longitude of PSI-points');
nc{'lon_psi'}.long_name = 'longitude of PSI-points';
nc{'lon_psi'}.units = ncchar('degree_east');
nc{'lon_psi'}.units = 'degree_east';

nc{'lat_u'} = ncdouble('eta_u', 'xi_u');
nc{'lat_u'}.long_name = ncchar('latitude of U-points');
nc{'lat_u'}.long_name = 'latitude of U-points';
nc{'lat_u'}.units = ncchar('degree_north');
nc{'lat_u'}.units = 'degree_north';

nc{'lat_v'} = ncdouble('eta_v', 'xi_v');
nc{'lat_v'}.long_name = ncchar('latitude of V-points');
nc{'lat_v'}.long_name = 'latitude of V-points';
nc{'lat_v'}.units = ncchar('degree_north');
nc{'lat_v'}.units = 'degree_north';

nc{'lat_psi'} = ncdouble('eta_psi', 'xi_psi');
nc{'lat_psi'}.long_name = ncchar('latitude of PSI-points');
nc{'lat_psi'}.long_name = 'latitude of PSI-points';
nc{'lat_psi'}.units = ncchar('degree_north');
nc{'lat_psi'}.units = 'degree_north';

nc{'mask_rho'} = ncdouble('eta_rho', 'xi_rho');
nc{'mask_rho'}.long_name = ncchar('mask on RHO-points');
nc{'mask_rho'}.long_name = 'mask on RHO-points';
nc{'mask_rho'}.option_0 = ncchar('land');
nc{'mask_rho'}.option_0 = 'land';
nc{'mask_rho'}.option_1 = ncchar('water');
nc{'mask_rho'}.option_1 = 'water';

nc{'mask_u'} = ncdouble('eta_u', 'xi_u');
nc{'mask_u'}.long_name = ncchar('mask on U-points');
nc{'mask_u'}.long_name = 'mask on U-points';
nc{'mask_u'}.option_0 = ncchar('land');
nc{'mask_u'}.option_0 = 'land';
nc{'mask_u'}.option_1 = ncchar('water');
nc{'mask_u'}.option_1 = 'water';

nc{'mask_v'} = ncdouble('eta_v', 'xi_v');
nc{'mask_v'}.long_name = ncchar('mask on V-points');
nc{'mask_v'}.long_name = 'mask on V-points';
nc{'mask_v'}.option_0 = ncchar('land');
nc{'mask_v'}.option_0 = 'land';
nc{'mask_v'}.option_1 = ncchar('water');
nc{'mask_v'}.option_1 = 'water';

nc{'mask_psi'} = ncdouble('eta_psi', 'xi_psi');
nc{'mask_psi'}.long_name = ncchar('mask on PSI-points');
nc{'mask_psi'}.long_name = 'mask on PSI-points';
nc{'mask_psi'}.option_0 = ncchar('land');
nc{'mask_psi'}.option_0 = 'land';
nc{'mask_psi'}.option_1 = ncchar('water');
nc{'mask_psi'}.option_1 = 'water';


% Create global attributes
nc.date = date;
nc.type = 'ROMS grid file';


close(nc)

