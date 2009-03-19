function R_slicecb(what)
% sselect slicee type.

global H

%unselect_all:
objs=[
H.ROMS.grid.icb
H.ROMS.grid.jcb
H.ROMS.grid.loncb
H.ROMS.grid.latcb
H.ROMS.grid.kcb
H.ROMS.grid.zcb
];
set(objs,'value',0);

evalc(['set(H.ROMS.grid.',what,',''value'',1)'],'');
