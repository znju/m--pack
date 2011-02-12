function [x,y,h,m,M]=hycom_grid(g,ruv)
%OCCAM_GRID    Get HYCOM grid data
%
%   Syntax:
%      [X,Y,H,M,M3] = HYCOM_GRID(FILE,RUV)
%
%   Inputs:
%      FILE   HYCOM file (u,v,temp,salt,ssh,depth,h,lon,lat,mask)
%      RUV    Locations, may be 'r' (rho points) or 'uv' (u,v points),
%             default is 'r' (all the same --> obtained from DODS)
%
%   Outputs:
%      X,Y   Lon and lat
%      H     Depth
%      M,M3  2-D and 3-D mask
%
%   Examples:
%      [x,y,h,m,m3] = hycom_grid('file.nc');
%
%   See also OCCAM_GRID
%
%   MMA 06-06-2009 from OCCAM_GRID, 16-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin<2
  ruv='r';
end

lonr=use(g,'lon'); i=lonr>180; lonr(i)=lonr(i)-360;
latr=use(g,'lat');

lonu=lonr;
latu=latr;

if n_varexist(g,'mask')
  mr=use(g,'mask');
else
  mr=use(g,'temp','depth',1)>1e3;
  mr=~mr;
  mr=mr*1.;
end
mu=mr;

% not needed:
if 0
  d=use(g,'depth');
  % depth edges !! considering at bottom it continues linearly...
  % also note that ssh should be added at top!!
  dw=[0; (d(1:end-1)+d(2:end))/2];
  dw(end+1)=d(end)+(d(end)-d(end-1))/2;
end

hr=use(g,'h');
hu=hr;

% 3d mask:
mt=1e3;
for month=1:n_dim(g,'time')
  temp=use(g,'temp','month',month);
  if month==1
    Mr=~(temp>mt | temp==0);
  else
    Mr=~(temp>mt | temp==0) & Mr;
  end
end
Mu=Mr;

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
