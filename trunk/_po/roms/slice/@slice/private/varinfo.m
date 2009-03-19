function varinfo(Obj,varname)
%   VARINFO method for class slice
%   Shows attributes and dimensions of the current slice variable

% MMA, martinho@fis.ua.pt
% 21-07-2005

out = get(Obj,'slice_info');
file    = out.file;
if nargin < 2
  varname = out.var;
end

ncquiet;
nc=netcdf(file);
if n_varexist(file,varname)
  a=att(nc{varname});
  d=dim(nc{varname});
else
  disp(['# variable ',varname,' not found']);
  close(nc);
  return
end
for i=1:length(a)
    b=a{i};
    attrib.name{i}  = name(b);
    attrib.value{i} = b(:);
end
for i=1:length(d)
  thedim.name{i}   = name(d{i}); % NetCDF_Dimension
  thedim.length{i} = d{i}(:);    % itsLength
end
close(nc);

% --------------------------------------------------------------------
% attributes
% --------------------------------------------------------------------
fprintf(1,'\n:: attributes of %s\n',varname);
fprintf(1,'   from file %s\n\n',file);

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

% --------------------------------------------------------------------
% dimensions
% --------------------------------------------------------------------
fprintf(1,':: dimensions: \n\n');
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
