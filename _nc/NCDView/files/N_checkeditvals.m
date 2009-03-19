function N_checkeditvals(handle,n,def)
%N_checkeditvals
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% check entry of editable handle; must be value (n numbers)
% in case of error, the value to  put there comes from handle handle<_current>

global H

if nargin < 3
  return
end

evalc(['vals = str2num(get(',handle,',''string''));'],'vals=[]');

is=isnumber(vals,n);

if ~is
  currhandle=[handle,'_current'];
  evalc(['currentVal=',currhandle,';'],'currentVal=def;');
%  currentVal = reshape(currentVal,1,length(currentVal))
%  currentVal = num2str(currentVal)
  evalc(['set(',handle,',''string'',currentVal);'],'');
end
