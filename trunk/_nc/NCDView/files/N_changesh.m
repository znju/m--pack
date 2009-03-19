function N_changesh(num)
%N_changesh
%is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% changes shading

global H

set(findobj('tag','menu_shading'),'checked','off');

set(H.menu_sh(num),'checked','on');

cms  = get(H.menu_sh(num),'label');
str = get(H.menu_sh(num),'label');
%%cm=strrep(cms,' ','');
if isequal(str,'color...')
  color = uisetcolor;
  % get last surface:
  axes(H.axes);
  obj = findobj('Type','surface');
  set(obj(end),'faceColor',color);
  set(H.menu_sh(num),'UserData',color);
else
  shading(cms)
end
