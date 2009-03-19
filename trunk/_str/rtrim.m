function theString = rtrim(theString,charList)
%RTRIM   Trim string at the end
%   Strip whitespace (or other characters) from the end of a string.
%
%   Syntax:
%      OUT = RTRIM(STR,CHARLIST)
%
%   Inputs:
%      STR        String
%      CHARLIST   The characters to strip, char array [ ' ' ]
%
%   Output:
%      OUT   Trimmed string
%
%   Example:
%      str = 'blabla   ';
%      out = rtrim(str); % 'blabla'
%
%   MMA 9-2005, martinho@fis.ua.pt
%
%   See also TRIM, LTRIM

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 2
  charList = ' ';
end
n=length(theString);
while 1
  if ~any(theString(n) == charList), break, end
  n=n-1;
  if n==0, break, end
end
theString = theString(1:n);
