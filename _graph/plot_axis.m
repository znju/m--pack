function handle = plot_axis(x,y,z,options)
%PLOT_AXIS   Plot axis on current axes
%
%   Syntax:
%      HANDLE = PLOT_AXIS(X,Y,Z,OPT)
%
%   Inputs:
%      X     A line will be plotted between -X and X on xx axis
%      Y     A line will be plotted between -Y and Y on yy axis [ X ]
%      Z     A line will be plotted between -Z and Z on zz axis [ X ]
%      OPT   Line plot options [ 'k' ]
%
%   Outputs:
%      HANDLE   Plotted line handle
%
%   Comment:
%      If Y and Z not specified, they will be X.
%      If Z not specified the plot will be only xy (2D).
%
%   Example:
%      figure
%      h=plot_axis(1);
%      view(3)
%
%   MMA 8-6-2003, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

if nargin < 4
  options='k';
end

zz=1;
if nargin == 1
  y=x;
  z=x;
end
if nargin == 2
  zz=0;
end

is = ishold;
hold on

if zz
  handle=plot3([-x x nan  0 0 nan  0 0],...
               [ 0 0 nan -y y nan  0 0],...
               [ 0 0 nan  0 0 nan -z z],options);
else
  handle=plot([-x x nan  0 0],...
              [ 0 0 nan -y y],options);
end

if ~is
  hold off
end
