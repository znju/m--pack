function [X,Y,Z,V,Ze]=occam_slicell(fname,vname,X,Y,NaN2zero)
%OCCAN_SLICELL   Make OCCAM slice along any path
%
%   Syntax:
%      [X,Y,Z,V,ZE]  = OCCAM_SLICELL(FILE,VARNAME,LON,LAT,NAN2Z)
%
%   Inputs:
%      FILE   OCCAM output file
%      VARNAME   Variable to extract (array with dimension >= 2)
%      LON       Longitude vector; If length is 3, lon will be
%                linspace(LON(1),LON(2),LON(3)
%      LAT       Latitude vector, linspace is also used if length is 3
%      NAN2Z     Flag to convert NaNs to zero, default=0
%
%   Outputs:
%     X,Y   Same as LON, LAT, but with size of extracted variable
%     Z     Depth
%     V   Variable at slice
%
%   Examples:
%     file='jan.nc';
%     varname='POTENTIAL_TEMPERATURE__MEAN_';
%     lon=[-10 10 100]; % same as lon=linspace(-10,10,200);
%     lat=[ 40 55 100]; % same as lat=linspace(40 55 100);
%     [x,y,z,v] = occam_slicell(file,varname,lon,lat)
%
%     varname='hr';        % 2-d array
%     [x,y,z,v] = pom_slicell(file,varname,lon,lat)  % z is empty
%
%   MMA 16-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin < 5
  NaN2zero=0;
end

if length(X)==3, X=linspace(X(1),X(2),X(3)); else X=X(:)'; end
if length(Y)==3, Y=linspace(Y(1),Y(2),Y(3)); else Y=Y(:)'; end

Z=[];
Ze=[];
V=[];

X=X(:)';
Y=Y(:)';

[lonr,latr,hr,mr,Mr]=occam_grid(fname,'r');
[lonu,latu,hu,mu,Mu]=occam_grid(fname,'uv');

if isequal(vname,'hr')
  v=hr;
elseif isequal(vname,'hu')
  v=hu;
else
  v = use(fname,vname);
end
is3d=ndims(v)==3;
n=n_filedim(fname,'DEPTH');
if ~is3d
 n=1;
end

UVvars = {'U_WIND_STRESS__MEAN_', 'V_WIND_STRESS__MEAN_','U_VELOCITY__MEAN_','V_VELOCITY__MEAN_'};
if ismember(vname,UVvars)
  x=lonu;
  y=latu;
  h=hu;
  m=mu;
  M=Mu;
else
  x=lonr;
  y=latr;
  h=hr;
  m=mr;
  M=Mr;
end
x(x>180)=x(x>180)-360;
X(X>180)=X(X>180)-360;

if ~NaN2zero
  if is3d
    v(M==0)=nan;  % needed when there are points between sea and land!!
  else
  v(m==0)=nan;
  end
end

for l=1:length(X)
  xx=X(l); yy=Y(l);
  [i,j]=find_nearest(x,y,xx,yy); i=i(1); j=j(1);

  j0=j;
  if xx<x(i,j),  j=j-1; end
  if yy<y(i,j0), i=i-1; end

  if i==0 | j==0 | i+1>size(x,1) | j+1>size(x,2)
    if ~NaN2zero
      vv=repmat(nan,n,1);
      zz=repmat(nan,n,1);
    else
      vv=repmat(0,n,1);
      zz=repmat(0,n,1);
    end
  else
    xb=[x(i,j) x(i,j+1) x(i+1,j+1) x(i+1,j)];
    yb=[y(i,j) y(i,j+1) y(i+1,j+1) y(i+1,j)];

    if is3d
      vb=[v(:,i,j) v(:,i,j+1) v(:,i+1,j+1) v(:,i+1,j)];
    else
      vb=[v(  i,j) v(  i,j+1) v(  i+1,j+1) v(  i+1,j)];
    end

    a=(xx-xb(1))/(xb(2)-xb(1)); aa=1-a;
    b=(yy-yb(1))/(yb(4)-yb(1)); bb=1-b;

    if is3d
      vv=a*b*vb(:,3) +aa*b*vb(:,4) + aa*bb*vb(:,1) + a*bb*vb(:,2);
    else
      vv=a*b*vb(3) +aa*b*vb(4) + aa*bb*vb(1) + a*bb*vb(2);
    end

  end
  V(:,l)=vv;
end
if is3d
  X=repmat(X,n,1);
  Y=repmat(Y,n,1);

  Z=use(fname,'DEPTH')*0.01;
  Z=repmat(Z,1,size(X,2));

  Ze=use(fname,'DEPTH_EDGES')*0.01;
  Ze=repmat(Ze,1,size(X,2));
end

if nargout==1
  X=V;
end
