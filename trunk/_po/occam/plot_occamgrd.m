function plot_occamgrd(g)
%PLOT_OCCAMGRD   Plot OCCAM grid
%
%   Sintax:
%      PLOT_OCCAMGRD(FILE)
%
%   Inputs:
%      FILE   OCCAM file
%
%   MMA 16-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

figure
[x,y,h,m]=occam_grid(g);

Lon=[min(x(:)) max(x(:))];
Lat=[min(y(:)) max(y(:))];

m_proj('mercator','lon',Lon,'lat',Lat);
m_grid;
hold on

try
  cl=load('south_atlantic');
  m_plot(cl.lon,cl.lat)
end

h(h==0)=nan;
pc=m_pcolor(x,y,h); set(pc,'edgecolor','none');
colorbar

m_contour(x,y,m,[.5 .5],'g')
