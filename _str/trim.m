function theString = trim(theString,charList)
%TRIM   Trim string
%   Strip whitespace (or other characters) from the beginning and end
%   of a string.
%
%   Syntax:
%      OUT = TRIM(STR,CHARLIST)
%
%   Inputs:
%      STR        String
%      CHARLIST   The characters to strip, char array [ ' ' ]
%
%   Output:
%      OUT   Trimmed string
%
%   Example:
%      str = ['   blabla  ',10]; % length 12
%      out = trim(str,[' ',10]); % length 6
%
%   MMA 9-2005, martinho@fis.ua.pt
%
%   See also RTRIM, LTRIM

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 2
  charList = ' ';
end
theString = rtrim(theString,charList);
theString = ltrim(theString,charList);
