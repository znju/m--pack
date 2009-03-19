function pom_ncfrc(frc,grd,time)
%POM_NCFRC   Create POM NetCDF wind frc file
%
%   Syntax:
%      POM_NCFRC(FRC,GRD,TIME)
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
  [x,y,h] = pom_grid(grd,'r');
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
nc{'time'}  = ncfloat('time');
nc{'lon'}   = ncfloat('y','x');
nc{'lat'}   = ncfloat('y','x');
nc{'uwindstr'}   = ncfloat('time','y','x');
nc{'uwindstr'}.long_name = ncchar('u wind stress * -1/1025 (m2/s2)');
nc{'vwindstr'}   = ncfloat('time','y','x');
nc{'vwindstr'}.long_name = ncchar('v wind stress * -1/1025 (m2/s2)');

% Create global attributes:
nc.title('POM wind frc file from OCCAM')
nc.date=datestr(now);
nc.path=pwd;
[status,host]=system('hostname');
nc.host=host(1:end-1);

% Fill reccord variable:
for i=1:length(time)
  nc{'time'}(i)=time(i);
end

% Fill grid data:
nc{'lon'}(:) = x;
nc{'lat'}(:) = y;

close(nc);
