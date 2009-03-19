function dist = sph_dist(Loni,Lati,Lone,Late,R)
%SPH_DIST   Shortest distance between two points on a sphere
%   Gives the distance over a sphere of radius R between the points
%   [LON1 LAT1] and [LON2 LAT2]. By default the radius is the earth
%   radius, 6370 km.
%
%   Syntax:
%      DIST = SPH_DIST(LON1,LAT1,LON2,LAT2,R)
%
%   Input:
%      LON1, LAT1   Initial longitude and latitude (deg)
%      LON2, lat2   Final longitude and latitude (deg)
%      R      radius of the sphere [ 6370*1000 ]
%
%   Output:
%      DIST   The distance in units of R [ metre ]
%
%   Example:
%      lon1 = 0;
%      lon2 = 1;
%      lat1 = 0;
%      lat2 = 0;
%      sph_dist(lon1,lat1,lon2,lat2,1)*180/pi
%
%   MMA 2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 5
  % use earth radius
  R=6371*1000;
end

deg_rad=pi/180;
loni=Loni*deg_rad;
lati=Lati*deg_rad;
lone=Lone*deg_rad;
late=Late*deg_rad;

p1=[R*cos(lati)*cos(loni) R*cos(lati)*sin(loni) R*sin(lati)];
p2=[R*cos(late)*cos(lone) R*cos(late)*sin(lone) R*sin(late)];

ang=acos(sum(p1.*p2)/R^2);
dist=R*ang;

if nargout == 0
  disp(['distance = ',num2str(dist)]);
end
