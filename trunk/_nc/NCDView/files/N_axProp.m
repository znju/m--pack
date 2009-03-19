function N_axProp
%N_axProp
%is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% controls axes properties:
% - colors
% - position
% - colorbar position

global H

evalc('is=ishandle(H.axes)','is=0');
if ~is
  return
end

%----------------------- axes colors:
axes(H.axes);
set(gca,'color',H.theme.axbg,'xcolor',H.theme.axfg,'ycolor',H.theme.axfg,'zcolor',H.theme.axfg);
%----------------------- axes position and axes_title:
evalc('set(gca,''position'',H.axes_position);','');
tp=get(H.axes_title,'position');
W=H.axes_position(3);
%set(H.axes_title,'position',[tp(1) tp(2) W tp(4)]);
%do this before return, cos if no return, would be updated
%later (bellow), and would blink

%check if there is a colorbar:
%cb=findobj(gcf,'type','axes','tag','Colorbar'); % not working !?
evalc('cb=ishandle(H.colorbar);','cb=0;');
if ~cb
  set(H.axes_title,'position',[tp(1) tp(2) W tp(4)]);
  return
end

%----------------------- axes and colorbar position:
% So, I have the constants: width of colorbar and separation between
% colorbal and axes. I need to place the colorbar and axes after each plot,
% or gui resize. For that I must know the width of colorbar labels (EX),
% and remove it also in axes width.
% Moreover, I should set with of H.axes_title to axes width, cos for a
% higher power than 10^4, this power is inserted over the colorbar. So
% axes_title cannot be there.

% find with (EX) of colorbar labels:
axes(H.axes);
y=get(colorbar,'yticklabel');
nchar=size(num2str(y),2); % number of characters
nchar=max(nchar,3); % 3 is approx. the the width of 'x 10^?'
cb_fontUnits   = get(colorbar,'fontunits');
cb_fontSize= get(colorbar,'fontsize');
tmpHandle=text(0,0,repmat('9',1,nchar),'units',cb_fontUnits,'fontsize',cb_fontSize,'visible','off');

set(tmpHandle,'units','points');
EX=get(tmpHandle,'extent');
EX=EX(3);
delete(tmpHandle);
% remove EX to axes width:
au=get(gca,'units');
set(gca,'units','points');
ap=get(gca,'position');
set(gca,'position',[ap(1) ap(2) ap(3)-EX ap(4)]);
set(gca,'units',au);

% now, remove width of colorbar and some extra space between axes and
% colorbar:
ap=get(gca,'position');
cw=H.settings.colorbar_width;
ax_cb=H.settings.colorbar_axes_separation;
W=ap(3)-cw-ax_cb;
set(gca,'position',[ap(1) ap(2) W ap(4)]);

% also shrink axes_title or colorbar label magnitude may be hidden!!
tp=get(H.axes_title,'position');
if ~isequal(tp(3),W)
  set(H.axes_title,'position',[tp(1) tp(2) W tp(4)]);
end

% now, put colorbar in correct place:
ap=get(gca,'position');
cp=get(colorbar,'position');
set(colorbar,'position',[ap(1)+ap(3)+ax_cb ap(2) cw ap(4)]);

%----------------------- colorbar colors:
set(colorbar,'color',H.theme.axbg,'xcolor',H.theme.axfg,'ycolor',H.theme.axfg,'zcolor',H.theme.axfg);
