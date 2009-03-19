function handle = fill_box(x,y,opt)
%FILL_BOX   Fill rectangle
%   HANDLE = PLOT_BOX(X,Y,OPT);
%
%   Inputs:
%      X     Rectangle x [ <x1 x2> ]
%      Y     Rectangle y [ <y1 y2> ]
%      OPT   Fill options [ 'y' ]
%
%   Output:
%      HANDLE   Fill handle
%
%   Example:
%      figure
%      x=[-1 1];
%      y=[-2 2];
%      fill_box(x,y,'r')
%      axis([-5 5 -5 5])
%
%   MMA 1-4-2005, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

if nargin < 3
  opt = 'y';
end

h=ishold;
hold on
handle=fill([x(1) x(2) x(2) x(1) x(1)], [y(1) y(1) y(2) y(2) y(1)],opt);

if ~h
  hold off;
end
