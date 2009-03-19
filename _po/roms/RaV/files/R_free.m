function R_free
%R_free
%is part of Rav
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See also NCDV

% copy aces to new figure

global H

% get  axes:
evalc('figure(H.fig)','return');
axes(gca);

% get axes_title:
if isequal(get(H.axes_title,'visible'),'on')
  at = H.axes_title;
  israv = 0;
  ca = H.axes;
else
  at = H.ROMS.axes_title;
  israv = 1;
  ca = H.ROMS.axes;
end
axes(ca);


cm=colormap; % keep colormap
ar=get(gca,'dataaspectratio'); %keep aspect ratio

obj=get(gca,'children');

tit  = get(at,'string');
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

if ~israv
  % colorbar
  % check if exist:
  evalc('cb=ishandle(H.colorbar);','cb=0;');
  if cb
     colorbar
  end
end
