function R_coastline(type)

global H

if nargin==0
  type=1;
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
evalc(['p=plot(',var1,',',var2,',''UiContextMenu'',cmenu,''tag'',''cl_overlay'');'],'err=1;');
N_setcontextmenu(cmenu,'cl_overlay');
if ~err
  x=get(p,'xdata');
  y=get(p,'ydata');
  H.ROMS.overlay.data=[x; y]';

  LineStyle = 'default';
  LineWidth = 'default';
  Color     = 'default'; Color = 'b';
  set(p,'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',Color);
end

if ~h
  hold off
end
