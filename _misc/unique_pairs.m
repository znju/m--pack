function [x,y,I]=unique_pairs(x0,y0)
%UNIQUE_PAIRS   Set unique pairs in two vectors
%   Given two vectors, returns the pairs (xi,yi) without repetition.
%
%   Syntax:
%      [XI,YI,I] = UNIQUE_PAIRS(X,Y)
%
%   Inputs:
%      X, Y     Vectors
%
%   Outputs:
%      XI, YI   X, Y without repeated pairs
%      I        Index  of XI, YI
%
%   Example:
%     [xi,yi,i]=unique_pairs([1,1,3,4],[2,2,0,5]);
%
%   MMA 24-5-2007, martinho@fis.ua.pt
%
%   See also ISIN

% Department of Physics
% University of Aveiro, Portugal

x=[];
y=[];
I=[];
tmp={};
for i=1:length(x0)
  if ~isin([x0(i) y0(i)],tmp)
    tmp{end+1}=[x0(i) y0(i)];
    x(end+1)=x0(i);
    y(end+1)=y0(i);
    I(end+1)=i;
  end
end
