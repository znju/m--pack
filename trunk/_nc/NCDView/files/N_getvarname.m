function [varname,filenumber] = N_getvarname(theHandle)
%N_getvarname
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% returns varname(s) and filenumber(s) from handle' string
% string may  be: varname(filenumber), v(n),...

global H

if ~ishandle(theHandle)
  return
end

str=get(theHandle,'string');

% remove spaces:
str=strrep(str,' ','');

% find if there is more than one variable separated by ',':
vars=explode(str,',');

% find if there is more than one a filenumber: ex: mask(3)
for i=1:length(vars)
  tmp=explode(vars{i},'(');
  varname{i}=tmp{1};
  if length(tmp) > 1
    fnumber=strrep(tmp{2},')','');
    filenumber{i}=str2num(fnumber);
  else
    filenumber{i}=H.fnamen;
  end
end
