function S_plot
%function S_plot
%Plot loaded mat file with time serie
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FLOAD HANDLES LOOK ETC
S_pointer

marker=LOOK.marker.file;
markerColor=LOOK.markerColor.file;
markerColorOld=LOOK.markerColorOld.file;
markerSize=LOOK.markerSize.file;

if isempty(FLOAD.name)
  errordlg('No series loaded','missing...','modal');
  return
end

serie=FLOAD.serie;
interval=FLOAD.interval;
lon=FLOAD.position(1);
lat=FLOAD.position(2);

% plot position in grid (cos when S_load_grid, hold is off !)
axes(HANDLES.grid_axes);
if ishandle(FLOAD.current)
  delete(FLOAD.current);
end
FLOAD.current=plot(lon,lat,'color',markerColor,'marker',marker,'markersize',markerSize); 
S_axes_prop

%enable xlim buttons:
S_enable_xlim('on');

axes(HANDLES.spectrum_axes);
xlim=get(gca,'xlim');

% check if necessary to hold off...
if ~S_isplotted('series')
  hold off
  set(HANDLES.hold_spect,'value',0);
end

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

% different color if hold is on:
if ishold
  if isreal(serie)
    handle=auto_color(HANDLES.spectrum_axes,ETC.handles.plot);
    ETC.handles.plot=[];
  else
    handle=auto_color(HANDLES.spectrum_axes,pl);
  end
end


% limits:  
axis auto
if ishold % keep xlim if hold is on !
  set(gca,'xlim',xlim);
end
  
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

if ~isreal(serie)
  currentLegend=strvcat(currentLegend,currentLegend);
end

if ishold
  ETC.legend=strvcat(ETC.legend,currentLegend);
else
  ETC.legend=currentLegend;
end
S_upd_legend(ETC.legend);

%---------------------------------------------------------------------
%final settings...
S_pointer

return
