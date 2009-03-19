function u = fpt(p, doInverse)

% fpt -- Fast Poisson transform.
%  fpt(p) solves laplacian(u) = p, for matrix u,
%   assuming periodic boundary conditions.
%  fpt(p, doInverse) performs the inverse-transform
%   if "doInverse" is logically TRUE.  Default =
%   FALSE.
%
% Also see: fps, fft2, ifft2.
 
% Copyright (C) 1998 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.

% Reference: Press, et al., Numerical Recipes,
%    Cambridge University Press, 1986 and later.
 
% Version of 23-Oct-1998 09:02:58.
% Updated    24-Jun-2003 09:12:22.

if nargin < 1, help(mfilename), return, end
if nargin < 2, doInverse = 0; end

% Compute Fourier weights.

[m, n] = size(p);

i = (0:m-1).' * ones(1, n);
j = ones(m, 1) * (0:n-1);

weights = 2 * (cos(2*pi*i/m) + cos(2*pi*j/n) - 2);
weights(1, 1) = 1;

% Solve.

if ~any(doInverse)
	u = ifft2(fft2(p) ./ weights);
else
	u = ifft2(fft2(p) .* weights);
end

if isreal(p), u = real(u); end
