function [X,Y,Z,V,mask] = roms_slicell(fname,varname,X,Y,time,varargin)
%ROMS_SLICE   Make ROMS slice along any path
%
%   Syntax:
%      [X,Y,Z,V,M] = ROMS_SLICELL(FILE,VARNAME,LON,LAT,T)
%      [DIST,Z,V] = ROMS_SLICELL(FILE,VARNAME,LON,LAT,T)
%
%   Inputs:
%      FILE   ROMS output file (may be the cell {File,Grid})
%      VARNAME   Variable to extract (array with dimension >= 2)
%      LON       Longitude vector; If length is 3, lon will be
%                linspace(LON(1),LON(2),LON(3)
%      LAT       Latitude vector, linspace is also used if length is 3
%      T         Time indice (1 by default)
%      VARARGIN:
%         'theta_s', s-levels theta_s
%         'theta_b', s-levels theta_b
%         'hc', s-levels hc
%         'grid', grid filename
%         'plt', plot output flag, if 3 the 3d surf ouput will be shown
%           otherwise pcolor will be used. If output is 1d is shown
%           a plot for any plt~=0
%         'ax', axes where data will be displayed if plt
%         'gd', interpolate with griddata (true). Better results with
%               curvilinear grids, but slow.
%
%   Outputs:
%     X,Y   Same as LON, LAT, but with size of extracted variable
%     Z     Depth
%     DIST  Distance (m)
%     V     Variable at slice
%     M     Mask
%
%   Examples:
%     file='roms_his.nc';
%     varname='temp;      % 3-d [or 4-d] array, I [and T] are required
%     lon=[-10 10 100]; % same as lon=linspace(-10,10,100)
%     lat=[ 40 55 100]; % same as lat=linspace(40 55 100)
%     time=3
%     [x,y,z,v] = roms_slicell(file,varname,lon,lat,time)
%     % or
%     [dist,z,v] = roms_slicell(file,varname,lon,lat,time)
%
%     varname='h';        % 2-d array
%     [x,y,z,v] = roms_slicell(file,varname,lon,lat,time)  % z is empty
%     % or
%     [dist,z,v] = roms_slicell(file,varname,lon,lat,time) % z is empty
%
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   01-07-2008

%   after vertical_slice and pom_slicell, mma 31-03-2009

%   21-10-2010 - IO-USP

if nargin <5
  time=1;
end

if length(X)==3, X=linspace(X(1),X(2),X(3)); else X=X(:)'; end
if length(Y)==3, Y=linspace(Y(1),Y(2),Y(3)); else Y=Y(:)'; end

grd = [];
plt = 0;
ax = [];
tts = [];
ttb = [];
hc  = [];
useGriddata=1;


vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'theta_s'), tts = vin{i+1};
  elseif isequal(vin{i},'theta_b'), ttb = vin{i+1};
  elseif isequal(vin{i},'hc'),      hc  = vin{i+1};
  elseif isequal(vin{i},'grid') | isequal(vin{i},'grd'), grd=vin{i+1};
  elseif isequal(vin{i},'plt'), plt=vin{i+1};
  elseif isequal(vin{i},'ax'),  ax=vin{i+1};
  elseif isequal(vin{i},'gd'),  useGriddata=vin{i+1};
  end
end

% get grid filename:
if isempty(grd)
  grd=fname;
  if n_attexist(fname,'grd_file')
    grd_=n_att(fname,'grd_file');
    if exist(grd_)==2, grd=grd_; end
  end
end

% get the s parameters from the file or from grid file:
[tts_,ttb_,hc_,n] = s_params(fname);
if isempty(tts_) & ~isequal(grd,fname)
  [tts_,ttb_,hc_,n] = s_params(grd);
end
if isempty(tts), tts=tts_; end
if isempty(ttb), ttb=ttb_; end
if isempty(hc),  hc =hc_;  end

Z=[];
V=[];
mask=[];
dist=[];

Uvars={'u','ubar'};
Vvars={'v','vbar'};
Wvars={'w'};

