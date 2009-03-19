function [is,isb,isv] = in_polygon(x,y,px,py)
%IN_POLYGON   Test for a point inside a polygon using a 2*pi algorithm
%   This function was created for test purposed, use the matlab tool
%   INPOLYGON instead.
%
%   Syntax:
%      [IS,ISB,ISV] = IN_POLYGON(X,Y,XP,YP))
%
%   Inputs:
%      X,Y     2D point
%      Xp,YP   Polygon coordinates (don't need to be closed)
%
%   Outputs:
%      IS   True/False
%      ISB  In border True/False
%      ISV  In vertice True/False (if ISB then ISB,IS)
%
%   Example:
%     [i,b,v]=in_polygon(0,2,[0 2 2 0 0],[0 0 2 2 0]);
%
%   MMA 24-5-2007, martinho@fis.ua.pt
%
%   See also ANGLE_BV

% Department of Physics
% University of Aveiro, Portugal

is  = 0;
isb = 0;
isv = 0;

% close the polygon if needed:
if px(end)~=px(1) | py(end)~=py(1)
  px(end+1)=px(1);
  py(end+1)=py(1);
end

% calc all angles:
for i=1:length(px)-1
  [ang(i),inb(i),inv(i)]=angle_bv([px(i)-x py(i)-y],[px(i+1)-x py(i+1)-y]);
end
%is  = abs(sum(ang))==2*pi;
try
  e=eps;
catch
  e=mach_eps;
end
is  = abs( abs(sum(ang))-2*pi) < e*1000;

% chek in-border and in-vertice:
isb = any(inb);
isv = any(inv);

if isv, isb=1; end
if isb, is=1; end
% if in vertice then in border,
% if in border the in polygon.
