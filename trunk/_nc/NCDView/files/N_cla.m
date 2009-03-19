function N_cla
%N_cla
% is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% clear axis and labels

global H

axes(H.axes);
cla

% also clear labels:
xlabel('');
ylabel('');
set(H.axes_title,'string','');
