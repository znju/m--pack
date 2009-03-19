function dist_label(x,y,dist,ratio)
%DIST_LABEL   Insert distance label
%
%   Syntax:
%      DIST_LABEL(X,Y,DIST,RATIO)
%
%   Inputs:
%      X, Y    Position, lower left corner
%      DIST    Distance
%      RATIO   Length/height of the box to draw
%
%   Example:
%      figure,
%      plot(30:40)
%      dist_label(4,32,100)
%
%   MMA 16-1-2005, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

if nargin < 4
  ratio = 1/6;
end

h=ishold;
hold on

Rt = 6370;
R = Rt * cos(y*pi/180);
ang = dist/R *180/pi;

x1 = x;
x2 = x1+ang;
y1 = y;
y2 = y1 + (x2-x1)*ratio;
x3 = (x1+x2)/2;
y3 = (y1+y2)/2;

x  = [x1 x2 x2 x1 x1 nan x1 x3 nan x3 x3];
y  = [y1 y1 y2 y2 y1 nan y3 y3 nan y1 y2];
plot(x,y)

text(x3,y2,[num2str(dist),' km'],'HorizontalAlignment','center','VerticalAlignment','bottom');

if ~h
   hold off
end
