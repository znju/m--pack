function [x,y,z,v] = pom_slicej(fname,varname,ind,time)
%POM_SLICEJ   Make POM slice across x direction (y=const)
%
%   Syntax:
%      [X,Y,Z,V]  = POM_SLICEJ(FILE,VARNAME,J,T)
%      [DIST,Z,V] = POM_SLICEJ(FILE,VARNAME,J,T)
%
%   Inputs:
%      FILE   POM output file
%      VARNAME   Variable to extract (array with dimension >= 2)
%      J         Indice in y direction
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
%     varname='temp;      % 3-d [or 4-d] array, J [and T] are required
%     j=50;
%     [x,y,z,v] = pom_slicej(file,varname,j)
%     % or
%     [dist,z,v] = pom_slicej(file,varname,j)
%
%     varname='h';        % 2-d array
%     [x,y,z,v] = pom_slicej(file,varname,j)  % z is empty
%     % or
%     [dist,z,v] = pom_slicej(file,varname,j) % z is empty
%
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   01-07-2008

if nargin<4
  time=1;
end

indDim='y';
if nargout==4
  [x,y,z,v] = pom_slicei(fname,varname,ind,time,indDim);
else
  [d,z,v] = pom_slicei(fname,varname,ind,time,indDim);
  x=d;
  y=z;
  z=v;
end
