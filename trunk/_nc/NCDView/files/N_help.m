function N_help(target)
%N_help
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% shows NCDView help

html_file='ncdview.htm';
site='http://neptuno.fis.ua.pt/~mma/NCDView';

if isequal(target,'local')
  e=which(html_file);
  if isempty(e)
    errordlg('?? help files not found, add dir help to path !!');
    return
  end

  if strcmpi(computer,'PCWIN')
     web(['file:///' which(html_file)]);
  else
    eval(['web ', which(html_file)]);
  end
end

if isequal(target,'www')
   eval(['web ',site,' -browser']);
end
