function handles = plot_border2d(fname,varargin)
%PLOT_BORDER2D   Display ROMS grid 2D
%   Plots bathymetry and slices location.
%
%   Syntax:
%      HANDLES = PLOT_BORDER2D(FNAME,VARARGIN)
%
%   Inputs:
%      FNAME   ROMS grid or history file [ {<none>} <filename> ]
%      VARARGIN:
%         'slicei', <i>,     will show slice at i
%         'slicej', <j>,     will show slice at j
%         'slicelon', <lon>, will show slice at lon
%         'slicelat', <lat>, will show slice at lat
%         'bathy', <bathy_contours>, contours  on bathymetry will be
%            done. By default contours are done with values:
%            [100 200 500 1000]; if 0, contours are not added.
%         'mask', [{1} | 0], make 0.5 mask contour
%         'coast', [<filename> {'coastline.mat'} 0], coastline file:
%            .mat file with variables lon and lat. If 0, is  not
%            plotted.
%
%   Output:
%      HANDLES   Structure with the several figure handles
%
%   Examples:
%      figure
%      fname = 'grid.nc'
%      plot_border2d(fname)
%      clf
%      plot_border2d(fname,'slicej',50)
%      clf
%      plot_border2d(fname,'slicelat',40);
%      clf
%      h=plot_border2d(fname,'coast','coast_pt.mat','slicelat',41,'bathy',[20 30 40],'mask',0);
%      m_clabel(h.contour);
%
%   MMA 12-2004, martinho@fis.ua.pt
%
%   See Also PLOT_BORDER3D, ROMS_GRID, ROMS_BORDER

%   Department of Physics
%   University of Aveiro, Portugal

handles=[];
if nargin == 0
  fname = getf;
end

if isempty(fname);
  return
end

doslicei = 0;
doslicej = 0;
domask   = 1;
bathy    = [100 200 500 1000];
doslicelon = 0;
doslicelat = 0;
coast    = 'coastline.mat';

vin = varargin;
for i=1:length(vin)
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
  if isequal(vin{i},'mask')
    domask = vin{i+1};
  end
  if isequal(vin{i},'coast')
    coast = vin{i+1};
  end

end

is_hold = ishold;
hold on


% load data:
[lon,lat,h,m] = roms_grid(fname);

% --------------------------------------------------------------------
% bathymetry, mask, coastline:
% --------------------------------------------------------------------
% bathymetry contour:
if ~isequal(bathy,0)
  if length(bathy) == 1, bathy = -abs(bathy); end
  [tmp,handles.contour] = contour(lon,lat,-h,-bathy,'b');
end

% mask:
if domask
  [tmp,handles.mask] = contour(lon,lat,m,[.5 .5],'r');
end

% border
handles.border = plot_border(lon,lat);

axis equal

xm = min(min(lon));
xM = max(max(lon));
ym = min(min(lat));
yM = max(max(lat));
dx = (xM-xm)/10;
dy = (yM-ym)/10;
xlim([xm-dx xM+dx]);
ylim([ym-dy yM+dy]);

% coastline:
if ~isequal(coast,0)
  evalc('cl = load(coast);','cl = 0;');
  if ~isequal(cl,0)
    handles.coast = plot(cl.lon,cl.lat);
  end
end

% --------------------------------------------------------------------
% slices i, j, lon and lat
% --------------------------------------------------------------------
if doslicei
  handles.slicei = plot(lon(:,I),lat(:,I),'r');
end
if doslicej
  handles.slicej = plot(lon(J,:),lat(J,:),'r');
end
if doslicelon
  handles.slicelon = plot([LON LON],[min(min(lat)) max(max(lat))],'r');
end
if doslicelat
  handles.slicelat = plot([min(min(lon)) max(max(lon))],[LAT LAT],'r');
end

if ~is_hold
  hold off;
end
box on
