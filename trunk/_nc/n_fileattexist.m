function out =  n_fileattexist(file,attname)
%N_FILEATTEXIST   Check if NetCDF file attribute exists
%
%   Syntax:
%      OUT = N_FILEATTEXIST(FILE,VARNAME,ATTNAME)
%
%   Inputs:
%      FILE      NetCDF file
%      ATTNAME   Attribute name
%
%   Output:
%      OUT   1 = yes; 0 = no; [] = error in file
%
%   Requirement:
%      NetCDF interface for Matlab
%
%   Example:
%      out = n_fileattexist('file.nc','units')
%
%   MMA 7-2-2005, martinho@fis.ua.pt
%
%   See also N_FILEATT, N_VAREATT, N_VAREATTEXIST

%   Department of Physics
%   University of Aveiro, Portugal

out=[];

if nargin < 2
  disp('# arguments required');
  return
end

attrib = n_fileatt(file);

if isempty(attrib)
  return
end

out=0;
for i=1:length(attrib.name)
  if isequal(attrib.name{i},attname)
    out = 1;
    return
  end
end
