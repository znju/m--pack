function [x,y,h,m]=roms_grid(g,ruvp,varargin)
%ROMS_GRID   Get ROMS grid data x, y, h and mask
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
%   21-04-2010, IO-USP

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

x=[];
y=[];
h=[];
m=[];

vars=n_filevars(g);
nc=netcdf(g);
h=nc{'h'}(:);
mr=nc{'mask_rho'}(:);
[mu,mv,mp]=uvp_mask(mr);
if strcmpi(ruvp,'u')
  if ismember('lon_u',vars) & ismember('mask_u',vars)
    x=nc{'lon_u'}(:);
    y=nc{'lat_u'}(:);
    m=nc{'mask_u'}(:);
  elseif ismember('x_u',vars) & ismember('mask_u',vars)
    x=nc{'x_u'}(:);
    y=nc{'y_u'}(:);
    m=nc{'mask_u'}(:);
  else
    [x,y]=load_rho(nc,vars);
    x=(x(:,2:end)+x(:,1:end-1))/2;
    y=(y(:,2:end)+y(:,1:end-1))/2;
    h=(h(:,2:end)+h(:,1:end-1))/2;
    m=mu;
  end

elseif strcmpi(ruvp,'v')
  if ismember('lon_v',vars) & ismember('mask_v',vars)
    x=nc{'lon_v'}(:);
    y=nc{'lat_v'}(:);
    m=nc{'mask_v'}(:);
  elseif ismember('x_v',vars) & ismember('mask_v',vars)
    x=nc{'x_v'}(:);
    y=nc{'y_v'}(:);
    m=nc{'mask_v'}(:);
  else
    [x,y]=load_rho(nc,vars);
    x=(x(2:end,:)+x(1:end-1,:))/2;
    y=(y(2:end,:)+y(1:end-1,:))/2;
    h=(h(2:end,:)+h(1:end-1,:))/2;
    m=mv;
  end

elseif strcmpi(ruvp,'p')
  if ismember('lon_psi',vars) & ismember('mask_psi',vars)
    x=nc{'lon_psi'}(:);
    y=nc{'lat_psi'}(:);
    m=nc{'mask_psi'}(:);
  elseif ismember('x_psi',vars) & ismember('mask_psi',vars)
    x=nc{'x_psi'}(:);
    y=nc{'y_psi'}(:);
    m=nc{'mask_psi'}(:);
  else
    [x,y]=load_rho(nc,vars);
    x=(x(:,2:end)+x(:,1:end-1))/2; x=(x(2:end,:)+x(1:end-1,:))/2;
    y=(y(:,2:end)+y(:,1:end-1))/2; y=(y(2:end,:)+y(1:end-1,:))/2;
    h=(h(:,2:end)+h(:,1:end-1))/2; h=(h(2:end,:)+h(1:end-1,:))/2;
    m=mp;
  end
else
  [x,y]=load_rho(nc,vars);
  m=mr;
end
close(nc);

if ~(isequal(xi,xi0) & isequal(eta,eta0))
  x=eval(['x(' num2str(eta) ',' num2str(xi) ')']);
  y=eval(['y(' num2str(eta) ',' num2str(xi) ')']);
  h=eval(['h(' num2str(eta) ',' num2str(xi) ')']);
  m=eval(['m(' num2str(eta) ',' num2str(xi) ')']);
end

if isll
  m=griddata(x,y,m,lon,lat);
  h=griddata(x,y,h,lon,lat);
  x=lon;
  y=lat;
end


function [x,y]=load_rho(nc,vars)
x=[];
y=[];
if ismember('lon_rho',vars)
  x=nc{'lon_rho'}(:);
  y=nc{'lat_rho'}(:);
elseif ismember('x_rho',vars)
  x=nc{'x_rho'}(:);
  y=nc{'y_rho'}(:);
end

