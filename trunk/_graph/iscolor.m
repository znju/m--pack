function is = iscolor(in)
%ISCOLOR   Check if color string or rgb triple
%
%   Syntax:
%      IS = ISCOLOR(COLOR)
%
%   Input:
%      COLOR   rgb value, color short or long name
%
%   Output:
%      IS   0 or 1
%
%  Examples:
%     iscolor('g')
%     iscolor('green')
%     iscolor([0 1 0])
%
%   MMA 8-2005, martinh@fis.ua.pt
%
%   See also ISNUMBER

%   Department of physics
%   University of Aveiro

%   21-06-2006 - There was a bug: isnumber(in,3,'Z0+'), must be R0+

is=0;
str_color = {
             'w'; 'white'   ;
             'b'; 'blue'    ;
             'g'; 'green'   ;
             'r'; 'red'     ;
             'c'; 'cyan'    ;
             'm'; 'magenta' ;
             'y'; 'yellow'  ;
             'k'; 'black'
            };
if isstr(in)
  if ismember(in,str_color)
    is = 1;
    return
  end
elseif isnumber(in,3,'R0+') & all(in <= 1)
  is = 1;
end
