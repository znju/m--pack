function S2_cla

global HANDLES ETC

vis=get(HANDLES.spectrum_axes,'visible');
if isequal(vis,'on')
  axes(HANDLES.spectrum_axes);
else
  axes(HANDLES.z_ax);
end
cla

ETC.new.leg=[];
delete(legend)
