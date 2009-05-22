function  out = n_varsize(file,varname)
%N_VARSIZE   Get size of a NetCDF variable or range
%
%   Syntax:
%      OUT = N_VARSIZE(FILE,VARNAME)
%
%   Inputs:
%      FILE      NetCDF file
%      VARNAME   Variable
%
%   Output:
%      OUT   The size, or [] if variable do not exist or if there is
%            an error in file
%
%   Requirement:
%      NetCDF interface for Matlab when not using RANGE
%
%   Examples:
%      out = n_varsize('file.nc','lon')
%
%   MMA 7-6-2004, mma@odyle.net
%
%   See also N_VARATT, N_VARDIMS

if n_varexist(file,varname)
  ncquiet;
  nc=netcdf(file);
  out = size(nc{varname});
  close(nc);
else
  disp(['# variable ',varname,' not found']);
  out=[];
end
