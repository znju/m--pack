function [x,y,z,v] = pom_slicek(fname,varname,ind,time)
%POM_SLICEK   Make POM slice at s-level (k=const)
%
%   Syntax:
%      [X,Y,Z,V]  = POM_SLICEK(FILE,VARNAME,K,T)
%      [X,Y,V]    = POM_SLICEK(FILE,VARNAME,K,T)
%
%   Inputs:
%      FILE   POM output file
%      VARNAME   Variable to extract (array with dimension >= 2)
%      K         S-level Indice
%      T         Time indice (1 by default)
%
%   Outputs:
%     X   Position x (east_u, east_v or east_e)
%     Y   Position y (north_u, north_v or north_e)
%     Z   Depth (at zz or z points)
%     V   Variable at slice
%
%   Examples:
%     file='pom.nc.0010';
%     varname='temp;      % 3-d [or 4-d] array, K [and T] are required
%     k=50;
%     [x,y,z,v] = pom_slicek(file,varname,k)
%
%     varname='h';        % 2-d array
%     [x,y,z,v] = pom_slicek(file,varname)  % z is empty
%     % or
%     [x,y,v] = pom_slicek(file,varname)
%
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   01-07-2008

if nargin < 4
  time=1;
end

if nargin <3
  ind=0; % means no k dependence
end

x=[];
y=[];
z=[];
v=[];

Uvars={'u','wvsurf','uab'};
Vvars={'v','wvsurf','vab'};
Wvars={'w'};

if ismember(varname,Uvars)
  [x,y,h,m]=pom_grid(fname,'u');
elseif ismember(varname,Vvars)
  [x,y,h,m]=pom_grid(fname,'v');
else
  [x,y,h,m]=pom_grid(fname,'r');
end

T=n_dim(fname,'time');
S=n_dim(fname,'z');

is3d=n_vardimexist(fname,varname,'z');

if is3d & (ind > S | ind <=0)
  fprintf(1,'» s = %g exceeds z dimension (%g)\n',ind,S);
  return
end
if time > T | time <=0
  fprintf(1,'» time = %g exceeds time dimension (%g)\n',time,T);
  return
end

v=use(fname,varname,'z',ind,'time',time);
v(m==0)=nan;
if nargout==3
  z=v;
elseif is3d
  % calc s-level k
  [zr,zw,zrsub]=pom_s_levels(fname,time);

  if ismember(varname,Wvars)
    z=squeeze(zw(:,:,ind));
  else
    if ind==S, z=zrsub;
    else, z=squeeze(zr(:,:,ind));
    end
  end

  if ismember(varname,Uvars)
    z=(z(:,2:end)+z(:,1:end-1))/2;
    z(:,2:end+1)=z;
  elseif ismember(varname,Vvars)
    z=(z(2:end,:)+z(1:end-1,:))/2;
    z(2:end+1,:)=z;
  end

end
