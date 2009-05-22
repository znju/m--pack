function [Tb,tot] = roms_transpclm(grd,clm)
%ROMS_TRANSPCLM   Transport of ROMS clm file at boundaries
%
%   Syntax:
%      [T,TOT] = ROMS_TRANSPCLM(GRD,CLM)
%
%   Inputs:
%      GRD   ROMS grid file
%      CLM   ROMS climatology file
%
%   Outputs:
%      T    Transports at the 4 boundaries
%      TOT  Total transport
%
%   MMA 30-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

[theta_s,theta_b,hc,N]=s_params(clm);
Times=n_dim(clm,'zeta_time');
Tb={};

atuv=1;
if atuv
  [xu,yu,hu,mu]=roms_grid(grd,'u');
  [xv,yv,hv,mv]=roms_grid(grd,'v');
  SSH  = use(clm,'zeta');
  sshu = rho2u_3d(SSH);
  sshv = rho2v_3d(SSH);
else
  [xu,yu,hu,mu]=roms_grid(grd,'r');
  [xv,yv,hv,mv]=roms_grid(grd,'r');
  SSH  = use(clm,'zeta');
  sshu = SSH;
  sshv = SSH;
end


fformat='      t = %3d of %d = %6.2f %6.2f %6.2f\n';

% West: --------------------------------------------------------------
fprintf(1,'\n West \n');
Tr=[];
dx   = ll_dx(xu(:,1), yu(:,1)); dx=repmat(dx(:)',[N 1]);
hh   = hu(:,1);
mask = mu(:,1);  mask=repmat(mask(:)',[N 1]);
sign_=+1;

u =use(clm,'u','xi_u',1);
for i=1:Times
  uu = squeeze(u(i,:,:));
  uu=uu.*mask;

  ssh=squeeze(sshu(i,:,1));
  [zr,zw]=s_levels(hh,theta_s,theta_b,hc,N,ssh);
  dz=diff(zw');

  [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,uu);
  fprintf(1,fformat,i,Times,[T,Tpos,Tneg]/1E6*sign_);
  Tr(i,:)=[T,Tpos,Tneg]/1E6*sign_;
end
Tb{1}=Tr;


% South: -------------------------------------------------------------
fprintf(1,'\n South \n');
Tr=[];
dx   = ll_dx(xv(1,:), yv(1,:)); dx=repmat(dx(:)',[N 1]);
hh   = hv(1,:);
mask = mv(1,:);  mask=repmat(mask(:)',[N 1]);
sign_=+1;

v =use(clm,'v','eta_v',1);

for i=1:Times
  vv = squeeze(v(i,:,:));
  vv=vv.*mask;
  ssh=squeeze(sshv(i,1,:));
  [zr,zw]=s_levels(hh,theta_s,theta_b,hc,N,ssh);
  dz=diff(zw');

  [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,vv);
  fprintf(1,fformat,i,Times,[T,Tpos,Tneg]/1E6*sign_);
  Tr(i,:)=[T,Tpos,Tneg]/1E6*sign_;
end
Tb{2}=Tr;


% East: -------------------------------------------------------------
fprintf(1,'\n East \n');
Tr=[];
dx   = ll_dx(xu(:,end), yu(:,end)); dx=repmat(dx(:)',[N 1]);
hh   = hu(:,end);
mask = mu(:,end);  mask=repmat(mask(:)',[N 1]);
sign_=-1;

u =use(clm,'u','xi_u','end');
for i=1:Times
  uu = squeeze(u(i,:,:));
  uu=uu.*mask;

  ssh=squeeze(sshu(i,:,end));
  [zr,zw]=s_levels(hh,theta_s,theta_b,hc,N,ssh);
  dz=diff(zw');

  [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,uu);
  fprintf(1,fformat,i,Times,[T,Tpos,Tneg]/1E6*sign_);
  Tr(i,:)=[T,Tpos,Tneg]/1E6*sign_;
end
Tb{3}=Tr;


% North: -------------------------------------------------------------
fprintf(1,'\n North \n');
Tr=[];
dx   = ll_dx(xv(end,:), yv(end,:)); dx=repmat(dx(:)',[N 1]);
hh   = hv(end,:);
mask = mv(end,:);  mask=repmat(mask(:)',[N 1]);
sign_=-1;

v =use(clm,'v','eta_v','end');

for i=1:Times
  vv = squeeze(v(i,:,:));
  vv=vv.*mask;
  ssh=squeeze(sshv(i,end,:));
  [zr,zw]=s_levels(hh,theta_s,theta_b,hc,N,ssh);
  dz=diff(zw');

  [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,vv);
  fprintf(1,fformat,i,Times,[T,Tpos,Tneg]/1E6*sign_);
  Tr(i,:)=[T,Tpos,Tneg]/1E6*sign_;
end
Tb{4}=Tr;


tot=0;
for i=1:length(Tb)
  tot = tot+Tb{i};
end
tot=tot/length(Tb);
