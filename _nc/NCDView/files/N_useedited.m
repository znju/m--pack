function N_useedited
%N_useedited
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% enables use of edited varname

global H

evalc('fname=H.fname','fname=[]');
if isempty(fname)
  return
end


% get x varname:
[varname,filenumber] = N_getvarname(H.varInfo);
Name = varname{1};
N    = filenumber{1};
evalc('fname = H.files{N};','fname=[];');
if isempty(fname)
  disp(['## error loading file number ',num2str(N),' : nfiles= ',num2str(length(H.files))]);
  return
end

n = n_vararraydim(fname,Name);
if isequal(n,-1)
  cb=['N_use(''ED'',','''',Name,''',',num2str(N),')'];
elseif isequal(n,0)
  cb=['N_use(''0D'',','''',Name,''',',num2str(N),')'];
elseif isequal(n,1)
  cb=['N_use(''1D'',','''',Name,''',',num2str(N),')'];
elseif isequal(n,2)
  cb=['N_use(''2D'',','''',Name,''',',num2str(N),')'];
elseif isequal(n,3)
  cb=['N_use(''3D'',','''',Name,''',',num2str(N),')'];
elseif isequal(n,4)
  cb=['N_use(''4D'',','''',Name,''',',num2str(N),')'];
else
  disp(['## error: variable ',Name,' do not exist in file ',fname]);
  set(H.varInfo1,'string','NOT FOUND');
  return
end

eval(cb);

% so, first variable is used to set limits, but now, restore  the string
% if edited 2 variables (so arrows can be plotted)
if length(varname) == 2 & length(filenumber) == 2
  Name2 = varname{2};
  N2    = filenumber{2};
  evalc('fname = H.files{N2};','fname=[];');
  if isempty(fname)
    disp(['## error loading file number ',num2str(N),' : nfiles= ',num2str(length(H.files))]);
    return
  end

  ok = n_varexist(fname,Name2);
  if ok
    str=[Name,'(',num2str(N),'),',Name2,'(',num2str(N2),')'];
    set(H.varInfo,'string',str);
  else
    disp(['## error: variable ',Name2,' do not exist in file ',fname]);
  end
end
