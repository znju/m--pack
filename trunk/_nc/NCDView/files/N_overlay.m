function N_overlay(type)
%N_overlay
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% loading and plot of mat file with vars lon and lat

global H

if nargin==0
  return
end

if type==1 % currently is the unique type accepted
  var1='lon';
  var2='lat';
end

[filename, pathname]=uigetfile('*.mat', 'Choose the lon x lat file');
if (isequal(filename,0)|isequal(pathname,0))
  fname=[];
  return
else
  fname=[pathname,filename];
end

load('-mat',fname);

if ~exist(var1) | ~exist(var2)
  return
end

h=ishold;
hold on
err=0;

cmenu = uicontextmenu;
evalc(['p=plot(',var1,',',var2,',''UiContextMenu'',cmenu);'],'err=1;');
N_setcontextmenu(cmenu,'overlay');

LineStyle = 'default';
LineWidth = 'default';
Color     = 'default'; Color = 'b';
set(p,'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',Color);


if ~err
  x=get(p,'xdata');
  y=get(p,'ydata');
end
H.overlay.data=[x; y]';

if ~h
  hold off
end
