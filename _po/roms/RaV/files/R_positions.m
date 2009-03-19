function R_positions(what,tofill)
%N_positions
%   is part of RaV
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
x=xc1+dlButtons+xsButtons; xi  = x;
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
x=xc1+dlButtons+xsButtons; xi = x;
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


% Add ##############################
% axes:
ax=get(H.axes,'position');
set(H.ROMS.axes,'position',ax);

% axes title:
at = get(H.axes_title,'position');
set(H.ROMS.axes_title,'position',at);


% frame ROMS:
pos=get(H.frameInit,'position');
set(H.ROMS.frame,   'position',[pos(1:3) pos(4)-hButtons]);

% toogle buttons:
x=pos(1); x0=pos(1);xe=pos(1)+pos(3);
y=pos(2)+pos(4)-hButtons;
l=0.5*xButtons;
set(H.ROMS.toggle_grid, 'position',[x y l hButtons*1]);x=x+l;
set(H.ROMS.toggle_his,  'position',[x y l hButtons*1]);x=x+l;
set(H.ROMS.toggle_sta,  'position',[x y l hButtons*1]);x=x+l;
set(H.ROMS.toggle_flt,  'position',[x y l hButtons*1]);x=x+l;

% grid objs:
% load:
x=x0+dlButtons;         xload=x;
y=y-dhButtons-hButtons; yload=y;
l=0.5*xButtons;
set(H.ROMS.grid.load,   'position',[x y l hButtons]);
% name:
x=x+l+dlButtons;
l=xe-x-2*dlButtons;
set(H.ROMS.grid.name,   'position',[x y l hButtons]);
% contour/clabel:
x=x0+dx;
y=y-dhButtons-hButtons;
l=xButtons;
set(H.ROMS.grid.contour,'position',[x y l hButtons]);
x=x+dlButtons+l;
l=0.5*xButtons;
set(H.ROMS.grid.clabel, 'position',[x y l hButtons]);
% overlay coastline, free-3D:
x=x0+dx;
y=y-dhButtons-hButtons;
set(H.ROMS.grid.coast,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.grid.free3d,  'position',[x y l hButtons]); x=x+l;
set(H.ROMS.grid.mask,    'position',[x y l hButtons]); x=x+l;
set(H.ROMS.grid.slev,    'position',[x y l hButtons]);
% about s-levels:
x=x0+dx;
y=y-dhButtons-hButtons  -2*dhButtons; 
set(H.ROMS.grid.thetas_,  'position',[x y l hButtons]);  x=x+l;
set(H.ROMS.grid.thetas,   'position',[x y l hButtons]);  x=x-l; y=y-dhButtons-hButtons;
set(H.ROMS.grid.thetab_,  'position',[x y l hButtons]);  x=x+l;
set(H.ROMS.grid.thetab,   'position',[x y l hButtons]);  x=x+l; y=y+dhButtons+hButtons;
set(H.ROMS.grid.tcline_,  'position',[x y l hButtons]);  x=x+l;
set(H.ROMS.grid.tcline,   'position',[x y l hButtons]);  x=x-l;, y=y-dhButtons-hButtons;
set(H.ROMS.grid.hmin_,    'position',[x y l hButtons]);  x=x+l;
set(H.ROMS.grid.hmin,     'position',[x y l hButtons]);  x=x-3*l;, y=y-dhButtons-hButtons;
set(H.ROMS.grid.zeta_,    'position',[x y l hButtons]);  x=x+l;
set(H.ROMS.grid.zeta,     'position',[x y l hButtons]);  x=x+l;
set(H.ROMS.grid.N_,       'position',[x y l hButtons]);  x=x+l;
set(H.ROMS.grid.N,        'position',[x y l hButtons]);  x=x+l;
set(H.ROMS.grid.sparams,  'position',[x y 1.5*l hButtons]);


% frame of position:
x=pos(1);%+pos(3)/2;
y=pos(2)-pos(4)-2*dy;
l=pos(3);%/2;
h=pos(4);  h=pos(4)/2; y=pos(2)-h-1*dy;
set(H.ROMS.frame_pos,     'position',[x y l h]);
% buttons inside frame:
x=x+dx; xi=x;
y=y+h-hButtons-dy;
l=0.5*xButtons;
ll=xButtons;
ls=xsButtons;

