function [U,V,x,y] = occam_uvbar(fname)
%OCCAM_UVBAR   Compute OCCAM barotropic currents
%
%   Syntax:
%      [UBAR,VBAR,X,Y] = GET_OCCAM_UVBAR(FNAME)
%
%   Inputs:
%      FNAME   OCCAM output file
%
%   Outputs:
%     U,V  Barotropic currents m.s-1
%     X,Y  U, V lon x lat positions
%
%   MMA 12-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

xi  = n_filedim(fname,'LONGITUDE_U');
eta = n_filedim(fname,'LATITUDE_U');
n   = n_filedim(fname,'DEPTH');

u=use(fname,'U_VELOCITY__MEAN_')*0.01;
v=use(fname,'V_VELOCITY__MEAN_')*0.01;

Ze=use(fname,'DEPTH_EDGES')*0.01;
dz=diff(Ze);
dz=repmat(dz,[1 eta xi]);

ssh=use(fname,'SEA_SURFACE_HEIGHT__MEAN_')*0.01;
dz(1,:,:)=squeeze(dz(1,:,:))+ssh;

U=sum(u.*dz)./sum(dz); U=squeeze(U);
V=sum(v.*dz)./sum(dz); V=squeeze(V);

if nargout >2
  x=use(fname,'LONGITUDE_U'); x(x>180)=x(x>180)-360;
  y=use(fname,'LATITUDE_U');
  [x,y]=meshgrid(x,y);
end
