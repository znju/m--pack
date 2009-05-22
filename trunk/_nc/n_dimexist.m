function out =  n_dimexist(file,dim)
%N_DIMEXIST   Check if NetCDF file dimension exists
%
%   Syntax:
%      OUT = N_DIMEXIST(FILE,DIM)
%
%   Inputs:
%      FILE   NetCDF file
%      DIM    Dimension name
%
%   Output:
%      OUT   1 = yes; 0 = no; [] = error in file
%
%   Requirement:
%      NetCDF interface for Matlab
%
%   Example:
%      out = n_dimexist('file.nc','time')
%
%   MMA 7-2-2005, mma@odyle.net
%
%   See also N_DIM

%   CESAM, Aveiro, Portugal

%   07-04-2009
%     renamed from n_dimexist
%     both n_filedimexist and n_vardimexist are now deprecated

out=[];

if nargin < 2
  disp('# arguments required');
  return
end

dims = n_dim(file);

if isempty(dims)
  return
end

out=0;
for i=1:length(dims.name)
  if isequal(dims.name{i},dim)
    out = 1;
    return
  end
end
