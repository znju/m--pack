function varargout=pl_cmap(name,invert)
%PL_CMAP   Pylab colormaps
%
%   Syntax:
%      C = PL_CMAP(NAME,INVERT)
%
%   Inputs:
%      NAME   Colormap name
%      INVERT   Invert colormap flag, default=0
%
%   Output:
%      C   Colormap array
%
%   Comment:
%      To test available colormaps you can use cmap('test'). Then
%      all the pylab colormaps will be applied with pause between.
%
%   Example:
%     figure
%     pcolor(peaks);
%     pl_cmap('YlGnBu')
%
%     pl_cmap('test')
%
%   MMA 10-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin < 2
  invert=0;
end

if strcmpi(name,'test')
  names=readfile('CMAPNAMES');
  % figure, pcolor(peaks(100)); shading flat
  for i=1:length(names)
    n=names{i}(1:end-4);
    pl_cmap(n,invert);
    title(n,'interpreter','none')
    pause
  end
else
  f=[name '.txt'];
  c=load(f);
  if invert, c=flipud(c); end
  colormap(c)

  if nargout==1
    varargout{1}=c;
  end
end
