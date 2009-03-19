function is=isnc(fname)
%ISNC   True for NetCDF files
%
%   Syntax:
%      IS = ISNC(FILE)
%
%   Inputs:
%      FILE
%
%   Output:
%      IS   1 if FILE is exists and is NetCDF
%
%   MMA 01-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

is=0;
if exist(fname)==2
  try
    nc=netcdf(fname);
    close(nc);
    if ~isempty(nc), is=1; end
  end
end
