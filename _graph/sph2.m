function handle = sph2(pos,r,n,fcolor,ecolor)
%SPH2   Draw circle taking in account DataAspectRatio
%   Well this is nothing more than a circle.
%
%   Syntax:
%      HANDLE = SPH2(POS,R,N,FCOLOR,ECOLOR)
%
%   Inputs:
%      POS      Centre of the circle [ <x y z>, <x y> ]
%      R        Radius, in the scale of axis with lower DataAspectRatio
%      N        Number of points on the circumference [ 20 ]
%      FCOLOR   FaceColor [ 'blue' ]
%      ECOLOR   EdgeColor [ 'r' ]
%
%   Output:
%      HANDLE   Fill3 handle
%
%   Example:
%      figure,peaks; hold on
%      sph2([1 0 9],1)
%      camlight
%
%   MMA 11-5-2004, martinho@fis.ua.pt
%
%   See also SPH

%   Department of physics
%   University of Aveiro

%   07-07-2004 - Improvement

if nargin < 5
  ecolor = 'r';
end
if nargin < 4
  fcolor = 'b';
end
if nargin < 3
  n = 20;
end

ar=get(gca,'DataAspectRatio');

tt = linspace(0,360,n+1);
x=cos(tt*pi/180);
y=sin(tt*pi/180);

x=x*r;
y=y*r;
%z=z*r;

x=x*ar(1)+pos(1);
y=y*ar(2)+pos(2);
%z=z*ar(3)+pos(3);
if length(pos) == 2
  pos(3)=0;
end
z=repmat(pos(3),size(x));

h=ishold;
hold on

handle=fill3(x,y,z,'b');
set(handle,'facecolor',fcolor,'edgecolor',ecolor);
set(gca,'DataAspectRatio',ar);

if ~h
  hold off
end
