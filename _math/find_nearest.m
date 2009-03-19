function [i,j]=find_nearest(x,y,xi,yi)
%FIND_NEAREST   Find index of nearest point in 2D
%
%   Syntax:
%      [I,J] = FIND_NEAARES(X,Y,XI,YI)
%
%   Inputs:
%      X,Y     The point
%      XI,YI   Points in 2D
%
%   Outputs:
%      I,J   Index of XI,YI nearest from X,Y
%
%   MMA 17-7-2006, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

if any(size(xi)==1) & any(size(yi)==1)
  [xi,yi]=meshgrid(xi,yi);
end

dist=(x-xi).^2+(y-yi).^2;
[i,j]=find(dist==min(min(dist)));
