function R_roms(action)

global H

if isequal(action,'start');
  % keep colormaap:
  H.colormap=colormap;

  obj=findobj(gcf,'tag','ncdv-only');
  set(obj,'visible','off');

  obj=findobj(gcf,'tag','rcdv-only');
  set(obj,'visible','on');

  % this do not work always for the axes!?, so
  % hide all axes and children:
  ax=findobj(gcf,'type','axes');
  set(ax,'visible','off');
  for i=1:length(ax)
    objs=get(ax(i),'children');
    set(objs,'visible','off');
  end
  % view ROMS axes and children:
  set(H.ROMS.axes,'visible','on' );
  set(get(H.ROMS.axes,'children'),'visible','on' );

  % reset axes-title position:
  R_delcolorbar
  colormap([1 1 1;.5 .5 .5])

  % clear axes_title
  set(H.axes_title,'string','');

  R_toogle('grid');

  % change menu rav vs ncdv:
  set(H.menu_rcdv,'label','ncdv','callback','R_roms(''stop'');');
end

if isequal(action,'stop');
  colormap(H.colormap);

  obj=findobj(gcf,'tag','ncdv-only');
  set(obj,'visible','on');

  obj=findobj(gcf,'tag','rcdv-only');
  set(obj,'visible','off');

  % this do not work always for the axes!?, so
  % show all axes and children:
  ax=findobj(gcf,'type','axes');
  set(ax,'visible','on');
  for i=1:length(ax)
    objs=get(ax(i),'children');
    set(objs,'visible','on');
  end
  % hide ROMS axes and children:
  set(H.ROMS.axes,'visible','off' );
  set(get(H.ROMS.axes,'children'),'visible','off' );

  % change menu rav vs ncdv:
   set(H.menu_rcdv,'label','rav','callback','R_roms(''start'');');
end
