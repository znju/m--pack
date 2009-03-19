function S2_radio_s(in)

global HANDLES


set(HANDLES.amp_box,'value',0);
set(HANDLES.pha_box,'value',0);

if isequal(in,'amp');
  set(HANDLES.amp_box,'value',1);
end

if isequal(in,'pha')
  set(HANDLES.pha_box,'value',1);
end


