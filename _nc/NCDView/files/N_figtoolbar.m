function N_figtoolbar
%N_figtoolbar
%is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% changes MenuBar

global H

checked=get(H.menu_toolbar,'checked');
if isequal(checked,'on')
  set(H.menu_toolbar,'checked','off');
  set(gcf,'MenuBar','none');
else
  set(H.menu_toolbar,'checked','on');
  set(gcf,'MenuBar','figure');
end
