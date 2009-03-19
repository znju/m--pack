function N_changeax(num)
%N_changeax
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV
%

% executes axis(...): equal, normal, ...

global H

axes(H.axes);
set(findobj('tag','menu_axis'),'checked','off');
set(H.menu_ax(num),'checked','on');
type  = get(H.menu_ax(num),'label');
axis(type)
