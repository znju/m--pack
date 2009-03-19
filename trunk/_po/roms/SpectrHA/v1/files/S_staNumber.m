function S_staNumber
%function S_staNumber
%Select stations (edit)
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FSTA HANDLES LOOK ETC
S_pointer

marker=LOOK.marker.select;
markerColor=LOOK.markerColor.select;
markerColorOld=LOOK.markerColorOld.select;
markerSize=LOOK.markerSize.select;

axes(HANDLES.grid_axes);

fid=fopen(ETC.logname,'a');
%%fprintf(fid,'%s\n','# Selecting stations...');
if isempty(FSTA.name)
  errordlg('No station loaded','missing...','modal');
  fclose(fid);
  set(HANDLES.selectN,'string','sta#');
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
  h_sta=reshape(h_sta,n,1);

L=length(lon_sta);

str=get(HANDLES.selectN,'string');
val=str2num(str);

if isempty(val) | val-round(val) ~= 0 | val < 1 | val > L | any(isnan(val))
  on_error
  return
end
if isequal(length(val),1)
  i=val;  
elseif isequal(length(val),2)
  if val(2) > x  | val(1) > y
    on_error  
    return
  end
  i=sub2ind([x y],val(2),val(1));
else
  on_error;
  return
end

  lon=lon_sta(i);
  lat=lat_sta(i);
  h=h_sta(i);
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
        FSTA.selected=plot(xs,ys,'color',markerColorOld,'marker',marker,'markersize',markerSize');
        delete(FSTA.current)
        FSTA.current=plot(lon_sta(i),lat_sta(i),'color',markerColor,'marker',marker,'markersize',markerSize');
      end
%--------------------------------------------------------------------

set(HANDLES.selectN,'string','sta#');

%choose stations:
S_choose('station');

function on_error
global HANDLES
errordlg('Bad station number...','wrong...','modal');
set(HANDLES.selectN,'string','sta#');


