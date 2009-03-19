function S_upd_legend(leg,handles)
%function S_upd_legend(leg,handles)
%Update current legend 
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global LOOK HANDLES

axes(HANDLES.spectrum_axes)

warning off

if nargin==2
  legend(handles,leg);
elseif nargin==1
  legend(leg);
else
  legend
end

set(legend,'fontname',LOOK.fontname);
lc=get(legend,'children');
if ~isempty(lc)
  set(lc(end),'interpreter','none','color',LOOK.color.legend_fg);
end
warning on

