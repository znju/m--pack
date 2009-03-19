function handle = cone3d(P0,U,fi,R,color,cl)
%CONE3D   Draw arrow 3D
%   HANDLE = CONE3D(P0,U,FI,R,COLOR,CL)
%
%   input:
%      P0      initial position [ <x y z> ]
%      U       velocity [ <u v w> ]
%      FI      tip angle (degrees) [ 20 ]
%      R       tip scale [ <value> <value as string> {0.2} ]
%              or absolute length if is a string
%      COLOR   tip color [ 'b' ]
%      CL      line color [ 'r' ]
%
%   output:
%      HANDLE   structure of handles
%
%   example:
%      figure,
%      handle=cone3d([0 0 0],[1 1 1],20,'.1')
%      axis equal, box on, grid off, light, view(3)
%
%   MMA 14-1-2003, martinho@fis.ua.pt
%   Revision 10-2003
%   Modified Aug-2004: no plot if 0 or nan
%
%   See also VECTOR

handle = [];

if nargin < 6
   cl=[1 0 0];
   if nargin < 5
      color=[0 0 1];
      if nargin < 4
         R=.2;
         if nargin < 3
            fi=20;
            if nargin < 2
               error('cone3D needs at least P0 and U as input arguments');
               return
            end
         end
      end
   end
end
if ~((size(P0) == [1 3] | size(P0) == [3 1]) & (size(U) == [1 3] | size(U) == [3 1]))
   error('P0 and U must be vectors with length 3');
   return
elseif ~isequal(size(U),size(P0))
   U=U';
end

% no plot for zero or nan:
if any(isnan(U)) | all(U==0)
  return
end

h=ishold;
hold on

V=norm(U);
P1=[V 0 0];
if length(R) ~= 1 & nargin >= 4
   R=str2num(R);
   L=R;
else
   L=V*R;
end
r=L*tan(fi*pi/180);

%=====================================================================
% non-rotated vars:
tt=linspace(0,2*pi,100);
%plot circ:
zc=r*sin(tt);
yc=r*cos(tt);
xc=(V-L)*ones(size(yc));
%surf:
x=[xc;P1(1)+zeros(size(tt))];
y=[yc;P1(2)+zeros(size(tt))];
z=[zc;P1(3)+zeros(size(tt))];

%=====================================================================
% rotation:
[th,phi,r]=cart2sph(U(1),U(2),U(3));
%surf:
[x y z]=rot3d(x,y,z,th*180/pi,phi*180/pi);
handle.surf=surf(x+P0(1),y+P0(2),z+P0(3),'facecolor',color,'edgecolor','none');
%plot line:
p1=P0+U;
[p1(1) p1(2) p1(3)]=rot3d(P1(1),P1(2),P1(3),th*180/pi,phi*180/pi);
handle.line=plot3([0 p1(1)]+P0(1),[0 p1(2)]+P0(2),[0 p1(3)]+P0(3),'color',cl);
%plot circ:
[xc yc zc]=rot3d(xc,yc,zc,th*180/pi,phi*180/pi);
handle.circ=plot3(xc+P0(1),yc+P0(2),zc+P0(3),'color',cl);

if h ~= 1
   hold off
end
