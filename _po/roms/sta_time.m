function [interval,ndias] = sta_time(sta)
%STA_TIME   Get interval and length of ROMS output stations
%
%   Syntax:
%      [INTERVAL,NDAYS]=STA_TIME(STA)
%
%   Inputs:
%      STA   ROMS sta output file
%
%   Outputs:
%      INTERVAL   Interval between data in hours
%      NDAYS      Duration in days
%
%   Comment:
%      DEPRECATED, use ROMS_DT instead
%
%   MMA 29-9-2002, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

dt       = use(sta,'dt');
nsta     = use(sta,'nsta');
interval = dt*nsta/3600; % horas.
ot       = use(sta,'ocean_time');
ndias    = ot(end)/86400;
