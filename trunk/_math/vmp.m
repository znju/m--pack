function [xi,yi]=vmp(x,y,xh,yh)
%VMP   Vertical meepoint
%   Computes the intesection of one segment with one vertical line.
%   Created to be used in clipping of lines, being faster than
%   MEETPOINT.
%
%   Syntax:
%      [XI,YI] = VMP(X,Y,XV,YV)
%
%   Inputs:
%     X, Y     Line segment
%     XV, YV   Vertical line segment, lenght XV=1
%
%   Outputs:
%     XI,YI   Intersection point, or empty
%
%   Example:
%     vmp([0,1],[0,1],.5,[0,1])
%
%   MMA 24-5-2007, martinho@fis.ua.pt
%
%   See also HMP, MEETPOINT

% Department of Physics
% University of Aveiro, Portugal

if max(x)<min(xh) | min(x)>max(xh) | ...
   max(y)<min(yh) | min(y)>max(yh) | ...
   diff(x)==0
  xi=[];
  yi=[];
else
  m=diff(y)/diff(x);
  xi=xh;
  yi=m*(xi-x(1))+y(1);
end
