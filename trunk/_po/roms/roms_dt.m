function [dt,ndays,l]=roms_dt(file,tunits,tvar)
%ROMS_DT   Get time info from ROMS output file
%
%   Syntax:
%      [DT,NDAYS,L] = ROMS_DT(FILE,TUNITS,TVAR)
%
%   Inputs:
%      FILE     ROMS output file
%      TUNITS   Time units: 'd','h','m','s',
%               for days, hours, minutes or seconds,
%               or value by which dt will be divided,
%               for instance, in case of 's', the value is 1  [ 1 ]
%     TVAR      Time variable [ 'ocean_time' ]
%
%   Outputs:
%      DT      Time interval between records or NetCDF variable 'dt'
%              if length of records < 2
%      NDAYS   Data length in days
%      L       Number of records
%
%   MMA 16-7-2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   26-11-2004 - Corrected

if nargin < 3
  tvar='ocean_time';
end

nc=netcdf(file);
l = length(nc{tvar});
ndays = nc{tvar}(end) - nc{tvar}(1);

% check  tvar length:
if l > 1
  dt = nc{tvar}(2) - nc{tvar}(1);
else
  % get info from netcdf dt:
  dt = nc{'dt'}(:);
end
nc=close(nc);

% convert dt required units:
if nargin < 2
  tunits = 1; % output in sec by default
end
if isstr(tunits)
  switch tunits
    case 'd', tunits = 60*60*24;
    case 'h', tunits = 60*60;
    case 'm', tunits = 60;
    case 's', tunits = 1;
  end
end
dt    = dt/tunits;

% convert ndays to days:
ndays = ndays/86400;
