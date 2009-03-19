function R_toogle(what)
global H

% restore pointer (may be used in case of errors to stop the clock)
set(gcf,'Pointer','arrow');

% unselect all:
set(H.ROMS.toggle_grid, 'value',0);
set(H.ROMS.toggle_his,  'value',0);
set(H.ROMS.toggle_sta,  'value',0);
set(H.ROMS.toggle_flt,  'value',0);

% hide all ROMS buttons
set(findobj('userdata','roms_grid'), 'visible','off');

set(findobj('userdata','roms_his1'),  'visible','off');
set(findobj('userdata','roms_his2'),  'visible','off');
set(findobj('userdata','roms_his_more'),  'visible','off');


set(findobj('userdata','roms_sta'),  'visible','off');
set(findobj('userdata','roms_flt'),  'visible','off');


% enable current:
if isequal(what,'his')
  set(findobj('userdata','roms_his2'),  'visible','on');
  set(findobj('userdata','roms_his1'),  'visible','on');
  set(findobj('userdata','roms_his_more'),  'visible','on');
  R_varopts('stop');
  evalc(['set(H.ROMS.toggle_',what,', ''value'',1)']);
else
  evalc(['set(H.ROMS.toggle_',what,', ''value'',1)']);
  evalc(['set(findobj(''userdata'',''roms_',what,'''),  ''visible'',''on'');']);
end
