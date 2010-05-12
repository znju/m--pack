function [x,y,z,v]=roms_slicell_aux(f,varname,t,varargin)
%VERTICAL_SLICE_AUX   Auxiliary tool for VERTICAL_SLICE
%   Useful to select the slice xy path. First the 2d region is
%   plotted and the user can select the path with mouse, either as
%   a apline or as a broken line.
%
%   Syntax:
%      [X,Y,Z,V] = VERTICAL_SLICE_AUX(F,VAR,T,VARARGIN)
%
%  Inputs:
%     F     Roms input/output file
%     VAR   Variable name to slice
%     T     Time index
%     VARARGIN:
%        'npoins', number horizontal points to use [200]
%        'isSpline', use spline or broken line, [1]
%        'plt', plot result at the end [1]
%        'new', new path selection, if false, the path drawn in the
%               current axes is used, may be used if you want to
%               change the path and don't need to draw a new one
%
%   Output:
%      X,Y,Z,V, 2D matrices if variable VAR has vertical component,
%               1D and empty Z otherwise
%
%   Examples:
%      f='roms_his.nc';
%      vn='salt';
%      t=10;
%      [x,y,z,v]=vertical_slice_aux(f,vn,t);
%
%   MMA 23-3-2007, martinho@fis.ua.pt
%
%   See also VERTICAL_SLICE, SPL, BLIN

% Department of Physics
% University of Aveiro, Portugal

npoints  = 200;
isSpline = 1;
plt      = 1;
new      = 1;

vin = varargin;
for i=1:length(vin)
  if isequal(lower(vin{i}),'npoints')
    npoints=vin{i+1};
  elseif isequal(lower(vin{i}),'isspline')
    isSpline=vin{i+1};
  elseif isequal(lower(vin{i}),'plt')
    plt=vin{i+1};
  elseif isequal(lower(vin{i}),'new')
    new=vin{i+1};
  end
end

% pick the xy points ----------------------------:
if new
  figure
  plot_border2d(f); hold on
end

if isSpline
  if new, spl; end
  tag='spline';
else
  if new, blin; end
  tag='blin';
end

ob=findobj(gca,'tag',tag);

X=get(ob,'xdata');
Y=get(ob,'ydata');

d=ceil(length(X)/npoints);
X=X(1:d:end);
Y=Y(1:d:end);

% get slice -------------------------------------:
[x,y,z,v]=roms_slicell(f,varname,X,Y,t);

% plot result -----------------------------------:
if plt
  figure
  if isempty(z)
    plot3(x,y,v);
  else
    plot_border3d(f,'bottom',0); hold on,% camlight
    surf(x,y,z,zero2nan(v),'edgecolor','none','facecolor','interp','FaceLighting','none');
    view(3)
  end
end
