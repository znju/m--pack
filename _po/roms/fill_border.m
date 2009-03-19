function handle=fill_border(lon,lat,type,color,dx,dy)
%FILL_BORDER   Fill around ROMS region
%   Fills box around LON x LAT region. The region may be a box,
%   a rectangle from min(LON) until max(LON), and from min(LAT) until
%   max(LAT); or may be the real curvilinear border.
%   LON and LAT are supposed to be from ROMS model.
%   The region to be filled will be between the ROMS region and an
%   exterior rectangle defined by min(LON)-DX(1), max(LON)+dx(2),
%   min(LAT)-DY(1) and max(LAT)+dy(2)
%   If DY is not defined, will be as DX; if DX is also not defined
%   it will (max(LON)-min(LON))/20.
%   If DX(2) or DY(2) are not defined, then DX(2)=DX(1) and
%   DY(2)=DY(1).
%
%
%   Syntax:
%      HANDLE = FILL_BORDER(LON,LAT,TYPE,COLOR,DX,DY)
%
%   Inputs:
%      LON     ROMS longitude
%      LAT     ROMS latitude
%      TYPE    Type of inner box; may be rectangle extremes box, ie,
%              from min(LON) until max(LON) and from min(LAT) until
%              max(LAT), or may be the real curvilinear border
%              [ 'box' {'border'} ]
%      COLOR   Fill FaceColor options [ 'b' ]
%      DX      Left and right offset [ <L R> <a> ]
%      DY      Top and bottom offset [ <T B> <a> ]
%
%   Output:
%      HANDLE   Fill handle
%
%   Examples:
%      fname = 'roms.nc';
%      nc = netcdf(fname);
%        lon = nc{'lon_rho'}(:);
%        lat = nc{'lat_rho'}(:);
%      nc =close(nc);
%      h=fill_border(lon,lat);
%      h=fill_border(lon,lat,'border','r',[1 2],1);
%
%   MMA 13-7-2004, martinho@fis.ua.pt
%
%   See also PLOT_BORDER, M_AXIS

%   Department of Physics
%   University of Aveiro, Portugal

handle=[];

if nargin < 2
  disp('# lon and lat are needed...');
end
if nargin < 5
 dx=(max(max(lon))-min(min(lon)))/20;
 dy=dx;
end
if nargin < 6
  dy=dx;
end
if nargin < 4
  color='b';
end
if nargin < 3
  type='border';
end

h=ishold;
hold on

if isequal(type,'border')
  x=[lon(:,1) ; lon(end,:)' ; lon(:,end) ; flipud(lon(1,:)')];
  y=[lat(:,1) ; lat(end,:)' ; lat(:,end) ; flipud(lat(1,:)')];
elseif isequal(type,'box')
  x=[lon(1,1) lon(1,end) lon(end,end) lon(end,1) lon(1,1)]';
  y=[lat(1,1) lat(1,end) lat(end,end) lat(end,1) lat(1,1)]';
else
  disp('## unrecognised type...');
  return
end

dx1=dx(1);
dy1=dy(1);
evalc('dx2=dx(2);','dx2=dx(1);');
evalc('dy2=dy(2);','dy2=dy(1);');

x1=min(min(lon))-dx1;
x2=max(max(lon))+dx2;
y1=min(min(lat))-dy1;
y2=max(max(lat))+dy2;

x=[x' x1 x2 x2 x1 x1];
y=[y' y1 y1 y2 y2 y1];

handle=fill(x,y,color);
set(handle,'EdgeColor','none');

if ~h
  hold off;
end
