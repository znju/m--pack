function [y, j] = unsort(x, i, dim)

% unsort -- Unsort a sorted vector.
%  [y, j] = unsort(x, i) restores sorted vector x
%   to its original sequence, using indices i from
%   the original call to SORT.  If x is a matrix,
%   the unsorting is columnwise, as in SORT.
%  [y, j] = unsort(x, i, dim) performs its work
%   in the dim direction, as in SORT.
%
% Also see: SORT.
 
% Copyright (C) 2001 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 16-Oct-2001 18:22:22.
% Updated    20-Jun-2003 12:04:35.

if nargin < 2, help(mfilename), return, end

% Sort the indices.

if nargin > 2
    [ignore, j] = sort(i, dim);
else
    [ignore, j] = sort(i);
end

% Dimensions.

sx = size(x);
ndims = length(sx);
    
if nargin < 3
    if prod(sx) == max(sx)
        dim = find(sx == max(sx));
    else
        dim = 1;
    end
end

if dim < 1 | dim > ndims
    error([' ## ' mfilename ': Bad dim.'])
end

% Permute the dim into dimension #1.

dims = rem((0:ndims-1) + dim-1, ndims) + 1;
x = permute(x, dims);
j = permute(j, dims);

% Reshape ND j into a matrix.

sj = size(j);
j = reshape(j, [sj(1) prod(sj)/sj(1)]);
[m, n] = size(j);

% Convert j to 1-d indices.

j1d = j;
for k = 1:n
    j1d(:, k) = j1d(:, k) + (k-1)*m;
end

% Unsort x via 1-d indices.

y = x(j1d);
y = reshape(y, sj);
j = reshape(j, sj);

% Un-permute.

y = ipermute(y, dims);
j = ipermute(j, dims);
