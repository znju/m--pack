function S_load_station
%function S_load_station
%Load stations file, currently, can be:
% ROMS hystory file and ROMS stations file
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FSTA HANDLES LOOK MENU ETC

S_pointer

marker=LOOK.marker.stations;
markerColor=LOOK.markerColor.stations;
markerSize=LOOK.markerSize.stations;

[filename, pathname]=uigetfile(ETC.netcdf_ext, 'Choose stations NetCDF file');
if (isequal(filename,0)|isequal(pathname,0))
  fname=[];
else
  fname=[pathname,filename];
end

if isempty(fname)
    return
end

fid=fopen(ETC.logname,'a');
  fprintf(fid,'# Loaded stations %s\n',fname);
fclose(fid);

%=====================================================================
S_pointer('watch');

% load vars:
% check for netcdf
if ~S_exists_netcdf
  str_error=['?? NetCDF not present ??'];
  log_error(str_error,ETC.logname);
  S_pointer;
  return
end
% positions:
lon=S_get_ncvar(fname,'lon_sta');
lat=S_get_ncvar(fname,'lat_sta');
% time:
ot=S_get_ncvar(fname,'time');
% vertical levels:
nlevels=S_get_ncvar(fname,'nlevels');

if isempty(lon) | isempty(lat) | isempty(ot) | isempty(nlevels)
  str_error=['?? some station var(s) is(are) empty ??'];
  errordlg(str_error,'wrong...','modal');
  log_error(str_error,ETC.logname);
  S_pointer
  return
end

ndias=(ot(end)-ot(1))/86400;
interval=(ot(2)-ot(1))/3600; %hours

%---------------------------------------------------------------------
% no error, update FSTA:
% clear selected stations:
if ishandle(FSTA.current)
    delete(FSTA.current);
end
if ishandle(FSTA.selected)
    delete(FSTA.selected);
end
if ishandle(FSTA.positions)
    delete(FSTA.positions);
end
%ps:type is obtained when any var is loaded, so keep it:
type=FSTA.type;
S_init_global('FSTA');
FSTA.type=type;
FSTA.name=fname;
FSTA.interval=interval;
FSTA.nlevels=nlevels;
set(MENU.stations,'label',['stations: ',fname]);


% plot positions:
axes(HANDLES.grid_axes);
hold on

% it looks like roms2+ sets positions over mask as 1e35, so convert to nan:
lon(lon == 1e35) = nan;
lat(lat == 1e35) = nan;

FSTA.positions=plot(lon,lat,'color',markerColor,'marker',marker,...
                    'linestyle','none','markersize',markerSize);
axis auto

% choose station on radio buttons:
S_choose('station');

% axes properties and legends:
extra_disp=[' - ndays = ',sprintf('%6.2f',ndias),...
        ' - interval = ',sprintf('%5.2f',FSTA.interval),' h'];
title([FSTA.name,extra_disp],'interpreter','none','color',LOOK.color.labels);
xlabel('');
S_axes_prop

% reset vars and nlevels
set(HANDLES.vars,'value',1); %zeta
S_check_levels


S_pointer

%---------------------------------------------------------------------
function log_error(string,logfile)
fid=fopen(logfile,'a');
  fprintf(fid,'ERROR: %s\n',string);
fclose(fid);
