function S_axes_prop
%function S_axes_prop
%Updates axes properties, colors, labels.
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES LOOK

set(gca,'color',LOOK.color.bg);

if gca==HANDLES.spectrum_axes
  set(gca,'xcolor',LOOK.color.spectrum_axes,'ycolor',LOOK.color.spectrum_axes);
  set(gca,'xminortick','on','yminortick','on');
  title('spectrum','color',LOOK.color.labels);
  %  if S_isserie |  (~S_isserie & S_isxout('any'))
  if S_isplotted('series')
    xlabel('Time (h)','color',LOOK.color.labels);
    ylabel('Amplitude','color',LOOK.color.labels);
  elseif S_isplotted('fsa','LeastSquares')
    xlabel('Period (h)','color',LOOK.color.labels);
    ylabel('Amplitude','color',LOOK.color.labels);
  else
    xlabel('','color',LOOK.color.labels)
    ylabel('','color',LOOK.color.labels)
  end
else
  set(gca,'xcolor',LOOK.color.grid_axes,'ycolor',LOOK.color.grid_axes);
end
