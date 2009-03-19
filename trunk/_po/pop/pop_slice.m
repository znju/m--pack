function [x,y,z,v]=pop_slice(fname,vname,type,ind)
%OCCAN_SLICE   Make POP slice
%   The section may be at i,j,k,lon,lat and z constant.
%
%   Syntax:
%      [X,Y,Z,V]  = POP_SLICE(FILE,VARNAME,TYPE,IND)
%      V  = POP_SLICE(FILE,VARNAME,TYPE,IND)
%
%   Inputs:
%      FILE   POP output file
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
%   See also OCCAM_SLICE
%
%    MMA 13-06-2008, mma@odyle.net
%    Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

UVvars = {'U', 'V'};
if ismember(vname,UVvars)
  dim_lon = 'u_lon';
  dim_lat = 'u_lat';
  x_name  = 'u_lon';
  y_name  = 'u_lat';
else
  dim_lon = 't_lon';
  dim_lat = 't_lat';
  x_name  = 't_lon';
  y_name  = 't_lat';
end
dim_k='depth_t';
z_name='depth_t';
zw_name='w_dep';

N=n_filedim(fname,dim_k);
z=use(fname,z_name);

% equal to occam_slice from here !
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
  z=use(fname,z_name);
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
end

i=x>180;
x(i)=x(i)-360;

if nargout==1
  x=v;
end
