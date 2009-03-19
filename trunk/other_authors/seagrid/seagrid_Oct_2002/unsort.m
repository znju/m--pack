function [y, j] = unsort(x, i)

% unsort -- Unsort a sorted variable.
%  [y, j] = unsort(x, i) restores sorted vector x
%   to its original order, using indices i from
%   the original call to "sort".  The indices j
%   are the inverse of i, such that y = x(j).
 
% Copyright (C) 2001 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 16-Oct-2001 18:22:22.
% Updated    16-Oct-2001 18:22:22.

if nargin < 2, help(mfilename), return, end

[ignore, j] = sort(i);
y = x(j);
