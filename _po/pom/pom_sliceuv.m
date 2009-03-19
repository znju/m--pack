function [x,y,z,u,v] = pom_sliceuv(fname,ind,time)
%POM_SLICEUV   Get horizontal velocity field at POM slice
%
%   Syntax:
%      [X,Y,Z,U,V]  = POM_SLICEUV(FILE,IND,T)
%
%   Inputs:
%      FILE   POM output file
%      IND    S-level indice (IND>0) or depth (IND<0); if 0
%             the barotropic currents are used
%      T         Time indice (1 by default)
%
%   Outputs:
%     X   Position x (east_u, east_v or east_e)
%     Y   Position y (north_u, north_v or north_e)
%     Z   Depth (at zz or z points), is empty if ISBAR
%     U,V   Horizontal velocity field (rotated with -ROT variable
%           from FILE)
%
%   Examples:
%     file='pom.nc.0010';
%     ind=0;
%     [x,y,z,u,v] = pom_sliceuv(file,ind) % z is empty (barotropic uv)
%
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   01-07-2008

if nargin <4
  time=1;
end

if ind==0
  u_name='uab';
  v_name='vab';
else
  u_name='u';
  v_name='v';
end

if ind >= 0
  [xu,yu,zu,u] = pom_slicek(fname,u_name,ind,time);
  [xv,yv,zv,v] = pom_slicek(fname,v_name,ind,time);
else
  [xu,yu,zu,u] = pom_slicez(fname,u_name,ind,time);
  [xv,yv,zv,v] = pom_slicez(fname,v_name,ind,time);
end

xu = (xu(:,1:end-1)+xu(:,2:end))/2; xu = xu(1:end-1,:);
yu = (yu(:,1:end-1)+yu(:,2:end))/2; yu = yu(1:end-1,:);
zu = (zu(:,1:end-1)+zu(:,2:end))/2; zu = zu(1:end-1,:);
u  = (u(:,1:end-1) +u(:,2:end))/2;  u  = u(1:end-1,:);


xv = (xv(1:end-1,:)+xv(2:end,:))/2; xv = xv(:,1:end-1);
yv = (yv(1:end-1,:)+yv(2:end,:))/2; yv = yv(:,1:end-1);
zv = (zv(1:end-1,:)+zv(2:end,:))/2; zv = zv(:,1:end-1);
v  = (v(1:end-1,:) +v(2:end,:))/2;  v  =  v(:,1:end-1);

% xu is now very similar to xv ... but may average them:
x=(xu+xv)/2;
y=(yu+yv)/2;
z=(zu+zv)/2;

% rotate uv with grid angle:
ang=use(fname,'rot');
ang=ang(1:end-1,1:end-1);
[u,v]=rot2d(u,v,ang*180/pi);
