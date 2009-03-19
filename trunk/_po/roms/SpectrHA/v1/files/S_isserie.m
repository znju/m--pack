function result=S_isserie
%function result=S_isserie
%1 if 1D data is to be used (instead of 2D,ie, ellipses)
%is given by radio buttons
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt
global HANDLES

result=get(HANDLES.radio_is_serie,'value');

