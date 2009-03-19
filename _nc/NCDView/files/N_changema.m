function N_changema(num)
%N_changema
%is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% changes materiaal

global H

axes(H.axes);

set(findobj('tag','menu_material'),'checked','off');
set(H.menu_ma(num),'checked','on');
type = get(H.menu_ma(num),'label');
type=strrep(type,'.',''); %cos default has a point: .default
material(type);
