function [xtick,ytick,ztick] = genticks(ax,x,y,z)
%GENTICKS   Generate axis ticks
%   Generate ticks for data X, Y and Z according to one axes position.
%
%   Syntax:
%      [XTICK,YTICK,ZTICK] = GENTICKS(AXES,X,Y,Z)
%
%   Inputs:
%      AXES      Reference axes
%      X, Y, Z   Data or data range (min x max x, ...)
%
%   Outputs:
%      XTICK, YTICK, ZTICK   axes ticks
%
%   Example:
%      figure
%      plot(1:10)
%      [xtick,ytick,ztick] = genticks(gca,[1 20],[30 100],[ 0 0])
%
%   MMA 8-2005, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

%   09-07-2008 - Improve for 2d

xtick = [];
ytick = [];
ztick = [];

vw=3;
if nargin < 4
  z = repmat(0,size(x));
  vw=2;
end

if ~isequal(size(x),size(y),size(z))
  disp('# X, Y and Z must have the same size');
  return
end

fig0      = get(ax,'parent');
fig0pos   = get(fig0,'position');
fig0units = get(fig0,'units');
axpos     = get(ax,'position');
axunits   = get(ax,'units');

fig = figure('visible','off','units',fig0units,'position',fig0pos);
axes('units',axunits,'position',axpos);

x = reshape(x,1,prod(size(x)));
y = reshape(y,1,prod(size(y)));
z = reshape(z,1,prod(size(z)));
x1 = min(x); x2 = max(x);
y1 = min(y); y2 = max(y);
z1 = min(z); z2 = max(z);

plot3([x1 x2],[y1 y2],[z1 z2]);
view(vw);
axis tight

xtick = get(gca,'xtick');
ytick = get(gca,'ytick');
ztick = get(gca,'ztick');

close(fig);
