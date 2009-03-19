function handle = pcplot(x,y,C,r,ec)
%PCPLOT   Pcolor plot
%   Draws circles as pstches
%
%   Syntax:
%      H = PCPLOT(X,Y,C,R,EC)
%
%   Inputs:
%      X,Y   Corrdinates
%      C     Color data, default=y
%      R     Circles radius [rx ry], default=[dx/3 dx/3]
%      Ec    Edge color, default='none'
%
%   Output:
%      H   Patch handle
%
%   Example:
%      figure
%      x=1:.1:10;
%      y=sin(x);
%      h=pcplot(x,y); colorbar
%
%   MMA 13-10-2006, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

if nargin <5
  ec='none';
end
if nargin <4
  r=diff(x)/3;r=r(1:2);
end
if nargin <3
  C=y;
end

rx=r(1);
ry=r(2);

nt=20;
n=length(x);
t=linspace(0,2*pi,nt);
t=repmat(t,n,1);

x=repmat(x',1,nt);
y=repmat(y',1,nt);
x=x+rx*cos(t);
y=y+ry*sin(t);

x=reshape(x',1,prod(size(x)));
y=reshape(y',1,prod(size(y)));

C = reshape(repmat(reshape(C,1,n),nt,1),nt*n,1);
Faces = reshape(1:nt*n,nt,n)';
Vert(:,1)=x';
Vert(:,2)=y';

handle = patch(Vert(:,1),Vert(:,2),C);
set(handle,'Faces', Faces,'edgecolor',ec);
