function [R,z1,z2,ze]=iso_interval(z,v,s,ze)
%ISO_INTERVAL   Pecentage of cells between two values (1d)
%   Returns the interpolation points for the two values and the
%   weights vector with the percentage of each cell inside the
%   interval bounded by the two values
%
%   Syntax:
%     [R,Z1,Z2,ZE] = ISO_INTERVAL(Z,V,S,ZE)
%
%   Inputs:
%      Z,V, Z are the points where Z is defined
%      S  Two iso values of V
%      ZE Bound points, considering Z at the centre of the cells
%         (not required, may be built)
%
%   Outputs:
%      R   Weights vector with the percentage of each cell inside the
%          interval defined by S
%      Z1,Z2   Points of Z where V== S(1) and S(2)
%      ZE   Bound points, same as input
%
%   Comment:
%      V may have NaNs at the start and end of the vector.
%      V must be monotonic
%
%   Example:
%     z= 0:10:100;
%     v=0:10:100;
%     x=z*0+1;
%     s=[91 98];
%
%     [R,z1,z2,ze]=iso_interval(z,v,s);
%
%     figure
%     plot(x,z,'b+'); hold on
%     plot([x(1); x(:)],ze,'r+')
%     for i=1:length(v)
%       text(x(i),z(i),num2str(v(i)))
%     end
%     plot(x(1),z1,'r*');
%     plot(x(1),z2,'r*');
%
%   See also ISO_ZLAYER
%
%   Martinho MA, 08-03-2009, mma@odyle.net
%   CESAM, Portugal

R=0*v;
z1=nan;
z2=nan;

% deal with nans, extrap:
is=isnan(v);
if any(is)
  if all(is)
    return
  else
    % error if only one not nan, so:
    if length(find(~isnan(v)))==1
      v(isnan(v))=v(~isnan(v));
    else
      v(is)=interp1(z(~is),v(~is),z(is),'linear','extrap');
    end
  end
end

% if not provided, build edge points
if nargin <4
  ze=zeros(1,length(z)+1);
  ze(2:end-1)=(z(2:end)+z(1:end-1))/2;
  ze(1)=ze(2)-(ze(3)-ze(2));
  ze(end)=ze(end-1)+(ze(end-1)-ze(end-2));
end

% vars (ye) used to set z1 and z2 inside bounds of non nans:
if any(is)
  i=find(~is);
  ye=ze(i(1):i(end)+1);
end

% check if grad v has same sign of grad s:
if (v(2)>v(1) && s(1)>s(2)) || (v(2)<v(1) && s(2)>s(1))
  s=[s(2) s(1)];
end

% extrap to edge points:
V=interp1(z,v,ze,'linear','extrap');

% calc depths and levels:
if s(1)>V(end)
  k1=length(v)+1;
  z1=ze(end);
  r1=1;
elseif s(1)<V(1)
  k1=1 +1;
  z1=ze(1);
  r1=1;
else
  z1=interp_mp(V,ze,s(1));
  k1=find(ze>z1); k1=k1(1);
  r1=(ze(k1)-z1)/(ze(k1)-ze(k1-1));
end

if s(2)>V(end)
  k2=length(v)+1;
  z2=ze(end);
  r2=1;
elseif s(2)<V(1)
  k2=1+1;
  z2=ze(1);
  r2=1;
else
  z2=interp_mp(V,ze,s(2));
  k2=find(ze>=z2); k2=k2(1);
  r2=1-(ze(k2)-z2)/(ze(k2)-ze(k2-1));
end

% deal with special case of same cell:
% include the case of s outside v extremes!
if k2==k1
  if all(s>max(V)) || all(s<min(V))
    r1=0;
    r2=0;
    z1=nan;
    z2=nan;
  else
    tmp=r2-(1-r1);
    r1=tmp;
    r2=tmp;
  end
end

% build R vector:
R(k1-1:k2-1)=1;
R(k1-1)=r1;
R(k2-1)=r2;
R(is)=nan;

% set z1 and z2 inside non nan bounds of ze, ie, ye (ze without nans):
if any(is)
  if ~isnan(z1)
    z1=min(z1,max(ye)); 
    z1=max(z1,min(ye));
  end
  if ~isnan(z2)
    z2=min(z2,max(ye));
    z2=max(z2,min(ye));
  end
end
