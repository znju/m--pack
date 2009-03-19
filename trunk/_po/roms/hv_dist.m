function [px,py] = hv_dist(lon_i,lon_f,lat_i,lat_f,rx,ry)
%HV_DIST   Compute number of grid points according to resolution
%   Providing longitude and latitude dimensions of a region, as well
%   as desired resolution, provides an estimative of number of points
%   to use.
%
%   Syntax:
%      [PX,PY] = HV_DIST(LONI,LONF,LATI,LATF,RX,RY)
%
%   Inputs:
%      LONI, LONF   Grid minimum and maximum longitude
%      LATI, LATF   Grid minimum and maximum latitude
%      RX, RY       Resolution in x and y direction (km)
%
%   Outputs:
%      PX, PY   Number of points in x and y direction
%
%   Comment:
%      This function provides an estimative, and grid must be
%      rectangular.
%      The y resolution is calculated based on mean latitude distance.
%
%   MMA 2002, martinho@fis.ua.pt
%
%   See also SPH_DIST

%   Department of Physics
%   University of Aveiro, Portugal

%   **-12-2004 - Added sph_dist instead of distance (map)

Rt=6370000; %raio da terra

if nargin~=6
   disp('## warnimg: wrong input params...')
end
if nargin==6
  %----------------------------------------------------
  %D_lon=lon_f-lon_i;
  %D_lat=(lat_f-lat_i)*pi/180;
  %
  %py=Rt/1000*D_lat/ry;
  %
  %lat_ref=(lat_i+lat_f)/2;
  %px=Rt/1000*sin((90-lat_ref)*pi/180)*D_lon*pi/180/rx;
  %----------------------------------------------------
  mean_lat=(lat_i+lat_f)/2;
  Klon=sph_dist(mean_lat,lon_i,mean_lat,lon_f,Rt/1000);
  Klat=sph_dist(lat_i,0,lat_f,0,Rt/1000);
  px=Klon/rx;
  py=Klat/ry;
end

lat=0:90;
x_lon=Rt*sin((90-lat)*pi/180)*pi/180*1; % para delta_lon=1º.
y_lat=Rt*pi/180*1; % para delta_lat=1º.

figure
subplot(2,1,1)
plot(x_lon/1000), xlim([0 90]), ylim([0 115]); grid
ylabel('distance along meridians, Km');
xlabel('Lat')
title('y length vs Lat')

subplot(2,1,2)
t_v=['1 lon degree at lat=41º = ',num2str(Rt*sin((90-41)*pi/180)*pi/180/1000),' Km'];
t_h=['1 lat degree = ',num2str(y_lat/1000),' Km'];
text(0,.75,t_v)
text(0,.5,t_h)
axis off

if nargin==6
  t_lo=[' # lon € [',num2str(lon_i),' , ',num2str(lon_f),'], rx= ',num2str(rx),' ==> px= ',num2str(round(px))];
  t_la=[' # lat € [',num2str(lat_i),' , ',num2str(lat_f),'], ry= ',num2str(ry),' ==> py= ',num2str(round(py))];
  text(0,0,t_lo)
  text(0,.2,t_la)
end
