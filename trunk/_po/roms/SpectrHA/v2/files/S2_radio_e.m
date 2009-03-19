function S2_radio_e(in)

global HANDLES


set(HANDLES.major_box,'value',0);
set(HANDLES.minor_box,'value',0);
set(HANDLES.inc_box,'value',0);
set(HANDLES.phase_box,'value',0);
%-------------------- MMA, 29-4-2004: add ECC
set(HANDLES.ecc_box,'value',0);
%---------------------------------------------- end

if isequal(in,'major');
  set(HANDLES.major_box,'value',1);
end

if isequal(in,'minor')
  set(HANDLES.minor_box,'value',1);
end

if isequal(in,'inc')
  set(HANDLES.inc_box,'value',1);
end

if isequal(in,'phase')
  set(HANDLES.phase_box,'value',1);
end
%-------------------- MMA, 29-4-2004: add ECC
if isequal(in,'ecc')
  set(HANDLES.ecc_box,'value',1);
end
%---------------------------------------------- end

