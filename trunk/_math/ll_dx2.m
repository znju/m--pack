function [X,b] = ll_dx2(x,y,varargin)
%LL_DX   Lon Lat (2d) distance intervals
%
%   Syntax:
%      D,X = LL_DX2(LON,LAT,VARARGIN)
%
%   Inputs:
%      LON, LAT   2-d arrays with path coordinates
%      VARARGIN:
%        halfdxi, if 1, D(1) will be D(1)/2 (default=0)
%        halfdxe, if 1, D(end) will be D(end)/2 (default=0)
%        direct, direction, 'i' of 'j' (default j, where j,i=size(x))
%
%    Output:
%       D   Distance intervals for each path point
%       X   Bound points, ie, D=diff(X)
%
%   MMA 30-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

direct='j';
vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'direct'), direct = vin{i+1}; end
end

if direct=='i'
  x=x';
  y=y';
end

[eta,xi]=size(x);

X = zeros(eta,xi+1);
b = zeros(eta,xi);

for i=1:size(x,1)
  [b(i,:),X(i,:)]=ll_dx(x(i,:),y(i,:),varargin{:});
end

if direct=='i'
  X=X';
  b=b';
end
