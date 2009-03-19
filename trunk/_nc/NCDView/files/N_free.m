function N_free
%N_free
%is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% copy aces to new figure

global H

axes(H.axes);
cm=colormap; % keep colormap
ar=get(gca,'dataaspectratio'); %keep aspect ratio

obj=get(gca,'children');

tit  = get(H.axes_title,'string');
xlab = get(gca,'xlabel'); xlab=get(xlab,'string');
ylab = get(gca,'ylabel'); ylab=get(ylab,'string');

figure;
new=axes;

copyobj(obj,new);

% title:
title(tit,   'interpreter','none');
xlabel(xlab, 'interpreter','none');
ylabel(ylab, 'interpreter','none');

% colormap and DataAspectRatio
colormap(cm);
set(gca,'dataaspectratio',ar);

% colorbar
% check if exist:
evalc('cb=ishandle(H.colorbar);','cb=0;');
if cb
  colorbar
end
