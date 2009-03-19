function [ubar,vbar] = calc_roms_uvbar(u,v,ssh,grd,s_params)
%ROMS_UVBAR   Compute ROMS barotropic currents from 3d currents
%
%   Syntax:
%      [UBAR,VBAR] = ROMS_UVBAR(U,V,SSH,GRD,S_PARAMS)
%
%   Inputs:
%      U,V   3D currents
%      SSH   Sea surface hight
%      GRD   ROMS grid file
%      S_PARAMS   S-coordinate parameters (theta_s,theta_b,hc,N)
%
%   Outputs:
%     UBAR,VBAR  Barotropic currents
%
%   See also OCCAM_UVBAR
%
%   MMA 16-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

h=use(grd,'h');
if isstr(s_params)
  datafile=s_params;
  [zr,zw]=pom_s_levels(s_params,h,ssh);
  N=pom_s_levels(s_params);
else
  [theta_s,theta_b,hc,N]=unpack(s_params);
  [zr,zw]=s_levels(h,theta_s,theta_b,hc,N,ssh);
end

% calc s-levels:
zr=permute(zr,[3 1 2]);
zw=permute(zw,[3 1 2]);

zwu=(zw(:,:,1:end-1)+zw(:,:,2:end))/2;
zwv=(zw(:,1:end-1,:)+zw(:,2:end,:))/2;

dzu=diff(zwu);
dzv=diff(zwv);

ubar=sum(u.*dzu)./sum(dzu); ubar=squeeze(ubar);
vbar=sum(v.*dzv)./sum(dzv); vbar=squeeze(vbar);
