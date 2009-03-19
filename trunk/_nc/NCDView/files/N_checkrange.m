function N_checkrange(what,dim,obj)
%N_checkrange
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% validates edited variables range
% what: start : step : end
% dim: 1,2,3,4
% obj: handle

global H

% dim1 : stepi : dim1e

if nargin < 3
  return
end

evalc('fname=H.fname','fname=[]');
if isempty(fname)
  return
end

% get varname:
[varname,filenumber] = N_getvarname(H.varInfo);
varname = varname{1};
N       = filenumber{1};
evalc('file = H.files{N};','file=[];');
if isempty(file)
  disp(['## error loading file number ',num2str(N),' : nfiles= ',num2str(length(H.files))]);
  return
end

s=n_varsize(file,varname);
evalc('s(end+1:4)=1;','');
s=s(dim);

if isempty(s)
  return
end

% ------------------------------------------------
eval(['obj=',obj,';']);

if isequal(what,'start')
  num=str2num(get(obj,'string'));
  if isnumber(num,1)
    if ~(num >= 1 & num <= s)
      set(obj,'string',1);
     end
  else
    set(obj,'string',1);
  end
end

if isequal(what,'end')
  num=str2num(get(obj,'string'));
  if isnumber(num,1)
    if ~(num >= 1 & num <= s)
      set(obj,'string',num2str(s));
     end
  else
     set(obj,'string',num2str(s));
  end
end

if isequal(what,'step')
  num=str2num(get(obj,'string'));
  if isnumber(num,1)
    if num < 1 | num > s
      set(obj,'string',1);
     end
  else
    set(obj,'string',1);
  end
end
