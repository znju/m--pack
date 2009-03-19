function R_hold(what)
% not create new figure if hold on

global H

if nargin == 0
  return
end

theNewFig = H.ROMS.his.newfig;
theHold   = H.ROMS.his.hold;

newfig  = get(theNewFig,'value');
is_hold = get(theHold,'value');

if isequal(what,'hold')
  if is_hold
    set(theNewFig,'value',0);
  end
end

if isequal(what,'newfig')
  if newfig
    set(theHold,'value',0);
  end
end

