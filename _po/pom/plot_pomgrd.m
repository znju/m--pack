function plt_pomgrd(g)
%PLOT_POMGRD   Plot POM grid
%
%   Sintax:
%      PLOT_POMGRD(FILE)
%
%   Inputs:
%      FILE   POM grid text file
%
%   MMA 11-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

figure
[x,y,h,m]=pom_gridtxt(g);

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
