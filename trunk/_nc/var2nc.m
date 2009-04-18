function var2nc(ncfile,Vars,Dims,Atts)
%MAT2NC   Create NetCDF file from list of variables
%   The NetCDF dimensions will be dim1, dim2, ...
%
%   Syntax:
%      VAR2NC(FNAME,VARIABLES,DIMENSIONS,ATTRIBUTES)
%
%   Input:
%      FNAME   Netcdf file to create
%      VARIABLES   struct or cell with variables, names and values
%      DIMENSIONS  struct or cell with dimensions, names and values
%      ATTRIBUTES  struct or cell with global attributes, names and values
%
%   Examples:
%     % gen vars:
%     lon=rand(1,100);
%     lat=rand(1,130);
%     temp=rand(100,130);
%     vars={'lon',lon,'lat',lat,'temp',temp};
%     % or as a struct: vars.lon=lon; vars.lat=lat; vars.temp=temp;
%
%     % gen dims, not required:
%     dims.lon_r = 100;
%     dims.lat_r = 130;
%     dims.one   = 1;
%     dims.time  = 10; % will not be used !!
%     % or as a cell: dims={'lon_r',100,'lat_r',100,'one',1,'time',10};
%
%     % gen global atts, not required !!
%     atts.name='My Name';
%     atts.data=[12 12.5 24];
%     % or as a cell...
%
%     var2nc('example1.nc',vars) % dim names will be dim_1,dim_2, ...
%     var2nc('example2.nc',vars,dims, atts)
%
%   MMA 10-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

%   15-04-2009 - Added arguments Dims and Atts

[p,name,ext]=fileparts(ncfile);
if ~strcmpi(ext,'.nc')
  fname=[ncfile '.nc'];
end

if nargin>=4
  if iscell(Atts)
    names = Atts(1:2:end);
    vals  = Atts(2:2:end);
    Atts  = cell2struct(vals,names,2);
  end
else
  Atts=[];
end

if nargin>=3
  if iscell(Dims)
    names = Dims(1:2:end);
    vals  = Dims(2:2:end);
    Dims  = cell2struct(vals,names,2);
  end
else
  Dims=[];
end

if nargin>=2
  if iscell(Vars)
    names = Vars(1:2:end);
    vals  = Vars(2:2:end);
    Vars  = cell2struct(vals,names,2);
  end
else
  Dims=[];
end

% find var sizes:
sizes=[];
if ~isempty(Vars)
  vvalues=struct2cell(Vars);
  for i=1:length(vvalues)
    s=size(vvalues{i});
    for j=1:length(s)
      if ~ismember(s(j),sizes), sizes=[sizes s(j)]; end
    end
  end
end

nc=netcdf(ncfile,'clobber');

% global attributes:
nc.date=datestr(now);
nc.path=pwd;
[status,host]=system('hostname');
nc.host=host(1:end-1);
% add input global attributes:
if ~isempty(Atts)
  names  = fieldnames(Atts);
  values = struct2cell(Atts);
  for i=1:length(names);
    if ischar(values{i})
      cmd=['nc.' names{i} '=''' values{i} ''';'];
    else
      cmd=['nc.' names{i} '= values{i};'];
    end
    eval(cmd);
  end
end

% create dimensions:
for j=1:length(sizes)
  found=0;
  if ~ isempty(Dims)
    names  = fieldnames(Dims);
    values = struct2cell(Dims);
    i=find(sizes(j)==cell2mat(values));
    if ~isempty(i)
      dimname{j}=names{i};
      found=1;
    end
  end
  if ~found
    dimname{j}=['dim',num2str(j)];
  end
  nc(dimname{j})=sizes(j);
end

% create variables:
if ~isempty(Vars)
  names  = fieldnames(Vars);
  values = struct2cell(Vars);
  for j=1:length(names)

    % find type:
    mType=class(values{j}); Type=['nc',mType];
    % find dims:
    s=size(values{j});
    dims='';
    for i=1:length(s)
      k=find(sizes==s(i));
      dims=[dims,',''',dimname{k},''''];
    end

    ev=['nc{names{j}}=',Type,'(',dims(2:end),');'];
    %disp(ev)
    eval(ev)

    % fill variables:
    ev=['nc{names{j}}(:)=values{j};'];
    %ev=['nc{vars{j}}(:)=',mType,'(aa{j});']
    eval(ev)
  end
end

close(nc);
