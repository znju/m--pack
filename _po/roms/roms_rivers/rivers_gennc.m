function rivers_gennc(gridname,ns,nt,frcname,rivers,title,tstart,time_offset)
%RIVERS_GENNC   Create ROMS NetCDF rivers forcing file
%   Creates a NetCDF file to be used as ROMS rivers forcing file.
%   The file created is ready to be filled with the desired data.
%
%   Syntax:
%      RIVERS_GENNC(GRIDNAME,NS,FRCNAME,RIVERS,TITLE,TSTART,TOFFSET)
%
%   MMA 17-3-2005, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 8
  time_offset = 0;
end
if nargin < 7
  tstart = '0000-00-00 00:00:00';
end
if nargin < 6
  title = 'rivers forcing file';
end
if nargin < 5
  rivers.names   = 'unknown';
  rivers.nrivers = 1;
end
if nargin < 4
  frcname = 'rivers_frc.nc';
end
if nargin < 3
  disp(['## ',mfilename,': missing argument length time'])
  return
end
if nargin < 2
  disp(['## ',mfilename,': missing argument n. s-levels'])
  return
end
if nargin < 1
  disp(['## ',mfilename,': missing argument grid file'])
  return
end

% --------------------------------------------------------------------
% create file
% --------------------------------------------------------------------
rivernames = rivers.names;
names = '';
for i=1:length(rivernames)
  names = [names,', ',rivernames{i}];
end
names = names(3:end);

disp('## Rivers forcing file creation:');
disp(['    --> grid:        ',gridname             ]);
disp(['    --> output file: ',frcname              ]);
disp(['    --> rivers:      ',names                ]);
disp(['    --> t start:     ',tstart               ]);
disp(['    --> t offset:    ',num2str(time_offset) ]);
disp(' ');

nc=netcdf(frcname,'clobber');

% --------------------------------------------------------------------
% global attributes:
% --------------------------------------------------------------------
evalc('[a,author_str] = unix(''whoami'');',        'author_str = [];' );
evalc('[a,domain_str] = unix(''dnsdomainname'');', 'domain_str = [];' );
evalc('[a,host_str]   = unix(''hostname'');',      'host_str   = [];' );

nc.type     = 'ROMS FORCING file';
nc.title    = title;
nc.rivers   = names;
nc.author   = author_str(1:end-1);
nc.host     = host_str(1:end-1);
nc.domain   = domain_str(1:end-1);
nc.date     = datestr(now);
nc.grd_file = gridname;

% --------------------------------------------------------------------
% dimensions:
% --------------------------------------------------------------------
nxi     = n_dim(gridname,'xi_rho');
neta    = n_dim(gridname,'eta_rho');
nrivers = rivers.nrivers;

nc('xi_rho')  = nxi;
nc('eta_rho') = neta;
nc('s_rho')   = ns;
nc('river')   = nrivers;
nc('time')    = nt;

% --------------------------------------------------------------------
% variables aand attributes:
% --------------------------------------------------------------------

nc{'river'}                     = ncdouble('river');
nc{'river'}.long_name           = ncchar('river runoff identification number');
nc{'river'}.units               = ncchar('nondimensional');
nc{'river'}.field               = ncchar('river, scalar');

nc{'river_Xposition'}           = ncdouble('river');
nc{'river_Xposition'}.long_name = ncchar('river XI-position at RHO-points');
nc{'river_Xposition'}.units     = ncchar('nondimensional');
nc{'river_Xposition'}.valid_min = ncdouble(1);
nc{'river_Xposition'}.valid_max = ncdouble(nxi-1);
nc{'river_Xposition'}.field     = ncchar('river_Xposition, scalar');

nc{'river_Eposition'}           = ncdouble('river');
nc{'river_Eposition'}.long_name = ncchar('river ETA-position at RHO-points');
nc{'river_Eposition'}.units     = ncchar('nondimensional');
nc{'river_Eposition'}.valid_min = ncdouble(1);
nc{'river_Eposition'}.valid_max = ncdouble(neta-1);
nc{'river_Eposition'}.field     = ncchar('river_Eposition, scalar');

nc{'river_direction'}           = ncdouble('river');
nc{'river_direction'}.long_name = ncchar('river runoff direction');
nc{'river_direction'}.units     = ncchar('nondimensional');
nc{'river_direction'}.field     = ncchar('river_direction, scalar');

nc{'river_flag'}                = ncdouble('river');
nc{'river_flag'}.long_name      = ncchar('river runoff tracer flag');
nc{'river_flag'}.option_0       = ncchar('all tracers are off');
nc{'river_flag'}.option_1       = ncchar('only temperature is on');
nc{'river_flag'}.option_2       = ncchar('only salinity is on');
nc{'river_flag'}.option_3       = ncchar('both temperature and salinity are on');
nc{'river_flag'}.units          = ncchar('nondimensional');
nc{'river_flag'}.field          = ncchar('river_flag, scalar');

nc{'river_Vshape'}              = ncdouble('s_rho', 'river');
nc{'river_Vshape'}.long_name    = ncchar('river runoff mass transport vertical profile');
nc{'river_Vshape'}.units        = ncchar('nondimensional');
nc{'river_Vshape'}.field        = ncchar('river_Vshape, scalar');

nc{'river_time'}                = ncdouble('time');
nc{'river_time'}.long_name      = ncchar('river runoff time');
nc{'river_time'}.units          = ncchar(['days since ',tstart]);
nc{'river_time'}.add_offset     = ncdouble(time_offset);
nc{'river_time'}.field          = ncchar('river_time, scalar, series');

nc{'river_transport'}           = ncdouble('time', 'river');
nc{'river_transport'}.long_name = ncchar('river runoff vertically integrated mass transport');
nc{'river_transport'}.units     = ncchar('meter3 second-1');
nc{'river_transport'}.field     = ncchar('river_transport, scalar, series');
nc{'river_transport'}.time      = ncchar('river_time');

nc{'river_temp'}                = ncdouble('time', 's_rho', 'river');
nc{'river_temp'}.long_name      = ncchar('river runoff potential temperature');
nc{'river_temp'}.units          = ncchar('Celsius');
nc{'river_temp'}.field          = ncchar('river_temp, scalar, series');
nc{'river_temp'}.time           = ncchar('river_time');

nc{'river_salt'}                = ncdouble('time', 's_rho', 'river');
nc{'river_salt'}.long_name      = ncchar('river runoff salinity');
nc{'river_salt'}.units          = ncchar('PSU');
nc{'river_salt'}.field          = ncchar('river_salt, scalar, series');
nc{'river_salt'}.time           = ncchar('river_time');

% --------------------------------------------------------------------
% done.

close(nc)

show(frcname);
