function grd_pom2roms(g1,g2,hmin)
%GRD_POM2ROMS  Create ROMS NetCDF grid from POM text grid
%
%   Syntax:
%      GRD_POM2ROMS(GPOM,GROMS)
%
%   Inputs:
%      GPOM   POM text grid file
%      GROMS  ROMS NetCDF file to create
%      HMIN   If set, will be the minimum depth and also mask points
%
%   See also MINIMAL_ROMS_GRD
%
%   MMA 18-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil


% g1='/home_stommel/remo/POM/grade_teste/grade_180_300_gebco_filtrada.dat';

if nargin>2
  [lon,lat,h,mask,ang]=pom_gridtxt(g1,hmin);
else
  [lon,lat,h,mask,ang]=pom_gridtxt(g1);
end

[Mp,Lp]=size(h);

fprintf(1,' - Creating roms grid %s\n',g2);
minimal_roms_grd(g2,[Mp,Lp]);


fprintf(1,' - Filling with data...\n');
% fill grid:
nc=netcdf(g2,'w');

nc{'h'}(:)         = h;
nc{'lon_rho'}(:)   = lon;
nc{'lat_rho'}(:)   = lat;
nc{'mask_rho'}(:)  = mask;
nc{'spherical'}(:) = 'T';

[lonu,lonv,lonp]    = rho2uvp(lon);
[latu,latv,latp]    = rho2uvp(lat);
[umask,vmask,pmask] = uvp_mask(mask);

nc{'lon_u'}(:)    = lonu;
nc{'lon_v'}(:)    = lonv;
nc{'lon_psi'}(:)  = lonp;
nc{'lat_u'}(:)    = latu;
nc{'lat_v'}(:)    = latv;
nc{'lat_psi'}(:)  = latp;
nc{'mask_u'}(:)   = umask;
nc{'mask_v'}(:)   = vmask;
nc{'mask_psi'}(:) = pmask;

% pm and pn
M  = Mp-1;
Mm = Mp-2;
L  = Lp-1;
Lm = Lp-2;

dx=zeros(Mp,Lp);
dy=zeros(Mp,Lp);
dx(:,2:L)=spheric_dist(latu(:,1:Lm),latu(:,2:L),...
                       lonu(:,1:Lm),lonu(:,2:L));
dx(:,1)=dx(:,2);
dx(:,Lp)=dx(:,L);

dy(2:M,:)=spheric_dist(latv(1:Mm,:),latv(2:M,:),...
                       lonv(1:Mm,:),lonv(2:M,:));
dy(1,:)=dy(2,:);
dy(Mp,:)=dy(M,:);

pm=1./dx;
pn=1./dy;

%  Angle between XI-axis and the direction
%  to the EAST at RHO-points [radians].
if 1
  angle=get_angle(latu,lonu);
else
  angle=180+ang;
  angle=angle*pi/180;
end

% coriolis
f=4*pi*sin(pi*lat/180)/(24*3600);

% write
nc{'pm'}(:)=pm;
nc{'pn'}(:)=pn;
nc{'angle'}(:)=angle;
nc{'f'}(:)=f;

close(nc)

fprintf(1,' - Done\n');
show(g2)
