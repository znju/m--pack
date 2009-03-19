function S_help
%function S_help
%Opens SpectrHA help in default brouser
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

html_file='spectrha.htm';

e=which(html_file);
if isempty(e)
  errordlg('?? help files not found, add dir help to path !!','missing...','modal');
  return
end

if strcmpi(computer,'PCWIN')
   web(['file:///' which(html_file)]);
else
   eval(['web ', which(html_file),' -browser;']);
end
