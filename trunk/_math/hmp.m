function [xi,yi]=hmp(x,y,xh,yh)
%HMP   Horizontal meepoint
%   Computes the intesection of one segment with one horizontal line.
%   Created to be used in clipping of lines, being faster than
%   MEETPOINT.
%
%   Syntax:
%      [XI,YI] = HMP(X,Y,XH,YH)
%
%   Inputs:
%     X, Y     Line segment
%     XH, YH   Horizontal line segment, lenght YH=1
%
%   Outputs:
%     XI,YI   Intersection point, or empty
%
%   Example:
%     hmp([0,1],[0,1],[0,1],.5)
%
%   MMA 24-5-2007, martinho@fis.ua.pt
%
%   See also VMP, MEETPOINT

% Department of Physics
% University of Aveiro, Portugal

if max(x)<min(xh) | min(x)>max(xh) | ...
   max(y)<min(yh) | min(y)>max(yh) | ...
   diff(y)==0
  xi=[];
  yi=[];
else
  yi=yh;
  if x(1)==x(2)
    xi=x(1);
  else
    m=diff(y)/diff(x);
    xi=(yi-y(1))/m +x(1);
  end
end
