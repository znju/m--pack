function S2_hide

global HANDLES FSTA FGRID ETC

val=get(HANDLES.output,'visible');
hiden_obj=findobj('tag','new');

if isequal(val,'on')
  set(HANDLES.output,   'visible','off');
  set(hiden_obj,'visible','on');
else
  set(HANDLES.output,   'visible','on');
  set(hiden_obj,'visible','off');
end

%---------------------------------

S2_update_z
