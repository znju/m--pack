function handles = plot_border3d(fname,varargin)
%PLOT_BORDER3D   Display ROMS grid boundaries
%   Plots bathymetry  and zeta (if ROMS  history file).
%
%   Syntax:
%      HANDLES = PLOT_BORDER3D(FNAME,VARARGIN)
%
%   Inputs:
%      FNAME   ROMS grid or history file [ {<none>} <filename> ]
%      VARARGIN:
%         'zeta', <time>,           will show zeta at selected time
%         'slicei', <i>,            will show bathymetry slice at i
%         'slicej', <j>,            will show bathymetry slice at j
%         'slicelon', <lon [npts]>, will show bathymetry slice at lon
%         'slicelat', <lat [npts]>, will show bathymetry slice at lat;
%            npts is the number of points to use in interpolation,
%            the default value is 100.
%         'bathy', <bathy_contours>, contours on bathymetry will be
%            done. By default contours are done with values
%            [100 200 500 1000]; if 0, contours are not added.
%         'bottom', [{1} | 0], show bottom using surf
%         'zero', [{1} | 0], plot boundary line at z=0 and vertical
%            lines at corners
%         'mask', [{1} | 0], make 0.5 mask contour
%
%   Output:
%      HANDLES   Structure with the several figure handles
%
%   Examples:
%      figure
%      fname = 'grid.nc'
%      plot_border3d(fname), camlight
%      clf
%      plot_border3d(fname,'slicej',50), camlight
%      clf
%      plot_border3d(fname,'bottom',0,'slicelat',[40 200]);
%
%      fname = 'roms.nc'
%      plot_border3d(fname,'zeta',10,'slicej',50), camlight
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See Also ROMS_GRID, ROMS_BORDER, VAR_BORDER

%   Department of Physics
%   University of Aveiro, Portugal

%   28-11-2004 - Matlab R<12 does not support edgealpha
%   23-07-2008 - Changed cos roms_border changed

handles=[];
if nargin == 0
  fname = getf;
end

if isempty(fname);
  return
end


dozeta   = 0;
doslicei = 0;
doslicej = 0;
dobottom = 1;
domask   = 1;
dozero   = 1;
bathy    = [100 200 500 1000];
doslicelon = 0;
doslicelat = 0;
nLON = 100; % n. of points to use in interpolation at lon
nLAT = 100; % n. of points to use in interpolation at lat

vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'zeta')
    dozeta = 1;
    time = vin{i+1};
  end
  if isequal(vin{i},'slicei')
    doslicei = 1;
    I = vin{i+1};
  end
  if isequal(vin{i},'slicej')
    doslicej = 1;
    J = vin{i+1};
  end
  if isequal(vin{i},'slicelon')
    doslicelon = 1;
    LON = vin{i+1};
  end
  if isequal(vin{i},'slicelat')
    doslicelat = 1;
    LAT = vin{i+1};
  end
  if isequal(vin{i},'bathy')
    bathy = vin{i+1};
  end
  if isequal(vin{i},'bottom')
    dobottom = vin{i+1};
  end
  if isequal(vin{i},'zero')
    dozero =  vin{i+1};
  end
  if isequal(vin{i},'mask')
    domask = vin{i+1};
  end
end

is_hold = ishold;
hold on


% --------------------------------------------------------------------
% boundaries:
% --------------------------------------------------------------------
% get data:
% Changed cos roms_border was changed, 23-07-2008
%[x,y,z,xc,yc,zc] = roms_border(fname);
%z0 = zeros(size(z));
%
%% plot bottom border:
%handles.bottom = plot3(x,y,z,'r');
%
%if dozero
%  % surfaze z=zero:
%  handles.top    = plot3(x,y,z0,'r');
%
%  % vertical lines at corners:
%  xc = [xc(1) xc(1) nan xc(2) xc(2) nan xc(3) xc(3) nan xc(4) xc(4)];
%  yc = [yc(1) yc(1) nan yc(2) yc(2) nan yc(3) yc(3) nan yc(4) yc(4)];
%  zc = [zc(1) 0     nan zc(2) 0     nan zc(3) 0     nan zc(4) 0    ];
%  handles.corners = plot3(xc,yc,zc,'r');
%end

handles.corners=[];
handles.top=[];

if dozero
  [x,y,z] = roms_border(fname,'3d');
else
  [x,y,z]=roms_border(fname,'k',1,1,'w');
end
handles.corners_top= plot3(x,y,z,'r');

% --------------------------------------------------------------------
% bathymetry and mask:
% --------------------------------------------------------------------
% load data:
if dobottom | ~isequal(bathy,0) | domask
  [lon,lat,h,m] = roms_grid(fname);
end

% bathymetry surf:
if dobottom
  dx = 1;
  dy = 1;
  s=surf(lon(1:dy:end,1:dx:end),lat(1:dy:end,1:dx:end),-h(1:dy:end,1:dx:end));
  eval('set(s,''facecolor'',''green'');','');
  eval('set(s,''edgecolor'',''white'');','');
  eval('set(s,''edgealpha'',.2);',''); % think is not supported by some versions !
  handles.surfh = s;
end

% bathymetry contour:
if ~isequal(bathy,0)
  if length(bathy) == 1, bathy = -abs(bathy); end
  [tmp,handles.contour] = contour3(lon,lat,-h,-bathy,'g');