zeta=use(fname,'zeta','time',time);
if ismember(varname,Uvars)
  [x,y,h,m]=roms_grid(grd,'u');
  zeta=rho2u_2d(zeta);
elseif ismember(varname,Vvars)
  [x,y,h,m]=roms_grid(grd,'v');
  zeta=rho2v_2d(zeta);
else
  [x,y,h,m]=roms_grid(grd,'r');
end

T  = n_dim(fname,'time');
Sr = n_dim(fname,'s_rho');

if time > T | time <=0
  fprintf(1,'» time = %g exceeds time dimension (%g)\n',time,T);
  return
end

v=use(fname,varname,'time',time);
v(v==0)=nan;

is3d=ndims(v)==3;

if is3d
  if ismember(varname,Wvars)
    n=Sr+1;
  else
    n=Sr;
  end
else
  n=1;
end


if useGriddata
  V=repmat(nan,[n length(X)]);
  if is3d
    for i=1:n
      V(i,:)=griddata(x,y,squeeze(v(i,:,:)),X,Y);
    end
  else
    V=griddata(x,y,v,X,Y);
  end

  if is3d
    zeta=griddata(x,y,zeta,X,Y);
    h=griddata(x,y,h,X,Y);
    [Z,zw]=s_levels(h,tts,ttb,hc,n,zeta);
    if ismember(varname,Wvars), Z=zw; end
    Z=Z';
  else
    Z=zeros(size(V));
  end

else

  if is3d
    % calc s-levels:
    [zr,zw]=s_levels(h,tts,ttb,hc,n,zeta);
    if ismember(varname,Wvars)
      z=permute(zw,[3,1,2]);
      n=Sr+1;
    else
      z=permute(zr,[3,1,2]);
      n=Sr;
    end
  else
    n=1;
  end

  for l=1:length(X)
    xx=X(l); yy=Y(l);
    [i,j]=find_nearest(x,y,xx,yy); i=i(1); j=j(1);

    if 1
      isin=0;
      for ii=max(1,i-1):min(size(x,1)-1,i)
        if isin, break; end
        for jj=max(1,j-1):min(size(x,2)-1,j)
          Px=[x(ii,jj) x(ii,jj+1) x(ii+1,jj+1) x(ii+1,jj)];
          Py=[y(ii,jj) y(ii,jj+1) y(ii+1,jj+1) y(ii+1,jj)];
          if inpolygon(xx,yy,Px,Py)
            isin=1;
            i=ii;
            j=jj;
            break
          end
        end
      end

    else
      j0=j;
      if xx<x(i,j),  j=j-1; end
      if yy<y(i,j0), i=i-1; end
    end


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
end %useGriddata

mask=~isnan(V);

if nargout<=4 | plt
  dst=spheric_dist(Y(2:end),Y(1:end-1),X(2:end),X(1:end-1));
  dst=[0; cumsum(dst(:))];
  dst=repmat(dst(:)',[n 1]);
end

if is3d
  X=repmat(X,n,1);
  Y=repmat(Y,n,1);
end


% plt:
if plt
  if ~isempty(ax)
    axes(ax);
  else
    figure, axes;
  end

  if prod(size(V))==length(V) % 1d
    plot(dst/1000,V);
  else % 2d
    if plt==3
      p=plot_border3d(grd); hold on
      set(p.surfh,'edgecolor','none');
      view(3);
      camlight
      s=surf(X,Y,Z,V); set(s,'edgecolor','none','facelighting','none');
      caxis([min(V(:)) max(V(:))]);
    else
      s=pcolor(dst/1000,Z,V); set(s,'edgecolor','none');
      hold on
      if ~useGriddata
        zeta=griddata(x,y,zeta,X,Y);
        h=griddata(x,y,h,X,Y);
      end
      mask1d=mask(end,:);
      zeta(~mask1d)=nan;
      h(~mask1d)=nan;
      plot(dst(1,:)/1000,-h);
      plot(dst(1,:)/1000,zeta);
      colorbar
    end
  end
end

if nargout<=4
  X=dst;
  Y=Z;
  Z=V;
  V=mask;
end
