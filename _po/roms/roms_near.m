function [xi,eta]=roms_near(f,x,y,plt)
%ROMS_NEAR   Search nearest index from point in ROMS file
%   Will use the ROMS variables lon_rho or lon and lat_rho or lat
%   to find the nearest xi,eta from a given point
%
%   Syntax:
%     [XI,ETA] = ROMS_NEAR(FILE,X,Y,PLT)
%
%   Inputs:
%      FILE   ROMS file wuth grid variables, like stations, his, etc
%      X,Y    If none, ginput is used
%      PLT    Plot grid and points flag (default=0)
%
%   Outputs:
%      XI,ETA   Nearest point index
%
%   Example:
%      [xi,eta]=roms_near('roms_grd.nc',x,y);
%
%   MMA 11-10-2006, martinho@fis.ua.pt
%
%   See also FIND_NEAREST, PLOT_ROMSGRD

xi  = [];
eta = [];

if nargin <4
  plt=0;
end

if nargin < 3
  plt=1;
end

if plt
  fig=gcf;
  if ~isequal(get(fig,'tag'),'plot_romsgrd')
    plot_romsgrd(f)
    set(gcf,'tag','plot_romsgrd')
  end
end

if nargin < 3
  [x,y]=m_input(1);
  [x,y]=m_xy2ll(x,y);
end

if isempty(x) | isempty(y)
  return
end

if plt
  hold on
  m_plot(x,y,'bo');
end

isHis=1;
if n_varexist(f,'lon');
  isHis=0;
end

if isHis
  lon=use(f,'lon_rho');
  lat=use(f,'lat_rho');
else
  lon=use(f,'lon');
  lat=use(f,'lat');
end
[i,j]=find_nearest(lon,lat,x,y);

if plt
  m_plot(lon(i,j),lat(i,j),'r*');
end

xi=j(1);
eta=i(1);
