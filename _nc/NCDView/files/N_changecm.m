function N_changecm(num)
%N_changecm
%is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% changes colormap

global H

set(findobj('tag','menu_colormap'),'checked','off');

set(H.menu_cm(num),'checked','on');

cms  = get(H.menu_cm(num),'label');
if isequal(cms,'2 colors')
  cm=[.5 .5 .5; 1 1 1];
  set(H.menu_cm(num),'userData',cm);
else
  cm=strrep(cms,' ','');
end
colormap default % is needed cos some problems arise after 2 colors !?
colormap(cm);

