function N_changeli(num)
%N_changeli
%is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% changes lighting

global H

axes(H.axes);

% first rmeove any previous light:
lighting none
% now add one:
light

set(findobj('tag','menu_light'),'checked','off');
set(H.menu_li(num),'checked','on');
type  = get(H.menu_li(num),'label');
lighting(type);

