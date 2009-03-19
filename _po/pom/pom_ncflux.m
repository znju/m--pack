function pom_ncflux(frc,grd,time)
%POM_NCFLUX   Create POM NetCDF flux frc file
%
%   Syntax:
%      POM_NCFLUX(FRC,GRD,TIME)
%
%   Inputs:
%      FRC     Forcing file to create
%      GRD     POM grid file (netcdf of text)
%      TIME    Time variable (any length)
%
%   MMA 23-10-2008, mma@odyle.net
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
nc('x') = nx;
nc('y') = ny;
nc('time') = 0;

%  Create variables:
nc{'time'} = ncfloat('time');

nc{'lon'} = ncfloat('y', 'x');
nc{'lon'}.units = ncchar('graus');
nc{'lon'}.long_name = ncchar('Longitude');

nc{'lat'} = ncfloat('y', 'x');
nc{'lat'}.units = ncchar('graus');
nc{'lat'}.long_name = ncchar('Latitude');

nc{'shortwave'} = ncfloat('time', 'y', 'x');
nc{'shortwave'}.units = ncchar('W/m^2');
nc{'shortwave'}.long_name = ncchar('Monthly Longterm Mean of Net Shortwave Radiation Flux');

nc{'longwave'} = ncfloat('time', 'y', 'x');
nc{'longwave'}.units = ncchar('W/m^2');
nc{'longwave'}.long_name = ncchar('Monthly Longterm Mean of Net Longwave Radiation Flux');

nc{'latente'} = ncfloat('time', 'y', 'x');
nc{'latente'}.units = ncchar('W/m^2');
nc{'latente'}.long_name = ncchar('Monthly Longterm Mean of Latent Heat Net Flux');

nc{'sensivel'} = ncfloat('time', 'y', 'x');
nc{'sensivel'}.units = ncchar('W/m^2');
nc{'sensivel'}.long_name = ncchar('Monthly Longterm Mean of Sensible Heat Net Flux');

% Create global attributes:
nc.title('POM fluxes frc file')
nc.date=datestr(now);
nc.path=pwd;
[status,host]=system('hostname');
nc.host=host(1:end-1);

endef(nc)

% Fill reccord variable:
for i=1:length(time)
  nc{'time'}(i)=time(i);
end

% Fill grid data:
nc{'lon'}(:) = x;
nc{'lat'}(:) = y;

close(nc);
