function [a,inBorder,inVertice] = angle_bv(v1,v2)
%ANGLE_BV   Angle between two vectors 2D
%   This function was created to be used by the 2*pi in-polygon
%   algorithm (IN_POLYGON) returnning additional outputs which have
%   sense in the context of that function.
%
%   Syntax:
%      [A,B,V] = ANGLE_BV(V1,V2)
%
%   Inputs:
%      V1, V2   2D vectors (x,y)
%
%   Outputs:
%      A      Angle (rad, -pi:pi)
%      B, V   In border and in vertice (data to be used by IN_POLYGON;
%             notice that if in vertice is not included in border)
%
%   Example:
%     a=angle_bv([1 1],[0 1]);
%
%   MMA 24-5-2007, martinho@fis.ua.pt
%
%   See also IN_POLYGON

% Department of Physics
% University of Aveiro, Portugal

a1=atan2(v1(2),v1(1));
a2=atan2(v2(2),v2(1));

a=a2-a1;
a=mod(a,2*pi);
if a>pi; a=a-2*pi; end

inBorder  = 0;
inVertice = 0;
if all(v1==0) | all(v2==0), inVertice=1; end
if a==pi,     inBorder=1;  end
%if inVertice, inBorder=1;  end
