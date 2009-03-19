function N_maxsize(val,n,type)
%N_maxsize
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% controls max var size
%  type= var or arrows

global H

if isequal(type,'var')
  % unchek all:
  obj=get(H.menu_varsize,'children');
  set(obj(6:9),'checked','off');
  % check current one:
  set(obj(n),'checked','on');

  % set global var:
  H.maxvarsize=val;
end

if isequal(type,'arrows')
  % unchek all:
  obj=get(H.menu_varsize,'children');
  set(obj(1:4),'checked','off');
  % check current one:
  set(obj(n),'checked','on');

  % set global var:
  H.maxarrowssize=val;
end

