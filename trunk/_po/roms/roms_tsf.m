function vf = roms_tsf(t,z,v,varargin)
%ROMS_TSF   Filter ROMS time series
%   Filters the output time series of the ROMS_TS function.
%   It uses PL33TN function (Bob Beadsley).
%
%   Syntax:
%      VF = ROMS_TSF(T,Z,V,VARARGIN)
%
%   Inputs:
%      T   Time in days
%      Z   Depth
%      V   Variable time series/vertical profile
%      VARARGIN:
%         'T',   filter half-amplitude period (h), see PL33TN [ 33 ]
%         'show' {2}01, if 1 the filtered data is plotted, if 2 both
%                the raw and filtered data are plotted
%
%   Output:
%      VF   Filtered variable time series
%
%   Exampes:
%      file    = 'sta.nc';
%      varname = 'temp';
%      station = 123;
%      [t,z,v,x,y] = roms_ts(file,varname,'station',station);
%      vf = roms_tsf(t,z,v,'show',2);
%
%   MMA 6-2-2004, martinho@fis.ua.pt
%
%   See also ROMS_TS

%   Department of Physics
%   University of Aveiro, Portugal

vf = [];

set_show = 1;
T        = 33;

vin = varargin;
for ii=1:length(vin)
  if isequal(vin{ii},'show')
    set_show = vin{ii+1};
  end
  if isequal(vin{ii},'T')
    T = vin{ii+1};
  end
end

if size(t) == 1
  disp('# this is not a timme series...');
  return
end

if ndims(squeeze(v)) ~= 2
  disp('# v is not 1D or 2D array...');
  return
end

% get dt:
dt = (t(2) - t(1)) *24;
% roms_ts gives time in days and pl33tn
% needs time in hours

% apply filter:
if any(size(v) == 1)
  % then is a simple time series, without vertical profile
  vf = pl33tn(v,dt,T);

else
  % then should be a time series of a vertical profile
  % the filter will be done at each supposed s-level
  % the s-level dimension shall be considered the smaller one, which
  % got to be correct, right !!

  d=find(size(v) == min(size(v)));
  for n=1:size(v,d)
    if d==1, vf(n,:) = pl33tn(v(n,:),dt,T);
    else     vf(:,n) = pl33tn(v(:,n),dt,T);
    end
  end

end

% --------------------------------------------------------------------
% plot:
% --------------------------------------------------------------------
if set_show
  %figure
  if any(size(v) == 1)
    plot(t,vf)
    xlabel('time (days)')

    if set_show == 2
      hold on
      plot(t,v,'r');
    end

  else
    [cs,ch] = contour(t,z,vf);
    evalc('clabel(cs);','');
    xlabel('time (days)')
    ylabel('depth')

    if set_show == 2
      hold on
      [cs,ch] = contour(t,z,v);
      clabel(cs)
    end

  end
end
