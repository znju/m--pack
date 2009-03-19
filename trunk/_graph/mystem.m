function handle = mystem(x,y,r,options)
%MYSTEM   Modified version of stem
%   Creates a plot similar to stem, but using a line of desired
%   length as marker.
%
%   Syntax;
%      HANDLE = MYSTEM(X,Y,R,OPTIONS)
%
%   Inputs:
%      X         Vector x
%      Y         Vector y=f(x)
%      R         Length/2 of line to use as marker [ 0.05 ]
%      OPTIONS   Plot options [ 'b' ]
%
%   Output:
%      HANDLE   Plotted line handle
%
%   Example:
%      figure
%      h=mystem(1:.2:10,sin(1:.2:10),.2,'r');
%
%   MMA 2003, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

if nargin < 4
  options='b';
end
if nargin < 3
  r=.05;
end

X=[];
Y=[];
for i=1:length(x)
%  circlex=x(i)+r*cos(linspace(0,2*pi,20));
%  circley=y(i)+r*sin(linspace(0,2*pi,20));
  crossx=[x(i)-r x(i)+r];
  crossy=[y(i) y(i)];
  X=[X crossx nan x(i) x(i) nan];
  Y=[Y crossy nan y(i) 0 nan];
end

handle=plot(X,Y,options);
