function S_www
%function S_www
%Opens SpectrHA homepage in default brouser
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global INFO

eval(['web ',INFO.www,' -browser;']);
