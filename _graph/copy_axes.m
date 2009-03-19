function copy_axes(CurrentAxes,NewAxes,name,invert)
%COPY_AXES   Copy objects of an axis to another
%
%   Syntax:
%      COPY_AXES(AXES,NEW_AXES,NAME,INVERT)
%
%   Inputs:
%      AXES       Axes to copy [ <current> ]
%      NEW_AXES   Destination axis [ <figure,axes> ]
%      NAME       title on new figure [ 'copy of' ]
%      INVERT     make flipud of objects during copy [ {0} | 1 ]
%
%   Example:
%      figure
%      plot(1:10), hold on
%      plot(2:15,'r*'); pcolor(rand(3))
%      copy_axes
%      xlabel('testing...')
%      old=gca;
%      figure, new=axes;
%      copy_axes(old, new,'just another copy')
%
%   MMA Jul-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   29-0-2005 - The current function was renamed from copy_figure,
%               which was not a realistic name.

if nargin ==0
    CurrentAxes=gca;
end
if nargin < 4
  invert=0;
end
if nargin < 3
    name='copy';
end
if nargin < 2
    figure
    NewAxes=axes;
end
set(gcf,'numbertitle','off','name',name);

objects=get(CurrentAxes,'children');
if invert
  objects=flipud(objects);
end

CopiedHandles=copyobj(objects,CurrentAxes);

for i=length(CopiedHandles):-1:1
    set(CopiedHandles(i),'parent',NewAxes);
end
