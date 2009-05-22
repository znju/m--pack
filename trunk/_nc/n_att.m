function attrib = n_att(file,attname)
%N_ATT   Get global attributes of NetCDF file
%   Recommended standard attributes:
%   (from the NetCDF User's Guide)
%   - title
%   - history
%   - Conventions
%
%   Syntax:
%      ATTRIB = N_ATT(FILE,ATTNAME)
%
%   Inputs:
%      FILE      NetCDF file
%      ATTNAME   Attribute [<none>]
%
%   Output:
%      ATTRIB   NetCDF file attribute value if ATTNAME is specified
%               If not, ATTRIB will be a structure with all the file
%               attributes name and value.
%               ATTRIB will be empty if the attribute ATTNAME is not
%               found, or if there is an error in the file.
%               Without output and ATTNAME arguments the result is
%               printed.
%
%   Requirement:
%      NetCDF interface for Matlab
%
%   Example:
%      attribs = n_att('file.nc');
%      attrib  = n_att('file.nc','title');
%
%   MMA 25-6-2004, mma@odyle.net
%
%   See also N_ATTEXIST, N_VARATT

%   CESAM, Aveiro, Portugal

%   22-04-2009 - renamed from n_fileatt

attrib=[];

if nargin == 0
  disp('# file required');
  return
end

nc=netcdf(file);

if isempty(nc)
  return
end

a=att(nc);

for i=1:length(a)
    b=a{i};
    attrib.name{i}  = name(b);
    attrib.value{i} = b(:);
end

close(nc);

if nargin == 2 % look for attributen ATTNAME:
  found = [];
  for i=1:length(attrib.name)
    if isequal(attrib.name{i},attname)
      found = attrib.value{i};
      break
    end
  end

  attrib = found;
  if isempty(attrib)
    disp(['# attribute ',attname,' not found']);
  end
end

% show values if no output argument:
if nargout == 0 & nargin < 2
  fprintf('\n Attributes in NetCDF file\n %s\n\n',file);
  strn = '';
  strl = '';
  for i=1:length(attrib.name)
    strn = strvcat(strn,attrib.name{i});

    % deal with numeric values:
    if isnumeric(attrib.value{i})
      if any(size(attrib.value{i}) == 1) & length(attrib.value{i}) == 1
        attrib.value{i} = ['<numeric: ',num2str(attrib.value{i}),'>'];
      else
        attrib.value{i} = ['<numeric: size = ',num2str(size(attrib.value{i})),'>'];
      end

    % deal with long strings:
    else
      if length(attrib.value{i}) > 50;
        attrib.value{i} = [attrib.value{i}(1:50),' ...etc'];
      end
    end

    % deal with empty values:
    if isempty(attrib.value{i})
      attrib.value{i} = '<empty>';
    end

    strl = strvcat(strl,num2str(attrib.value{i}));
  end

  maxn = size(strn,2);
  maxl = size(strl,2);
  for i=1:length(attrib.name)
    format = ['  --> %',num2str(maxn),'s     %s\n'];
    fprintf(1,format,strn(i,:),strl(i,:));
  end
  fprintf(1,'\n');
end
