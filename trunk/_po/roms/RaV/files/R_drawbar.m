function R_drawbar(what)
% adds and remoevs draw-bar

global H

evalc('down   = H.ROMS.fcn.down;','   down = '''';'   );
evalc('motion = H.ROMS.fcn.motion;', 'motion = '''';' );
evalc('up     = H.ROMS.fcn.up;',     'up = '''';'     );

if nargin == 0
  return
end

if isequal(what,'add')
  pos = [.8 .95 .2 .05];
  draw_bar([.8 .95 .2 .05]);
elseif isequal(what,'del')
  fcn = {down,motion,up};
  draw_bar(fcn);
end