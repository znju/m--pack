function S_enable_xlim(status)
%function S_enable_xlim(status)
%input: status: 'on' or 'off'
%enable or disable xlim buttons
%showld be disable when an ellipse is plotted
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

set(HANDLES.xlim_i,'enable',status);
set(HANDLES.xlim_e,'enable',status);
set(HANDLES.xlim,'enable',status);

