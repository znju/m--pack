function S_plotit
%function S_plotit
%Enables select frequency or ellipse in spectrum axes
%there are to modes of ellipse selection
%edit this file to change
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES ETC LOOK

marker=LOOK.marker.plotit;
markerColor=LOOK.markerColor.plotit;
markerSize=LOOK.markerSize.plotit;

if ishandle(ETC.plotit)
  delete(ETC.plotit);
end

% nothing to do:
str=get(HANDLES.output,'string');
if isempty(str)
    return
end

k=get(HANDLES.output,'value');

% first line and line with correlation (if exist)
if isequal(k,1) | ~isempty(findstr('correlation',str(k,:)))
  return
end

%---------------------------------------------------------------------
axes(HANDLES.spectrum_axes);
h=ishold;
hold on

k=k-1; % first line has no data!

if S_isplotted('fsa','LeastSquares')
  freq=ETC.tidestruc.freq(k);
  T=1./freq;
  amp=ETC.tidestruc.tidecon(k,1);

  ETC.plotit=plot(T,amp,'color',markerColor,'marker',marker,'markersize',markerSize);
end

if S_isplotted('ellipse')
  mode=2;
  if mode == 1
    lw=get(ETC.ellipse(k),'LineWidth');
    vs=get(ETC.ellipse(k),'visible');
    if lw == 2
      set(ETC.ellipse(k),'visible','off');
    else
      set(ETC.ellipse(k),'LineWidth',2);
    end
    if strcmp(vs,'off')
      set(ETC.ellipse(k),'visible','on');
      set(ETC.ellipse(k),'LineWidth',.5);
    end
  else % mode 2
    lw=get(ETC.ellipse(k),'LineWidth');
    vs=get(ETC.ellipse(k),'visible');
    e=length(ETC.ellipse);
    any_off=0;
    for i=1:e
      if isequal(get(ETC.ellipse(i),'visible'),'off');
        any_off=1;
      end
    end
    if lw == .5 & ~any_off % start case
      for n=1:e
        set(ETC.ellipse(n),'visible','off');
      end
      set(ETC.ellipse(k),'visible','on');
    end
    if any_off
      for n=1:e
        set(ETC.ellipse(n),'visible','on');
        set(ETC.ellipse(n),'LineWidth',.5);
      end
      set(ETC.ellipse(k),'LineWidth',2);
    end
    if lw == 2
      set(ETC.ellipse(k),'LineWidth',.5);
    end
  end % mode
end

% keep hold status:
if ~ h
    hold off
end

%-------------------------------------------
%if ~S_isplotted('ellipse')
if ~isempty(legend)
  S_upd_legend; %refresh legend is not ellipses plotted
end

S_pointer


