function [x,y,z,v] = pom_slicez(fname,varname,ind,time)
%POM_SLICEZ   Make POM slice at z=const
%
%   Syntax:
%      [X,Y,Z,V]  = POM_SLICEZ(FILE,VARNAME,Z,T)
%      [X,Y,V]    = POM_SLICEZ(FILE,VARNAME,Z,T)
%
%   Inputs:
%      FILE   POM output file
%      VARNAME   Variable to extract (3,4-d, with z dependence)
%      Z        Depth (negative below zero)
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
%     varname='temp;      % 3-d [or 4-d] array, z [and T] are required
%     z=-200;
%     [x,y,z,v] = pom_slicez(file,varname,z)
%
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   01-07-2008

x=[];
y=[];
z=[];
v=[];

if nargin <4
  time=1;
end

depth=ind;

Uvars={'u','wvsurf','uab'};
Vvars={'v','wvsurf','vab'};
Wvars={'w'};

if ismember(varname,Uvars)
  [x,y]=pom_grid(fname,'u');
elseif ismember(varname,Vvars)
  [x,y]=pom_grid(fname,'v');
else
  [x,y]=pom_grid(fname,'r');
end

T   = n_filedim(fname,'time');
Nr  = n_filedim(fname,'z')-1;
Nw  = n_filedim(fname,'z');
Xi  = n_filedim(fname,'x');
Eta = n_filedim(fname,'y');

if time > T | time <=0
  fprintf(1,'» time = %g exceeds time dimension (%g)\n',time,T);
  return
end

% calc s-levels:
[zr,zw]=pom_s_levels(fname,time,1);
if ismember(varname,Uvars)
  zr=(zr(:,2:end,:)+zr(:,1:end-1,:))/2;
  zr(:,2:end+1,:)=zr;
elseif ismember(varname,Vvars)
  zr=(zr(2:end,:,:)+zr(1:end-1,:,:))/2;
  zr(2:end+1,:,:)=zr;
end

% load var:
v=use(fname,varname,'time',time);
v=flipdim(v,1);

% start interp:
if ~ismember(varname,Wvars)
  z = repmat(nan,[Nr+2 Eta Xi]);
  z(2:end-1,:,:) = permute(zr, [3 1 2]);
  v=v(2:end,:,:);
else
  z = repmat(nan,[Nw+2 Eta Xi]);
  z(2:end-1,:,:) = permute(zw,[3 1 2]);
end

z(1,:,:) = -inf;
z(end,:,:) = inf;

% find z indices with depth above z:
i=z > depth;
iM = i(2:end,:,:) - i(1:end-1,:,:);
iM(2:end+1,:,:) = iM;
iM(1,:,:) = zeros(size(iM(1,:,:)));
iM = logical(iM);

% find z indices with depth under z:
i=z < depth;
im = i(1:end-1,:,:) - i(2:end,:,:);
im(end+1,:,:) = zeros(size(iM(1,:,:)));
im = logical(im);

% get interpolation coefficients:
zUp   = reshape(z(iM),size(z,2),size(z,3));
zDown = reshape(z(im),size(z,2),size(z,3));
coefUp   = (zUp-depth)./(zUp-zDown);
coefDown = (depth-zDown)./(zUp-zDown);

% z not needed anymore:
z=repmat(depth,size(z,2),size(z,3));

v(2:end+1,:,:) = v;
v(1,:,:)       = repmat(nan,size(v,2),size(v,3));
v(end+1,:,:)   = repmat(nan,size(v,2),size(v,3));

vUp   = reshape(v(iM),size(z,1),size(z,2));
vDown = reshape(v(im),size(z,1),size(z,2));
v = coefUp.*vDown + coefDown.*vUp;

if nargout == 1
  x = v;
elseif nargout==3
  z=v;
end
