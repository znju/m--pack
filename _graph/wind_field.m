function handles=wind_field(x,y,u,v,divs,len)
%WIND_FIELD   Plot 2D velocity field using weather code
%
%   Syntax:
%      HANDLES = WIND_FIELD(X,Y,U,V,DIVS,LEN)
%
%   Inputs:
%      X, Y    Arrows origin, N-D arrays
%      U, V    Velocity components, N-D arrays
%      DIVS    Wind intensities subdivisions (3 elements), def=[1 2 5]
%      LEN     Length of arrows, default=1
%
%   Outputs:
%      HANDLES   Handles of all lines and fills
%
%   Example:
%      figure, hold on
%      u=1:20;
%      x1=zeros(5,1);
%      y1=[0:-1:-4; 0:-1:-4; 0:-1:-4; 0:-1:-4;]';
%      x=[x1 x1+2 x1+4 x1+6];
%      y=y1(:);
%
%      h=wind_field(x,y,u,0*u);
%
%      for i=1:length(u)
%        text(x(i)+1.2,y(i),num2str(u(i)))
%      end
%      xlim([-1 8])
%      axis off
%
%   MMA 04-06-2009, mma@ua.pt

%   CESAM, Universidade de Aveiro, Portugal

color='k';

if nargin < 6
  len=1;
end

if nargin < 5
  divs=[1 2 5];
end

x=x(:);
y=y(:);
u=u(:);
v=v(:);

h=ishold;
hold on
handles={};
for i=1:length(x)
  handles{i}=wind_fiedl1(x(i),y(i),u(i),v(i),divs,len,color);
end
axis equal
if ~h, hold off, end


function handles=wind_fiedl1(x,y,u,v,divs,len,color)
handles=[];
iU=u+sqrt(-1)*v;
U=abs(iU);
A=angle(iU);

% some settings:
%len = 1;                  % len of arrow
inc = 20;                  % angle of triangles
ry1 = .3 ;                 % height of triangles
rx1 = tan(inc*pi/180)*ry1; % base of triangles
rx2 = 0.6*rx1;             % sep between lines, rate to base of triangles
r2  = 0.5;                 % rate of lines

% data per intensity subdivison:
N(1)=floor(U/divs(3));
tmp=rem(U,divs(3));
N(2)=floor(tmp/divs(2));
tmp=rem(tmp,divs(2));
N(3)=floor(tmp/divs(1));

% main line:
xx=x+len*cos(A);
yy=y+len*sin(A);
handles(end+1)=plot([x xx],[y yy],color);
handles(end+1)=plot(x,y,'.','color',color);

% highest intensity:
xref=len;
for i=1:N(1)
  X=[len len len*(1-rx1)]+xref-len;
  Y=[0 len*ry1 0];
  [X,Y]=rot2d(X,Y,A*180/pi);
  handles(end+1)=fill(X+x,Y+y,color);
  xref=xref-len*(rx1+rx2);
end

% medium intensity:
xref2=xref;
for i=1:N(2)
  X=[len len*(1+rx1)]+xref-len;
  Y=[0  0+len*ry1];
  [X,Y]=rot2d(X,Y,A*180/pi);
  handles(end+1)=plot(X+x,Y+y,color);
  xref=xref-len*rx2;
end

% lowest intensity:
for i=1:N(3)
  X=[len len*(1+rx1*r2)]+xref-len;
  Y=[0  len*ry1*r2];
  [X,Y]=rot2d(X,Y,A*180/pi);
  handles(end+1)=plot(X+x,Y+y,color);
  xref=xref-len*rx2;
end


function [x,y] = rot2d(xi,yi,teta)
%ROT2D   2D rotation
%   Rotates arrays of positions (XI, YI) by the angle theta (polar
%   coordinates).
%
%   Syntax:
%      [X,Y] = ROT2D(XI,YI,THETA)
%
%   Inputs:
%      XI, YI   Initial positionsm, N-D arrays
%      THETA    Angle to rotate (deg), scalar or N-D array
%
%   Output:
%      X, Y   Rotated positions
%
%   Example:
%      figure
%      x=1; y=1;
%      plot([0 x], [0 y]); hold on
%      [x,y]=rot2d(x,y,40);
%      plot([0 x], [0 y],'r'), axis equal
%
%   MMA 13-1-2003, martinho@fis.ua.pt
%
%   See also ROT3D

%   Department of Physics
%   University of Aveiro, Portugal

if nargin ~= 3
   error('rot2d must have x,y and teta as input arguments');
   return
end
if size(xi)~=size(yi)
   error('xi and yi must have same size');
   return
end

teta=teta*pi/180;
[th,r]=cart2pol(xi,yi);
[x,y]=pol2cart(th+teta,r);

