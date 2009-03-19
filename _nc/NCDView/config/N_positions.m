function N_positions(what,tofill)
%N_positions
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% sets GUI objects positions

global H

if nargin < 2
  tofill=[];
end
if nargin == 0
  what=[];
end

%----------------------------------------------------------------
% figure units and position:
% --------------------------------------------------------------
evalc('is=ishandle(H.fig)','is=0');
if ~is
  return
end
figure(H.fig);
set(gcf,'units','normalized');
children=get(gcf,'children');
for i=1:length(children)
  evalc(['set(children(',num2str(i),'),''units'',''normalized'');'],'');
end

if ~isequal(tofill,'fill')
  fig_pos=[.1 .1 .6 .62];
  set(H.fig,'position',fig_pos);
else
  fig_pos=get(gcf,'position');
end


% some parameters:
H.settings.colorbar_width=0.02;
H.settings.colorbar_axes_separation=0.01;

% defined values:
lAxLeft   = 0.4  ;
lAxRight  = 0.02 ;
lAxTop    = 0.0645;
lAxBottom = 0.23;
Htitle    = 0.05;
dx        = 0.01;
dy        = 0.013;  lAxTop=2*dy+Htitle;
dxax      = 0.07 ;
hButtons  = 0.032;
dhButtons = hButtons/8;  % vertical space between buttons
dlButtons = hButtons/16; % horizontal space between buttons
xsButtons = .025;        % width of small buttons and checkboxes:
xButtons  = 0.1;         % with to use in axes control buttons

%%%%%%%%%%%%%%%%%%%%%%


if isnumber(what,2);
  addx=what(1)/100;
  addy=what(2)/100;

  incx=fig_pos(4)*(1+addx);
  rx=fig_pos(4)/incx;
  fig_pos(4)=incx;
  set(H.fig,'position',fig_pos);

  lAxTop    = lAxTop    * rx;
  lAxBottom = lAxBottom * rx;
  Htitle    = Htitle    * rx;
  dy        = dy        * rx;
  hButtons  = hButtons  * rx;
  dhButtons = dhButtons * rx;


  incy=fig_pos(3)*(1+addy);
  ry=fig_pos(3)/incy;
  fig_pos(3)=incy;
  set(H.fig,'position',fig_pos);

  lAxLeft   = lAxLeft   * ry;
  lAxRight  = lAxRight  * ry;
  dx        = dx        * ry;
  dxax      = dxax      * ry;
  dlButtons = dlButtons * ry;
  xsButtons = xsButtons * ry;
  xButtons  = xButtons  * ry;
end

% derived values
% axes:
lax = 1 - lAxLeft - lAxRight;
hax = 1 - lAxTop - lAxBottom;
axes_position = [lAxLeft lAxBottom lax hax];
set(H.axes,'position',axes_position);
H.axes_position=axes_position; % to restore after plot, may be needed!

% axes title:
axes_title_position  =  [lAxLeft lAxBottom+hax+dy  lax Htitle];
set(H.axes_title,'position',axes_title_position);

% frame init:
lfrini = lAxLeft - dx -dxax;
hfrini = 7*hButtons+6*dhButtons+2*dy+3*dhButtons;
xfrini = dx;
yfrini = 1-dy - hfrini;
frame_init_position = [xfrini yfrini lfrini hfrini];
set(H.frameInit,'position',frame_init_position);


% frame_2d
lfr2d = lfrini;
hfr2d = 7*hButtons+8*dhButtons+2*dy;% +2*dhButtons;
xfr2d = xfrini;
yfr2d = yfrini-hfr2d-2*dy; %2*dy is the space between frames.
frame_2d_position = [xfr2d yfr2d lfr2d hfr2d];
set(H.frame2D,'position',frame_2d_position);

% frame_1d
lfr1d = lfrini;
hfr1d = 2*hButtons+1*dhButtons+2*dy;
xfr1d = xfrini;
yfr1d = yfr2d-hfr1d-2*dy; %2*dy is the space between frames.
frame_1d_position = [xfr1d yfr1d lfr1d hfr1d];
set(H.frame1D,'position',frame_1d_position);

% frame_att
lfratt = lfrini;
hfratt = hfrini*.75;
xfratt = xfrini;
yfratt = yfr1d-hfratt-2*dy; %2*dy is the space between frames.
frame_att_position = [xfratt yfratt lfratt hfratt];
set(H.frameAtt,'position',frame_att_position);

