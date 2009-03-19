function name = freq2name(freq,display)
%FREQ2NAME   Convert tidal frequency to name
%   This functions searches in the t_tide file t_constituents.mat
%   the tidal constituent name with frequency closer to given one.
%
%   Syntax:
%      NAME = FREQ2NAME(FREQ,DISPLAY)
%
%   Inputs:
%      FREQ      Tidal component approximated frequency
%      DIAPLAY   Show results [ {0} | 1 ]
%
%   Output:
%      NAME   Tidal component name
%
%   Comment:
%      T_tide file t_constituints.mat must be in path.
%      T_tide is a Rich Pawlowicz's Matlab toolbox available at
%      http://www2.ocgy.ubc.ca/~rich/
%
%   Example:
%      freq2name(1/12,1)
%
%   MMA 18-2-2003, martinho@fis.ua.pt
%
%   See also NAME2FREQ

%   Department of Physics
%   University of Aveiro, Portugal

if nargin == 1
 display=0;
end

if exist('t_constituents.mat') ~= 2
  disp(':: t_constituents.mat not found (can be found in t_tide package');
  name = [];
  return
else
  load t_constituents
end

NAME=const.name;
FREQ=const.freq;

dist=(freq-FREQ).^2;
[d,i]=min(dist);
name=NAME(i,:);

if display
  disp(['# name of freq ',sprintf('%13.10f',freq),'  is  ',name]);
end
