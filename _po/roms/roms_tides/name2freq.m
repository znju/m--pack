function freq = name2freq(name,display)
%NAME2FREQ   Convert tidal name to frequency
%   This functions searches in the t_tide file t_constituents.mat
%   the tidal frequency for a given tidal constituent name.
%
%   Syntax:
%      FREQ = FREQ2NAME(FREQ,DISPLAY)
%
%   Inputs:
%      NAME      Tidal component name
%      DIAPLAY   Show results [ {0} | 1 ]
%
%   Output:
%      FREQ   Tidal component frequency
%
%   Comment:
%      T_tide file t_constituents.mat must be in path.
%      T_tide is a Rich Pawlowicz's Matlab toolbox available at
%      http://www2.ocgy.ubc.ca/~rich/
%
%   Example:
%      freq=name2freq('M2',1)
%
%   MMA 29-9-2002, martinho@fis.ua.pt
%
%   See also FREQ2NAME

%   Department of Physics
%   University of Aveiro, Portugal
%
%   21-08-2006 - Corrected bug

freq = NaN;

if nargin == 1
    display=0;
end

if exist('t_constituents.mat') ~= 2
  disp(':: t_constituents.mat not found (can be found in t_tide package)');
  freq=NaN;
  return
else
  load t_constituents
end

NAME=const.name;
FREQ=const.freq;

name(end+1:4)=' ';

for i=1:length(FREQ)
  if strcmpi(NAME(i,:),name)
    ii=i;
    break
  end
end

if exist('ii')
  freq=FREQ(ii);
else
  disp([':: tidal name ',name,' not found'])
end

if display
  T = 1/freq;
  disp(['# freq of ',name,' = ',sprintf('%13.10f',freq)]);
  disp(['# T of ',name,' = ',sprintf('%13.10f',T)]);
end
