function R_stamarker

global H

hp  = H.ROMS.sta.points;
hs  = H.ROMS.sta.selectmarker;

% get markersize:
tmp = get(hs,'string');
ms = tmp{get(hs,'value')};
ms = str2num(ms);

if ms == 0
  set(hp,'visible','off');
  return
end

eval('is = ishandle(hp);','is=0;');

if is
  set(hp,'visible','on');
  set(hp,'markersize',ms);
end




