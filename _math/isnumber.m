function is = isn(v,n,space)
%ISNUMBER   Enhanced version of isnumeric
%   Similar to isnumeric but checks length/size, NaNs and range
%   (space).
%
%   Syntax:
%      IS = ISNUMBER(V,N,SPACE)
%      IS = ISNUMBER(V,SPACE)
%
%   Inputs:
%      V       Data, N-D array
%      N       Desired length or size
%      SPACE   Allowed values (default is 'R'):
%              'Z'   : integers, ..., -2, -1, 0, 1, 2, ...
%              'Z+'  : positive integers, 1, 2 ,3, ...
%              'Z0+' : positive integers including zero, 0, 1, 2, 3, ...
%              'Z-'  : negative integers, ..., -3, -2, -1
%              'Z0-' : negative integers including zero, ..., -2, -1, 0
%              'R'   : reals (default)
%              'R+'  : reals, positive, higher than zero
%              'R0+' : reals, positive including zero
%              'R-'  : reals, negative, lower than zero
%              'R0-' : reals, negative, including zero
%              'C'   : complexes, at least one element
%
%   Output:
%      IS   Logical 0 or 1
%
%   Examples:
%      isnumber([1 2 3],3)       % 1
%      isnumber([1 2 3])         % 1
%      isnumber('www')           % 0
%      isnumber([1 2.1],'Z')     % 0
%      isnumber(rand(3,4),[3 4]) % 1
%
%   MMA, 8-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   02-02-2005 - Introduced argument SPACE
%   11-10-2005 - Allow N-D arrays, instead of vectors
%   12-01-2006 - Some improvements and bug fix

is=~1;

check_size  = 0;
check_space = 0;

if nargin == 2
  if isstr(n)
    space = n;
    check_space = 1;
  else
    check_size = 1;
  end
elseif nargin == 3
  check_size  = 1;
  check_space = 1;
end

if ~check_space
  space = 'R';
end

if isempty(v),    return; end
if ~isnumeric(v), return, end
vv = reshape(v,prod(size(v)),1);
if any(isnan(vv)), return, end

if check_size
  if length(n) == 1
    if ~(ndims(v) == 2 & any(size(v)==1) & length(v) == n), return, end
  else
    if ~(isequal(size(v),n)), return, end
  end
end

switch space
  case 'Z',   if ~( isreal(v) & all(vv == floor(vv))                ), return, end
  case 'Z-',  if ~( isreal(v) & all(vv == floor(vv)) & all(vv <  0) ), return, end
  case 'Z0-', if ~( isreal(v) & all(vv == floor(vv)) & all(vv <= 0) ), return, end
  case 'Z+',  if ~( isreal(v) & all(vv == floor(vv)) & all(vv >  0) ), return, end
  case 'Z0+', if ~( isreal(v) & all(vv == floor(vv)) & all(vv >= 0) ), return, end

  case 'R',   if ~isreal(v)                  , return, end
  case 'R-',  if ~( isreal(v) & all(v <  0) ), return, end
  case 'R0-', if ~( isreal(v) & all(v <= 0) ), return, end
  case 'R+',  if ~( isreal(v) & all(v >  0) ), return, end
  case 'R0+', if ~( isreal(v) & all(v >= 0) ), return, end

  case 'C',   if isreal(v), return, end
  otherwise, disp([':: invalid space : ',space]); return
end

is=~0;
