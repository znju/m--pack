function sta_grid_pos(grd,sta,pos)
%STA_GRID_POS   Plot ROMS stations location
%   With more than one argument, a stations can be selected using left
%   mouse button, until one right mouse click.
%   The number of such station will be returned as I.
%
%   Syntax:
%      I = STA_GRID_POS(GRID,STA,POS)
%
%   Inputs:
%      GRD   ROMS NetCDF grid or history file
%      STA   ROMS output stations file
%      POS   Station(s), all by default
%
%   Output:
%      I   Selected station numbers
%
%   Examples:
%      sta_grid_pos
%      sta_grid_pos('grid.nc','station.nc');
%      sta_grid_pos('grid.nc','station.nc',[1:10]);
%      sta_grid_pos('grid.nc','station.nc',123);
%
%
%   MMA 11-12-2002, mma@odyle.net
%

%   07-04-2009 - some improv.

%   CESAM, Aveiro, Portugal

init=0;
if nargin>=2
  init=1;
end

opt='b.';

if init
  [lon,lat,h,m]=roms_grid(grd);
  contour(lon,lat,m,[.5 .5],'r');
  hold on
  contour(lon,lat,h,[200 500],'k');
  axis([min(min(lon))-.1 max(max(lon))+.1 min(min(lat))-.1 max(max(lat))+.1])
  title(grd,'interpreter','none');

  [lonb,latb]=roms_border(grd);
  plot(lonb,latb,'r');

  if     n_varexist(sta,'lon_rho'), lon_sta=use(sta,'lon_rho');
  elseif n_varexist(sta,'lon'),     lon_sta=use(sta,'lon');
  elseif n_varexist(sta,'LON'),     lon_sta=use(sta,'LON');
  end

  if     n_varexist(sta,'lat_rho'), lat_sta=use(sta,'lat_rho');
  elseif n_varexist(sta,'lat'),     lat_sta=use(sta,'lat');
  elseif n_varexist(sta,'LAT'),     lat_sta=use(sta,'LAT');
  end

  if      n_varexist(sta,'h'), h_sta=use(sta,'lat_rho');
  elseif  n_varexist(sta,'H'), h_sta=use(sta,'H');
  end

  pos=1:prod(size(lon_sta));
  if nargin == 2
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
  xlabel(label);
  ylabel(sta,'interpreter','none');

  data.lon=lon_sta;
  data.lat=lat_sta;
  data.h=h_sta;
  data.label=label;
  set(gcf,'userdata',data);

  uicontrol('units','normalized','position',[.88 .02 .1 .03],'string','select',...
            'callback','sta_grid_pos');

  set(gcf,'toolbar','figure');

else % select
  data=get(gcf,'userdata');
  lon=data.lon;
  lat=data.lat;
  h=data.h;
  label=data.label;

  hold on
  % Initially, the list of points is empty.
  xy = [];
  n = 0;
  % Loop, picking up the points.
  disp('Left mouse button picks points.')
  disp('Right mouse button picks last point.')
  but = 1;
  tmp=[];
  while but == 1
    [xi,yi,but] = ginput(1);
    if but == 1
      % distancia:
      dist=(xi-lon).^2+(yi-lat).^2;
      [y,i]=min(dist(:));
      if ~isempty(tmp), delete(tmp); end
      tmp=plot(lon(i),lat(i),'ro');
      %      plot(xi,yi,'ro')
      n = n+1;
      %      xy(:,n) = [xi;yi];
      fprintf(1,'## station number: %6.0f ; h = %10.2f\n',i,h(i))
      xlabel([label,'; current selected: ',int2str(i),...
          ' ; h = ',num2str(h(i))])
    end
  end
  if ~isempty(tmp), set(tmp,'color',[.5 .5 .5]); end
end
