function cor = caxcolor(val,cax,cmap)
%CAXCOLOR   Caxis color for value
%   Find the color for a given value in a colormap.
%
%   Syntax:
%     COLOR = CAXCOLOR(VALUE,CAXIS,COLORMAP)
%
%   Inputs:
%      VALUE
%      CAXIS   Default is current caxis
%      COLORMAP   Default is current colormap
%
%   Output:
%      COLOR   RGB color vector
%
%   Example:
%      figure
%      pcolor(peaks)
%      color=caxcolor(0);
%      set(gcf,'color',color)
%
%   MMA 28-5-2007, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

if nargin < 3
  cmap = get(gcf,'colormap');
end
if nargin < 2
  cax = caxis;
end

n=size(cmap,1);
i= (val-cax(1))/diff(cax) * (n-1) +1;
a=i-floor(i);
i=floor(i);

i=min(i,n);
i=max(i,1);

if i==n
  cor=cmap(n,:);
elseif i==1
  cor=cmap(1,:);
else
  cor=cmap(i,:)*(1-a) + cmap(i+1,:)*a;
end
