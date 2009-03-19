function S2_select(ismouse)

global HANDLES ETC FSTA

if ismouse == 1
  status=S_2_select;
  if isequal(status,'error')
      return
  end
else
  S_staNumber
end

if ismouse ~=2 % 2 is used in S2_calc
  % add stations to popupmenu:
  str0=get(HANDLES.z_many,'string');
  if get(HANDLES.many_box,'value')
    str=strvcat(str0, num2str(FSTA.i));
  else
    str=num2str(FSTA.i);
  end

  set(HANDLES.z_many,'value',1);
  set(HANDLES.z_many,'string',str);
end

S2_update_z


