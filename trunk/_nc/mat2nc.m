function mat2nc(matfile)
%MAT2NC   Convert mat file to NetCDF
%   The NetCDF dimensions will be dim1, dim2, ...
%
%   Syntax:
%      MAT2NC(MATFILE)
%
%   Input:
%      MATFILE
%
%   MMA, 3-2007, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

ncfile=[matfile(1:end-3),'nc'];

a=load(matfile);

if isstruct(a) & 0
  b=struct2cell(a);
  a=b{:};
end
aa=struct2cell(a);

% find dimensions:
sizes=[];
for i=1:length(aa)
  s=size(aa{i});
  for j=1:length(s)
    if ~ismember(s(j),sizes), sizes=[sizes s(j)]; end
  end
end
%sizes(sizes==1)=[];

% find variables:
vars=fieldnames(a);

nc=netcdf(ncfile,'clobber');

% some global attributes:
nc.date=datestr(now);
nc.path=pwd;
[status,host]=system('hostname');
nc.host=host(1:end-1);
nc.source=matfile;
d=dir(matfile);
nc.source_date=d.date;

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
  disp(ev)
  eval(ev)

  % fill variables:
  ev=['nc{''',vars{j},'''}(:)=aa{j};'];
%  ev=['nc{''',vars{j},'''}(:)=',mType,'(aa{j});']
  eval(ev)

end

close(nc);
