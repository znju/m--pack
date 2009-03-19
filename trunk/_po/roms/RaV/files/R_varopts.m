function R_varopts(what)

% show/hide options for his variables, tag= roms_his_more

global H

hisframe1 = findobj(gcf,'userdata','roms_his1');
his_more  = findobj(gcf,'userdata','roms_his_more');

thehandle = H.ROMS.his.varopts; % used to toggle
thestart  = 'R_varopts(''start'');';
thestop   = 'R_varopts(''stop'');';

if isequal(what,'start')
  set(hisframe1, 'visible','off');
  set(his_more,  'visible','on');

  set(thehandle,'callback',thestop);
  set(thehandle,'string','<<');
  set(thehandle,'visible','on');
end

if isequal(what,'stop')
  set(hisframe1, 'visible','on');
  set(his_more,  'visible','off');

  set(thehandle,'callback',thestart);
  set(thehandle,'string','>>');
  set(thehandle,'visible','on');
end

