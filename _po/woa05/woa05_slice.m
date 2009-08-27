function [x,y,z,v]=woa05_slice(fname,fls,vname,type,ind,time)
%WOA05_SLICE   Make WOA05 slice
%   The section may be at i,j,k,lon,lat and z constant.
%
%   Syntax:
%      [X,Y,Z,V]  = WOA05_SLICE(FILE,FLS,VARNAME,TYPE,IND,TIME)
%      V  = WOA05_SLICE(FILE,FLS,VARNAME,TYPE,IND,TIME)
%
%   Inputs:
%      FILE   OCCAM output file
%      FLS    Landsea file
%      VARNAME   Variable to extract
%      TYPE   Slice type: i,j,k,lon,lat and z
%      IND    Slice indice (i, j, k, long, lat or z)
%      TIME   Time indice
%
%   Outputs:
%     X,Y,Z   Positions and depth
%     V   Variable at slice
%
%    Examples:
%      file='file.nc';
%      varname='temp';
%      [x,y,z,v] = woa05_slice(file,'landsea.nc',varname,'lon',-30,1)
%
%   See also OCCAM_SLICE, HYCOM_SLICE
%
%   MMA 25-08-2009 from OCCAM_SLICE, 17-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   and CESAM, UA, Portugal

if nargin<6
  time=1;
end

dim_lon = 'X';
dim_lat = 'Y';
x_name  = 'X';
y_name  = 'Y';
dim_k='Z';
z_name='Z';

% load mask 3d:
[xg,yg,hg,m,m3d]=woa05_grid(fls,fname);

N=n_dim(fname,dim_k);
z=use(fname,z_name);

if isequal(type,'lon')
  lon=use(fname,x_name,dim_lat,1); i=lon>180; lon(i)=lon(i)-360;

  Lon=[-inf lon(:)' inf];
  i2=find(Lon>ind); i2=i2(1);
  i1=i2-1;
  d2=Lon(i2)-ind;
  d1=ind-Lon(i1);

  v=use(fname,vname,'T',time);

  [S,M,L]=size(v);
  V=repmat(nan,[S M L+2]);
  V(:,:,2:end-1)=v;
  v=(squeeze(V(:,:,i1))*d2 + squeeze(V(:,:,i2))*d1)/(d1+d2);

  x=repmat(ind,size(v));
  y=yg(:,i1); % any ind is ok, since it is constant !!
  y=repmat(y',N,1);

  z=repmat(z,1,size(v,2));

elseif isequal(type,'lat')
  lat=use(fname,y_name,dim_lon,1);
  Lat=[-inf lat(:)' inf];
  i2=find(Lat>ind); i2=i2(1);
  i1=i2-1;
  d2=Lat(i2)-ind;
  d1=ind-Lat(i1);

  v=use(fname,vname,'T',time);

  [S,M,L]=size(v);
  V=repmat(nan,[S M+2 L]);
  V(:,2:end-1,:)=v;
  v=(squeeze(V(:,i1,:))*d2 + squeeze(V(:,i2,:))*d1)/(d1+d2);

  y=repmat(ind,size(v));
  x=xg(i1,:); % any ind is ok, since it is constant !!
  x=repmat(x,N,1);

  z=repmat(z,1,size(v,2));

elseif isequal(type,'z')
  Z=[-inf z(:)' inf];
  i2=find(Z>abs(ind)); i2=i2(1);
  i1=i2-1;
  d2=Z(i2)-abs(ind);
  d1=abs(ind)-Z(i1);

  v=use(fname,vname,'T',time);

  [S,M,L]=size(v);
  V=repmat(nan,[S+2 M L]);
  V(2:end-1,:,:)=v;
  v=(squeeze(V(i1,:,:))*d2 + squeeze(V(i2,:,:))*d1)/(d1+d2);

  x=xg;
  y=yg;
  z=-repmat(abs(ind),size(v));

elseif isequal(type,'i')
  v=use(fname,vname, dim_lon,ind,'T',time);

  x=xg(:,ind);
  y=yg(:,ind);

  x=repmat(x',N,1);
  y=repmat(y',N,1);
  z=repmat(z,1,size(v,2));

elseif isequal(type,'j')
  v=use(fname,vname, dim_lat,ind,'T',time);

  x=xg(ind,:);
  y=yg(ind,:);

  x=repmat(x,N,1);
  y=repmat(y,N,1);
  z=repmat(z,1,size(v,2));
elseif isequal(type,'k')
  v=use(fname,vname, dim_k,ind,'T',time);
  x=xg;
  y=yg;
  z=repmat(z(ind),size(v));
end

i=x>180;
x(i)=x(i)-360;

if nargout==1
  x=v;

end
