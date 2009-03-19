function S_plot_data
%function S_plot_data
%plots current data (to be analysed
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES FSTA ETC LOOK FLOAD

S_pointer

%---------------------------------------------------------------------
% get vector to analyse:
%---------------------------------------------------------------------
S_pointer('watch');

[x,field,level,interval]=S_set_data;
if isempty(x)
  S_pointer
  return
end
t=0:length(x)-1;
t=t*interval;

%---------------------------------------------------------------------
% plot:
%---------------------------------------------------------------------
axes(HANDLES.spectrum_axes);
xlim=get(gca,'xlim');

%enable xlim buttons:
S_enable_xlim('on');

% check if necessary to hold off...
if ~S_isplotted('series')
  hold off
  set(HANDLES.hold_spect,'value',0);
end

% plot:
if isreal(x)
  pl=plot(t,x);
else
  pl=plot(t,real(x),t,imag(x));
end

% set plotted variable:
ETC.plotted='series';

% different color if hold is on:
if ishold
  for i=1:length(pl)
    auto_color(HANDLES.spectrum_axes,pl(i));
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
if ~S_isplotted('ellipse')
  format_str=['DATA sta: %4d x %4d:%4s:%s'];
  if ~S_isserie % is ellipse
    field_u='u';
    field_v='v';
    if ~isempty(findstr('bar',lower(field))) % barotropic vars should be '...bar'
      field_u=[field_u,'bar'];
      field_v=[field_v,'bar'];
    end
    currentLegend_u=sprintf(format_str,FSTA.i,field_u,level);
    currentLegend_v=sprintf(format_str,FSTA.i,field_v,level);
    currentLegend=strvcat(currentLegend_u,currentLegend_v);
  else
    currentLegend=sprintf(format_str,FSTA.i,field,level);
  end
  
  if ~S_isstation
    if ~S_isserie    
      currentLegend_r=sprintf('%0.9s %s','DATAr ',FLOAD.name);
      currentLegend_i=sprintf('%0.9s %s','DATAi ',FLOAD.name);
      currentLegend=strvcat(currentLegend_r,currentLegend_i);    
    else
      currentLegend=sprintf('%0.9s %s','DATA  ',FLOAD.name);    
    end
  end
  
  if ishold
    ETC.legend=strvcat(ETC.legend,currentLegend);
  else
    ETC.legend=currentLegend;
  end
  S_upd_legend(ETC.legend);  
end

%---------------------------------------------------------------------
%final settings...
S_pointer

return

