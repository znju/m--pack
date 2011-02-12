function [R,Z1,Z2] = iso_zlayer(z3d,zedges3d,D_,s,mask,quiet)
%ISO_ZLAYER   Pecentage of cells between two values (3d)
%   Return weights array with the percentage of each cell inside an
%   interval bounded by the two values
%
%   Syntax:
%      [R,Z1,Z2] = ISO_ZLAYER(Z3d,ZE3d,D,S,MASK,QUIET)
%
%   Inputs:
%      Z3D   Where points are definned
%      ZE3D  Bound points ("vertical" edges of Z3D)
%      D   Values
%      S   Two iso values of V
%      MASK   mask of D (may be 2D, ie, horizontal mask)
%      QUIET  Loop info is shown if 0 or 2 (default is 1)
%
%   Outputs:
%      R Weights array with the percentage of each D cell inside the
%        interval defined by S
%      Z1,Z2   Points of Z3D where V== S(1) and S(2). If S(1) or S(2)
%              are outside the values of V(:,i,j) then Z1 and Z2
%              become the bound points (excluding possible NaNs at
%              start and end of V(:,i,j)
%
%   Comment:
%      The dimension of Z3D, and D must be N,J,I, where JxI are the
%      "horizontal" dimentions and N is the vertical one.
%      The dimension of ZE3D must be N+1,I,J
%      V(:,i,j) must be monotonic
%
%   See also ISO_INTERVAL
%
%   Martinho MA, 08-03-2009, mma@odyle.net
%   CESAM, Portugal

[n,eta,xi]=size(D_);

if nargin <5
  mask=ones(size(D_));
end
if nargin <5
  quiet==1;
end

% gen output vars:
R  = zeros(size(D_));
Z1 = nan*zeros(eta,xi);
Z2 = nan*zeros(eta,xi);

% deal with 2 or 3d mask
if ndims(mask)==2
  mask=shiftdim(repmat(mask,[1 1 n]),2);
end

% apply mask at field:
D_(mask==0)=nan;

for j=1:eta;
  if quiet==2 && mod(j,10)==0 || j==eta
    fprintf('- %3d of %d\n',j,eta);
  end

  Z  = squeeze(z3d(:,j,:));
  zz = squeeze(zedges3d(:,j,:));
  D  = squeeze(D_(:,j,:));

  for i=1:xi
    if mask(1,j,i) % is, not masked at level 1 !
      if quiet==0, fprintf('- %3d -  processing ind %3d of %d',j,i,xi); end
      z  = Z(:,i);
      ze = zz(:,i);
      v  = D(:,i);
      [rr,z1,z2,ze]=iso_interval(z,v,s,ze);
      Z1(j,i)=z1;
      Z2(j,i)=z2;
    else
      rr=nan*zeros(1,n);
    end % mask
  R(:,j,i)=rr;
  end %xi
end % eta
