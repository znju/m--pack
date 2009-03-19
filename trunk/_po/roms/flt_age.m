function age=flt_age(iflt,file,itime)
%FLT_AGE   Get ROMS float age
%   Returns the age of the float iflt, ie, time since it started
%   moving and ocean_time at index itime.
%   If itime not specified, then returns iflt start time.
%   When age < 0, particle did not start at time index itime yet, thus
%   for itime=1, age = -start time, for any float.
%   When age = 0, particle starts at time index itime.
%
%   Syntax:
%      AGE = FLT_AGE(IFLT,FILE,ITIME)
%
%   Inputs:
%      IFLT    Float index
%      FILE    Floats output file
%      ITIME   Reference time index
%
%   Output:
%      AGE   Float age: how long it is moving or start time if ITIME
%            not specified
%
%   Comments:
%      Needs variables: lon, ocean_time.
%      Needs the properties: missing_value (for lon).
%      Works with ROMS NetCDF floats output file.
%      The lon dimensions should be: time , index.
%
%   MMA 11-5-2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

varname='lon';

nc=netcdf(file);
lon=nc{varname}(:,iflt); % t pos
ot=nc{'ocean_time'}(:);

% get missing_value:
v=nc{varname};
a=att(v);
missing=[];
for n=1:length(a)
  b=a{n};
  att_name=name(b);
  if isequal(att_name,'missing_value');
    missing=a{n}(:);
  end
end
nc=close(nc);

if isempty(missing)
  disp(['# missing value not found in variable --- ',varname]);
  age=[];
  return
end

%---------------------------------------------------------------------

tmp=find(lon==missing);

if isempty(tmp);
  start=ot(1);
else
  start=ot(tmp(end)+1);
end

%---------------------------------------------------------------------
% elapsed:

if nargin < 3
  age=start; % if itime not specified, then just give start time.
else
  age=ot(itime)-start; % otherwise, give flt age : how long it is moving.
end
