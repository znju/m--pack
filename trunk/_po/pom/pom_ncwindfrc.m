function pom_ncwindfrc(frc,grd,time)
%POM_NCWINDFRC   Create POM NetCDF wind frc file
%
%   Syntax:
%      POM_NCWINDFRC(FRC,GRD,TIME)
%
%   Inputs:
%      FRC     Forcing file to create
%      GRD     POM grid file (netcdf of text)
%      TIME    Time variable (any length)
%
%   MMA 02-09-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

% Get grid data:

if isbinary(grd)
  if n_varexist(grd,'lon') & n_varexist(grd,'lat')
    x=use(grd,'lon');
    y=use(grd,'lat');
  else
    [x,y,h] = pom_grid(grd,'r');
  end
else
  [x,y,h] = pom_gridtxt(grd);
end
[ny,nx]=size(x);

% Gen frc file:
nc=netcdf(frc,'c');

%  Create dimensions:
nc('X') = nx;
nc('Y') = ny;
nc('TIME') = 0;

%  Create variables:
nc{'X'} = ncdouble('X');
nc{'X'}.point_spacing = ncchar('even');
nc{'X'}.axis = ncchar('X');

nc{'Y'} = ncdouble('Y');
nc{'Y'}.point_spacing = ncchar('even');
nc{'Y'}.axis = ncchar('Y');

nc{'TIME'} = ncdouble('TIME');
nc{'TIME'}.units = ncchar('hours since 0001-01-01 00:00:00');
nc{'TIME'}.time_origin = ncchar('01-JAN-0001 00:00:00');
nc{'TIME'}.axis = ncchar('T');

nc{'UVENTO'} = ncfloat('TIME', 'Y', 'X');
nc{'UVENTO'}.missing_value = ncfloat(-1.e+34);
nc{'UVENTO'}.FillValue_ = ncfloat(-1.e+34);
nc{'UVENTO'}.long_name = ncchar('...');
nc{'UVENTO'}.long_name_mod = ncchar('...');

nc{'VVENTO'} = ncfloat('TIME', 'Y', 'X');
nc{'VVENTO'}.missing_value = ncfloat(-1.e+34);
nc{'VVENTO'}.FillValue_ = ncfloat(-1.e+34);
nc{'VVENTO'}.long_name = ncchar('...');
nc{'VVENTO'}.long_name_mod = ncchar('...');

nc{'EAST_E'} = ncfloat('Y', 'X');
nc{'EAST_E'}.long_name = ncchar('easting of elevation points');
nc{'EAST_E'}.units = ncchar('metre');
nc{'EAST_E'}.history = ncchar('From pom_grid');

nc{'NORTH_E'} = ncfloat('Y', 'X');
nc{'NORTH_E'}.long_name = ncchar('northing of elevation points');
nc{'NORTH_E'}.units = ncchar('metre');
nc{'NORTH_E'}.history = ncchar('From pom_grid');


% Create global attributes:
nc.title('POM wind frc file')
nc.date=datestr(now);
nc.path=pwd;
[status,host]=system('hostname');
nc.host=host(1:end-1);

% Fill reccord variable:
for i=1:length(time)
  nc{'TIME'}(i)=time(i);
end

% Fill grid data:
nc{'EAST_E'}(:) = x;
nc{'NORTH_E'}(:) = y;

nc{'X'}(:) = 1:nx;
nc{'Y'}(:) = 1:ny;

close(nc);
