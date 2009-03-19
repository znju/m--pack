function N_clabel
%N_clabel
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% aplies clabel to contours

global H

evalc('c1=H.cs;','cs=[];');
evalc('c2=H.ch;','ch=[];');

%check if currently contour is plotted:
evalc('is=H.is.plotted==''contour''','is=0');

if is & ~isempty(c1)
  %clabel(c1,c2,'manual');
  clabel(c1,'manual')
end
