function show_mask(file,varargin)
%SHOW_MASK   Display mask from ROMS grid or history file
%   Ps: i,j starts as 0,0
%
%   Syntax:
%      SHOW_MASK(GRD,VARARGIN)
%
%   Inputs:
%      GRD   Name of the NetCDF file [ {<none>} <filename> ];
%            it should be grid or history file
%      VARARGIN:
%         'uvr', [{0} | 1], show u, v and rho points, as o, > and ^
%
%   Examples:
%      show_mask('grid.nc')
%      show_mask('his.nc','uvr',1)
%
%   MMA 5-5-2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   11-01-2005 - New version
%      06-2007 - A couple of changes

if nargin == 0
  file = netcdf('*.nc');
  file=name(file);
end
if isempty(file) & nargin == 1
  return
end

uvr = 0;
vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'uvr')
    uvr = vin{i+1};
  end
end

if n_varexist(file,'lon_rho')
  lonr = use(file,'lon_rho');
elseif n_varexist(file,'x_rho')
  lonr = use(file,'x_rho');
end

if n_varexist(file,'lat_rho')
  latr = use(file,'lat_rho');
elseif n_varexist(file,'y_rho')
  latr = use(file,'y_rho');
end

if  n_varexist(file,'mask_rho')
  maskr = use(file,'mask_rho');
else
  maskr = ones(size(lonr));
end

if  n_varexist(file,'mask_u') &   n_varexist(file,'mask_v')
  masku = use(file,'mask_u');
  maskv = use(file,'mask_v');
else
  [masku,maskv,pmask]=uvp_masks(maskr);
end

% --------------------------------------------------------------------
[m,n] = size(lonr);
[lonr,latr] = meshgrid(0:n-1,0:m-1);
lonu = (lonr(:,1:end-1) + lonr(:,2:end) )/2;
latu = (latr(:,1:end-1) + latr(:,2:end) )/2;
lonv = (lonr(1:end-1,:) + lonr(2:end,:) )/2;
latv = (latr(1:end-1,:) + latr(2:end,:) )/2;

[lon,lat] = gen_grid(lonr,latr); %lon=lon-1; lat=lat-1;

% --------------------------------------------------------------------
mr=maskr;
mr(:,end+1)=mr(:,end);
mr(end+1,:)=mr(end,:);
p=pcolor(lon,lat,mr); colormap([1 1 0.781; 1 1 1]);
set(p,'edgecolor',[.8 .8 .8])

xl=xlim; dx=diff(xl);
yl=ylim; dy=diff(yl);
r=20;
axis([xl(1)-dx/r xl(2)+dx/r  yl(1)-dy/r yl(2)+dy/r])

if uvr
  hold on

  % rho, u, v
  set_points(lonr,latr,maskr,'rho');
  set_points(lonu,latu,masku,'u');
  set_points(lonv,latv,maskv,'v');
end

lh = .8;
lw = .5;
set(gcf,'units','normalized');
fp = get(gcf,'position');
set(gcf,'position',[0.5-lw/2 0.5-lh/2 lw lh]);
set(gca,'position',[0.0738    0.0535    0.8989    0.9092]);


function set_points(x,y,m,type)
global DATA
switch type
  case 'rho'
    opt = 'ko';
  case 'u'
    opt = 'b>';
  case 'v'
    opt = 'r^';
end

i  = m~=0;
obj = findobj(gca,'tag',type);
if isempty(obj)
  pl =plot(x(i),y(i),opt); set(pl,'Markersize',4,'tag',type);
else
  set(obj,'xdata',x(i),'ydata',y(i));
end


function [lon,lat] = gen_grid(lonr,latr)

lon = (lonr(:,2:end)+lonr(:,1:end-1))/2;
lat = (latr(:,2:end)+latr(:,1:end-1))/2;

lon = (lon(2:end,:)+lon(1:end-1,:))/2;
lat = (lat(2:end,:)+lat(1:end-1,:))/2;


lon(2:end+1,2:end+1) = lon;
lon(1,:) = lon(2,:) - (lon(3,:) - lon(2,:));
lon(end+1,:) = lon(end,:) + (lon(end,:) - lon(end-1,:));

lon(:,1) = lon(:,2) - (lon(:,3) - lon(:,2));
lon(:,end+1) = lon(:,end) + (lon(:,end) - lon(:,end-1));


lat(2:end+1,2:end+1) = lat;
lat(1,:) = lat(2,:) - (lat(3,:) - lat(2,:));
lat(end+1,:) = lat(end,:) + (lat(end,:) - lat(end-1,:));

lat(:,1) = lat(:,2) - (lat(:,3) - lat(:,2));
lat(:,end+1) = lat(:,end) + (lat(:,end) - lat(:,end-1));
