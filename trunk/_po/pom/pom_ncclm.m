function pom_ncclm(clm,grd,zfile,time)
%POM_NCCLM   Create POM NetCDF clm file
%
%   Syntax:
%      POM_NCCLM(CLM,GRD,ZFILE,TIME)
%
%   Inputs:
%      CLM     Climatology file to create
%      GRD     POM grid file (netcdf of text)
%      ZFILE   POM vertical coordinates text file
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

% Get vertical coordinates data:
[z,zz,dz,dzz]=pom_ztxt(zfile);
nz=length(z);

% Gen clim file:
nc=netcdf(clm,'c');

%  Create dimensions:
nc('x') = nx;
nc('y') = ny;
nc('z') = nz;
nc('time') = 0;

%  Create variables:
nc{'time'}  = ncfloat('time');
nc{'z'}     = ncfloat('z');
nc{'zz'}    = ncfloat('z');
nc{'dz'}    = ncfloat('z');
nc{'dzz'}   = ncfloat('z');
nc{'lon'}   = ncfloat('y','x');
nc{'lat'}   = ncfloat('y','x');
nc{'h'}     = ncfloat('y','x');
nc{'ssh'}   = ncfloat('time','y','x');
nc{'temp'}  = ncfloat('time','z','y','x');
nc{'sal'}   = ncfloat('time','z','y','x');
nc{'rmean'} = ncfloat('time','z','y','x');
nc{'u'}     = ncfloat('time','z','y','x');
nc{'v'}     = ncfloat('time','z','y','x');

% Create global attributes:
nc.title('POM clm file from OCCAM')
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
nc{'h'}(:)   = h;

% Fill vertical corrdinates data:
nc{'z'}(:)   = z;
nc{'zz'}(:)  = zz;
nc{'dz'}(:)  = dz;
nc{'dzz'}(:) = dzz;

close(nc);
