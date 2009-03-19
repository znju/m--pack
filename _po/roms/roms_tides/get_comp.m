function [a,ea,p,ep]=get_comp(ts,name)
%GET_COMP   Extract tidal data from tidestruc (T_TIDE)
%   Returns, amp, eamp, phase and ephase for the desired component
%   from the T_TIDE output. In case of ellipses, returns fmaj, fmin,
%   finc and pha.
%
%   Syntax:
%      [A,EA,P,EP] = GET_COMP(TS,NAME)
%
%   Inputs:
%     TS    T_TIDE tidestruc
%     NAME  Tidal component, ex: 'M2'
%
%   Examples:
%      ts=t_tide(...)
%      [amp,eamp,pha,epha]   = get_comp(ts,'M2')
%      [fmaj, fmin,finc,pha] = get_comp(ts,'M2')
%
%   MMA 4-4-2007, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

a  = nan;
ea = nan;
p  = nan;
ep = nan;

I=[];
for i=1:size(ts.name,1)
  if all(lower(ts.name(i,1:length(name)))==lower(name))
    I=i;
    break
  end
end

if isempty(I)
  disp(['## not found ',name]);
  return
else
%  disp(['## found ',ts.name(I,:)])
end

if size(ts.tidecon,2)==4
  a  = ts.tidecon(I,1);
  ea = ts.tidecon(I,2);
  p  = ts.tidecon(I,3);
  ep = ts.tidecon(I,4);
else
  a  = ts.tidecon(I,1); % major, etc
  ea = ts.tidecon(I,3);
  p  = ts.tidecon(I,5);
  ep = ts.tidecon(I,7);
end
