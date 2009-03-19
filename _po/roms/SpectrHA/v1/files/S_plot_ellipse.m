function S_plot_ellipse
%function S_plot_ellipse
%Plot loaded ellipse file
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global ELLIPSE HANDLES LOOK ETC

S_pointer

marker=LOOK.marker.struc;
markerColor=LOOK.markerColor.struc;
markerColorOld=LOOK.markerColorOld.struc;
markerSize=LOOK.markerSize.struc;

if isempty(ELLIPSE.name)
  errordlg('No ellipse struc loaded','missing...','modal');
  return
end

lon=ELLIPSE.position(1);
lat=ELLIPSE.position(2);
color=ELLIPSE.color;
tidestruc=ELLIPSE.tidestruc;

% plot position in grid (cos when S_load_grid, hold is off !)
axes(HANDLES.grid_axes);
if ishandle(ELLIPSE.current)
  delete(ELLIPSE.current);
end
ELLIPSE.current=plot(lon,lat,'color',markerColor,'marker',marker,'markersize',markerSize);
S_axes_prop

axes(HANDLES.spectrum_axes);

% check if necessary to hold off...
if ~S_isplotted('ellipse')
  hold off
  set(HANDLES.hold_spect,'value',0);
end

% plot:
if ~ishold % if hold, keep output analysis (var ETC.ellipse)
  ETC.ellipse=plot_tidestruc(tidestruc);
  for i=1:length(ETC.ellipse)
    set(ETC.ellipse(i),'color',color(i,:));
  end
else
  handles=plot_tidestruc(tidestruc);
  for i=1:length(handles)
    set(handles(i),'color',color(i,:));
  end
end
ETC.handles.plot_axis=plot_axis(max(tidestruc.tidecon(:,1)));
set(ETC.handles.plot_axis,'color',LOOK.color.plot_axis);

% set plotted variable:
ETC.plotted='ellipse';

% disable xlim controls cos of axis equal !!
S_enable_xlim('off');

axis equal
xlim=get(gca,'xlim');
set(HANDLES.xlim_i,'string',xlim(1));
set(HANDLES.xlim_e,'string',xlim(2));

S_axes_prop;

if ~ishold
  % output:
  s1=sprintf('       Period   major    minor    inc        pha');
  major = ELLIPSE.tidestruc.tidecon(:,1);
  minor = ELLIPSE.tidestruc.tidecon(:,3);
  inc   = ELLIPSE.tidestruc.tidecon(:,5);
  phase = ELLIPSE.tidestruc.tidecon(:,7);
  if isempty(ELLIPSE.tidestruc.name)
    name=repmat(' ',length(major),4);
  else
    name=ELLIPSE.tidestruc.name;
  end
  if isnan(ELLIPSE.tidestruc.freq)
    T=repmat(nan,size(major));
  else
    T=1./ELLIPSE.tidestruc.freq;
  end
  s_val='';
  for i=1:length(major)
    sc=sprintf('%0.4s %8.4f  %7.4f %8.4f %9.4f  %9.4f',name(i,:), T(i), major(i), minor(i), inc(i), phase(i));
    s_val=strvcat(s_val,sc);
  end
  s_out=strvcat(s1,s_val);
  set(HANDLES.output,'string',s_out);
  
  % txt_head:
  txt=ELLIPSE.name;
  set(HANDLES.txt_head,'string',txt);
  ETC.txt_head=txt;
end

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
if ~ishold
  currentLegend=sprintf('%s',ELLIPSE.name);
  S_upd_legend(currentLegend,ETC.handles.plot_axis);
% with second arg, legend line will be line of plot_axis!
end

%---------------------------------------------------------------------
%final settings...
S_pointer

