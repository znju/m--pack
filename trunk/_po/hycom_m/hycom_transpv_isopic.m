function [Tr,TR]=hycom_transpv_isopic(f,time,s)
%HYCOM_TRANSPV_ISOPIC  HYCOM transport-v between two isopicnal layers
%
%   Syntax:
%      [Tr,TR]=HYCOM_TRANSPV_ISOPIC(F,time,S)
%
%   Inputs:
%      F   HYCOM file (u,v,temp,salt,ssh,depth,h,lon,lat,mask)
%      TIME Time indice
%      S   Densities, [s-min s-max]. If not provided, all water column
%          is used.
%
%   Outputs:
%      Tr   Transport (Sv)
%      TR   Accumulated transport (cumsum(Tr,2))
%
%   Example:
%      f='file.nc';
%      [Tr,TR]=hycom_transpv_isopic(f,1,[0 25]);
%      [xg,yg,hg,mg,m3g] = hycom_grid(f);
%
%      figure
%      pcolor(xg,yg,Tr), shading flat, colorbar
%
%      figure
%      pcolor(xg,yg,TR), shading flat, colorbar, hold on
%      contour(xg,yg,TR,[-50:2:50],'w')
%
%   See also HYCOM_DENS, ISO_ZLAYER, ISO_INTERVAL, OCCAM_TRANSPV_ISOPIC
%
%   Martinho MA, 06-06-2009, mma@odyle.net
%   CESAM, Portugal

Layer=1;
if nargin<3
  Layer=0;
end

varname='v';

% load grid vars:
[xg,yg,hg,mg,m3g] = hycom_grid(f);
[n,eta,xi]=size(m3g);

% calc pot dens:
D=hycom_densp(f,time);

% z3d:
depth=use(f,'depth');
z3d=repmat(depth,[1 eta xi]);

% zedges3d:
% depth edges !! considering at bottom it continues linearly...
% also note that ssh should be added at top!!
d=use(f,'depth');
ze=[0; (d(1:end-1)+d(2:end))/2];
ze(end+1)=d(end)+(d(end)-d(end-1))/2;
ze3d=repmat(ze,[1 eta xi]);
ssh = use(f,'ssh','month',time);
ze3d(1,:,:)=squeeze(ze3d(1,:,:))+ssh;

% calc R weights:
if Layer
  [R,Z1,Z2] = iso_zlayer(z3d,ze3d,D,s,m3g,2);
else
  R=repmat(mg,[1 1 n]); R=shiftdim(R,2);
end

% calc dx:
[xb,dx]=ll_dx2(xg,yg);
dx=repmat(dx,[1 1 n]); dx=shiftdim(dx,2);

% calc dz:
dz=diff(ze3d);

% calc transp:
R(isnan(R))=0; % otherwise, sum will return nan!
v=use(f,varname,'month',time); v(m3g==0)=0;
Tr=squeeze(sum(dx.*dz.*R.*v)); Tr=Tr/1E6;
TR=cumsum(Tr,2);
%Tr(mg==0)=nan;
%TR(mg==0)=nan;

is1=squeeze(sum(R))==0;
%is2=isnan(Z1) | isnan(Z2);
% is1 and is2 must be equal and must include horizontal mask !!!
is=is1;
Tr(is)=nan;