% frame init, buttoms:
%line 1: var name, scale, offset:
x=xfrini+dx;
y=yfrini+hfrini-dy-hButtons;
l=(lfrini-2*dx-2*xsButtons)/3;
set(H.varInfo,    'position', [x                  y         l  hButtons]);
set(H.varMults,   'position', [x+l                y xsButtons  hButtons]);
set(H.varMult,    'position', [x+l+xsButtons      y         l  hButtons]);
set(H.varOffsets, 'position', [x+2*l+xsButtons    y xsButtons  hButtons]);
set(H.varOffset,  'position', [x+2*l+2*xsButtons  y         l  hButtons]);
% line 2: var  size:
x = xfrini+dx;
y = y-hButtons-dhButtons;
l = (lfrini-2*dx);%/2;
set(H.varInfo1,'position', [x y l hButtons]);
% lines 3 o 6, limits and steps:
% column 1:
x = xfrini+dx;            xc1=x;
y = y-hButtons-dhButtons; yc1=y;
l= (lfrini-2*dx-1*xsButtons-3*xsButtons-6*dlButtons)/4;
set(H.dim1c,'position',   [x y xsButtons hButtons]); y=y-hButtons-dhButtons;
set(H.dim2c,'position',   [x y xsButtons hButtons]); y=y-hButtons-dhButtons;
set(H.dim3c,'position',   [x y xsButtons hButtons]); y=y-hButtons-dhButtons;
set(H.dim4c,'position',   [x y xsButtons hButtons]);
% column 2:
y=yc1;
x=xc1+dlButtons+xsButtons;
set(H.stepbI,'position',  [x y xsButtons*1.5 hButtons]); y=y-hButtons-dhButtons;
set(H.stepbJ,'position',  [x y xsButtons*1.5 hButtons]); y=y-hButtons-dhButtons;
set(H.stepbK,'position',  [x y xsButtons*1.5 hButtons]); y=y-hButtons-dhButtons;
set(H.stepbL,'position',  [x y xsButtons*1.5 hButtons]);
% column 3:
y=yc1;
x=xc1+2*dlButtons+2.5*xsButtons;
set(H.dim1,'position',    [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.dim2,'position',    [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.dim3,'position',    [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.dim4,'position',    [x y l hButtons]);
% column 4:
y=yc1;
x=xc1+3*dlButtons+2.5*xsButtons+l;
set(H.stepi,'position',   [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.stepj,'position',   [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.stepk,'position',   [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.stepl,'position',   [x y l hButtons]);
% column 5:
y=yc1;
x=xc1+4*dlButtons+2.5*xsButtons+2*l;
set(H.dim1e,'position',   [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.dim2e,'position',   [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.dim3e,'position',   [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.dim4e,'position',   [x y l hButtons]);
% column 6:
y=yc1;
x=xc1+5*dlButtons+2.5*xsButtons+3*l;
set(H.stepI,'position',   [x y xsButtons*1.5 hButtons]); y=y-hButtons-dhButtons;
set(H.stepJ,'position',   [x y xsButtons*1.5 hButtons]); y=y-hButtons-dhButtons;
set(H.stepK,'position',   [x y xsButtons*1.5 hButtons]); y=y-hButtons-dhButtons;
set(H.stepL,'position',   [x y xsButtons*1.5 hButtons]);
% column 7:
y=yc1;
x=xc1+6*dlButtons+4*xsButtons+3*l;
set(H.dim1s,'position',   [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.dim2s,'position',   [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.dim3s,'position',   [x y l hButtons]); y=y-hButtons-dhButtons;
set(H.dim4s,'position',   [x y l hButtons]);
% line 7: plot on load, display:
y=y-hButtons-dhButtons; y=y-3*dhButtons; % include extra vertical space
x=xc1;
set(H.plotOnLoad, 'position',    [x                    y 2*l hButtons]);
set(H.disp,       'position',    [xfrini+lfrini-dx-2*l y 2*l hButtons]);

% frame_2d:
x = xfr2d+dx;              xc1=x;
y=yfr2d+hfr2d-dy-hButtons; yc1=y;
% column 1: checkboxes:
set(H.contourcb, 'position',[x y xsButtons hButtons]); y=y-hButtons-dhButtons;
set(H.pcolorcb,  'position',[x y xsButtons hButtons]); y=y-hButtons-dhButtons;
set(H.surfcb,    'position',[x y xsButtons hButtons]);
% column 2: buttons:
y=yc1;
x=xc1+dlButtons+xsButtons;
l=(lfr2d-2*dx-3*dlButtons-2*xsButtons)/2.5;
set(H.contour,   'position',[x y l hButtons]); y=y-hButtons-dhButtons;
set(H.pcolor,    'position',[x y l hButtons]); y=y-hButtons-dhButtons;
set(H.surf,      'position',[x y l hButtons]);
% column 3: editable:
y=yc1;
x=xc1+2*dlButtons+xsButtons+l;
set(H.contourvals, 'position',[x y l     hButtons]); y=y-hButtons-dhButtons;
set(H.pcolorcaxis, 'position',[x y l*1.5 hButtons]); y=y-hButtons-dhButtons;
set(H.surfview,    'position',[x y l*1.5 hButtons]);
% column 4: clabel+checkboxes:
y=yc1;
x=xc1+3*dlButtons+xsButtons+l*2.5;
x1=x-0.5*l;
set(H.contourclabel, 'position',[x1 y xsButtons+l*0.5 hButtons]); y=y-hButtons-dhButtons;
set(H.pcolorcaxiscb, 'position',[x  y xsButtons       hButtons]); y=y-hButtons-dhButtons;
set(H.surfviewcb,    'position',[x  y xsButtons       hButtons]);
% second part: x  and y:
% column 1: checkboxes:
y=yfr2d+hfr2d-dy-4*hButtons-4*dhButtons; yc1=y;
y=y-hButtons/2-dhButtons/2;
x=xc1;
set(H.xycb,  'position',[x y xsButtons hButtons]); y=y-2*hButtons-2*dhButtons;
set(H.xyrcb, 'position',[x y xsButtons hButtons]);
% column 2: x and y:
y=yc1;
x=xc1+dlButtons+xsButtons; xi=x;
l=lfr2d-2*dx-dlButtons-xsButtons;
set(H.x,      'position',  [x y l/2 hButtons*1.1]); x=x+l/2;
set(H.xscale, 'position',  [x y l/2 hButtons*1.1]); y=y-hButtons-dhButtons; x=xi;
set(H.y,      'position',  [x y l/2 hButtons*1.1]); x =x+l/2;
set(H.yscale, 'position',  [x y l/2 hButtons*1.1]); y=y-hButtons-dhButtons; x=xi;
set(H.xrange, 'position',  [x y l   hButtons*1.1]); y=y-hButtons-dhButtons;
set(H.yrange, 'position',  [x y l   hButtons*1.1]);

% frame_1d
x = xfr1d+dx;              xc1=x;
y=yfr1d+hfr1d-dy-hButtons; yc1=y;
% column 1: checkboxes:
set(H.d1xcb,     'position',[x y xsButtons hButtons]); y=y-hButtons-dhButtons;
set(H.d1xrangecb,'position',[x y xsButtons hButtons]);
% column2:
y=yc1;
x=xc1+dlButtons+xsButtons; xi =x;
set(H.d1x,       'position',[x y l/2 hButtons*1.1]); x=x+l/2;
set(H.d1xscale,  'position',[x y l/2 hButtons*1.1]); y=y-hButtons-dhButtons; x = xi;
set(H.d1xrange,  'position',[x y l   hButtons*1.1]);

% frame_att:
x = xfratt+dx;
y = yfratt+dy;
l = lfratt-2*dx;
h = hfratt-2*dy;
set(H.varAtt,'position',[x y l h]);

%--------------------------------------------------------------
% axes controls:
% -------------------------------------------------------------
x = lAxLeft;
y = lAxBottom-hButtons-2.25*hButtons; yc1=y;
%y=yfratt+3*hButtons; yc1=y;
% grid, zoom, rotate, axis equal:
l=xButtons;
set(H.grid,    'position',[x y l hButtons]); y=y-hButtons;
set(H.zoom,    'position',[x y l hButtons]); y=y-hButtons;
set(H.rotate,  'position',[x y l hButtons]); y=y-hButtons;
set(H.axis_eq, 'position',[x y l hButtons]);
% hold on, cla, free:
x=x+dlButtons+l;
y=yc1;
set(H.hold,    'position',[x y l hButtons]); y=y-hButtons;
set(H.free,    'position',[x y l hButtons]); y=y-hButtons;
set(H.cla,     'position',[x y l hButtons]);
% xlim, ylim, dataAspectRatio:
x=1-lAxRight-2*xButtons-xsButtons;
y=yc1;
% first column: checkboxes:
set(H.xlim_cb, 'position',[x y xsButtons hButtons]); y=y-hButtons;
set(H.ylim_cb, 'position',[x y xsButtons hButtons]); y=y-hButtons;
set(H.zlim_cb, 'position',[x y xsButtons hButtons]); y=y-hButtons;
set(H.ar_cb,   'position',[x y xsButtons hButtons]);
% 2nd column: editable lims:
x=x+xsButtons;
y=yc1;
l=1.5*xButtons;
set(H.xlim,    'position',[x y l hButtons]); y=y-hButtons;
set(H.ylim,    'position',[x y l hButtons]); y=y-hButtons;
set(H.zlim,    'position',[x y l hButtons]); y=y-hButtons;
set(H.ar,      'position',[x y l hButtons]);
% 3 rd column: set lims:
x=x+l;
y=yc1;
l=0.5*xButtons;
set(H.xlim_do, 'position',[x y l hButtons]); y=y-hButtons;
set(H.ylim_do, 'position',[x y l hButtons]); y=y-hButtons;
set(H.zlim_do, 'position',[x y l hButtons]); y=y-hButtons;
set(H.ar_do,   'position',[x y l hButtons]);
