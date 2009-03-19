function  S_predic
%function S_predic
%executes t_predic from LSF or T_TIDE output
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES ETC LOOK

S_pointer

%---------------------------------------------------------------------
% get data:
%---------------------------------------------------------------------
%get tim:
ts=datenum(get(HANDLES.datenum_s,'string'));
te=datenum(get(HANDLES.datenum_e,'string'));
dt=ETC.datenum.dt;
tim=ts:dt/24:te;
t=(tim-tim(1))*24;

tidestruc=ETC.tidestruc;
if isempty(tidestruc) | isequal(ETC.tidestruc_origin,'fsa')
  errordlg('Use FSA or T_TIDE before T_PREDIC','missing...','modaal');
  return
end

S_pointer('watch');
%---------------------------------------------------------------------
% t_predic:
%---------------------------------------------------------------------
% get configuration settings: see S_config_T_TIDE
tide=S_config_T_TIDE;
lat=tide.predic_latitude;
synth=tide.predic_synthesis;

% t_predic:
if ~isempty(lat) & ~isempty(synth)
  yout=t_predic(tim,tidestruc,'latitude',lat,'synthesis',synth);
elseif isempty(synth)
  yout=t_predic(tim,tidestruc,'latitude',lat);
elseif isempty(lat)
  yout=t_predic(tim,tidestruc,'synthesis',synth);
end

%---------------------------------------------------------------------
% plot:
%---------------------------------------------------------------------
axes(HANDLES.spectrum_axes);
xlim=get(gca,'xlim');
h=ishold;

%enable xlim buttons:
S_enable_xlim('on');

% check if necessary to hold off...
if ~S_isplotted('series');
  hold off
  set(HANDLES.hold_spect,'value',0);
end

% plot:
if isreal(yout)
  ETC.handles.plot=plot(t,yout);
  set(ETC.handles.plot,'color',LOOK.color.plot);
else
  pl=plot(t,real(yout),t,imag(yout));
end

% set plotted variable:
ETC.plotted='series';

% different color if hold is on:
if ishold
  if isreal(yout)
    auto_color(HANDLES.spectrum_axes,ETC.handles.plot);
    ETC.handles.plot=[];
  else
    auto_color(HANDLES.spectrum_axes,pl); 
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
currentLegend=sprintf('T_PREDIC %0.7s',ETC.tidestruc_origin);
if ~isreal(yout)
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

%log:
fid = fopen(ETC.logname,'a');
  fprintf(fid,'# Exec T_PREDIC from %s : %s : %s\n',ETC.tidestruc_origin,datestr(ts),datestr(te));
fclose(fid);
return

