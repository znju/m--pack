function [X,Y,Z,V]=vertical_slice(f,varname,t,X,Y)
%VERTICAL_SLICE   ROMS vertical slice along any path
%   Allows the extraction of vertical slices in ROMS variables
%   following any chosen xy path. This path can be easily
%   created with VERTICAL_SLICE_AUX.
%
%   Syntax:
%      [X,Y,Z,V] = VERTICAL_SLICE(F,VAR,T,X,Y)
%
%  Inputs:
%     F     Roms input/output file
%     VAR   Variable name to slice
%     T     Time index
%     X,Y   Horizontal path, vectors
%
%   Output:
%      X,Y,Z,V, 2D matrices if variable VAR has vertical component,
%               1D and empty Z otherwise
%
%   Examples:
%      f='roms_his.nc';
%      vn='salt';
%      t=10;
%      xp=-10:.1:0;
%      yp=40+0*x;
%      [x,y,z,v]=vertical_slice_aux(f,vn,t,xp,yp);
%
%   MMA 23-3-2007, martinho@fis.ua.pt
%
%   See also VERTICAL_SLICE_AUX, ROMS_SLICE

% Department of Physics
% University of Aveiro, Portugal

% 29-10-2007 - Added v(v==0)=nan;

[x,y,h]=roms_grid(f);
v = use(f,varname,'time',t);
v(v==0)=nan; % needed when there are points between sea and land!! 29-Oct-2007

is3d=ndims(v)==3;

if is3d
  zeta = use(f,'zeta','time',t);
  [tts,ttb,hc,n]=s_params(f);
  [z_r,z_w]=s_levels(h,tts,ttb,hc,n,zeta);
  isRho=n_vardimexist(f,varname,'s_rho');
  if isRho
    z=permute(z_r,[3,1,2]);
  else
    z=permute(z_w,[3,1,2]);
    n=n+1;
  end
else
  n=1;
end

V = [];
Z = [];

for l=1:length(X)
  xx=X(l); yy=Y(l);
  [i,j]=find_nearest(x,y,xx,yy); i=i(1); j=j(1);

  j0=j;
  if xx<x(i,j),  j=j-1; end
  if yy<y(i,j0), i=i-1; end


  if i==0 | j==0 | i+1>size(x,1) | j+1>size(x,2)
    vv=repmat(nan,n,1);
    zz=repmat(nan,n,1);
  else
    xb=[x(i,j) x(i,j+1) x(i+1,j+1) x(i+1,j)];
    yb=[y(i,j) y(i,j+1) y(i+1,j+1) y(i+1,j)];

    if is3d
      vb=[v(:,i,j) v(:,i,j+1) v(:,i+1,j+1) v(:,i+1,j)];
      zb=[z(:,i,j) z(:,i,j+1) z(:,i+1,j+1) z(:,i+1,j)];
    else
      vb=[v(  i,j) v(  i,j+1) v(  i+1,j+1) v(  i+1,j)];
    end

    a=(xx-xb(1))/(xb(2)-xb(1)); aa=1-a;
    b=(yy-yb(1))/(yb(4)-yb(1)); bb=1-b;

    if is3d
      vv=a*b*vb(:,3) +aa*b*vb(:,4) + aa*bb*vb(:,1) + a*bb*vb(:,2);
      zz=a*b*zb(:,3) +aa*b*zb(:,4) + aa*bb*zb(:,1) + a*bb*zb(:,2);
    else
      vv=a*b*vb(3) +aa*b*vb(4) + aa*bb*vb(1) + a*bb*vb(2);
    end

  end

  V(:,l)=vv;
  if is3d
    Z(:,l)=zz;
  end
end
if is3d
  X=repmat(X,n,1);
  Y=repmat(Y,n,1);
end
