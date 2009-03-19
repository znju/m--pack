function handle = sph(pos,r,n,fcolor,ecolor)
%SPH   Draw sphere taking in account DataAspectRatio
%
%   Syntax:
%      HANDLE = SPH(POS,R,N,FCOLOR,ECOLOR)
%
%   Inputs:
%      POS      Centre of the sphere [ <x y z> ]
%      R        Radius, in the scale of axis with lower DataAspectRatio
%      N        Argument of SPHERE [ 20 ]
%      FCOLOR   FaceColor [ 'none' ]
%      ECOLOR   EdgeColor [ 'r' ]
%
%   Output:
%      HANDLE   Surf handle
%
%   Example:
%      figure;
%      peaks;
%      sph([1 0 8],1);
%      camlight
%
%   MMA 2003, martinho@fis.ua.pt
%
%   See also SPH2

%   Department of physics
%   University of Aveiro

%   07-07-2005 - Improvement

if nargin < 5
  ecolor = 'r';
end
if nargin < 4
  fcolor = 'none';
end
if nargin < 3
  n=20;
end

ar=get(gca,'DataAspectRatio');

[x,y,z]=sphere(n);

x=x*r;
y=y*r;
z=z*r;

x=x*ar(1)+pos(1);
y=y*ar(2)+pos(2);
z=z*ar(3)+pos(3);

h=ishold;
hold on

handle=surf(x,y,z);
set(handle,'facecolor',fcolor,'edgecolor',ecolor);
set(gca,'DataAspectRatio',ar);

if ~h
  hold off
end
