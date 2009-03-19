function R_exit
%N_exit
%   is part of RaV
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See also NCDV

% closes GUI

global H

%%evalc('close(H.fig)','');
% close all NCDVs
obj=findobj(0,'name','RAV');
for i=1:length(obj)
  closereq;
end
