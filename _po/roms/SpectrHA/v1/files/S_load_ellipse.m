function S_load_ellipse
%function S_load_ellipse
%load mat file with ellipse params:
% 1) lon and lat (default nan)
% 2) major
% 3) minor
% 4) pha
% 5) inc
% 6) name (default='')
% 7) freq (default=nan)
% 6) color (default: view setting.m)
% or
% i)   tidestruc from T_TIDE or LSF
% ii)  color (default view setting.m, same for all constituints)
% iii) lon and lat (default nan)
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global ELLIPSE HANDLES LOOK ETC MENU

S_pointer

marker=LOOK.marker.struc;
markerColor=LOOK.markerColor.struc;
markerColorOld=LOOK.markerColorOld.struc;
markerSize=LOOK.markerSize.struc;
defaultColor=LOOK.defaultEllipseColor;

%---------------------------------------------------------------------
% load mat file with ellipse params
%---------------------------------------------------------------------
[filename, pathname] = uigetfile('*.mat', 'Select ellipse parameters mat file');
fname=[pathname,filename];
if isequal(filename,0)|isequal(pathname,0)
    return
end

%default position:
lon=nan;
lat=nan;
freq=nan;
name='';

load(fname);

if exist('tidestruc')
  ELLIPSE.tidestruc=tidestruc;
elseif exist('major') & exist('minor') & exist('inc') & exist('pha')
  tidestruc.tidecon=repmat(0,length(major),8);
  tidestruc.tidecon(:,1)=major;
  tidestruc.tidecon(:,3)=minor;
  tidestruc.tidecon(:,5)=inc;
  tidestruc.tidecon(:,7)=pha;
  ELLIPSE.tidestruc=tidestruc;
else
  errordlg('Wrong variables: major, minor, inc and pha or tidestruc are needed...','missing...','modal');
  return
end
ELLIPSE.name=fname;
ELLIPSE.position=[lon lat];  % not needed
ELLIPSE.tidestruc.freq=freq; % not needed
ELLIPSE.tidestruc.name=name; % not needed


%colors:
if ~exist('color','var')
  color=defaultColor;
end
n=size(tidestruc.tidecon,1);
ncolors=size(color,1);
ELLIPSE.color=repmat(defaultColor,n,1);
ELLIPSE.color(1:min(n,ncolors),:)=color(1:min(n,ncolors),:);

% log:
fid=fopen(ETC.logname,'a');
fprintf(fid,'# Loaded ellipse %s\n',fname);
fclose(fid);

set(MENU.struc,'label',['struc: ',fname]);

%---------------------------------------------------------------------
% plot position in grid and ellipse in spectrum
%---------------------------------------------------------------------
axes(HANDLES.grid_axes);
hold on
if ishandle(ELLIPSE.current)
    set(ELLIPSE.current,'color',markerColorOld);
end
ELLIPSE.current=plot(lon,lat,'color',markerColor,'marker',marker,'markersize',markerSize);
S_axes_prop;

axes(HANDLES.spectrum_axes);

% hold off, in any case:
hold off
set(HANDLES.hold_spect,'value',0);

% plot:
ETC.ellipse=plot_tidestruc(tidestruc);
ETC.handles.plot_axis=plot_axis(max(tidestruc.tidecon(:,1))); 
set(ETC.handles.plot_axis,'color',LOOK.color.plot_axis); 
for i=1:length(ETC.ellipse)
  set(ETC.ellipse(i),'color',ELLIPSE.color(i,:));
end

% set plotted variable:
ETC.plotted='ellipse';

% disable xlim controls cos of axis equal !!
S_enable_xlim('off');
    
axis equal
xlim=get(gca,'xlim');
set(HANDLES.xlim_i,'string',xlim(1));
set(HANDLES.xlim_e,'string',xlim(2));

S_axes_prop;


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
currentLegend=sprintf('%s',ELLIPSE.name);
S_upd_legend(currentLegend,ETC.handles.plot_axis);
% with second arg, legend line will be line of plot_axis!
ETC.legend=currentLegend;
%---------------------------------------------------------------------
%final settings...
S_pointer

return

