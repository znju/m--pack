function out =  n_filedimexist(file,dim)
%N_FILEDIMEXIST   Check if NetCDF file dimension exists
%
%   Syntax:
%      OUT = N_FILEDIMEXIST(FILE,DIM)
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
%      out = n_filedimexist('file.nc','time')
%
%   MMA 7-2-2005, martinho@fis.ua.pt
%
%   See also N_FILEDIM, N_VARDIM, N_VARDIMEXIST

%   Department of Physics
%   University of Aveiro, Portugal


fprintf(1,'\n:: %s is DEPRECATED, use %s instead\n',mfilename,'n_dimexist');

out=[];

if nargin < 2
  disp('# arguments required');
  return
end

dims = n_filedim(file);

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
