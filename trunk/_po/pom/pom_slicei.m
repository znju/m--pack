function [x,y,z,v] = pom_slicei(fname,varname,ind,time,indDim)
%POM_SLICEI   Make POM slice across y direction (x=const)
%
%   Syntax:
%      [X,Y,Z,V]  = POM_SLICEI(FILE,VARNAME,I,T)
%      [DIST,Z,V] = POM_SLICEI(FILE,VARNAME,I,T)
%
%   Inputs:
%      FILE   POM output file
%      VARNAME   Variable to extract (array with dimension >= 2)
%      I         Indice in x direction
%      T         Time indice (1 by default)
%
%   Outputs:
%     X   Position x (east_u, east_v or east_e)
%     Y   Position y (north_u, north_v or north_e)
%     Z   Depth (at zz or z points)
%     DIST   Distance (m)
%     V   Variable at slice
%
%   Examples:
%     file='pom.nc.0010';
%     varname='temp;      % 3-d [or 4-d] array, I [and T] are required
%     i=50;
%     [x,y,z,v] = pom_slicei(file,varname,i)
%     % or
%     [dist,z,v] = pom_slicei(file,varname,i)
%
%     varname='h';        % 2-d array
%     [x,y,z,v] = pom_slicei(file,varname,i)  % z is empty
%     % or
%     [dist,z,v] = pom_slicei(file,varname,i) % z is empty
%
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   01-07-2008

if nargin <5
  indDim='x';
end

if nargin <4
  time=1;
end

x=[];
y=[];
z=[];
v=[];

Uvars={'u','wvsurf','uab'};
Vvars={'v','wvsurf','vab'};
Wvars={'w'};

if ismember(varname,Uvars)
  [x,y,h,m]=pom_grid(fname,'u',indDim,ind);
elseif ismember(varname,Vvars)
  [x,y,h,m]=pom_grid(fname,'v',indDim,ind);
else
  [x,y,h,m]=pom_grid(fname,'r',indDim,ind);
end

is3d=n_vardimexist(fname,varname,'z');

T   = n_dim(fname,'time');
S   = n_dim(fname,'z');
Nw  = S;
Nr  = S-1;
Ind = n_dim(fname,indDim);

if ind > Ind | ind <=0
  fprintf(1,'» ind = %g exceeds %s dimension (%g)\n',ind,indDim,Ind);
  return
end
if time > T | time <=0
  fprintf(1,'» time = %g exceeds time dimension (%g)\n',time,T);
  return
end

x=x(:)';
y=x(:)';
v=use(fname,varname,indDim,ind,'time',time);


if is3d
   m=repmat(m(:)',[S 1]);
end
v(m==0)=nan;

dst=spheric_dist(y(2:end),y(1:end-1),x(2:end),x(1:end-1));
dst=[0; cumsum(dst(:))]; dst=dst(:)';

if is3d
  % calc s-levels:
  z   = use(fname,'z');
  zz  = use(fname,'zz');

  if strcmpi(indDim,'x')
    ux=Uvars;
    vx=Vvars;
  elseif strcmpi(indDim,'y')
    ux=Vvars;
    vx=Uvars;
  end

  if ismember(varname,ux)
    if ind==1
      ssh = use(fname,'elb','time',time,indDim,ind);
%      h   = use(fname,'h',indDim,ind);
    else
      ssh0 = use(fname,'elb','time',time,indDim,ind-1);
      ssh1 = use(fname,'elb','time',time,indDim,ind);
      ssh  = (ssh0+ssh1)/2;

%      h0   = use(fname,'h',indDim,ind-1);
%      h1   = use(fname,'h',indDim,ind);
%      h    = (h0+h1)/2;
    end
  elseif ismember(varname,vx)
     ssh = use(fname,'elb','time',time,indDim,ind);
     ssh = (ssh(2:end)+ssh(1:end-1))/2;
     ssh(2:end+1)=ssh;

%     h   = use(fname,'h',indDim,ind);
%     h   = (h(2:end)+h(1:end-1))/2;
%     h(2:end+1)=h;
  else
     ssh = use(fname,'elb','time',time,indDim,ind);
%     h   = use(fname,'h',indDim,ind);
  end

  [zr,zw]=pom_s_levels(zz,z,h,ssh,1);
  if ismember(varname,Wvars)
    z=zw;
    N=Nw;
  else
    z=zr;
    N=Nr;
  end
  z=permute(squeeze(z),[2 1]);

  v=v(1:N,:);
  v=flipud(v);
  x=repmat(x,[N 1]);
  y=repmat(y,[N 1]);
  dst=repmat(dst,[N 1]);
else
  x=x(:)';
  y=y(:)';
  v=v(:)';
  dstv=dst(:)';
end

if nargout==3
  x=dst;
  y=z;
  z=v;
end
