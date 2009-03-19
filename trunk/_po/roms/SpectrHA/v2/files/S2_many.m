function S2_many

global HANDLES FSTA

stations=get(HANDLES.z_many,'string');
stations=str2num(stations);
if isempty(stations)
  return
end

val=get(HANDLES.z_many,'value');
set(HANDLES.selectN,'string',num2str(stations(val,:)));
S2_select(2);

