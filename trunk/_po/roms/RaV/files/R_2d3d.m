function R_2d3d(what)

global H

d2 = H.ROMS.his.d2;
d3 = H.ROMS.his.d3;

set(d2,'value',0);
set(d3,'value',0);

if isequal(what,2)
  set(d2,'value',1);
elseif isequal(what,3)
  set(d3,'value',1);
end

