function [X,b] = ll_dx(x,y,varargin)
%LL_DX   Lon Lat distance intervals
%
%   Syntax:
%      X,D = LL_DX(LON,LAT,VARARGIN)
%
%   Inputs:
%      LON, LAT   Path coordinates
%      VARARGIN:
%        halfdxi, if 1, D(1) will be D(1)/2 (default=0)
%        halfdxe, if 1, D(end) will be D(end)/2 (default=0)
%
%    Output:
%       D   Distance intervals for each path point
%       X   Bound points, ie, D=diff(X)
%
%   MMA 30-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

halfdxi=0;
halfdxe=0;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'halfdxi'), halfdxi = vin{i+1};
  elseif isequal(vin{i},'halfdxe'), halfdxe = vin{i+1};
  end
end

dx=spheric_dist(y(2:end),y(1:end-1),x(2:end),x(1:end-1));
dx=[0; cumsum(dx(:))];
dx=interp1(1:length(dx),dx,0:length(dx)+1,'cubic','extrap');
X=(dx(2:end)+dx(1:end-1))/2; b=X;
X=diff(X);
if halfdxi
  X(1)=X(1)/2;
end
if halfdxe
 X(end)=X(end)/2;
end
