function S2_hold

global HANDLES

S2_hide_ax('on');

axes(HANDLES.z_ax);
val=get(HANDLES.z_hold,'value');
if val
   hold on
else
  hold off
end

S2_legend
