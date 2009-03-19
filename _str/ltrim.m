function theString = ltrim(theString,charList)
%LTRIM   Trim string at the beginning
%   Strip whitespace (or other characters) from the beginning of a
%   string.
%
%   Syntax:
%      OUT = LTRIM(STR,CHARLIST)
%
%   Inputs:
%      STR        String
%      CHARLIST   The characters to strip, char array [ ' ' ]
%
%   Output:
%      OUT   Trimmed string
%
%   Example:
%      str = '   blabla';
%      out = ltrim(str); % 'blabla'
%
%   MMA 9-2005, martinho@fis.ua.pt
%
%   See also TRIM, RTRIM

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 2
  charList = ' ';
end
n=1;
while 1
  if ~any(theString(n) == charList), break, end
  n=n+1;
  if n>length(theString), break, end
end
theString = theString(n:end);
