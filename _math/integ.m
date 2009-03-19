function result = integ(x,y)
%INTEG   Riemann integration
%   Calculate numeric integral of y=f(x).
%
%   Syntax:
%      RES = INTEG(X,Y)
%
%   Inputs:
%      X, Y   Vectors, Y=f(X)
%
%   Example:
%      x=linspace(0,pi/2,10);
%      y=sin(x);
%      res=integ(x,y)
%
%   MMA 22-4-2002, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   27-05-2008 - Allow len x = len y +1

if nargin ~=2
  error('wrong input args...');
end

x=x(:)';
y=y(:)';

if length(x)==length(y)+1
  yi=y;
  dxi=diff(x);
else
  xi=(x(2:end)+x(1:end-1))/2;
  yi=interp1(x,y,xi);
end
dxi=diff(x);
result=sum(dxi.*yi);
