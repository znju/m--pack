function [x,y,h,m,M]=occam_grid(g,ruv)
%OCCAM_GRID    Get OCCAM grid data
%
%   Syntax:
%      [X,Y,H,M,M3] = OCCAM_GRID(FILE,RUV)
%
%   Inputs:
%      FILE   OCCAM output file
%      RUV    Locations, may be 'r' (rho points) or 'uv' (u,v points),
%             default is 'r'
%
%   Outputs:
%      X,Y   Lon and lat
%      H     Depth
%      M,M3  2-D and 3-D mask
%
%   Examples:
%      [x,y,h,m,m3] = occam_grid('jan.nc');
%
%   MMA 16-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin<2
  ruv='r';
end

lonr=use(g,'LONGITUDE_T'); i=lonr>180; lonr(i)=lonr(i)-360;
latr=use(g,'LATITUDE_T');

lonu=use(g,'LONGITUDE_U'); i=lonu>180; lonu(i)=lonu(i)-360;
latu=use(g,'LATITUDE_U');

maskr=use(g,'KMT');
masku=use(g,'KMU');

[lonr,latr]=meshgrid(lonr,latr);
[lonu,latu]=meshgrid(lonu,latu);

mr=0*maskr; mr(maskr~=0)=1;
mu=0*masku; mu(masku~=0)=1;

d=use(g,'DEPTH')*0.01;
dw=use(g,'DEPTH_EDGES')*0.01; %cm to m

[m,n]=size(maskr);
hr=[];
hu=[];

N=n_dim(g,'DEPTH');
Mr=ones([N size(maskr)]);
Mu=ones([N size(masku)]);
for i=1:m
  for j=1:n
    hr(i,j)=dw(maskr(i,j)+1);
    hu(i,j)=dw(masku(i,j)+1);

    % 3d mask:
    Mr(maskr(i,j)+1:end,i,j)=0;
    Mu(masku(i,j)+1:end,i,j)=0;

  end
end

if strcmpi(ruv,'uv')
  x = lonu;
  y = latu;
  h = hu;
  m = mu;
  M = Mu;
else
  x = lonr;
  y = latr;
  h = hr;
  m = mr;
  M = Mr;
end
