function [x,y,h,m,M]=pop_grid(g,ruv)
%POP_GRID    Get POP grid data
%
%   Syntax:
%      [X,Y,H,M,M3] = POP_GRID(FILE,RUV)
%
%   Inputs:
%      FILE   POP output file
%      RUV    Locations, may be 'r' (rho points) or 'uv' (u,v points),
%             default is 'r'
%
%   Outputs:
%      X,Y   Lon and lat
%      H     Depth
%      M,M3  2-D and 3-D mask
%
%   Comment:
%      To have uv data, FILE must contain variable U or V,
%      to have rho data, FILE must include TEMP or SALT
%
%   Examples:
%      [x,y,h,m,m3] = pop_grid('salt_file.nc');
%
%   MMA 28-08-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin<2
  ruv='r';
end

lonr=use(g,'t_lon'); i=lonr>180; lonr(i)=lonr(i)-360;
latr=use(g,'t_lat');

lonu=use(g,'u_lon'); i=lonu>180; lonu(i)=lonu(i)-360;
latu=use(g,'u_lat');

% get mask:
r=[];
u=[];

if     n_varexist(g,'TEMP'); r=use(g,'TEMP');
elseif n_varexist(g,'SALT'); r=use(g,'SALT');
end

if     n_varexist(g,'U'); u=use(g,'U');
elseif n_varexist(g,'V'); u=use(g,'V');
end

if ~isempty(r), maskr=double(squeeze(isnan(r(1,:,:))));
else, maskr=[];
end

if ~isempty(u), masku=double(squeeze(isnan(u(1,:,:))));
else, masku=[];
end

[lonr,latr]=meshgrid(lonr,latr);
[lonu,latu]=meshgrid(lonu,latu);

d=use(g,'depth_t');
dw=use(g,'w_dep');

if ~isempty(r)
  [m,n]=size(maskr);
else
  [m,n]=size(masku);
end
hr=[];
hu=[];

N=n_dim(g,'depth_t');
Mr=ones([N size(maskr)]);
Mu=ones([N size(masku)]);

if ~isempty(r)
  r=isnan(r);
  r=diff(r);
end
if ~isempty(u)
  u=isnan(u);
  u=diff(u);
end

for i=1:m
  for j=1:n
    if ~isempty(r)
      kr=find(r(:,i,j)); if isempty(kr), kr=0; end
      hr(i,j)=dw(kr+1);
      Mr(kr+1:end,i,j)=0;
    end
    if ~isempty(u)
      ku=find(u(:,i,j)); if isempty(ku), ku=0; end
      hu(i,j)=dw(ku+1);
      Mu(ku+1:end,i,j)=0;
    end
  end
end

if isempty(r)
  hr=[];
  Mr=[];
end
if isempty(u)
  hu=[];
  Mu=[];
end

if strcmpi(ruv,'uv')
  x = lonu;
  y = latu;
  h = hu;
  m = masku;
  M = Mu;
else
  x = lonr;
  y = latr;
  h = hr;
  m = maskr;
  M = Mr;
end
