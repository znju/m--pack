function N_contourcolor(color,n)
%N_contourcolor
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% change color of contours

global H

if nargin == 0
  % find which s selected, to use when run contour:
  tmp=findobj(H.menu_contourc,'checked','on');
  tmp=tmp(1); % not needed is everything is ok!
  cb=get(tmp,'callback');
  eval(cb)
  return
else
  % unchek all:
  obj=get(H.menu_contourc,'children');
  set(obj,'checked','off');
  % check current one:
  set(obj(n),'checked','on');
end

% contour handles are in global var: H.ch ( se N_disp)
if isequal(color,'default')
  evalc('set(H.ch,''edgecolor'',''interp'');','');
else
  evalc('set(H.ch,''edgecolor'',color);','');
end
