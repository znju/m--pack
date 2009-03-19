function xj=join_list(x,v)
%JOIN_LIST   Split list of data by value
%   The output will be a vector with data from a cell array.
%   Created to join the output of SPLIT_LIST.
%
%   Syntax:
%      XJ = JOIN_LIST(X,V)
%
%   Inputs:
%      X   Data to join (cell array)
%      V   Joinning value (default=nan)
%
%   Output:
%      XJ   Vector
%
%   Example:
%     xs=split_list([1 2 3 nan 4 nan nan])
%     xj=join_list(xs)
%
%   MMA 27-5-2007, martinho@fis.ua.pt
%
%   See also SPLIT_LIST

% Department of Physics
% University of Aveiro, Portugal

if nargin<2
    v=nan;
end

xj=[];
for i=1:length(x)
  xj=[xj v x{i}(:)'];
end
xj=xj(2:end);
