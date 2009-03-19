function S_t_tide
%function S_t_tide
%Calls T_TIDE
%Requires T_TIDE package
%
%This function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FSTA FLOAD HANDLES LOOK DATA ETC MENU

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
N=length(x);

%---------------------------------------------------------------------
% t_tide:
%---------------------------------------------------------------------
t=0:length(x)-1;
t=t*interval;

tideS=S_config_T_TIDE;
more=tideS.eval;


% first and final time index (see S_config_T_TIDE)
if S_isstation % currently is only used by stations data (not loaded mat file...)
  ti=tideS.start_t;
  te=tideS.end_t;  te_=te;
  evalc('x(ti);t(ti);err_i=0;','ti=1;err_i=1;');
  evalc('x(te);t(te);err_e=0;','te=length(x);err_e=1;');
  if err_i, warndlg(['!! problems with ti; using ti=',num2str(ti)],'bad time indice','modal'); end
  if err_e & te_ >=0, warndlg(['!! problems with te; using te=',num2str(te)],'bad time indice','modal'); end
else
  ti=1;
  te=length(x);
end
x=x(ti:te);
t=t(ti:te);

if interval > 1
  warndlg('interval is too big (>1h) to be used by t_tide ','t_tide error','modal');
  S_pointer
  return
end

str=(['[tidestruc,xout]=t_tide(x,''interval'',',num2str(interval),more,');']);
eval(str);

if isequal(get(MENU.phases_atStart,'checked'),'on')
  tidestruc=t0_t_tide(tidestruc,length(xout),interval,0);
  str=[str,' +  phase correction'];
end

set(MENU.str_t_tide,'label',str);

if S_isserie
  C=tidestruc.tidecon(:,1);
  eC=tidestruc.tidecon(:,2);
  pha=tidestruc.tidecon(:,3);
  freq=tidestruc.freq;
  T=1./freq;
else
  major=tidestruc.tidecon(:,1);
  emajor=tidestruc.tidecon(:,2);
  minor=tidestruc.tidecon(:,3);
  inc=tidestruc.tidecon(:,5);
  phase=tidestruc.tidecon(:,7);
end
freq=tidestruc.freq;
T=1./freq;

% sort components according to amplitude or major axis:
if S_isserie
  [I,J]=sort(C);
  J=flipud(J);
  C=C(J);
  eC=eC(J);
  pha=pha(J);
  snr=(C./eC).^2;
else
  [I,J]=sort(major);
  J=flipud(J);
  major=major(J);
  emajor=emajor(J);
  minor=minor(J);
  inc=inc(J);
  phase=phase(J);
  snr=(major./emajor).^2;
end
freq=freq(J);
T=T(J);
names=tidestruc.name(J,:);

tidestruc.tidecon=tidestruc.tidecon(J,:);
tidestruc.name=tidestruc.name(J,:);
tidestruc.freq=tidestruc.freq(J);

%---------------------------------------------------------------------
% output
%---------------------------------------------------------------------
%head:
if S_isstation
  fname=FSTA.name;
  s4=sprintf(' Station:%4d x %4d',FSTA.i);
else
  fname=FLOAD.name;
  s4=sprintf(' Position: %3.3f x %3.3f',FLOAD.position(1), FLOAD.position(2));
end
s1=sprintf('  T_TIDE output:');
s2=sprintf(' Date: %s',datestr(now));
s3=sprintf(' File: %s',fname);
s4=s4;
s5=sprintf(' Serie Length: %d',N);
s6=sprintf(' ti= %d te= %d: %d',ti,te);
s7=sprintf(' Interval: %2.2f h',interval);
s8=sprintf(' Days: %2.2f',N*interval/24);
s9=sprintf(' Field: %s',field);
s10=sprintf(' Level: %s',level);
s10=strvcat(s10,str); % include eval str
if isequal(get(MENU.phases_atStart,'checked'),'on')
  str=sprintf(' Phases displaced to t=0');
  s10=strvcat(s10,str);
end
s11=sprintf('-------------------------------------------');
s_val='';
if S_isserie
  s12=sprintf('       Period    Amp      Pha        snr'); 
  for j=1:length(T)
    sc=sprintf('%0.4s %8.4f %8.4f %9.4f %9.2g',names(j,:), T(j), C(j), pha(j), snr(j));
    s_val=strvcat(s_val,sc);
  end
else
  s12=sprintf('       Period   major    minor    inc        pha        snr');
  for j=1:length(T)
    sc=sprintf('%0.4s %8.4f  %7.4f %8.4f %9.4f  %9.4f %9.2g',names(j,:), T(j), major(j), minor(j), inc(j), phase(j), snr(j));
    s_val=strvcat(s_val,sc);
  end
