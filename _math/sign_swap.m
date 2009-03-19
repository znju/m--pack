function [I,Y]=sign_swap(x)
%SIGN_SWAP   Get indices of sign change
%   The index is the one before change of sign.
%
%   Syntax:
%      [I,Y] = SIGN_SWAP(X)
%
%   Input:
%      X   Data vector
%
%   Output:
%      I   Indices
%      Y   X(I)
%
%   Example:
%      t=linspace(0,3*pi,30);
%      x=sin(t);
%      [i,y]=sign_swap(x);
%      figure
%      plot(t,x,'k.'); hold on
%      plot(t(i),y,'ro')
%      plot([t(1) t(end)], [0 0])
%
%   MMA 22-4-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

n=length(x);
cont=0;
I=0;
Y=0;
for i=1:n-1
  if ~isequal(sign(x(i+1)),sign(x(i))) & sign(x(i))~=0
    cont=cont+1;
    I(cont)=i;
    Y(cont)=x(i);
  end
end
