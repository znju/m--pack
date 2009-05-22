function [X,Y,Z,V] = pom_slicell(fname,varname,X,Y,time)
%POM_SLICELL   Make POM slice along any path
%
%   Syntax:
%      [X,Y,Z,V]  = POM_SLICELL(FILE,VARNAME,LON,LAT,T)
%      [DIST,Z,V] = POM_SLICELL(FILE,VARNAME,LON,LAT,T)
%
%   Inputs:
%      FILE   POM output file
%      VARNAME   Variable to extract (array with dimension >= 2)
%      LON       Longitude vector; If length is 3, lon will be
%                linspace(LON(1),LON(2),LON(3)
%      LAT       Latitude vector, linspace is also used if length is 3
%      T         Time indice (1 by default)
%
%   Outputs:
%     X,Y   Same as LON, LAT, but with size of extracted variable
%     Z     Depth (at zz or z points)
%     DIST  Distance (m)
%     V   Variable at slice
%
%   Examples:
%     file='pom.nc.0010';
%     varname='temp;      % 3-d [or 4-d] array, I [and T] are required
%     lon=[-10 10 100]; % same as lon=linspace(-10,10,100)
%     lat=[ 40 55 100]; % same as lat=linspace(40 55 100)
%     [x,y,z,v] = pom_slicell(file,varname,lon,lat)
%     % or
%     [dist,z,v] = pom_slicell(file,varname,lon,lat)
%
%     varname='h';        % 2-d array
%     [x,y,z,v] = pom_slicell(file,varname,lon,lat)  % z is empty
%     % or
%     [dist,z,v] = pom_slicell(file,varname,lon,lat) % z is empty
%
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   01-07-2008

if nargin <5
  time=1;
end

if length(X)==3, X=linspace(X(1),X(2),X(3)); else X=X(:)'; end
if length(Y)==3, Y=linspace(Y(1),Y(2),Y(3)); else Y=Y(:)'; end
dst=spheric_dist(Y(2:end),Y(1:end-1),X(2:end),X(1:end-1));
dst=[0; cumsum(dst(:))];

x=[];
y=[];
z=[];
v=[];

Uvars={'u','wvsurf','uab'};
Vvars={'v','wvsurf','vab'};
Wvars={'w'};

if ismember(varname,Uvars)
  [x,y,h,m]=pom_grid(fname,'u');
elseif ismember(varname,Vvars)
  [x,y,h,m]=pom_grid(fname,'v');
else
  [x,y,h,m]=pom_grid(fname,'r');
end

T   = n_dim(fname,'time');
S   = n_dim(fname,'z');
if ~ismember(varname,Wvars), S=S-1; end

if time > T | time <=0
  fprintf(1,'» time = %g exceeds time dimension (%g)\n',time,T);
  return
end

v=use(fname,varname,'time',time);
v(v==0)=nan;

is3d=ndims(v)==3;

if is3d
  n=S;
  % calc s-levels:
  z   = use(fname,'z');
  zz  = use(fname,'zz');
  ssh = use(fname,'elb','time',time);
  [zr,zw]=pom_s_levels(zz,z,h,ssh,1);
  if ismember(varname,Wvars)
    z=zw;
  else
    z=zr;
    v=v(1:end-1,:,:);
  end
  z=permute(squeeze(z),[3 1 2]);
else
  n=1;
end

V=[];
Z=[];

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
V=flipud(V);

if nargout==3
  dst=repmat(dst(:)',[n 1]);
  X=dst;
  Y=Z;
  Z=V;
end
