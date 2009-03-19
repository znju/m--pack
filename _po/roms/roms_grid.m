function [x,y,h,m]=roms_grid(g,ruvp,varargin)
%POM_GRID   Get ROMS grid data x, y, h and mask
%
%   Syntax:
%      [X,Y,H,M] = ROMS_GRID(FNAME,RUVP,VARARGIN)
%
%   Inputs:
%      FNAME   ROMS NetCDF grid
%      RUVP    Locations, may be 'r', 'u', 'v', or 'p', for rho, u,
%              v and psi points (default is 'r')
%      VARARGIN:
%        xi, xi slice, default='1:end'
%        eta, eta slice, default='1:end'
%        lon, longitude vector; If length is 3, lon will be
%             linspace(LON(1),LON(2),LON(3)
%        lat  latitude vector, linspace is also used if length is 3;
%             in case of lon and lat are defined, interpolation occurs
%
%   Outputs:
%      X,Y   Lon and lat
%      H     Depth
%      M     Mask
%
%   Example:
%      [x,y,h,m] = roms_grid('roms_grd.nc','v');
%
%   MMA 02-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

% Created from pom_grid. A previous roms_grid existed (18-8-2004)
% but was returning only for rho points

if nargin <2
  ruvp='r';
end

xi  = '1:end'; xi0=xi;
eta = '1:end'; eta0=eta;
lon=0;
lat=0;
isll=0;
vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'xi'),    xi  = vin{i+1};
  elseif isequal(vin{i},'eta'),   eta = vin{i+1};
  elseif isequal(vin{i},'lon'),   lon = vin{i+1};
  elseif isequal(vin{i},'lat'),   lat = vin{i+1};
  end
end

if lon & lat
  isll=1;
  if length(lon)==3, lon=linspace(lon(1),lon(2),lon(3)); end
  if length(lat)==3, lat=linspace(lat(1),lat(2),lat(3)); end
end

if ~ismember(ruvp,{'r','u','v','p'})
  ruvp='r';
end

if strcmpi(ruvp,'p')
  x_name = 'lon_psi';  xx_name = 'x_psi';
  y_name = 'lat_psi';  yy_name = 'y_psi';
  m_name = 'mask_psi';
  xdim = 'xi_psi';
  ydim = 'eta_psi';
elseif strcmpi(ruvp,'u')
  x_name = 'lon_u';    xx_name = 'x_u';
  y_name = 'lat_u';    yy_name = 'y_u';
  m_name = 'mask_u';
  xdim = 'xi_u';
  ydim = 'eta_u';
elseif strcmpi(ruvp,'v')
  x_name = 'lon_v';    xx_name = 'x_v';
  y_name = 'lat_v';    yy_name = 'y_v';
  m_name = 'mask_v';
  xdim = 'xi_v';
  ydim = 'eta_v';
elseif strcmpi(ruvp,'r')
  x_name = 'lon_rho';  xx_name = 'x_rho';
  y_name = 'lat_rho';  yy_name = 'y_rho';
  m_name = 'mask_rho';
  xdim = 'xi_rho';
  ydim = 'eta_rho';
end

if ~n_varexist(g,x_name)
  x_name=xx_name;
  y_name=yy_name;
end

x=use(g,x_name,xdim,xi,ydim,eta);
y=use(g,y_name,xdim,xi,ydim,eta);
m=use(g,m_name,xdim,xi,ydim,eta);

h=use(g,'h');
if strcmpi(ruvp,'u')
  h=(h(:,2:end)+h(:,1:end-1))/2;
elseif strcmpi(ruvp,'v')
  h=(h(2:end,:)+h(1:end-1,:))/2;
elseif strcmpi(ruvp,'p')
  h=(h(:,2:end)+h(:,1:end-1))/2;
  h=(h(2:end,:)+h(1:end-1,:))/2;
end

if ~(isequal(xi,xi0) & isequal(eta,eta0))
  h=eval(['h(' num2str(eta) ',' num2str(xi) ')']);
end

if isll
  m=griddata(x,y,m,lon,lat);
  h=griddata(x,y,h,lon,lat);
  x=lon;
  y=lat;
end
