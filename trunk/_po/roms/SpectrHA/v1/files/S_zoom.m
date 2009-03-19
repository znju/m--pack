function S_zoom
%function S_zoom
%zomm on/off
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

if get(HANDLES.zoom,'value') == 1
  zoom on
else
  zoom off
end

