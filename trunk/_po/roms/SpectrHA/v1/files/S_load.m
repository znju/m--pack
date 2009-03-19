function S_load
%function S_load
%Load mat file with time serie
% vars:
%      serie (real or imag)
%      interval (default=1)
%      lon, lat (default=nan)
%      start_time (default=nan)
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FLOAD HANDLES LOOK ETC MENU

S_pointer

marker=LOOK.marker.file;
markerColor=LOOK.markerColor.file;
markerColorOld=LOOK.markerColorOld.file;
markerSize=LOOK.markerSize.file;

%---------------------------------------------------------------------
% load mat file with time serie 
%---------------------------------------------------------------------
[filename, pathname] = uigetfile('*.mat', 'Select serie mat file');
fname=[pathname,filename];
if ~(isequal(filename,0)|isequal(pathname,0))    
  %default values:
  interval=1;
  lon=NaN;
  lat=NaN;
  start_time=nan;
  
  load(fname);
else
  return
end

if exist('serie')
  FLOAD.name=fname;
  FLOAD.interval=interval;
  FLOAD.position=[lon lat];
  FLOAD.serie=serie;
  FLOAD.dim=1+any(imag(serie));
  FLOAD.start_time=start_time;
else
  errordlg('Var serie not found...','missing...','modal');
  return
end

% set radio buttons:
S_choose('file');
if FLOAD.dim == 2
    S_choose('ellipse');
elseif FLOAD.dim == 1
    S_choose('serie');
else
    errordlg('Wrong serie loaded...improper serie dimentions','missing...','modal');
    return
end

% log:
fid=fopen(ETC.logname,'a');
fprintf(fid,'# Loaded mat file %s\n',fname);
fclose(fid);

set(MENU.file,'label',['file: ',fname]);
set(MENU.file_interval,'label',['interval: ',num2str(FLOAD.interval)]);
set(MENU.file_dim,'label',['dim: ',int2str(FLOAD.dim)]);
if isnan(FLOAD.start_time)
  set(MENU.file_start_time,'label',['start_time: NaN']);
else
  set(MENU.file_start_time,'label',['start_time: ',datestr(FLOAD.start_time)]);
end

%---------------------------------------------------------------------
% plot position in grid and data in spectrum
%---------------------------------------------------------------------
% position on grid:
axes(HANDLES.grid_axes);
hold on
if ishandle(FLOAD.current)
    set(FLOAD.current,'color',markerColorOld);
end
FLOAD.current=plot(lon,lat,'color',markerColor,'marker',marker,'markersize',markerSize); 
S_axes_prop

%enable xlim buttons:
S_enable_xlim('on');

axes(HANDLES.spectrum_axes);

% hold off, in any case:
hold off
set(HANDLES.hold_spect,'value',0);

% plot:
t=0:length(serie)-1;
t=t*interval;
if isreal(serie)
  ETC.handles.plot=plot(t,serie);
  set(ETC.handles.plot,'color',LOOK.color.plot);  
else
  pl=plot(t,real(serie),t,imag(serie));
end

% set plotted variable:
ETC.plotted='series';

% limits:  
axis auto
xlim=get(gca,'xlim');
set(HANDLES.xlim_i,'string',xlim(1));
set(HANDLES.xlim_e,'string',xlim(2)); 

S_axes_prop

%---------------------------------------------------------------------
% plotit:
%---------------------------------------------------------------------
if ishandle(ETC.plotit)
  delete(ETC.plotit);
end % cos of the legend...
set(HANDLES.output,'value',1); % select the first line of output

%---------------------------------------------------------------------
% legend:
%---------------------------------------------------------------------
currentLegend=sprintf('%s',FLOAD.name);

if isreal(serie)
  ETC.legend=currentLegend;
else
  ETC.legend=strvcat(currentLegend,currentLegend);
end

S_upd_legend(ETC.legend)

%---------------------------------------------------------------------
%final settings...
S_pointer

return
