function [x,y,z,v]=hycom_slice(fname,vname,type,ind,time)
%HYCOM_SLICE   Make HYCOM_M slice
%   The section may be at i,j,k,lon,lat and z constant.
%
%   Syntax:
%      [X,Y,Z,V]  = HYCOM_SLICE(FILE,VARNAME,TYPE,IND,TIME)
%      V  = HYCOM_SLICE(FILE,VARNAME,TYPE,IND,TIME)
%
%   Inputs:
%      FILE   OCCAM output file
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
%      [x,y,z,v] = hycom_slice(file,varname,'lon',-30,1)
%
%   See also OCCAM_SLICE
%
%   MMA 25-08-2009 from OCCAM_SLICE, 17-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   and CESAM, UA, Portugal

UVvars = {};
if ismember(vname,UVvars)
  dim_lon = 'xi';
  dim_lat = 'eta';
  x_name  = 'lon';
  y_name  = 'lat';
  m_name  = 'mask';
else
  dim_lon = 'xi';
  dim_lat = 'eta';
  x_name  = 'lon';
  y_name  = 'lat';
  m_name  = 'mask';
end
dim_k='z';
z_name='depth';

% load mask 3d:
[xtmp,ytmp,htmp,mtmp,m3d]=hycom_grid(fname);

N=n_dim(fname,dim_k);
z=use(fname,z_name);

if isequal(type,'lon')
  lon=use(fname,x_name,dim_lat,1); i=lon>180; lon(i)=lon(i)-360;

  Lon=[-inf lon(:)' inf];
  i2=find(Lon>ind); i2=i2(1);
  i1=i2-1;
  d2=Lon(i2)-ind;
  d1=ind-Lon(i1);

  v=use(fname,vname,'month',time);
  v(m3d==0)=nan;
%  miss=fastmode(v);
%  if length(miss)==1, v(v==miss)=nan; end

  [S,M,L]=size(v);
  V=repmat(nan,[S M L+2]);
  V(:,:,2:end-1)=v;
  v=(squeeze(V(:,:,i1))*d2 + squeeze(V(:,:,i2))*d1)/(d1+d2);

  x=repmat(ind,size(v));
  y=use(fname,y_name,dim_lon,i1); % any ind is ok, since it is constant !!
  y=repmat(y',N,1);

  z=repmat(z,1,size(v,2));

elseif isequal(type,'lat')
  lat=use(fname,y_name,dim_lon,1);
  Lat=[-inf lat(:)' inf];
  i2=find(Lat>ind); i2=i2(1);
  i1=i2-1;
  d2=Lat(i2)-ind;
  d1=ind-Lat(i1);

  v=use(fname,vname,'month',time);
  v(m3d==0)=nan;
%  miss=fastmode(v);
%  if length(miss)==1, v(v==miss)=nan; end

  [S,M,L]=size(v);
  V=repmat(nan,[S M+2 L]);
  V(:,2:end-1,:)=v;
  v=(squeeze(V(:,i1,:))*d2 + squeeze(V(:,i2,:))*d1)/(d1+d2);

  y=repmat(ind,size(v));
  x=use(fname,x_name,dim_lat,i1); % any ind is ok, since it is constant !!
  x=repmat(x,N,1);

  z=repmat(z,1,size(v,2));

elseif isequal(type,'z')
  Z=[-inf z(:)' inf];
  i2=find(Z>abs(ind)); i2=i2(1);
  i1=i2-1;
  d2=Z(i2)-abs(ind);
  d1=abs(ind)-Z(i1);

  v=use(fname,vname,'month',time);
  v(m3d==0)=nan;
%  miss=fastmode(v);
%  if length(miss)==1, v(v==miss)=nan; end

  [S,M,L]=size(v);
  V=repmat(nan,[S+2 M L]);
  V(2:end-1,:,:)=v;
  v=(squeeze(V(i1,:,:))*d2 + squeeze(V(i2,:,:))*d1)/(d1+d2);

  x=use(fname,x_name);
  y=use(fname,y_name);
%  [x,y]=meshgrid(x,y);
  z=-repmat(abs(ind),size(v));

elseif isequal(type,'i')
  v=use(fname,vname, dim_lon,ind,'month',time);
  m=squeeze(m3d(:,:,ind));
  v(m==0)=nan;

  x=use(fname,x_name,dim_lon,ind);
  y=use(fname,y_name,dim_lon,ind);

  x=repmat(x',N,1);
  y=repmat(y',N,1);
  z=repmat(z,1,size(v,2));

elseif isequal(type,'j')
  v=use(fname,vname, dim_lat,ind,'month',time);
  m=squeeze(m3d(:,ind,:));
  v(m==0)=nan;

  x=use(fname,x_name,dim_lat,ind);
  y=use(fname,y_name,dim_lat,ind);

  x=repmat(x,N,1);
  y=repmat(y,N,1);
  z=repmat(z,1,size(v,2));
elseif isequal(type,'k')
  v=use(fname,vname, dim_k,ind,'month',time);
  m=squeeze(m3d(ind,:,:));
  v(m==0)=nan;

  x=use(fname,x_name);
  y=use(fname,y_name);
  z=repmat(z(ind),size(v));

%  miss=fastmode(v);
%  if length(miss)==1, v(v==miss)=nan; end
end

i=x>180;
x(i)=x(i)-360;

if nargout==1
  x=v;

end
