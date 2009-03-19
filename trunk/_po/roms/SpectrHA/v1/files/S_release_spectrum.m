function S_release_spectrum
%function S_release_spectrum
%Open spectrum in a new figure
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES  LOOK ETC

figure

if S_isplotted('ellipse')
  invert=0; % like this legend line will be line of plot_axis!!
else
  invert=1; % cos of plotit, to remove marker, executes flipud on objects when copying
end

copy_axes(HANDLES.spectrum_axes,axes,'SPECTRUM',invert);

if ~isempty(ETC.legend)
  warning off
  legend(ETC.legend)
  set(legend,'fontname',LOOK.fontname);
  lc=get(legend,'children');
  if ~isempty(lc)
    set(lc(end),'interpreter','none');%,'color',LOOK.color.legend_fg);
  end
  warning on
end

ti=get(gca,'title');
tit=get(ti,'string');
str=[tit,'  ',datestr(now)];
title(str);

