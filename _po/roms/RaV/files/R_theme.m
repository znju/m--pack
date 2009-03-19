function R_theme
global H

obj = findobj(gcf,'style','popupmenu');
set(obj,'backgroundcolor',H.theme.textbg,'foregroundcolor',H.theme.textfg);

obj = findobj(gcf,'string','>>');
set(obj,'foregroundcolor',H.theme.inctfg);
obj = findobj(gcf,'string','<<');
set(obj,'foregroundcolor',H.theme.inctfg);

obj = findobj(gcf,'string','load');
set(obj,'foregroundcolor',H.theme.inctfg);

set(H.ROMS.axes,'xcolor',H.theme.inctfg,'ycolor',H.theme.inctfg);

% set backckground color of color-buttons:
% bathy:
set(H.ROMS.his.morebathyc,'backgroundColor','k');

%mask:
set(H.ROMS.his.moremaskc,'backgroundColor','r');

% arrows:
set(H.ROMS.his.morearrcolor,'backgroundColor','r');

% contours:
set(H.ROMS.his.morelinec1,'backgroundColor','k');
set(H.ROMS.his.morelinec2,'backgroundColor','r');
