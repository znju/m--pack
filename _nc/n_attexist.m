function out =  n_attexist(file,attname)
%N_ATTEXIST   Check if NetCDF file attribute exists
%
%   Syntax:
%      OUT = N_ATTEXIST(FILE,VARNAME,ATTNAME)
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
%      out = n_attexist('file.nc','units')
%
%   MMA 7-2-2005, mma@odyle.net
%
%   See also N_ATT, N_VAREATT, N_VAREATTEXIST

%   CESAM, Aveiro, Portugal

%   22-04-2009 - renamed from n_fileeattexist

out=[];

if nargin < 2
  disp('# arguments required');
  return
end

attrib = n_att(file);

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
