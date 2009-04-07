function out =  n_vardimexist(file,varname,dim)
%N_VARDIMEXIST   Check if NetCDF variable dimension exists
%
%   Syntax:
%      OUT = N_VARDIMEXIST(FILE,VARNAME,DIM)
%
%   Inputs:
%      FILE      NetCDF file
%      VARNAME   variable
%      DIM       dimension name
%
%   Output:
%      OUT   1 = yes; 0 = no; [] = error in file or if VARNAME not
%            found
%
%   Requirement:
%      NetCDF interface for Matlab
%
%   Example:
%      out = n_vardimexist('file.nc','temp','eta_rho')
%
%   MMA 7-2-2005, martinho@fis.ua.pt
%
%   See also N_VARDIM, N_FILEDIM, N_FILEDIMEXIST

%   Department of Physics
%   University of Aveiro, Portugal


fprintf(1,'\n:: %s is DEPRECATED, use %s instead\n',mfilename,'n_dimexist');

out=[];

if nargin < 3
  disp('# arguments required...');
  return
end

dims = n_vardim(file,varname);

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
