function [Tr,TR,Z1,Z2]=occam_transpu_isopic(f,s)
%OCCAM_TRANSPU_ISOPIC  OCCAM transport-u between two isopicnal layers
%
%   Syntax:
%      [Tr,TR]=OCCAM_TRANSPU_ISOPIC(F,S)
%
%   Inputs:
%      F   OCCAM file
%      S   Densities, [s-min s-max]. If not provided, all water column
%          is used.
%
%   Outputs:
%      Tr   Transport (Sv)
%      TR   Accumulated transport (cumsum(Tr,1))
%
%   Example:
%      f='jan.nc';
%      [Tr,TR]=occam_transpu_isopic(f,[0 25]);
%      [xg,yg,hg,mg,m3g] = occam_grid(f);
%
%      figure
%      pcolor(xg,yg,Tr), shading flat, colorbar
%
%      figure
%      pcolor(xg,yg,TR), shading flat, colorbar, hold on
%      contour(xg,yg,TR,[-50:2:50],'w')
%
%   See also OCCAM_DENS, ISO_ZLAYER, ISO_INTERVAL, OCCAM_TRANSPV_ISOPIC
%
%   Martinho MA, 28-07-2009, mma@odyle.net
%   UFBA, Brasil

Layer=1;
if nargin==1
  Layer=0;
end

varname='U_VELOCITY__MEAN_';              % diff from occam_transpv_isopic %%

% load grid vars:
[xg,yg,hg,mg,m3g] = occam_grid(f);
[n,eta,xi]=size(m3g);

% calc pot dens:
D=occam_densp(f);

% z3d:
depth=use(f,'DEPTH')*0.01;
z3d=repmat(depth,[1 eta xi]);

% zedges3d:
ze=use(f,'DEPTH_EDGES')*0.01;
ze3d=repmat(ze,[1 eta xi]);
ssh = use(f,'SEA_SURFACE_HEIGHT__MEAN_')*0.01;
ze3d(1,:,:)=squeeze(ze3d(1,:,:))+ssh;

% calc R weights:
if Layer
  [R,Z1,Z2] = iso_zlayer(z3d,ze3d,D,s,m3g,2);
else
  R=repmat(mg,[1 1 n]); R=shiftdim(R,2);
  Z1=squeeze(ze3d(1,:,:));
  Z2=squeeze(ze3d(end,:,:));
end

% calc dx:
[xb,dx]=ll_dx2(xg,yg,'direct','i');       % diff from occam_transpv_isopic %%
dx=repmat(dx,[1 1 n]); dx=shiftdim(dx,2);

% calc dz:
dz=diff(ze3d);

% calc transp:
R(isnan(R))=0; % otherwise, sum will return nan!
v=use(f,varname)*0.01; % cms ms
Tr=squeeze(sum(dx.*dz.*R.*v)); Tr=Tr/1E6;
TR=cumsum(Tr,1);                          % diff from occam_transpv_isopic %%
%Tr(mg==0)=nan;
%TR(mg==0)=nan;

is1=squeeze(sum(R))==0;
%is2=isnan(Z1) | isnan(Z2);
% is1 and is2 must be equal and must include horizontal mask !!!
is=is1;
Tr(is)=nan;
