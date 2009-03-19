function i = sta_grid_pos(grd,sta,pos,opt)
%STA_GRID_POS   Plot ROMS stations location
%   With more than one argument, a stations can be selected using left
%   mouse button, until one right mouse click.
%   The number of such station will be returned as I.
%
%   Syntax:
%      I = STA_GRID_POS(GRID,STA,POS,OPT)
%
%   Inputs:
%      GRD   ROMS NetCDF grid or history file
%      STA   ROMS output stations file
%      POS   Station, all by default
%      OPT   Plot option  [ 'bo' ]
%
%   Output:
%      I   Selected station numbers
%
%   Examples:
%      sta_grid_pos
%      sta_grid_pos('grid.nc','station.nc');
%      sta_grid_pos('grid.nc','station.nc',[1:10]);
%      sta_grid_pos('grid.nc','station.nc',123,'r.');
%
%   Comment:
%      DEPRECATED, use SpectrHA toolbox instead
%
%   MMA 11-12-2002, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 4
  opt='bo';
end
issta=1;
isgrd=1;
if nargin < 2
  [filename, pathname] = uigetfile('*.nc', 'Select ROMS stations file');
  sta=[pathname,filename];
  if isequal(sta,[0 0])
    issta=0;
  end
end

if nargin < 1
  [filename, pathname] = uigetfile('*.nc', 'Select grid file');
  grd=[pathname,filename];
  if isequal(grd,[0 0])
    isgrd=0;
  end
end

if isgrd
  m=use(grd,'mask_rho');
  h=use(grd,'h');
  lon=use(grd,'lon_rho');
  lat=use(grd,'lat_rho');
  pcolor(lon,lat,m); colormap([.5 .5 .5; 1 1 1]);
  hold on
  contour(lon,lat,h,[200 500],'k');
  axis([min(min(lon))-.1 max(max(lon))+.1 min(min(lat))-.1 max(max(lat))+.1])
  title(grd,'interpreter','none');
end

if issta
  lon_sta=use(sta,'lon_rho');
  lat_sta=use(sta,'lat_rho');
  h_sta=use(sta,'h');
  pos=1:length(lon_sta);
  if nargin == 2
    opt='b+';
    label='all stations';
  elseif nargin > 2
    if length(pos) == 1
      label=int2str(pos);
    else
      label=[num2str(pos(1)),' : ',num2str(pos(end))];
    end
  end
  hold on
  plot(lon_sta(pos),lat_sta(pos),opt)
  shading flat, label
  xlabel(label);
  ylabel(sta,'interpreter','none');


  %=====================================================================
  % GINPUT:
  %=====================================================================
  hold on
  % Initially, the list of points is empty.
  xy = [];
  n = 0;
  % Loop, picking up the points.
  disp('Left mouse button picks points.')
  disp('Right mouse button picks last point.')
  but = 1;
  while but == 1
    [xi,yi,but] = ginput(1);
    if but == 1
      % distancia:
      dist=(xi-lon_sta).^2+(yi-lat_sta).^2;
      [y,i]=min(dist);
      plot(lon_sta(i),lat_sta(i),'ro')
      %      plot(xi,yi,'ro')
      n = n+1;
      %      xy(:,n) = [xi;yi];
      fprintf(1,'## station number: %6.0f ; h = %10.2f\n',i,h_sta(i))
      xlabel([label,'; current selected: ',int2str(i),...
          ' ; h = ',num2str(h_sta(i))])
    end
  end
end
