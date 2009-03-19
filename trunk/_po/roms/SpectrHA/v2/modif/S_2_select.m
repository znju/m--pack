function status=S_2_select
%function S_2_select
%Select stations with mouse
%
%this function is part of SpectrHA utility  (v2)
%MMA, Jul-2003
%martinho@fis.ua.pt

global FSTA HANDLES LOOK ETC

status = [];

S_pointer

marker=LOOK.marker.select;
markerColor=LOOK.markerColor.select;
markerColorOld=LOOK.markerColorOld.select;
markerSize=LOOK.markerSize.select;

fid=fopen(ETC.logname,'a');
%%fprintf(fid,'%s\n','# Selecting stations...');
if isempty(FSTA.name) 
  errordlg('No station loaded','missing...','modal');
  fclose(fid);
  status = 'error';
  return
end

% load vars:
lon_sta=S_get_ncvar(FSTA.name,'lon_sta');
  x=size(lon_sta,1);
  y=size(lon_sta,2);
  n=x*y;
  lon_sta=reshape(lon_sta,n,1);
lat_sta=S_get_ncvar(FSTA.name,'lat_sta');
  lat_sta=reshape(lat_sta,n,1);
h_sta=S_get_ncvar(FSTA.name,'bathy_sta');
  try
    h_sta=reshape(h_sta,n,1);
  catch
    h_sta = 0;
  end

% select whith mouse left button until rigth is pressed:
uistate=uisuspend(gcf);
%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»» Add new:
%uirestore(uistate,'WindowButtonMotionFcn') 
set(gcf,'WindowButtonMotionFcn','S2_disp_pos'); % do not move rulers !!
%«««««««««««««««««««««««««««««««««««««««««««««« done,
set(gcf,'pointer','circle'); 
button = 'normal';
while strcmp(button,'normal')
  keydown = waitforbuttonpress;
  button = get(gcf, 'SelectionType');
  if  strcmp(button,'normal')
    if gca==HANDLES.grid_axes
      cp=get(gca,'currentpoint');
      xi=cp(1,1);
      yi=cp(1,2);
      dist=(xi-lon_sta).^2+(yi-lat_sta).^2;
      [y,i]=min(dist);
        lon=lon_sta(i);
        lat=lat_sta(i);
        try
          h=h_sta(i);
        catch
          h=0;
        end
      [I,J]=ind2sub([x y],i);
      FSTA.i=[J I];
      FSTA.lat=lat;
      fprintf(fid,'Station:%4d x %4d h=%8.2f [ %10.2f x %10.2f ]\n',J,I,h,lon,lat);
      str=sprintf('Station:%4d x %4d h=%8.2f [ %6.2f x %6.2f ]\n',J,I,h,lon,lat);
      xlabel(str,'color',LOOK.color.xlabel_grid,'FontName',LOOK.fontname);               
% plot:---------------------------------------------------------------
      if isempty(FSTA.selected)
        FSTA.selected=plot(lon_sta(i),lat_sta(i),'color',markerColor,'marker',marker,'markersize',markerSize');
      else
        xs=get(FSTA.selected,'xdata');
        ys=get(FSTA.selected,'ydata');
        xs=[xs NaN lon_sta(i)];
        ys=[ys NaN lat_sta(i)];
        delete(FSTA.selected);
        FSTA.selected=plot(xs,ys,'color',markerColorOld,'marker',marker,'markersize',markerSize);
        delete(FSTA.current)
        FSTA.current=plot(lon_sta(i),lat_sta(i),'color',markerColor,'marker',marker,'markersize',markerSize);
      end
%--------------------------------------------------------------------
    else
      button='not the desired axis';
    end % click correct axes
  end
end % while

%choose stations:
S_choose('station');

S_pointer;
uirestore(uistate);
fclose(fid);

return
