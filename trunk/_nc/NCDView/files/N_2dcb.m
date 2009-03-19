function N_2dcb(cb)
%N_2dcb
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% controls contour, pcolor and surf  checkboxes

global H

set(H.contourcb, 'value',0);
set(H.pcolorcb,  'value',0);
set(H.surfcb,    'value',0);

switch cb
  case 'contour'
    set(H.contourcb,'value',1);
  case 'pcolor'
    set(H.pcolorcb,'value',1);
  case 'surf'
    set(H.surfcb,'value',1);
end
