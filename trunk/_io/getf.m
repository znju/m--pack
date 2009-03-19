function f=getf
%GETF   Get filename
%   Uses uigetfile to get filename.
%   It is just a short way of calling uigetfile.
%
%   Syntax:
%      F = GETF
%
%   Output:
%      F   full filename (with path)
%
%   Example:
%      f=getf;
%
%   MMA 6-2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

[filename, pathname]=uigetfile('*', 'Choose the  file');
if (isequal(filename,0)|isequal(pathname,0))
  f=[];
  return
else
  f=[pathname,filename];
end
