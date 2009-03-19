function is=in_box(x,y,xl,yl,incb)
%IN_BOX   True for points inside a rectangular box
%   This is a particular case of INPOLYGON when the polygon is a
%   rectangle.
%
%   Syntax:
%      IS = IN_BOX(X,Y,XL,YL,INCB)
%
%   Inputs:
%     X,Y     Points to check
%     XL,YL   Box limits
%     INCB    Include border flag (default=0)
%
%   Outputs:
%     IS   True/False
%
%   Example:
%     in_box([1 1.5 2],[1 1.5 2],[1 2],[1 2])
%
%   MMA 24-5-2007, martinho@fis.ua.pt
%
%   See also IN_POLYGON

% Department of Physics
% University of Aveiro, Portugal

if nargin <5
  incb=0;
end

if incb
  is= x>=xl(1) & x<=xl(2) & y>=yl(1) & y<=yl(2);
else
  is= x>xl(1) & x<xl(2) & y>yl(1) & y<yl(2);
end
