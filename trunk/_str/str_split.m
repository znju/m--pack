function out=str_split(str,needle,iout)
%STR_SPLIT   Split string by string
%   Return a list of the words in the string S, using a delimiter
%   string.
%
%   Syntax:
%      OUT = STR_SPLIT(STR,SEP,IOUT)
%
%   Inputs:
%      STR   String to split
%      SEP   Separator, delimiter string [' ']
%      IOUT  Index to output, default is all the substrings as a cell
%
%   Output:
%      OUT   Cell array of substrings or string if IOUT is provided,
%            if iout higher than the number of substrings, the output
%            is empty
%
%   Example:
%      str = ' aaa    bbb cc ';
%      sep = 'b c';
%      str_split(str,sep)
%
%   MMA 21-8-2006, martinho@fis.ua.pt
%
%   See also STR_JOIN, SPLIT_LIST, EXPLODE

% Department of Physics
% University of Aveiro, Portugal

if nargin < 2
  needle=' ';
end

out={};
while 1
   i=strfind(str,needle);
   if isempty(i)
      break
   end
   i=i(1);

   out{end+1}=str(1:i-1);
   str=str(i+length(needle):end);
end
out{end+1}=str;

if nargin==3
  if iout <=length(out)
    out=out{iout};
  else
    out=[];
  end
end

if nargout==0
  disp(out)
end
