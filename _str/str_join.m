function out=str_join(str,sep)
%STR_SPLIT   Join list of strings
%   Return a string as a sum of substrings separatted by a delimiter.
%
%   Syntax:
%      OUT = STR_JOIN(STR,SEP)
%
%   Inputs:
%      STR   List of substrings, cell array
%      SEP   Delimiter string [' ']
%
%   Output:
%      OUT   String
%
%   Example:
%      str={'hello','abc'}
%      sep = '\n';
%      str_join(str,sep)
%
%   MMA 21-8-2006, martinho@fis.ua.pt
%
%   See also STR_SPLIT, SPLIT_LIST, EXPLODE

% Department of Physics
% University of Aveiro, Portugal

if nargin<2
  sep=' ';
end

out=str{1};
if length(str)>1
    for i=2:length(str)
        out=[out,sep,str{i}];
    end
end

if nargout==0
    disp(out);
end
