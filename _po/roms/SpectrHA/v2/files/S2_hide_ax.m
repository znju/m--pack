function S2_hide_ax(val)
% nargin: val= is spectrum axes visible

global HANDLES FSTA FGRID ETC

if nargin == 0
  val=get(HANDLES.spectrum_axes,'visible');
end


if isequal(val,'on')
  set(HANDLES.spectrum_axes,   'visible','off');
  set(HANDLES.z_ax,    'visible','on');

  axes(HANDLES.z_ax);
  S2_axes_prop

  S2_legend
else
  set(HANDLES.spectrum_axes,   'visible','on');
  set(HANDLES.z_ax,    'visible','off');
 
  axes(HANDLES.spectrum_axes);
  S_axes_prop;

  S_upd_legend
end

