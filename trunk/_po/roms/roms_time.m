function [t,time,dt]=roms_time(file,year)
%ROMS_TIME   Retrieve time info from ROMS output
%
%   Syntax:
%      [T,TIME,DT] = ROMS_TIME(FILE,YEAR)
%
%   Inputs:
%      FILE
%      YEAR   Needed to calc datenum, default=1
%
%   Outputs:
%      T      Variable scrum_time
%      TIME   Datenum of T
%      DT     T(2)-T(1)
%
%   MMA 20-7-2006, martinho@fis.ua.pt
%
%   See also GREG2

% Department of Physics
% University of Aveiro, Portugal

tname = 'scrum_time';

if nargin < 2
  year=1;
end

nc=netcdf(file);
  time=nc{tname}(:);
close(nc)
dt=time(2)-time(1);

% search for zeros at end!
i=find(time==0);
time(i)=nan;
i(i==1)=[]; % remove 1, if is the case

t=datenum(greg2(time/86400,year));
