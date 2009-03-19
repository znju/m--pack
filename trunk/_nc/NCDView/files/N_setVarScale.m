function [scale, offset] = N_setVarScale(w,what)
%N_setVarScale
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% set or check d1x, or x and y var scale and offset
% w: handle: d1x, x or y
% what: set, check or get
% 
% Added at 19-9-2004

global H


evalc('fname=H.fname','fname=[]');
if isempty(fname)
  return
end


% get x varname:
str=['[varname,filenumber] = N_getvarname(H.',w,');'];
eval(str);
varname = varname{1};
N       = filenumber{1};
evalc('file = H.files{N};','file=[];');
if isempty(file)
  disp(['## error loading file number ',num2str(N),' : nfiles= ',num2str(length(H.files))]);
  return
end

if ~isequal(n_varexist(file,varname),1)
  scale  = 1;
  offset = 0;
else
  [scale,offset] = n_varscale(file,varname);
end

def = [' * ',num2str(scale),' + ',num2str(offset)];

% ------------------------------------------ check:
if isequal(what,'check')
  str = ['s = get(H.',w,'scale,''string'');'];
  eval(str,'s=[];');
  s = strrep(s,'*',' ');
  s = strrep(s,'+',' ');
  if length(str2num(s)) ~= 2
    str = ['set(H.',w,'scale,''string'',def);'];
    eval(str,'');
  end
end


% --------------------------------------------- set:
if isequal(what,'set')
  str = ['set(H.',w,'scale,''string'',def);'];
  eval(str,'');
end

% --------------------------------------------- get:
if isequal(what,'get')
 str = ['s = get(H.',w,'scale,''string'');'];
  eval(str,'s=[];');
  s = strrep(s,'*',' ');
  s = strrep(s,'+',' ');
  n = str2num(s);
  scale  = n(1);
  offset = n(2);
end
