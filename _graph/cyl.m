function handle=cyl(P0,P1,r,fcolor,ecolor)
%CYL   Draw cylinder
%
%   Syntax:
%      HANDLE = CYL(P0,P1,R,FCOLOR.ECOLOR)
%
%   Inputs:
%      P0       Initial position [ <x y z> ]
%      P1       End of cylinder [ <x y z> ]
%      R        Radius  [ <r> ]
%      FCOLOR   FaceColor [ 'none' ]
%      ECOLOR   EdgeColor [ 'r' ]
%
%   Output:
%      HANDLE   surf handle
%
%   Example:
%      figure
%      cyl([0 0 0],[10 20 5],1,'g','none'), axis equal
%      axis([-2 12 -2 22 -2 7]), box on
%      view([12 14]); camlight
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also SPH, SPH2

%   Department of physics
%   University of Aveiro

%   30-09-2005 - Small improvements

if nargin < 5
  ecolor = 'r';
end
if nargin < 4
  fcolor = 'none';
end

% divisions  (number of rectangles)
nd= 20;

tmp=P1-P0;
[tet,fi,L]=cart2sph(tmp(1),tmp(2),tmp(3));
tet=tet*180/pi;
fi=fi*180/pi;fi=fi-90;

tt=linspace(0,2*pi,nd);
%circ:
xc=r*sin(tt);
yc=r*cos(tt);
zc=0*ones(size(yc));

xc2=xc;
yc2=yc;
zc2=zc+L;

tet = repmat(tet,size(xc));
fi  = repmat(fi,size(xc));

[x,y,z]    = rot3d(xc,yc,zc,tet,fi);
[xx,yy,zz] = rot3d(xc2,yc2,zc2,tet,fi);

X=[x; xx]+P0(1);
Y=[y; yy]+P0(2);
Z=[z; zz]+P0(3);

handle=surf(X,Y,Z);
set(handle,'facecolor',fcolor);
set(handle,'edgecolor',ecolor);

function [x2,y2,z2]=rot3d(x,y,z,tt,fi)
%ROT3D   3D solid rotation
%   Rotation arround OY (X to Z) followed by rotation arround OZ
%   (X to Y).
%
%   Syntax:
%      [X,Y,Z] = ROT3D(XI,YI,ZI,TH,PHI)
%
%   Inputs:
%      XI, YI, ZI   Initical positions, N-D arrays
%      TH    OZ rotation angle (deg)
%      PHI   OY rotation angle (deg)
%
%   Outputs:
%      X, Y, Z
%
%   Example:
%      figure
%      r = 1;
%      t = linspace(0,2*pi,20);
%      x = r*cos(t);
%      y = r*sin(t);
%      z = zeros(size(x));
%      plot3([-1 1 nan 0 0 nan 0 0],[0 0 nan -1 1 nan 0 0],[0 0 nan 0 0 nan -1 1]);
%      hold on, axis equal
%      plot3(x,y,z,'ro-')
%      [x,y,z] = rot3d(x,y,z,40,30)
%      plot3(x,y,z,'ko-')
%      text(1,0,0,'x');
%      text(0,1,0,'y');
%      text(0,0,1,'z');
%      view(75,25)
%
%   MMA 13-1-2003, martinho@fis.ua.pt
%
%   See also ROT2D

%   Department of Physics
%   University of Aveiro, Portugal

%   07-07-2004 - Correction
%   02-10-2005 - allow inputs as N-D arrays

x2=[];
y2=[];
z2=[];

theSize = size(x);
n = prod(theSize);

x = reshape(x,n,1);
y = reshape(y,n,1);
z = reshape(z,n,1);

if size(tt)==1 & size(fi)==1
  tt = repmat(tt,n,1);
  fi = repmat(fi,n,1);
else
  tt = reshape(tt,n,1);
  fi = reshape(fi,n,1);
end

v=[x y z];
v2 = rot(v,tt,fi);
x2=v2(1,:);  x2 = reshape(x2,theSize);
y2=v2(2,:);  y2 = reshape(y2,theSize);
z2=v2(3,:);  z2 = reshape(z2,theSize);

function v2 = rot(v,tt,fi)
v = repmat(v,1,3);
v  = reshape(v',1,prod(size(v)));
tt=-tt*pi/180; tt=tt';
fi=-fi*pi/180; fi=fi';
n=length(tt);

M = [ cos(tt).*cos(fi) ;  sin(tt)          ;   cos(tt).*sin(fi) ;
     -sin(tt).*cos(fi) ;  cos(tt)          ;  -sin(tt).*sin(fi) ;
     -sin(fi)          ;  zeros(size(tt))  ;   cos(fi)           ];

M  = reshape(M,1,9*n);
v2 = M.*v;
v2 = reshape(v2,3,3*n);
v2 = sum(v2);
v2 = reshape(v2,3,n);
