function tidestruc = t0_t_tide(tidestruc,xout,interval,disp);
%T0_T_TIDE   Adjust T_TIDE output to beginning of series
%   Displaces phase in tidestruc to the beginning of the series.
%   Created to correct phases from t_tide output which are for the
%   centre of the series if no start_time is specified.
%
%   Syntax:
%      TIDESTRUC = T0_T_TIDE(TIDESTRUC,XOUT,INTERVAL,DISPLAY)
%
%   Inputs:
%      TIDESTRUC   T_TIDE output (TIDESTRUC)
%      XOUT        T_TIDE output (XOUT) or length(XOUT)
%      INTERVAL    Original interval of analysed series (hours) [ 1 ]
%      DISPLAY     Show results [ {0} | 1 ]
%
%   Outputs:
%      TIDESTRUC   Corrected TIDESTRUC
%
%   Comment:
%      Works with the two types of TIDESTRUC (real or imaginary
%      analysis), changing the variable pha.
%      T_TIDE is a Rich Pawlowicz's Matlab toolbox available at
%      http://www2.ocgy.ubc.ca/~rich/
%
%   MMA 8-6-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 3
  interval=1; % 1 hour default
end
if nargin < 4
  disp=0;
end

FREQ=tidestruc.freq;
PHA=tidestruc.tidecon(:,end-1); %both for series or ellipses!

%---------------------------------------------------------------------
% Displacement of phase to beginning of series:
%---------------------------------------------------------------------
Lx=length(xout); %always even; last value is not used by t_tide if serie is odd!
if Lx == 1, Lx=xout; end
t=0:Lx-1;
t=t*interval;
center=round(Lx/2); % if using x instead of xout, this works for odd serie also!
delta_t=t(center);
D_pha=mod(2*pi*delta_t*FREQ,2*pi); % phase diff  between t=0 and center of serie
PHA_0=mod(PHA+D_pha*180/pi,360); % phase t=0.

% output:
tidestruc.tidecon(:,end-1)=PHA_0;

%---------------------------------------------------------------------
% Display:
%---------------------------------------------------------------------
if disp
  fprintf(1,'\n------------------------------------------------------\n');
  fprintf(1,'tidestruc with phases displaced to beginning of series:\n');
  fprintf(1,'------------------------------------------------------\n');
  displ(tidestruc)
end


%---------------------------------------------------------------------
function displ(tidestruc)
freq=tidestruc.freq;
name=tidestruc.name;
if size(tidestruc.tidecon,2) == 4
  amp=tidestruc.tidecon(:,1);
  eamp=tidestruc.tidecon(:,2);
  pha=tidestruc.tidecon(:,3);
  epha=tidestruc.tidecon(:,4);
  snr=(amp./eamp).^2;
  fprintf(1,'tide   freq       amp     amp_err    pha    pha_err     snr\n');
  for i=1:length(freq)
    fprintf(1,' %s %9.7f %9.4f %8.3f %8.2f %8.2f %8.2g\n',name(i,:), freq(i), amp(i), eamp(i), pha(i), epha(i), snr(i));
  end
else
  major=tidestruc.tidecon(:,1);
  emajor=tidestruc.tidecon(:,2);
  minor=tidestruc.tidecon(:,3);
  eminor=tidestruc.tidecon(:,4);
  inc=tidestruc.tidecon(:,5);
  einc=tidestruc.tidecon(:,6);
  phase=tidestruc.tidecon(:,7);
  ephase=tidestruc.tidecon(:,8);
  snr=(major./emajor).^2;
  for i=1:length(freq);
    fprintf(1,' %s %9.7f %6.3f %7.3f %7.3f %6.2f %8.2f %6.2f %8.2f %6.2f %6.2g\n',...
      name(i,:), freq(i), major(i), emajor(i), minor(i), eminor(i), inc(i), einc(i), phase(i), ephase(i), snr(i));
  end
end
