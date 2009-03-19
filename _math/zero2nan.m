function M = zero2nan(M,val)
%ZERO2NAN   Convert zeros to NaN
%   Converts all zeros (or VAL) entries to NaN.
%
%   Syntax:
%      ME = ZERO2NAN(MI,VAL)
%
%   Input:
%      MI    Array where to search
%      VAL   Value to occupy the place of the zeros (VAL) [ NaN ]
%
%   Output:
%      ME   Array with zeros (VAL) converted to NaN
%
%   MMA 1-2003, martinho@fis.ua.pt
%
%   See also NAN2ZERO, NAN_COUNT

%   Department of Physics
%   University of Aveiro, Portugal

if nargin==1
 val=0;
end
I=find(M==val);
M(I)=NaN;
