function [C,I] = nan_count(M)
%NAN_COUNT   Count NaNs
%
%   Syntaax:
%      [C,I] = NAN_COUNT(M)
%
%   Input:
%      M   N-D array
%
%   Outputs:
%      C   Number of NaNs
%      I   Position of NaNs
%
%   Example:
%      x=1:10;
%      y=1:10;
%      [x,y]=meshgrid(x,y);
%      figure,plot(x,y,'b*'); hold on
%      z=ones(10,10);
%      z(3:end,4:end)=nan;
%      [C,I]=nan_count(z);
%      plot(x(I),y(I),'ro'), axis([1 10 1 10]);
%
%   MMA,  6-8-2002
%
%   See also ZERO2NAN, NAN2ZERO

%   Department of Physics
%   University of Aveiro, Portugal

I=isnan(M);
C=length(M(I));
