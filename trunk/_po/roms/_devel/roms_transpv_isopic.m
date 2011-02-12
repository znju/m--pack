function [outTr1,outTR1,lon,lat]=roms_transpv_isopic(fr,fg,d,itime)
%OCCAM_TRANSPV_ISOPIC  OCCAM transport-v between two isopicnal layers
%
%   Syntax:
%      [Tr,TR]=OCCAM_TRANSPV_ISOPIC(Fr,Fg,d)
%
%   Inputs:
%      Fr   ROMS file
%      Fg   ROMS grid file
%      D   Densities, [d-min d-max]. If not provided, all water column
%          is used.
%
%   Outputs:
%      Tr   Transport (Sv)
%      TR   Accumulated transport (cumsum(Tr,2))
%
%   Example:
%      f='jan.nc';
%      [Tr,TR]=occam_transpv_isopic(f,[0 25]);
%      [xg,yg,hg,mg,m3g] = occam_grid(f);
%
%      figure
%      pcolor(xg,yg,Tr), shading flat, colorbar
%
%      figure
%      pcolor(xg,yg,TR), shading flat, colorbar, hold on
%      contour(xg,yg,TR,[-50:2:50],'w')
%
%   See also OCCAM_DENS, ISO_ZLAYER, ISO_INTERVAL
%
%   Martinho MA, 08-03-2009, mma@odyle.net
%   CESAM, Portugal

Layer=1;
if nargin<3
  Layer=0;
end

if nargin < 4
  time=use(fr,'scrum_time')/86400;
  itime=1:length(time);
end

% load grid vars:
[x,y,h,mask]=roms_grid(fg);

outTr1=zeros([length(itime) size(x,1)-1 size(x,2)]);
outTR1=outTr1;

cont=0;
for t=1:length(itime)
    i=itime(t);
    fprintf(1,'--> time=%d of %d\n',i,length(itime));
    v=use(fr,'v','time',i);
    temp=use(fr,'temp','time',i);
    sal=use(fr,'salt','time',i);

    % calc pot dens:
    dens=sw_dens0(sal,temp); dens=dens-1000;

    [n,eta,xi]=size(v);

    % z3d and zedges3d (z_w):
    [z_r,z_w]=s_levels(fr,i,fg);
    z_r=permute(z_r,[3 1 2]);
    z_w=permute(z_w,[3 1 2]);

%    size(z_r)
%    size(z_w)
%    size(dens)
    z_r=flipdim(z_r,1);
    z_w=flipdim(z_w,1);
    dens=flipdim(dens,1);
%    size(z_r)
%    size(z_w)
%    size(dens)
%    size(mask)

    % calc R weights:
    if Layer
      [R,Z1,Z2] = iso_zlayer(-z_r,-z_w,dens,d,mask,2);
    else
      R=repmat(mask,[1 1 n]); R=shiftdim(R,2);
    end

    % calc dx:
    [xb,dx]=ll_dx2(x,y);
    dx=repmat(dx,[1 1 n]); dx=shiftdim(dx,2);

    % calc dz:
%%%%%%    dz=diff(z_w);
    dz=-diff(z_w);

    % calc transp:
    R(isnan(R))=0; % otherwise, sum will return nan!
    Tr1=squeeze(sum(dx(:,1:eta,:).*dz(:,1:eta,:).*R(:,1:eta,:).*v));
    Tr1=Tr1/1E6;
    TR1=cumsum(Tr1,2);

    Tr1(Tr1==0)=nan;
    TR1(TR1==0)=nan;

    lon=x(1:eta,:); lat=y(1:eta,:);

    cont=cont+1;
    outTr1(cont,:,:)=Tr1;
    outTR1(cont,:,:)=TR1;
end
outTr1=squeeze(outTr1);
outTR1=squeeze(outTR1);
