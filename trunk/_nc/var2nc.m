function var2nc(ncfile,varargin)
%MAT2NC   Create NetCDF file from list of variables
%   The NetCDF dimensions will be dim1, dim2, ...
%
%   Syntax:
%      VAR2NC(FNAME,NAME1,VAR1,NAME2,VAR2,...)
%      VAR2NC(FNAME,DATA_STRUCURE)
%
%   Input:
%      FNAME
%      DATA_STRUCURE, structure with names and values...
%
%   Examples:
%     value1 = rand(10,5);
%     value2 = 123;
%     name1 = 'variable1';
%     name2 = 'variable2';
%     var2nc('example1.nc',name1,value1,name2,value2)
%
%     s.variable1=value1;
%     s.variable2=value2;
%     var2nc('example2.nc',s);
%
%   MMA 10-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

[p,name,ext]=fileparts(ncfile);
if ~strcmpi(ext,'.nc')
  fname=[ncfile '.nc'];
end

if length(varargin)==1
  % is a struct
  a=varargin{1};
  aa=struct2cell(a);
  vars=fieldnames(a);
else
  % is a cell
  aa=varargin(2:2:end);
  vars=varargin(1:2:end);
end

% find dimensions:
sizes=[];
for i=1:length(aa)
  s=size(aa{i});
  for j=1:length(s)
    if ~ismember(s(j),sizes), sizes=[sizes s(j)]; end
  end
end

nc=netcdf(ncfile,'clobber');

% some global attributes:
nc.date=datestr(now);
nc.path=pwd;
[status,host]=system('hostname');
nc.host=host(1:end-1);

% create dimensions:
for j=1:length(sizes)
  dimname{j}=['dim',num2str(j)];
  nc(dimname{j})=sizes(j);
end

% create variables:
for j=1:length(vars)

  % find type:
  mType=class(aa{j}); Type=['nc',mType];
  % find dims:
  s=size(aa{j});
  dims='';
  for i=1:length(s)
    k=find(sizes==s(i));
    dims=[dims,',''',dimname{k},''''];
  end

  ev=['nc{''',vars{j},'''}=',Type,'(',dims(2:end),');'];
%  disp(ev)
  eval(ev)

  % fill variables:
  ev=['nc{''',vars{j},'''}(:)=aa{j};'];
%  ev=['nc{''',vars{j},'''}(:)=',mType,'(aa{j});']
  eval(ev)

end

close(nc);
