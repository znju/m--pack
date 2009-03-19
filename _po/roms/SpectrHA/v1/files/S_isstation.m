function result=S_isstation
%function result=S_isstation
%1 if data to plot or analyse comes from stations file
%instead of loaded mat file
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

result=get(HANDLES.radio_is_station,'value');
