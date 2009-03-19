function xs=split_list(x,v)
%SPLIT_LIST   Split list of data by needle
%   The output will be a cell array with the splitted data.
%
%   Syntax:
%      XS = SPLIT_LIST(X,V)
%
%   Inputs:
%      X   Data to split
%      V   Needle (default=nan)
%
%   Output:
%      XS   Cell array
%
%   Example:
%     xs=split_list([1 2 3 nan 4 nan nan])
%     xs=split_list('aaa b c',' '); char(xs{:})
%
%   MMA 24-5-2007, martinho@fis.ua.pt
%
%   See also JOIN_LIST

% Department of Physics
% University of Aveiro, Portugal

if nargin<2
    v=nan;
end

y=[];
xs={};
if isnan(v)
  if ~isnan(x(end)), x(end+1)=nan; end
else
  if x(end)~=v, x(end+1)=v; end
end

for i=1:length(x)
  if isnan(v), cond=isnan(x(i));
  else, cond=x(i)==v;
  end

  if cond
    if length(y)>0, xs(end+1)={y}; end
    y=[];
  else
    y(end+1)=x(i);
  end
end
