function R_axprop

global H

axes(H.ROMS.axes);

set(gca,'color',H.theme.axbg,'xcolor',H.theme.axfg,'ycolor',H.theme.axfg,'zcolor',H.theme.axfg);

%set(gca,'xcolor','r','ycolor','r','tag','rcdv-only');
R_theme