end

s_head=strvcat(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
s_out=strvcat(s12,s_val);
set(HANDLES.output,'string',s_out);
a=sprintf('=====================================================');

% log:
s_out=strvcat(a,s_head,s_val,a);
fid = fopen(ETC.logname,'a');
for i=1:size(s_out,1)
  fprintf(fid,'%s\n',s_out(i,:));
end
fclose(fid);

% txt_head:
if S_isstation
  txt=sprintf('T_TIDE: Station%4d x %4d . %4s :%s %s : %s',FSTA.i,field,level,FSTA.name,s6);
else
  txt=FLOAD.name;
end
set(HANDLES.txt_head,'string',txt);
ETC.txt_head=txt;

%---------------------------------------------------------------------
% plot:
%---------------------------------------------------------------------
axes(HANDLES.spectrum_axes);
xlim=get(gca,'xlim');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% serie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% :
if S_isserie
  
  %enable xlim buttons:
  S_enable_xlim('on');
  
  % check if necessary to hold off...
  if ( S_isxout & ~S_isplotted('series'))|...
      (~S_isxout &  S_isplotted('series'))
    hold off
    set(HANDLES.hold_spect,'value',0);
  end
  
  % plot:
  if S_isxout
    ETC.handles.plot=plot(t,xout);
  else
    ETC.handles.plot=mystem(T,C);
  end
  set(ETC.handles.plot,'color',LOOK.color.plot);
  
  % set plotted variable:
  if S_isxout
    ETC.plotted='series';
  else
    ETC.plotted='LeastSquares';
  end
  
  % different color if hold is on:
  if ishold
    handle=auto_color(HANDLES.spectrum_axes,ETC.handles.plot);
    ETC.handles.plot=[];
  end
  
  % limits:  
  axis auto
  if ishold % keep xlim if hold is on !
    set(gca,'xlim',xlim);
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ellipses %%%%%%%%%%%%%%%%%%%%%%%%%%%% :
else
  
  % disable xlim controls cos of axis equal !!, if ~S_isxout
  if ~S_isxout
    S_enable_xlim('off');
  end
  
  % check if necessary to hold off...
  if ( S_isxout & ~S_isplotted('series'))|...
      (~S_isxout &  S_isplotted('series'))
    hold off
    set(HANDLES.hold_spect,'value',0);
  end
  
  if S_isxout
    pl=plot(t,real(xout),t,imag(xout));
    if ishold
      auto_color(HANDLES.spectrum_axes,pl(1));
      auto_color(HANDLES.spectrum_axes,pl(2));
    end
  else
    ETC.ellipse=plot_tidestruc(tidestruc);
    ETC.handles.plot_axis=plot_axis(max(major));    
    set(ETC.handles.plot_axis,'color',LOOK.color.plot_axis);
    % ellipse colors:
    name=tideS.const;
    color=tideS.colors; % config colors at menu: S_config_T_TIDE
    for i=1:length(T)
      set(ETC.ellipse(i),'color',LOOK.defaultEllipseColor);
      for c=1:size(color,1)
        if isequal(names(i,:),name(c,:))
          set(ETC.ellipse(i),'color',color(c,:));
        end
      end
    end
  end
  
  % set plotted variable:
  if S_isxout
    ETC.plotted='series';
  else
    ETC.plotted='ellipse';
  end
  
  % limits:
  axis auto
  if ~S_isxout
    axis equal
  elseif ishold % keep xlim if hold is on !
    set(gca,'xlim',xlim);
  end
  
end % serie or ell
%*********************************************************************

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
  format_str=['T_TIDE sta: %4d x  %4d:%4s:%s'];
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
      currentLegend_r=sprintf('%0.8s %s','T_TIDEr ',FLOAD.name);
      currentLegend_i=sprintf('%0.8s %s','T_TIDEi ',FLOAD.name);
      currentLegend=strvcat(currentLegend_r,currentLegend_i);    
    else
      currentLegend=sprintf('%0.8s %s','T_TIDE  ',FLOAD.name);    
    end
  end
  
  if ishold
    ETC.legend=strvcat(ETC.legend,currentLegend);
  else
    ETC.legend=currentLegend;
  end
  S_upd_legend(ETC.legend);  
else % ellipse
  ETC.legend=[]; %cos of release spectrum; dont want legend!
end

%---------------------------------------------------------------------
%final settings...
S_pointer

ETC.tidestruc=tidestruc;
ETC.tidestruc_origin='t_tide';
return
