function [Tb,tot] = roms_transpbry(grd,bry,sparams)
%ROMS_TRANSPBRY   Transport of ROMS clm file at boundaries
%
%   Syntax:
%      [T,TOT] = ROMS_TRANSPBRY(GRD,BRY)
%
%   Inputs:
%      GRD   ROMS grid file
%      BRY   ROMS boundary file
%
%   Outputs:
%      T    Transports at the 4 boundaries
%      TOT  Total transport
%
%   MMA 08-10-2010, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%
%   See also ROMS_TRANSPBRY

if nargin <3
  [theta_s,theta_b,hc,N]=s_params(clm)
else
  [theta_s,theta_b,hc,N]=unpack(sparams);
end


Times=n_dim(bry,'bry_time');
Tb={};

[xu,yu,hu,mu]=roms_grid(grd,'u');
[xv,yv,hv,mv]=roms_grid(grd,'v');
%SSH  = use(clm,'zeta');
%sshu = rho2u_3d(SSH);
%sshv = rho2v_3d(SSH);


fformat='      t = %3d of %d = %6.2f %6.2f %6.2f\n';

Vars=n_filevars(bry);
% West: --------------------------------------------------------------
if ismember('u_west',Vars)
  fprintf(1,'\n West \n');
  Tr=[];
  dx   = ll_dx(xu(:,1), yu(:,1)); dx=repmat(dx(:)',[N 1]);
  hh   = hu(:,1);
  mask = mu(:,1);  mask=repmat(mask(:)',[N 1]);
  sign_=+1;

  %u =use(clm,'u','xi_u',1);
  u=use(bry,'u_west');
  zeta=use(bry,'zeta_west');
  for i=1:Times
    uu = squeeze(u(i,:,:));
    uu=uu.*mask;

    %ssh=squeeze(sshu(i,:,1));
    ssh=zeta(i,:);
    [zr,zw]=s_levels(hh,theta_s,theta_b,hc,N,ssh);
    dz=diff(zw');

    [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,uu);
    fprintf(1,fformat,i,Times,[T,Tpos,Tneg]/1E6*sign_);
    Tr(i,:)=[T,Tpos,Tneg]/1E6*sign_;
  end
  Tb{1}=Tr;
end


% South: -------------------------------------------------------------
if ismember('u_south',Vars)
  fprintf(1,'\n South \n');
  Tr=[];
  dx   = ll_dx(xv(1,:), yv(1,:)); dx=repmat(dx(:)',[N 1]);
  hh   = hv(1,:);
  mask = mv(1,:);  mask=repmat(mask(:)',[N 1]);
  sign_=+1;

  %v =use(clm,'v','eta_v',1);
  v =use(bry,'v_south');
  zeta=use(bry,'zeta_south');
  for i=1:Times
    vv = squeeze(v(i,:,:));
    vv=vv.*mask;
    %ssh=squeeze(sshv(i,1,:));
    ssh=zeta(i,:);
    [zr,zw]=s_levels(hh,theta_s,theta_b,hc,N,ssh);
    dz=diff(zw');

    [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,vv);
    fprintf(1,fformat,i,Times,[T,Tpos,Tneg]/1E6*sign_);
    Tr(i,:)=[T,Tpos,Tneg]/1E6*sign_;
  end
  Tb{2}=Tr;
end


% East: -------------------------------------------------------------
if ismember('u_east',Vars)
  fprintf(1,'\n East \n');
  Tr=[];
  dx   = ll_dx(xu(:,end), yu(:,end)); dx=repmat(dx(:)',[N 1]);
  hh   = hu(:,end);
  mask = mu(:,end);  mask=repmat(mask(:)',[N 1]);
  sign_=-1;

  %u =use(clm,'u','xi_u','end');
  u =use(bry,'u_east');
  zeta=use(bry,'zeta_east');
  for i=1:Times
    uu = squeeze(u(i,:,:));
    uu=uu.*mask;

    %ssh=squeeze(sshu(i,:,end));
    ssh=zeta(i,:);
    [zr,zw]=s_levels(hh,theta_s,theta_b,hc,N,ssh);
    dz=diff(zw');

    [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,uu);
    fprintf(1,fformat,i,Times,[T,Tpos,Tneg]/1E6*sign_);
    Tr(i,:)=[T,Tpos,Tneg]/1E6*sign_;
  end
  Tb{3}=Tr;
end


% North: -------------------------------------------------------------
if ismember('u_north',Vars)
  fprintf(1,'\n North \n');
  Tr=[];
  dx   = ll_dx(xv(end,:), yv(end,:)); dx=repmat(dx(:)',[N 1]);
  hh   = hv(end,:);
  mask = mv(end,:);  mask=repmat(mask(:)',[N 1]);
  sign_=-1;

  %v =use(clm,'v','eta_v','end');
  v =use(bry,'v_north');
  zeta=use(bry,'zeta_north');
  for i=1:Times
    vv = squeeze(v(i,:,:));
    vv=vv.*mask;
    %ssh=squeeze(sshv(i,end,:));
    ssh=zeta(i,:);
    [zr,zw]=s_levels(hh,theta_s,theta_b,hc,N,ssh);
    dz=diff(zw');

    [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,vv);
    fprintf(1,fformat,i,Times,[T,Tpos,Tneg]/1E6*sign_);
    Tr(i,:)=[T,Tpos,Tneg]/1E6*sign_;
  end
  Tb{4}=Tr;
end


tot=0;
for i=1:length(Tb)
  if ~isempty(Tb{i})
    tot = tot+Tb{i};
  end
end
tot=tot/length(Tb);
