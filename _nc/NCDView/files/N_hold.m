function N_hold(o)
%N_hold
% is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% controls hold  on checkbox

global H

axes(H.axes);

if nargin == 0
  val=get(H.hold,'value');

  if val
    hold on
  else
    hold off
  end

elseif nargin == 1
  if  isequal(o,'on')
    hold on
    set(H.hold,'value',1);
  else
    hold off
    set(H.hold,'value',0);
  end
end
