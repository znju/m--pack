function [x,y] = rot2d(xi,yi,teta)
%ROT2D   2D rotation
%   Rotates arrays of positions (XI, YI) by the angle theta (polar
%   coordinates).
%
%   Syntax:
%      [X,Y] = ROT2D(XI,YI,THETA)
%
%   Inputs:
%      XI, YI   Initial positionsm, N-D arrays
%      THETA    Angle to rotate (deg), scalar or N-D array
%
%   Output:
%      X, Y   Rotated positions
%
%   Example:
%      figure
%      x=1; y=1;
%      plot([0 x], [0 y]); hold on
%      [x,y]=rot2d(x,y,40);
%      plot([0 x], [0 y],'r'), axis equal
%
%   MMA 13-1-2003, martinho@fis.ua.pt
%
%   See also ROT3D

%   Department of Physics
%   University of Aveiro, Portugal

if nargin ~= 3
   error('rot2d must have x,y and teta as input arguments');
   return
end
if size(xi)~=size(yi)
   error('xi and yi must have same size');
   return
end

teta=teta*pi/180;
[th,r]=cart2pol(xi,yi);
[x,y]=pol2cart(th+teta,r);
