function [lon,lat,h,mask,ang]=pom_gridtxt(g,hmin)
%POM_GRIDTXT   Read POM grid text file
%
%   Syntax:
%      [LON,LAT,H,MASK,ANG] = POM_GRIDTXT(FNAME,HMIN)
%
%   Inputs:
%     FNAME   POM grid text file
%     HMIN   If set, all above HMIN become HMIN and such points
%            become mask
%
%   Ouputs:
%      LON,LAT,H,MASK,ANG   Longitude, latitude, depth, mask and grid
%                           angle
%
%
%   MMA 11-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

% i j lat lon dx dy h ang.
a=load(g);
i    = a(:,1);
j    = a(:,2);
lat  = a(:,3);
lon  = a(:,4);
h    = a(:,7);
ang  = a(:,8);
%mask = ~h==1.;

m=find(j==1);m=m(end);
n=length(i)/m;

lon  = reshape(lon ,m,n)';
lat  = reshape(lat ,m,n)';
h    = reshape(h   ,m,n)';
ang  = reshape(ang ,m,n)';
%mask = reshape(mask,m,n);
mask = double(h~=1);

if nargin > 1
  % use hmin
  i=h<hmin;
  h(i)=hmin;

  mask2=~i;

  mask=double(mask & mask2);
end
