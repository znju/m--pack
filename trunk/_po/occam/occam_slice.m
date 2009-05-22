function [x,y,z,v]=occam_slice(fname,vname,type,ind)
%OCCAN_SLICE   Make OCCAM slice
%   The section may be at i,j,k,lon,lat and z constant.
%
%   Syntax:
%      [X,Y,Z,V]  = OCCAM_SLICE(FILE,VARNAME,TYPE,IND)
%      V  = OCCAM_SLICE(FILE,VARNAME,TYPE,IND)
%
%   Inputs:
%      FILE   OCCAM output file
%      VARNAME   Variable to extract
%      TYPE   Slice type: i,j,k,lon,lat and z
%      IND    Slice indice (i, j, k, long, lat or z)
%
%   Outputs:
%     X,Y,Z   Positions and depth
%     V   Variable at slice
%
%    Examples:
%      file='jan.nc';
%      varname='POTENTIAL_TEMPERATURE__MEAN_';
%      [x,y,z,v] = occam_slice(file,varname,'lon',-30)
%
%   See also OCCAM_SLICELL
%
%    MMA 17-07-2008, mma@odyle.net
%    Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

UVvars = {'U_WIND_STRESS__MEAN_', 'V_WIND_STRESS__MEAN_','U_VELOCITY__MEAN_','V_VELOCITY__MEAN_'};
if ismember(vname,UVvars)
  dim_lon = 'LONGITUDE_U';
  dim_lat = 'LATITUDE_U';
  x_name  = 'LONGITUDE_U';
  y_name  = 'LATITUDE_U';
  m_name  = 'KMU';
else
  dim_lon = 'LONGITUDE_T';
  dim_lat = 'LATITUDE_T';
  x_name  = 'LONGITUDE_T';
  y_name  = 'LATITUDE_T';
  m_name  = 'KMT';
end
dim_k='DEPTH';
z_name='DEPTH';

N=n_dim(fname,dim_k);
z=use(fname,z_name)*0.01;

if isequal(type,'lon')
  lon=use(fname,x_name); i=lon>180; lon(i)=lon(i)-360;

  Lon=[-inf lon(:)' inf];
  i2=find(Lon>ind); i2=i2(1);
  i1=i2-1;
  d2=Lon(i2)-ind;
  d1=ind-Lon(i1);

  v=use(fname,vname);
  miss=fastmode(v);
  if length(miss)==1, v(v==miss)=nan; end

  [S,M,L]=size(v);
  V=repmat(nan,[S M L+2]);
  V(:,:,2:end-1)=v;
  v=(squeeze(V(:,:,i1))*d2 + squeeze(V(:,:,i2))*d1)/(d1+d2);

  x=repmat(ind,size(v));
  y=use(fname,y_name); y=repmat(y',N,1);
  z=repmat(z,1,size(v,2));

elseif isequal(type,'lat')
  lat=use(fname,y_name);
  Lat=[-inf lat(:)' inf];
  i2=find(Lat>ind); i2=i2(1);
  i1=i2-1;
  d2=Lat(i2)-ind;
  d1=ind-Lat(i1);

  v=use(fname,vname);
  miss=fastmode(v);
  if length(miss)==1, v(v==miss)=nan; end

  [S,M,L]=size(v);
  V=repmat(nan,[S M+2 L]);
  V(:,2:end-1,:)=v;
  v=(squeeze(V(:,i1,:))*d2 + squeeze(V(:,i2,:))*d1)/(d1+d2);

  y=repmat(ind,size(v));
  x=use(fname,x_name); x=repmat(x',N,1);
  z=repmat(z,1,size(v,2));

elseif isequal(type,'z')
  Z=[-inf z(:)' inf];
  i2=find(Z>abs(ind)); i2=i2(1);
  i1=i2-1;
  d2=Z(i2)-abs(ind);
  d1=abs(ind)-Z(i1);

  v=use(fname,vname);
  miss=fastmode(v);
  if length(miss)==1, v(v==miss)=nan; end

  [S,M,L]=size(v);
  V=repmat(nan,[S+2 M L]);
  V(2:end-1,:,:)=v;
  v=(squeeze(V(i1,:,:))*d2 + squeeze(V(i2,:,:))*d1)/(d1+d2);

  x=use(fname,x_name);
  y=use(fname,y_name);
  [x,y]=meshgrid(x,y);
  z=-repmat(abs(ind),size(v));

elseif isequal(type,'i')
  v=use(fname,vname, dim_lon,ind);
  x=use(fname,x_name,dim_lon,ind);
  y=use(fname,y_name,dim_lon,ind);

  x=repmat(x,size(v));
  y=repmat(y',N,1);
  z=repmat(z,1,size(v,2));

elseif isequal(type,'j')
  v=use(fname,vname, dim_lat,ind);
  x=use(fname,x_name,dim_lat,ind);
  y=use(fname,y_name,dim_lat,ind);

  x=repmat(x',N,1);
  y=repmat(y,size(v));
  z=repmat(z,1,size(v,2));

elseif isequal(type,'k')
  v=use(fname,vname, dim_k,ind);
  x=use(fname,x_name);
  y=use(fname,y_name);
  [x,y]=meshgrid(x,y);
  z=repmat(z(ind),size(v));

  miss=fastmode(v);
  if length(miss)==1, v(v==miss)=nan; end
end

i=x>180;
x(i)=x(i)-360;

if nargout==1
  x=v;
end
