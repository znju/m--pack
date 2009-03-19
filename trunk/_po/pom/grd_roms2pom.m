function grd_roms2pom(rgrd,pgrd,ztxt)
%GRD_ROMS2POM   Create POM NetCDF grid from ROMS grid
%
%   Syntax:
%      GRD_ROMS2POM(RGRD,PGRD,ZTXT)
%
%   Inputs:
%      RGRD   ROMS grid
%      PGRD   POM grid to create
%      ZTXT   POM vertical coordinates text file
%
%   See also POM_NCGRD, GRD_POM2ROMS
%
%   MMA 03-09-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

% Read roms grid:
[x,y,h0,m]=roms_grid(rgrd);
h=h0;
h(m==0)=1;

% Read vertical coordinates text file:
[z,zz,dz,dzz]=pom_ztxt(ztxt);

% Create pom grid
[ny,nx]=size(x);
nz=length(z);
pom_ncgrd(pgrd,nx,ny,nz);

% Fill pom grid file:
nc=netcdf(pgrd,'w');
nc{'z'}(:)    = z;
nc{'zz'}(:)   = zz;
nc{'dz'}(:)   = dz;
nc{'dzz'}(:)  = dzz;
nc{'lon'}(:)  = x;
nc{'lat'}(:)  = y;
nc{'h'}(:)    = h;

nc{'mask'}(:)    = m;
nc{'h0'}(:)      = h0;
nc{'east_e'}(:)  = x;
nc{'north_e'}(:) = y;
nc{'fsm'}(:)     = m;

close(nc);
