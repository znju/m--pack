function thedim = n_vardims(file,varname,outAsDict)
%N_VARDIMS   Get dimensions of NetCDF variable
%   Returns the dimensions (name and length) of a NetCDF variable.
%
%   Syntax:
%      DIM = N_VARDIMS(FILE,VARNAME,ASDICT)
%
%   Inputs:
%      FILE      NetCDF file
%      VARNAME   Variable
%      ASDICT    Return dict flag (true)
%
%   Output:
%      DIM   Structure with all the variable dimensions name and
%            associated length. DIM will be empty if the variable
%            VARNAME is not found or if there is an error in the file.
%            If ASDICT a dimanamel, dimvalue dict will be returned
%            instead.
%            Without output and DIMNAME arguments the result is
%            printed.
%
%   Requirement:
%      NetCDF interface for Matlab
%
%   Examples:
%      dims = n_vardims('file.nc','var');
%      dim  = n_vardims('file.nc','temp');
%
%   MMA 7-2-2005, martinho@fis.ua.pt
%
%   See also N_VARDIMEXIST, N_DIM

%   Department of Physics
%   University of Aveiro, Portugal

if nargin<3
  outAsDict=true;
end

if outAsDict
  thedim=dict;
else
  thedim=[];
end

if nargin < 2
  disp('# arguments required');
  return
end

ncquiet;
nc=netcdf(file);

if isempty(nc)
  return
end

% check varname
if n_varexist(file,varname)
  d=dim(nc{varname});
else
  disp(['# variable ',varname,' not found']);
  close(nc);
  return
end

if isempty(d)
  thedim.name=[];
  thedim.length=[];
else
  if outAsDict
    for i=1:length(d)
      thedim(name(d{i}))=d{i}(:);
    end
  else
    for i=1:length(d)
      thedim.name{i}   = name(d{i}); % NetCDF_Dimension
      thedim.length{i} = d{i}(:);    % itsLength
    end
  end
end

close(nc);

% show values if no output argument:
if nargout == 0 & nargin < 3
  fprintf('\n Dimensions in variable %s from NetCDF file\n %s\n\n',varname,file);
  strn = '';
  strl = '';
  if outAsDict
    dnames  = keys(thedim);
    dvalues = values(thedim);
  else
    dnames=thedim.name;
    dvalues=thedim.length;
  end

  for i=1:length(dnames)
    strn = strvcat(strn,dnames{i});
    strl = strvcat(strl,num2str(dvalues{i}));
  end
  maxn = size(strn,2);
  maxl = size(strl,2);
  for i=1:length(dnames)
    format = ['  --> %',num2str(maxn),'s%',num2str(2*maxl+5-length(num2str(dvalues{i}))),'s\n'];
    fprintf(1,format,strn(i,:),strl(i,:));
  end
  fprintf(1,'\n');
end
