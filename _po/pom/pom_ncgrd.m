function pom_ncgrd(grd,nx,ny,nz)
%POM_NCGRD   Create POM NetCDF grid file
%
%   Syntax:
%      POM_NCGRD(GRID,NX,NY,NZ)
%
%   Inputs:
%      GRID   Grid file to create
%      NX,NY,NZ   Dimensions x,y and z
%
%   See also GRD_ROMS2POM
%
%   MMA 03-09-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

% Gen grd file:
nc=netcdf(grd,'c');

%  Create dimensions:
nc('x') = nx;
nc('y') = ny;
nc('z') = nz;

%  Create variables:
nc{'z'}     = ncfloat('z');
nc{'zz'}    = ncfloat('z');
nc{'dz'}    = ncfloat('z');
nc{'dzz'}   = ncfloat('z');
nc{'lon'}   = ncfloat('y','x');
nc{'lat'}   = ncfloat('y','x');
nc{'h'}     = ncfloat('y','x');

% Extra variables:
nc{'mask'}    = ncfloat('y','x');
nc{'h0'}      = ncfloat('y','x');
nc{'east_e'}  = ncfloat('y','x');
nc{'north_e'} = ncfloat('y','x');
nc{'fsm'}     = ncfloat('y','x');

nc{'h'}.long_name       = ncchar('depth, =1 on mask');
nc{'h0'}.long_name      = ncchar('h original, ie, not =1 on mask');
nc{'east_e'}.long_name  = ncchar('copy of lon');
nc{'north_e'}.long_name = ncchar('copy of lat');
nc{'fsm'}.long_name     = ncchar('copy of mask');


% Create global attributes:
nc.title('POM grd file')
nc.date=datestr(now);
nc.path=pwd;
[status,host]=system('hostname');
nc.host=host(1:end-1);

close(nc);
