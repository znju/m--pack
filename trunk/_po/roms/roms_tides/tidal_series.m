function y=tidal_series(ts,i,j,ndays)
%TIDAL_SERIES   Generate series from tidal amp and pha
%   From a ROMS tidal forcing file returns a time series using
%   amplitude (tide_Eamp) and phase (tide_Ephase).
%   Can also use a T_TIDE tidestruc instead of a forcing file.
%
%   Syntax:
%      Y = TIME_SERIES(FILE,XI,ETA,NDAYS)
%      Y = TIME_SERIES(TS,NDAYS)
%
%   Inputs:
%      FILE    ROMS tidal forcing file
%      TS      T_TIDE tidestruc
%      XI,ETA  Index xi_rho and eta_rho from the file
%      NDAYS   Number of days [10]
%
%   Output:
%      Y   Reconstructed data, a*cos(wt-pha)
%
%   Example:
%      y=tidal_series('tidal_frc.nc',10,20);
%      ts=t_tide(...);
%      tidal_series(ts)
%
%   MMA 26-12-2007, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

isTS=0;

if nargin==2
  ndays=i;
end

if nargin <=2
  isTS=1;
end

if (isTS & nargin<2) | (~isTS & nargin<4)
  ndias=10;
end

t=[0:ndays*24];

if isTS
  % plotar t_tide tidestruc:
  freq=ts.freq;
  amp=ts.tidecon(:,1);
  pha=ts.tidecon(:,3);
else
  fname=ts;
  amp=use(fname,'tide_Eamp','xi_rho',i,'eta_rho',j);
  pha=use(fname,'tide_Ephase','xi_rho',i,'eta_rho',j);
  freq=1./use(fname,'tide_period');
end

y=0*t;
for i=1:length(freq)
  y=y+ amp(i)*cos(2*pi*freq(i)*t  -pha(i)*pi/180);
end
