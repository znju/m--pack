function R_delcolorbar

global H

% remove colorbar that appear after GUI resize; also update axis-title size:

% fisrt check if colorbar exists...

ap  = get(H.ROMS.axes,'position');
atp = get(H.axes_title,'position');

evalc('cb=ishandle(H.colorbar);','cb=0;');
if cb
  set(colorbar,'visible','off');
end

set(H.axes_title,'position',[atp(1) atp(2) ap(3) atp(4)]);
