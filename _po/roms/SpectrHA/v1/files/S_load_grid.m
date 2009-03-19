function S_load_grid
%function S_load_grid
%Load grid file, currently, can be:
% ROMS hystory file and SEAGRID file
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FGRID FSTA HANDLES LOOK MENU ETC

S_pointer

[filename, pathname]=uigetfile(ETC.netcdf_ext, 'Choose grid NetCDF file');
if (isequal(filename,0)|isequal(pathname,0))
  fname=[];
else
  fname=[pathname,filename];
end

if isempty(fname)
    return
end

fid=fopen(ETC.logname,'a');
  fprintf(fid,'# Loaded grid %s\n',fname);
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
lon=S_get_ncvar(fname,'longitude');
lat=S_get_ncvar(fname,'latitude');
mask=S_get_ncvar(fname,'mask');

if isempty(lon) | isempty(lat) | isempty(mask)
  str_error=['?? some grid var(s) is(are) empty ??'];
  errordlg(str_error,'missing...','modal');
  log_error(str_error,ETC.logname);
  S_pointer
  return
end

% plot mask:
axes(HANDLES.grid_axes);
str_error=['?? inconsistent size of grid vars ??'];
error_str=['errordlg(str_error,''missing...'',''modal''), log_error(str_error,ETC.logname), S_pointer, return'];
evalc('hold off, pc=pcolor(lon,lat,zero2nan(mask,1));',error_str);
shading flat
colormap([0 0 0; LOOK.color.mask])
hold on
[a,ETC.handles.mask_line]=contour(lon,lat,mask,[.5 .5],'b');
set(ETC.handles.mask_line,'color',LOOK.color.mask_line);
set(ETC.handles.mask_line,'visible','off');

% axes properties and legends:
ylabel(fname,'interpreter','none','color',LOOK.color.labels);
S_axes_prop

% reset vars and nlevels
set(HANDLES.vars,'value',1); %zeta or uvbar
S_check_levels

%---------------------------------------------------------------------
% if no error happened until now, sow FGRID can be updated...
% start grid struc
S_init_global('FGRID')
FGRID.name=fname;

% empty station struct:
S_init_global('FSTA')

set(MENU.grid,'label',['grid: ',fname]); 
set(MENU.stations,'label','stations:'); %FSTA is empty!

S_pointer

%---------------------------------------------------------------------
function log_error(string,logfile)
fid=fopen(logfile,'a');
  fprintf(fid,'ERROR: %s\n',string);
fclose(fid);

