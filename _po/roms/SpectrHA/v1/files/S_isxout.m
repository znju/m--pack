function result=S_isxout
%function result=S_isxout
%1, if xout checkbox is checked
%in this case output timse serie is plotted, instead of analysis
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

result=get(HANDLES.xout,'value');
