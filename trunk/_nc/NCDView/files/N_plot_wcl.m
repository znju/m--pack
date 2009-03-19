function N_plot_wcl(data,ax)
%N_plot_wcl
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% plots WCL (coastline), data must be in path

global  H

if nargin < 2
  axes(gca);
else
  evalc('axes(ax);','');
end

if nargin < 1
  data=1; % 0-360
end

xy=[];
switch data
  case 1
    eval('xy=load(''wcl_0_360.dat'');','');
  case 2
    eval('xy=load(''wcl_180_180.dat'');','');
end

if isempty(xy)
  err=errordlg('error loading file, check if datasets is in path','','modal');
  return
end

x=xy(:,1);
y=xy(:,2);
    
h=ishold;
hold  on

cmenu = uicontextmenu;
p=plot(x,y,'UiContextMenu',cmenu);
N_setcontextmenu(cmenu,'overlay');

LineStyle = 'default';
LineWidth = 'default';
Color     = 'default'; Color = 'b';
set(p,'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',Color);

H.overlay.data=[x y];

if ~h
  hold off
end
