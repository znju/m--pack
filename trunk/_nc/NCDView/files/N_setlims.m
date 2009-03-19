function N_setlims(what)
%N_setlims
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% set limits boxes with current values and lock them (checkboxes=1)

global H

axes(H.axes);

xl=xlim;
yl=ylim;
zl=zlim;
ar=get(gca,'DataAspectRatio');

H.limits.xlim = xl;
H.limits.ylim = yl;
H.limits.zlim = zl;
H.limits.dar  = ar;

if isequal(what,'xlim') | isequal(what,'all')
  set(H.xlim,'string',[num2str(xl(1)),'  ',num2str(xl(2))]);
  set(H.xlim_cb, 'value',1);
end

if isequal(what,'ylim') | isequal(what,'all')
  set(H.ylim,'string',[num2str(yl(1)),'  ',num2str(yl(2))]);
  set(H.ylim_cb, 'value',1);
end

if isequal(what,'zlim') | isequal(what,'all')
  set(H.zlim,'string',[num2str(zl(1)),'  ',num2str(zl(2))]);
  set(H.zlim_cb, 'value',1);
end

if isequal(what,'ar') | isequal(what,'all')
  set(H.ar,'string',[num2str(ar(1)),'  ',num2str(ar(2)),'  ',num2str(ar(3))]);
  set(H.ar_cb,   'value',1);
end
