function theResult = isccw(x, y);

% isccw -- Is this polygon counter-clockwise?
%  isccw(x, y) returns TRUE if the (x, y) polygon
%   points are in counter-clockwise sequence;
%   else, FALSE.
 
% Copyright (C) 2002 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 26-Sep-2002 11:49:37.
% Updated    26-Sep-2002 11:49:37.

if nargin < 1, help(mfilename), return, end

if nargin == 1
    y = imag(x);
    x = real(x);
end

x(end+1) = x(1);
y(end+1) = y(1);
x = x(:).';
y = y(:);

area = (x(1:end-1)*y(2:end) - x(2:end)*y(1:end-1))/2;

result = (area > 0);

if nargout > 0
    theResult = result;
else
    disp(result)
    assignin('caller', 'ans', result)
end
