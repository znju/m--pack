function R_stasetts(what)

global H

% well, I will demand that when the checkboxe time is checked, so will the the  vert one.
% otherwise,  a variable at a fixes time without vertical profile is just one point !!

if isequal(what,'t')
  if get(H.ROMS.sta.tprofile,'value')
    set(H.ROMS.sta.vprofile,'value',1)
  end
end

if isequal(what,'v')
  if ~get(H.ROMS.sta.vprofile,'value') & get(H.ROMS.sta.tprofile,'value')
    set(H.ROMS.sta.tprofile,'value',0);
  end
end
