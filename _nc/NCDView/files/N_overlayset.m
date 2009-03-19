function N_overlayset(in)
%N_overlayset
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% controls the overlay menu

global H

% toogle betwen overlay once/always:
set(H.menu_overlay_once,   'checked','off');
set(H.menu_overlay_always, 'checked','off');
set(H.menu_overlay_2d,     'checked','off');

if isequal(in,'once')
  set(H.menu_overlay_once,      'checked','on');
end
if isequal(in,'always')
  set(H.menu_overlay_always,    'checked','on');
end
if isequal(in,'2d')
  set(H.menu_overlay_2d,        'checked','on');
end
