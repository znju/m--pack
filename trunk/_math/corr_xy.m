function r = corr_xy(x,y)
%CORR_XY   Correlation coefficient between two series
%   Computes the correlation coefficient between two series.
%
%   Syntax:
%      R = CORR_XY(X,Y)
%
%   Inputs:
%      X, Y   Series
%
%   Output:
%      R   Correlation coefficient
%
%   Example:
%      x=cos(2*pi*[1:100]/12);
%      y=x+rand(size(x));
%      r=corr_xy(x,y)
%
%   MMA 2-4-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

x=double(x);
y=double(y);
x=x-mean(x);
y=y-mean(y);
r=sum(sum(x.*y))/sqrt(sum(sum(x.*x))*sum(sum(y.*y)));
