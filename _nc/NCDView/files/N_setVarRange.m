function N_setVarRange(w)
%N_setVarRange
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% sets var range for edited X and Y
% Add 20-9-2004: get scale and offset for d1x, x and y
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


dim=n_varsize(file,varname);
evalc('dim(end+1:4)=1;','');

i1='1';
stepi='1';

rg=['('];
for i=1:length(dim)
  i2=num2str(dim(i));
  range = [i1,':',stepi,':',i2];
  rg=[rg,range,','];
end

rg = [rg(1:end-1),')'];

eval(['set(H.',w,'range,''string'',rg);']);

ok = n_varexist(file,varname);
if ok
  str=[varname,'(',num2str(N),')'];
  eval(['set(H.',w,',''string'',str)']);
else
  disp(['## error: variable ',varname,' do not exist in file ',file]);
end

% added: also set scale and offset:
str = ['N_setVarScale(w,''set'');'];
eval(str,'');