end

% mask:
if domask
  [tmp,handles.mask] = contour3(lon,lat,m,[.5 .5],'k');
end

% add camlight:
%%camlight

% --------------------------------------------------------------------
% if fname is roms history file, also plot zeta at border:
% --------------------------------------------------------------------
if dozeta
  if n_varexist(fname,'zeta')
    zeta = roms_slicek(fname,'zeta',[],time);

    % get variable at border:
    [zt,ztc] = var_border(zeta);

    handles.zeta = plot3(x,y,zt);
  end
end

% --------------------------------------------------------------------
% slicei and j
% --------------------------------------------------------------------
if doslicei
  % get zeta:
  if n_varexist(fname,'zeta') & dozeta
    zeta = roms_slicei(fname,'zeta',I,time);
  end

  % get h and lon:
  [x,y,z,h] = roms_slicei(fname,'h',I);

  handles.slicei_h = plot3(x,y,-h);
  if n_varexist(fname,'zeta') & dozeta
    handles.slicei_zeta = plot3(x,y,zeta);
    z0 = [zeta(1) zeta(end)];
    cor = 'b';
  else
    handles.slicei_0 = plot3(x,y,zeros(size(x)),'r');
    z0 =[0 0];
    cor = 'r';
  end
  handles.slicei_corners = ...
  plot3([x(1)     x(1) nan  x(end)    x(end)],...
        [y(1)     y(1) nan  y(end)    y(end)],...
        [-h(1)   z0(1) nan -h(end)   z0(2)  ],cor);
end

if doslicej
  % get zeta:
  if n_varexist(fname,'zeta') & dozeta
    zeta = roms_slicej(fname,'zeta',J,time);
  end

  % get h and lon:
  [x,y,z,h] = roms_slicej(fname,'h',J);

  handles.slicej_h = plot3(x,y,-h);
  if n_varexist(fname,'zeta') & dozeta
    handles.slicej_zeta = plot3(x,y,zeta);
    z0 = [zeta(1) zeta(end)];
    cor = 'b';
  else
    handles.slicej_0 = plot3(x,y,zeros(size(x)),'r');
    z0 =[0 0];
    cor = 'r';
  end
  handles.slicej_corners = ...
  plot3([x(1)     x(1) nan  x(end)    x(end)],...
        [y(1)     y(1) nan  y(end)    y(end)],...
        [-h(1)   z0(1) nan -h(end)   z0(2)  ],cor);
end

% --------------------------------------------------------------------
% slicelon and lat
% --------------------------------------------------------------------
if doslicelon
  % get zeta:
  if n_varexist(fname,'zeta') & dozeta
    zeta = roms_slicelon(fname,'zeta',LON,time);
  end

  % get h and lon:
  [x,y,z,h] = roms_slicelon(fname,'h',LON);

  handles.slicelon_h = plot3(x,y,-h);
  if n_varexist(fname,'zeta') & dozeta
    handles.slicelon_zeta = plot3(x,y,zeta);
    z0 = zeta;
    cor = 'b';
  else
    handles.slicelon_0 = plot3(x,y,zeros(size(x)),'r');
    z0 =zeros(size(h));
    cor = 'r';
  end

  % warning: h and zeta may have nans, so, find first and last non-nan:
  % (should be the same for h and zeta)
  is=isnan(h);
  for i=1:length(is)
    if is(i)==0, i1=i;break, end
  end
  for i=length(is):-1:1
    if is(i)==0, i2=i;break, end
  end

  handles.slicelon_corners = ...
  plot3([ x(i1)     x(i1) nan   x(i2)    x(i2)],...
        [ y(i1)     y(i1) nan   y(i2)    y(i2)],...
        [-h(i1)    z0(i1) nan  -h(i2)   z0(i2)],cor);
end

if doslicelat
  % get zeta:
  if n_varexist(fname,'zeta') & dozeta
    zeta = roms_slicelat(fname,'zeta',LAT,time);
  end

  % get h and lon:
  [x,y,z,h] = roms_slicelat(fname,'h',LAT);

  handles.slicelat_h = plot3(x,y,-h);
  if n_varexist(fname,'zeta') & dozeta
    handles.slicelat_zeta = plot3(x,y,zeta);
    z0 = zeta;
    cor = 'b';
  else
    handles.slicelat_0 = plot3(x,y,zeros(size(x)),'r');
    z0 =zeros(size(h));
    cor = 'r';
  end
  % warning: h and zeta may have nans, so, find first and last non-nan:
  % (should be the same for h and zeta)
  is=isnan(h);
  for i=1:length(is)
    if is(i)==0, i1=i;break, end
  end
  for i=length(is):-1:1
    if is(i)==0, i2=i;break, end
  end

  handles.slicelat_corners = ...
  plot3([ x(i1)     x(i1) nan   x(i2)    x(i2)],...
        [ y(i1)     y(i1) nan   y(i2)    y(i2)],...
        [-h(i1)    z0(i1) nan  -h(i2)   z0(i2)],cor);
end


% --------------------------------------------------------------------
% final settings:
% --------------------------------------------------------------------

% set DataAspectRatio:
dar = get(gca,'DataAspectRatio');
%darm = min(dar(1:2));
darm = max(dar(1:2));
set(gca,'DataAspectRatio',[darm darm dar(3)]);


if ~is_hold
  hold off;
end
