function N_resetLims(param1,param2)
%N_resetLims
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% resets limits (1 and end) in dimensions edit boxes

global H

evalc('fname=H.fname','fname=[]');
if isempty(fname)
  return
end


% get x varname:
[varname,filenumber] = N_getvarname(H.varInfo);
varname = varname{1};
N       = filenumber{1};
evalc('file = H.files{N};','file=[];');
if isempty(file)
  disp(['## error loading file number ',num2str(N),' : nfiles= ',num2str(length(H.files))]);
  return
end

dims = n_varsize(file,varname);
evalc('dims(end+1:4)=1;','');

for i=1:length(dims)
  if dims(i) == 0
    dimi(i) = 0;
  else
    dimi(i) = 1;
  end
end

switch param2
  case 1
    if isequal(param1,'init')
      set(H.dim1,'string',num2str(dimi(param2)));
    else
      set(H.dim1e,'string',num2str(dims(param2)));
      set(H.dim1s,'string',num2str(dims(param2)));
    end
  case 2
    if isequal(param1,'init')
      set(H.dim2,'string',num2str(dimi(param2)));
    else
      set(H.dim2e,'string',num2str(dims(param2)));
      set(H.dim2s,'string',num2str(dims(param2)));
    end
  case 3
    if isequal(param1,'init')
      set(H.dim3,'string',num2str(dimi(param2)));
    else
      set(H.dim3e,'string',num2str(dims(param2)));
      set(H.dim3s,'string',num2str(dims(param2)));
    end
  case 4
    if isequal(param1,'init')
      set(H.dim4,'string',num2str(dimi(param2)));
    else
      set(H.dim4e,'string',num2str(dims(param2)));
      set(H.dim4s,'string',num2str(dims(param2)));
    end
end
