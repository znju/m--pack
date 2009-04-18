function ZI = interp2pi(X,Y,Z,XI,YI,opt,method)
%INTER2PI   Angles interpolation
%   Same as interp2 or griddata, but to deal with angles.
%   The aim is avoid false discontinuities as in the case of
%   interpolation of an angle between 350 and 10, for instance.
%   Interp2 or griddata would give 180, while correct result is zero.
%
%   Syntax:
%      ZI = INTERP2PI(X,Y,Z,XI,YI,OPT,METHOD)
%
%   Inputs:
%      X, Y, Z   Original positions (X,Y) and values (Z)
%      XI, YI    Interpolation positions
%      OPT       Use interp2 or griddata [ {'int'} | 'gri' ]
%      METHOD    Interpolation method [ 'linear' ]
%
%   Output:
%      ZI   Interpolation of Z in XI x YI
%
%   Comments:
%      See interp2 and griddata for additional help.
%      METHOD must be compatible with OPT.
%      Z and ZI are angles in degrees.
%
%   Example:
%      x=1:10;
%      y=1:10;
%      [x,y]=meshgrid(x,y);
%      z=repmat([300:10:350 10:10:40]',1,10);
%
%      x1=1:.5:10;
%      y1=1:.5:10;
%      [x1,y1]=meshgrid(x1,y1);
%
%      z0=interp2(x,y,z,x1,y1);
%      z1=interp2pi(x,y,z,x1,y1);
%
%      subplot(2,2,1)
%      pcolor(x,y,z),    colorbar, title('original')
%      subplot(2,2,2)
%      pcolor(x1,y1,z0), colorbar, title('interp2')
%      subplot(2,2,3)
%      pcolor(x1,y1,z1), colorbar, title('interp2pi')
%
%   MMA 11-9-2002, martinho@fis.ua.pt
%   Revision 10-2003
%
%   See also ATAN3

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 7
  method='linear';
end
if nargin < 6
   opt='int';
end

Z=Z*pi/180;
Zs=sin(Z);
Zc=cos(Z);

if opt(1:3)=='int'
  ZIc=interp2(X,Y,Zc,XI,YI);
  ZIs=interp2(X,Y,Zs,XI,YI);
elseif opt(1:3)=='gri'
  ZIc=griddata(X,Y,Zc,XI,YI,method);
  ZIs=griddata(X,Y,Zs,XI,YI,method);
else
  error('## opt is wrong.')
end

ZI=atan3(ZIs,ZIc);

function teta = atan3(y,x)
%ATAN3   Inverse tangent [0:360[
%   Is the same as atan2(x,y)*180/pi, but with positive output.
%
%   Syntax:
%      TETA = ATAN3(Y,X)
%
%   Inputs:
%      Y, X   Same as in atan2
%
%   Output:
%      TETA   Angle (deg)
%
%   MMA 13-1-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

teta=atan2(y,x)*180/pi;
teta(teta<0)=teta(teta<0)+360;