set(H.ROMS.grid.icb,    'position',[x y ls hButtons]); x=x+ls;
set(H.ROMS.grid.i_,     'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.grid.i,      'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.grid.lon_,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.grid.lon,    'position',[x y ll hButtons]); x=x+ll;
set(H.ROMS.grid.loncb,  'position',[x y ls hButtons]); x=xi; y=y-hButtons;

set(H.ROMS.grid.jcb,    'position',[x y ls hButtons]); x=x+ls;
set(H.ROMS.grid.j_,     'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.grid.j,      'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.grid.lat_,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.grid.lat,    'position',[x y ll hButtons]); x=x+ll;
set(H.ROMS.grid.latcb,  'position',[x y ls hButtons]); x=xi; y=y-hButtons -1.7*dy;

set(H.ROMS.grid.kcb,    'position',[x y ls hButtons]); x=x+ls;
set(H.ROMS.grid.k_,     'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.grid.k,      'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.grid.z_,     'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.grid.z,      'position',[x y ll hButtons]); x=x+ll;
set(H.ROMS.grid.zcb,    'position',[x y ls hButtons]);

% his objs:
x=xload;
y=yload;
l=0.5*xButtons;
% load:
set(H.ROMS.his.load,    'position',[x y l hButtons]);
% name:
x=x+l+dlButtons;
l=xe-x-2*dlButtons;
set(H.ROMS.his.name,    'position',[x y l hButtons]);
% ocean time
x=x0+dx;
y=y-dhButtons-hButtons;
l=0.5*xButtons;
set(H.ROMS.his.ndays_,  'position',[x y l hButtons]); x=x+l;
set(H.ROMS.his.ndays,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.his.nhis_,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.his.nhis,    'position',[x y l hButtons]); x=x+l;
set(H.ROMS.his.dhis_,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.his.dhis,    'position',[x y l hButtons]);
% time:
x=x0+dx;
y=y-dhButtons-hButtons;
ls = xsButtons;
l  = 0.5*xButtons;
ll = xButtons;
set(H.ROMS.his.t,       'position',[x y ls hButtons]); x=x+ls;
set(H.ROMS.his.tless,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.his.tindex,  'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.his.tstep,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.his.tmore,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.his.tval,    'position',[x y  l*1.5 hButtons]);
% vars, disp:
x=x0+dx;
y=y-dhButtons-hButtons -dy;
set(H.ROMS.his.var1,    'position',[x y ll  hButtons]); x=x+ll;
set(H.ROMS.his.var2,    'position',[x y ll  hButtons]);x=x0+dx; y = pos(2)+dy;
set(H.ROMS.his.dispcb,  'position',[x y ls  hButtons]); x=x+ls;
set(H.ROMS.his.disp,    'position',[x y  l  hButtons]);

% his_more################################:
p=get(H.ROMS.frame,'position');
x=p(1)+p(3)-dx-l;
y=p(2)+dy;
set(H.ROMS.his.varopts,'position',[x y  l hButtons]);

x=p(1)+dx; xi=x;
y=p(2)+p(4)-dy-hButtons;

set(H.ROMS.his.morecvals1,   'position',[x  y ll hButtons]); y=y-hButtons;
set(H.ROMS.his.morecvals2,   'position',[x  y ll hButtons]); y=y+hButtons; x=x+ll;
set(H.ROMS.his.moreline1,    'position',[x  y  l hButtons]); y=y-hButtons;
set(H.ROMS.his.moreline2,    'position',[x  y  l hButtons]); y=y+hButtons; x=x+l;
set(H.ROMS.his.morelinew1,   'position',[x  y  l hButtons]); y=y-hButtons;
set(H.ROMS.his.morelinew2,   'position',[x  y  l hButtons]); y=y+hButtons; x=x+l;
set(H.ROMS.his.morelinec1,   'position',[x  y ls hButtons]); y=y-hButtons;
set(H.ROMS.his.morelinec2,   'position',[x  y ls hButtons]); y=y+hButtons; x=x+ls;
set(H.ROMS.his.moreclabel1,  'position',[x  y  l*1.5 hButtons]); y=y-hButtons;
set(H.ROMS.his.moreclabel2,  'position',[x  y  l*1.5 hButtons]);

y=y-2*hButtons-dx;
x=xi;

set(H.ROMS.his.morescale1_,  'position',[x  y  l*1.5 hButtons]); x=x+l*1.5;
set(H.ROMS.his.morescale1,   'position',[x  y  l*1.5 hButtons]); y=y+hButtons; x=xi;
set(H.ROMS.his.morescale2_,  'position',[x  y  l*1.5 hButtons]); x=x+l*1.5;
set(H.ROMS.his.morescale2,   'position',[x  y  l*1.5 hButtons]); x=x+l*1.5;
set(H.ROMS.his.moreduv_,     'position',[x  y  l*1.5 hButtons]); x=x+l*1.5;
set(H.ROMS.his.moreduv,      'position',[x  y  l*1.5 hButtons]); x=x-l*1.5; y=y-hButtons;

set(H.ROMS.his.morearrsc_,   'position',[x  y  l*1.5 hButtons]); x=x+l*1.5;
set(H.ROMS.his.morearrsc,    'position',[x  y  l*1.5 hButtons]); y=y-hButtons;
set(H.ROMS.his.morearrscgin, 'position',[x  y  l*1.5-ls hButtons]); x=x+l*1.5-ls;
set(H.ROMS.his.morearrcolor, 'position',[x  y  ls    hButtons]); x=x+ls-l*2.5;
set(H.ROMS.his.morearrscval, 'position',[x  y  l     hButtons]);
% bathy, grid on:
x=xi;
y=p(2)+dy+hButtons;
set(H.ROMS.his.moregridon,   'position',[x  y  l*1.3 hButtons]); y=y-hButtons;
set(H.ROMS.his.morebathy,    'position',[x  y  l*1.3 hButtons]); x=x+l*1.3;
set(H.ROMS.his.morebathyc,   'position',[x  y  ls    hButtons]); x=x+ls;
set(H.ROMS.his.moremask,     'position',[x  y  l*1.3 hButtons]); x=x+l*1.3;
set(H.ROMS.his.moremaskc,    'position',[x  y  ls    hButtons]);


%#########################################
% plot/new figure options frame:
pos=get(H.ROMS.frame_pos,'position');
x=pos(1);
l=pos(3);
h=pos(4)*1.65;
y=pos(2)-h-1*dy;

h = h+hButtons*.8;
y = y-hButtons*.8;
set(H.ROMS.frame_plotopt,     'position',[x y l h]);
% buttons:
x=x+dx; xi=x;
y=y+h-hButtons-dy;
ls = xsButtons;
l  = (lfr2d-2*dx-3*dlButtons-2*xsButtons)/2.5;
ll = l*1.5;
l1 = ls+l*0.5;
% % plot options
set(H.ROMS.his.contourcb,     'position',[x y ls hButtons]); x=x+ls +dlButtons;
set(H.ROMS.his.contour,       'position',[x y  l hButtons]); x=x+l  +dlButtons;
set(H.ROMS.his.contourvals,   'position',[x y  l hButtons]); x=x+l  +dlButtons;
set(H.ROMS.his.contourclabel, 'position',[x y l1 hButtons]); x=xi; y=y-hButtons;

set(H.ROMS.his.pcolorcb,      'position',[x y ls hButtons]); x=x+ls +dlButtons;
set(H.ROMS.his.pcolor,        'position',[x y  l hButtons]); x=x+l  +dlButtons;
set(H.ROMS.his.pcolorcaxis,   'position',[x y ll hButtons]); x=x+ll +dlButtons;
set(H.ROMS.his.pcolorcaxiscb, 'position',[x y ls hButtons]); x=xi; y=y-hButtons-dy;
% figure/axes options:
%y=y-hButtons; %%
set(H.ROMS.his.xlimcb,        'position',[x y ls hButtons]); x=x+ls;
set(H.ROMS.his.xlim,          'position',[x y ll hButtons]); x=xi; y=y-hButtons;
set(H.ROMS.his.ylimcb,        'position',[x y ls hButtons]); x=x+ls;
set(H.ROMS.his.ylim,          'position',[x y ll hButtons]); x=xi;   y=y-hButtons;
set(H.ROMS.his.zlimcb,        'position',[x y ls hButtons]); x=x+ls;
set(H.ROMS.his.zlim,          'position',[x y ll hButtons]); x=xi;   y=y-hButtons;
ld = ll+ls-l;
set(H.ROMS.his.d2,            'position',[x y  ld hButtons]); y=y-hButtons;
set(H.ROMS.his.d3,            'position',[x y  ld hButtons]); x = x+ld; y=y+hButtons;
set(H.ROMS.his.current,       'position',[x y  l hButtons]);y=y+2*hButtons;

x=pos(1)+pos(3)-dx-l; 
y=y+hButtons; %%
set(H.ROMS.his.newfig,        'position',[x y  l hButtons]);y=y-hButtons;
set(H.ROMS.his.axauto,        'position',[x y  l hButtons]);y=y-hButtons;
set(H.ROMS.his.axequal,       'position',[x y  l hButtons]);y=y-hButtons;
set(H.ROMS.his.closeall,      'position',[x y  l hButtons]);y=y-hButtons;
set(H.ROMS.his.hold,          'position',[x y  l hButtons]);
% Add end ###########################

%flt objs:
x=xload;
y=yload;
l=0.5*xButtons;
% load:
set(H.ROMS.flt.load,    'position',[x y l hButtons]);
% name:
x=x+l+dlButtons;
l=xe-x-2*dlButtons;
set(H.ROMS.flt.name,    'position',[x y l hButtons]);
% ocean time
x=x0+dx;
y=y-dhButtons-hButtons;
l=0.5*xButtons;
set(H.ROMS.flt.ndays_,  'position',[x y l hButtons]); x=x+l;
set(H.ROMS.flt.ndays,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.flt.nflt_,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.flt.nflt,    'position',[x y l hButtons]); x=x+l;
set(H.ROMS.flt.dflt_,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.flt.dflt,    'position',[x y l hButtons]);
% time:
x=x0+dx;
y=y-dhButtons-hButtons;
ls = xsButtons;
l  = 0.5*xButtons;
ll = xButtons;
set(H.ROMS.flt.t,       'position',[x y ls hButtons]); x=x+ls;
set(H.ROMS.flt.tless,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.flt.tindex,  'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.flt.tstep,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.flt.tmore,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.flt.tval,    'position',[x y  l*1.5 hButtons]);

% float indexes:
x = xfrini+dx;            xc1=x;
y = y-hButtons-dhButtons; yc1=y;
l= (lfrini-2*dx-1*xsButtons-3*xsButtons-6*dlButtons)/4;
set(H.ROMS.flt.dimc,    'position',  [x y xsButtons     hButtons]); x=xc1+dlButtons+xsButtons;
set(H.ROMS.flt.stepb,   'position',  [x y xsButtons*1.5 hButtons]); x=xc1+2*dlButtons+2.5*xsButtons;
set(H.ROMS.flt.dimi,    'position',  [x y l             hButtons]); x=xc1+3*dlButtons+2.5*xsButtons+l;
set(H.ROMS.flt.dimstep, 'position',  [x y l             hButtons]); x=xc1+4*dlButtons+2.5*xsButtons+2*l;
set(H.ROMS.flt.dime,    'position',  [x y l             hButtons]); x=xc1+5*dlButtons+2.5*xsButtons+3*l;
set(H.ROMS.flt.stepf,   'position',  [x y xsButtons*1.5 hButtons]); x=xc1+6*dlButtons+4*xsButtons+3*l;
set(H.ROMS.flt.dims,    'position',  [x y l             hButtons]);

% disp:
pos=get(H.frameInit,'position');
x=x0+dx; y = pos(2)+dy;
set(H.ROMS.flt.dispcb,  'position',[x y ls  hButtons]); x=x+ls;
set(H.ROMS.flt.disp,    'position',[x y  l  hButtons]);

% track:
x=xc1;
y = y+hButtons;
set(H.ROMS.flt.trackcb, 'position',  [x y l+ls    hButtons]);

%---------------------  new, 2-2005, for stations file:
x=xload;
y=yload;
l=0.5*xButtons;
% load:
set(H.ROMS.sta.load,    'position',[x y l hButtons]);
% name:
x=x+l+dlButtons;
l=xe-x-2*dlButtons;
set(H.ROMS.sta.name,    'position',[x y l hButtons]);
% ocean time
x=x0+dx;
y=y-dhButtons-hButtons;
l=0.5*xButtons;
set(H.ROMS.sta.ndays_,  'position',[x y l hButtons]); x=x+l;
set(H.ROMS.sta.ndays,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.sta.nsta_,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.sta.nsta,    'position',[x y l hButtons]); x=x+l;
set(H.ROMS.sta.dsta_,   'position',[x y l hButtons]); x=x+l;
set(H.ROMS.sta.dsta,    'position',[x y l hButtons]);
% time:
x=x0+dx;
y=y-dhButtons-hButtons;
ls = xsButtons;
l  = 0.5*xButtons;
ll = xButtons;
set(H.ROMS.sta.t,       'position',[x y ls hButtons]); x=x+ls;
set(H.ROMS.sta.tless,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.sta.tindex,  'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.sta.tstep,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.sta.tmore,   'position',[x y  l hButtons]); x=x+l;
set(H.ROMS.sta.tval,    'position',[x y  l*1.5 hButtons]);

% profiles:
x=x0+dx;
y=y-dhButtons-hButtons;
set(H.ROMS.sta.vprofile,  'position',[x y l+ls hButtons]); y = y-hButtons;
set(H.ROMS.sta.tprofile,  'position',[x y l+ls hButtons]); y = y-hButtons;
%set(H.ROMS.sta.vtprofile, 'position',[x y l+ls hButtons]);

% plot options:
pos=get(H.ROMS.frame_pos,'position');
x=pos(1);
l=pos(3);
h=pos(4)*1.65;
y=pos(2)-h-1*dy;

h = h+hButtons*.8;
y = y-hButtons*.8;

x=x+dx; xi=x;
y=y+h-hButtons-dy;
ls = xsButtons;
l  = (lfr2d-2*dx-3*dlButtons-2*xsButtons)/2.5;
ll = l*1.5;
l1 = ls+l*0.5;

set(H.ROMS.sta.contourcb,     'position',[x y ls hButtons]); x=x+ls +dlButtons;
set(H.ROMS.sta.contour,       'position',[x y  l hButtons]); x=x+l  +dlButtons;
set(H.ROMS.sta.contourvals,   'position',[x y  l hButtons]); x=x+l  +dlButtons;
set(H.ROMS.sta.contourclabel, 'position',[x y l1 hButtons]); x=xi; y=y-hButtons;

set(H.ROMS.sta.pcolorcb,      'position',[x y ls hButtons]); x=x+ls +dlButtons;
set(H.ROMS.sta.pcolor,        'position',[x y  l hButtons]); x=x+l  +dlButtons;
set(H.ROMS.sta.pcolorcaxis,   'position',[x y ll hButtons]); x=x+ll +dlButtons;
set(H.ROMS.sta.pcolorcaxiscb, 'position',[x y ls hButtons]); x=xi; y=y-hButtons;

set(H.ROMS.sta.plotcb,        'position',[x y ls hButtons]); x=x+ls +dlButtons;
set(H.ROMS.sta.plot,          'position',[x y  l hButtons]);

% select station, disp, variable and maarker sizes:
pos = get(H.frameInit,'position');
x  = pos(1) + pos(3) - dx - l;
tmp = get(H.ROMS.sta.vprofile,  'position');
y = tmp(2);
set(H.ROMS.sta.select,        'position',[x y  l hButtons]); x = tmp(1)+tmp(3)+dx; y =y-hButtons; ll = pos(3) -pos(1) - x+dx;
set(H.ROMS.sta.selectinfo,    'position',[x y ll hButtons]);
x = tmp(1)+tmp(3)+dx;
y =y+hButtons;
set(H.ROMS.sta.variable,  'position',[x y l hButtons ]);
x  = pos(1) + pos(3) - dx - 2.5*ls;
y = y-2*hButtons;
set(H.ROMS.sta.selectmarker,      'position',[x y 2.5*ls hButtons ]);
pos = get(H.ROMS.his.disp,'position');
set(H.ROMS.sta.disp,          'position',[pos ]);
pos = get(H.ROMS.his.dispcb,'position');
set(H.ROMS.sta.dispcb,          'position',[pos ]);
% selectn:
tmp1 = get(H.ROMS.sta.selectinfo,   'position');
tmp2 = get(H.ROMS.sta.selectmarker, 'position');
x = tmp1(1);
y = tmp2(2);
l = tmp2(1) - tmp1(1);
set(H.ROMS.sta.selectn,'position',[x y l hButtons]);


% filter:
pos = get(H.ROMS.sta.plotcb,'position');
x = pos(1);
y = pos(2)-hButtons;
l = 3*pos(3);
set(H.ROMS.sta.filtercb,  'position',[x y l hButtons]); x = x+l;
set(H.ROMS.sta.filterdt,  'position',[x y l hButtons]); x = x+l;
set(H.ROMS.sta.filterT,   'position',[x y l hButtons]); x = x+l;
set(H.ROMS.sta.filteradd, 'position',[x y l hButtons]);


