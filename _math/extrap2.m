function v = extrap2(x,y,v,mask,ijrate)
%EXTRAP2   Extrapolation 2-D
%   Uses the nearest points along lines and columns.
%
%   Syntax:
%      VI = EXTRAP2(X,Y,V,MASK,IJRATE)
%
%   Inputs:
%      X,Y,V   Positions of data 2-D array V
%      MASK    Mask value, where data will be extrapolated
%      IJRATE  Weight of the rows and columns, 2 values between 0 and
%              1, ie, [1 0] would use only direction i, default=[1 1]
%
%   Output:
%       VI   V extrapolated in MASK points
%
%
%   Example:
%      figure;
%      [x,y,z]=peaks(50);
%      z(30:35,:)=nan;
%      zi=extrap2(x,y,z,nan);
%
%      figure, pcolor(x,y,z)
%      figure, pcolor(x,y,zi)
%
%   MMA 28-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin < 5
  ijrate=[1 1];
end

prevMask=mask;
if isnan(mask)
  mask=-99;
  v(isnan(v))=mask;
end

[v,masked]=extrap_once(x,y,v,mask,ijrate);
if masked
  [v,masked]=extrap_once(x,y,v,mask,ijrate);
end

% if all is mask it will still be, so put back original mask:
v(v==mask)=prevMask;

function [v,masked] = extrap_once(x,y,v,mask,ijrate)
[L,M]=size(x);

A=v;
B=v;
C=v;
D=v;

for i=1:L
  for j=1:M
    if A(i,j)==mask
      A(i,j)=extrap_aux(x,y,A,mask,i,j,ijrate);
    end
  end
end

for i=L:-1:1
  for j=1:M
    if B(i,j)==mask
      B(i,j)=extrap_aux(x,y,B,mask,i,j,ijrate);
    end
  end
end

for i=1:L
  for j=M:-1:1
    if C(i,j)==mask
      C(i,j)=extrap_aux(x,y,C,mask,i,j,ijrate);
    end
  end
end

for i=L:-1:1
  for j=M:-1:1
    if D(i,j)==mask
      D(i,j)=extrap_aux(x,y,D,mask,i,j,ijrate);
    end
  end
end

masked=0;
v=(A+B+C+D)/4.;
ismask=(A==mask | B==mask | C==mask | D==mask);
v(ismask)=mask;
masked=any(v(:)==mask);


function out=extrap_aux(x,y,v,mask,i0,j0,ijrate)
[L,M]=size(x);
d=zeros(1,4);
u=zeros(1,4);

% find d,u 1 and 3 (left, right)
j=j0-1;
while j>=1
  if v(i0,j)~=mask
    u(1)=v(i0,j);
    d(1)=1./sqrt((x(i0,j0)-x(i0,j))^2 + (y(i0,j0)-y(i0,j))^2 );
    j=1;
  end
  j=j-1;
end

j=j0+1;
while j<=M
  if v(i0,j)~=mask
    u(3)=v(i0,j);
    d(3)=1./sqrt((x(i0,j0)-x(i0,j))^2 + (y(i0,j0)-y(i0,j))^2 );
    j=M;
  end
  j=j+1;
end

% find d,u 2 and 4 (top, bottom)
i=i0-1;
while i>=1
  if v(i,j0)~=mask
    u(2)=v(i,j0);
    d(2)=1./sqrt((x(i0,j0)-x(i,j0))^2 + (y(i0,j0)-y(i,j0))^2 );
    i=1;
  end
  i=i-1;
end

i=i0+1;
while i<=L
  if v(i,j0)~=mask
    u(4)=v(i,j0);
    d(4)=1./sqrt((x(i0,j0)-x(i,j0))^2 + (y(i0,j0)-y(i,j0))^2 );
    i=L;
  end
  i=i+1;
end

if sum(d)~=0
  rx=ijrate(1);
  ry=ijrate(2);
  d=d.*[rx ry rx ry];
  out=sum(u.*d)/sum(d);
else
  out=v(i0,j0);
end
