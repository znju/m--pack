function N_exit
%N_exit
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% closes GUI

global H

%%evalc('close(H.fig)','');
% close all NCDVs
obj=findobj(0,'name','NCDView');
for i=1:length(obj)
  closereq;
end
