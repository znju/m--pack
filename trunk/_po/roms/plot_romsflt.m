function handle=plot_romsflt(file,floats,times,type,varargin)
%PLOT_ROMSFLT   Plot floats from ROMS output floats file
%
%   Syntax:
%      H = PLOT_ROMSFLT(FILE,FLOATS,TIMES,TYPE,VARARGIN)
%
%   Inputs:
%      FILE    Floats NetCDF file
%      FLOATS  Floats index, istart:di:iend or istart:iend or
%              istart:end, if length FLOATS = 3, 2 or 1
%      TIMES   Time index, also with length 3, 2, or 1
%      TYPE    Type of info to show:
%              'lonlat', 'londep', 'timlon', 'latdep', 'timlat', 'timdep'
%      VARARGIN:
%         'axes', default=gca
%         'marker', marker to use, 'none'
%         'line', line properties, '-'
%         'm_map', use m_map projection, default=0
%
%   Output:
%      H   Plot handle
%
%   MMA 13-7-2006, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

handle=[];
if nargin < 3
  disp([':: ',mfilename,' : ROMS_Agrif output flt, floats and  times are needed']);
  return
end

if nargin < 4
  type='lonlat';
end

if length(times) == 3
  time_start    = times(1);
  time_interval = times(2);
  time_end      = times(3);
elseif length(times) == 2
  time_start    = times(1);
  time_interval = 1;
  time_end      = times(2);
elseif length(times) == 1
  time_start    = times(1);
  time_interval = 1;
  time_end      = n_filedim(file,'ftime');
end

if length(floats) == 3
  float_start    = floats(1);
  float_interval = floats(2);
  float_end      = floats(3);
elseif length(floats) == 2
  float_start    = floats(1);
  float_interval = 1;
  float_end      = floats(2);
elseif length(floats) == 1
  float_start    = floats(1);
  float_interval = 1;
  float_end      = n_filedim(file,'drifter');
end

theAxes   = [];
theMarker = 'none';
theLine   = '-';
use_m_map = 0;

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'axes')
    theAxes=vin{i+1};
  elseif isequal(vin{i},'marker')
    theMarker=vin{i+1};
  elseif isequal(vin{i},'line')
    theLine=vin{i+1};
  elseif isequal(vin{i},'m_map')
    use_m_map=vin{i+1};
  end
end

if isempty(theAxes)
  theAxes=gca;
end
axes(theAxes);

time_str   = sprintf('%d:%d:%d',time_start,time_interval,time_end);
floast_str = sprintf('%d:%d:%d',float_start,float_interval,float_end);

lon=use(file,'lon','ftime',  time_str,'drifter',floast_str);
lat=use(file,'lat','ftime',  time_str,'drifter',floast_str);
dep=use(file,'depth','ftime',time_str,'drifter',floast_str);
tim=use(file,'scrum_time','ftime',time_str);
tim=tim/86400;

val=1e15;
lon(lon==val)=nan;
lat(lat==val)=nan;
dep(dep==val)=nan;

switch type
  case 'lonlat', x=lon; y=lat;
  case 'londep', x=lon; y=dep;
  case 'timlon', x=tim; y=lon;

  case 'latdep', x=lat; y=dep;
  case 'timlat', x=tim; y=lat;

  case 'timdep', x=tim; y=dep;
end

if use_m_map
  hold on
  handle=m_plot(x,y,'LineStyle',theLine,'marker',theMarker);
else
  handle=plot(x,y,'LineStyle',theLine,'marker',theMarker);
end
