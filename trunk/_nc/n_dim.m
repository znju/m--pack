function thedim = n_filedim(file,dimname)
%N_DIM   Get dimensions of NetCDF file
%   Returns the dimension(s) (name and length) of a NetCDF file.
%
%   Syntax:
%      DIM = N_DIM(FILE,DIMNAME)
%
%   Inputs:
%      FILE      NetCDF file
%      DIMNAME   Dimension name [ none ]
%
%   Output:
%      DIM   NetCDF file dimension length if DINNAME is specified.
%            If not, DIM will be a structure with all the file
%            dimensions name and associated length.
%            DIM will be empty if the dimension DIMNAME is not found,
%            or if there is an error in the file.
%            Without output and DIMNAME arguments the result is
%            printed.
%
%   Requirement:
%      NetCDF interface for Matlab
%
%   Examples:
%      dims = n_dim('file.nc');
%      dim  = n_dim('file.nc','time');
%
%   MMA 7-2-2005, mma@odyle.net
%
%   See also N_DIMEXIST

%   CESAM, Aveiro, Portugal

%   07-04-2009
%     renamed from n_filedim
%     both n_filedim and n_vardim are now deprecated

thedim=[];

if nargin == 0
  disp('# file required');
  return
end

ncquiet;
nc=netcdf(file);

if isempty(nc)
  return
end

d=dim(nc);

for i=1:length(d)
  thedim.name{i}   = name(d{i}); % NetCDF_Dimension
  thedim.length{i} = d{i}(:);    % itsLength
end

close(nc);

if nargin == 2 % look for dimension DIMNAME:
  found = [];
  for i=1:length(thedim.name)
    if isequal(thedim.name{i},dimname)
      found = thedim.length{i};
      break
    end
  end

  thedim = found;
  if isempty(thedim)
    disp(['# dimension ',dimname,' not found']);
  end
end

% show values if no output argument:
if nargout == 0 & nargin < 2
  fprintf('\n Dimensions in NetCDF file\n %s\n\n',file);
  strn = '';
  strl = '';
  for i=1:length(thedim.name)
    strn = strvcat(strn,thedim.name{i});
    strl = strvcat(strl,num2str(thedim.length{i}));
  end
  maxn = size(strn,2);
  maxl = size(strl,2);
  for i=1:length(thedim.name)
    format = ['  --> %',num2str(maxn),'s%',num2str(2*maxl+5-length(num2str(thedim.length{i}))),'s\n'];
    fprintf(1,format,strn(i,:),strl(i,:));
  end
  fprintf(1,'\n');
end
