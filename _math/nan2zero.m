function M = nan2zero(M,val)
%NAN2ZERO   Convert NaNs to zero
%   Converts all NaN entries to zero (or VAL).
%
%   Syntax:
%      ME = NAN2ZERO(MI,VAL)
%
%   Inputs:
%      MI    Array where to search
%      VAL   Value to occupy the place of the NaNs [ 0 ]
%
%   Output:
%      ME   Array with NaNs converted to VAL
%
%   MMA 1-2003, martinho@fis.ua.pt
%
%   See also ZERO2NAN, NAN_COUNT

%   Department of Physics
%   University of Aveiro, Portugal

if nargin==1
 val=0;
end

I=isnan(M);
M(I)=val;
