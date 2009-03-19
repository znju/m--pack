function handle = plot_box(x,y,opt)
%PLOT_BOX   Plot rectangle
%
%   Syntax:
%      HANDLE = PLOT_BOX(X,Y,OPT)
%
%   Inputs:
%      X     Rectangle x [ <x1 x2> ]
%      Y     Rectangle y [ <y1 y2> ]
%      OPT   Plot options [ 'b' ]
%
%   Output:
%      HANDLE   Plot handle
%
%   Example:
%      x=[-1 1];
%      y=[-2 2];
%      plot_box(x,y,'rs-')
%
%   MMA 17-3-2003, martinho@fis.ua.pt
%
%   See also PLOT_BORDER

%   Department of physics
%   University of Aveiro

if nargin < 3
  opt = 'b';
end

h=ishold;
hold on
handle=plot([x(1) x(2) x(2) x(1) x(1)], [y(1) y(1) y(2) y(2) y(1)],opt);

if ~h
  hold off;
end
