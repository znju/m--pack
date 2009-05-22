function [dim,sz]=range_dims(v)
%RANGE_DIMS   Dimensions and size of range
%
%   Syntax:
%     [DIMS,SZ] = RANGE_DIMS(RANGE)
%
%   Inputs:
%      RANGE   String of ranges, ex: '1:2:10,10:10:100' or vector of
%              sizes, ex: [3 2 1 1], in this case SZ=RANGE
%
%   Outputs:
%      DIMS   Dimensions of RANGE, only ranges with more than one
%             element are taken into account
%      SZ     Size of RANGE
%
%   Examples:
%      [d,sz]=range_dims('1:10,3:5')        % d= 2, sz=[10 3]
%      [d,sz]=range_dims('1:10,2,3:5')      % d= 2, sz=[10 1 3]
%      [d,sz]=range_dims('1:10,2,123')      % d= 1, sz=[10 1 1]
%      [d,sz]=range_dims(size(zeros(1,10))) % d= 1, sz=[1 10]
%      [d,sz]=range_dims([1 10 0])          % d=-1, sz=[1 10 0]
%
%   MMA 22-04-2009, mma@odyle.net

if isstr(v)
  % first char may be ( and last, ), so remove them before:
  v(v == ')') = '';
  v(v == '(') = '';
  range=explode(v,',');
  for i=1:length(range)
    eval(['sz(i)=length(',range{i},');']);
    if str2num(range{i}) <= 0,  sz(i) = 0; end
  end
  v=sz;
else
  sz=v;
end

if all(v==1)
  dim=0;
elseif any(v==0)
  dim=-1;
else
  dim=length(find(v>1));
end
