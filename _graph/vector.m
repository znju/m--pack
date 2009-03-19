function handle = vector(P0,U,a,Fi,color,fillit)
%VECTOR   Draw arrow 2D or 3D (w=0)
%
%   Syntax:
%      HANDLES = VECTOR(P0,U,A,FI,COLOR,FILLIT)
%
%   Inputs:
%      P0       Arrow origin [ <x y> <x y z> ]
%      U        Speed vector   [ <u v> <u v 0> ]
%      A        Tip length with respect to intensity or absolute
%               length if is a string [ <value> <string> {0.3} ]
%      FI       Tip angle (deg) [ 30 ]
%      COLOR    Color of arrow [ 'k' ]
%      FILLIT   Fill arrow tip [ {0} | 1 ]
%
%   Output:
%      HANDLES   Handles of lines and filled surface
%
%   Comment:
%      This is actually a 2D arrow, but can be plotted in 3D on a z=0
%      surface (w=0)
%
%   Example:
%      figure
%      handles=vector([0 0],[1 1],.3,20,'r',1);
%      axis equal
%
%   MMA 13-1-2003, martinho@fis.ua.pt
%
%   See also CONE3D

%   Department of physics
%   University of Aveiro

%   ??-07-2004 - No plot if 0 or nan

handle=[];

if nargin < 6, fillit=0;  end
if nargin < 5, color='k'; end
if nargin < 4, Fi=30;     end
if nargin < 3, a=.3;      end
if nargin < 2
  error('P0 and U not specified!');
  return
end

% no plot for zero or nan:
if any(isnan(U)) | all(U==0)
  return
end

amp=norm(U(1:2));
if isstr(a)
  a=str2num(a);
else
  a=amp*a;
end

if length(P0)~=length(U)
  error('P0 must have same size as U');
  return
end
if length(U) == 3 & U(3)~=0
  error('U(3) must be 0!! use cone3D instead');
  return
end

h=ishold;
hold on
%teta=atan3(U(2),U(1));
teta = atan2(U(2),U(1))*180/pi;
fi=(180-Fi+teta)*pi/180;
fii=(180+Fi+teta)*pi/180;
Fi=Fi*pi/180;
P1=P0+U;
P2=[P1(1)+a*cos(fi)/cos(Fi)  P1(2)+a*sin(fi)/cos(Fi)  P1(end)];
P3=[P1(1)+a*cos(fii)/cos(Fi) P1(2)+a*sin(fii)/cos(Fi) P1(end)];

if length(P0) == 2
  handle.plot=plot([P0(1) P1(1) NaN P2(1) P1(1) P3(1)],...
                    [P0(2) P1(2) NaN P2(2) P1(2) P3(2)],color);
  if fillit == 1
    handle.fill=fill([P2(1) P1(1) P3(1)],...
                     [P2(2) P1(2) P3(2)],color);
    set(handle.fill,'EdgeColor',color);
  end
elseif length(P0) == 3
  handle.plot=plot3([P0(1) P1(1) NaN P2(1) P1(1) P3(1)],...
                    [P0(2) P1(2) NaN P2(2) P1(2) P3(2)],...
                    [P0(3) P1(3) NaN P2(3) P1(3) P3(3)],color);
  if fillit == 1
    handle.fill=fill3([P2(1) P1(1) P3(1)],...
                      [P2(2) P1(2) P3(2)],[P2(3) P1(3) P3(3)],color);
    set(handle.fill,'EdgeColor',color);
  end
end

if h~=1
  hold off
end
