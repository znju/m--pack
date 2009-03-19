function res=isin(a,b)
%ISIN   Test membership inside iterable
%   Completes ISMENBER allowing to look for any type of data inside
%   a cell. If a cell is not is use the output of ISMEMBER is
%   returned.
%
%   Syntax:
%      IS = ISIN(A,B)
%
%   Inputs:
%     A,B   Look for A inside B
%
%   Outputs:
%     IS   True/False
%
%   Example:
%     isin([1 2],{'123',123,[1,2]})
%
%   MMA 24-5-2007, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

if iscell(b)
  res=0;
  for i=1:length(b)
    if isequal(b{i},a)
      res=1;
      return
    end
  end
else
  res=ismember(a,b);
end
