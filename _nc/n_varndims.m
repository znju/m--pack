function d = n_varndims(file,varname)
%N_VARNDIMS   Get ndims of NetCDF variable
%   Only dimensions with more than one element are taken into account
%
%   Syntax:
%      D = N_VARNDIMS(FILE,VARNAME)
%
%   Inputs:
%      FILE      NetCDF file
%      VARNAME   Variable
%
%   Output:
%      D   the dimension; -1 if variable is empty; 1 if vector; ...
%          [] if variable do not exist or if there is an error in
%          file
%
%   Requirement:
%      NetCDF interface for Matlab
%
%   Comment:
%      A variable with size = 0 10 10 returns dimension = -1
%
%   Examples:
%      out = n_varndims('filename.nc','lon')
%
%   MMA 7-6-2004, mma@odyle.net
%
%   See also N_VARSIZE


d  = [];

s = n_varsize(file,varname);

if isempty(s)
  return
end

if all(s==1)
  d=0;
end

if any(s==0)
  d=-1;
else
  d=length(find(s>1));
end
