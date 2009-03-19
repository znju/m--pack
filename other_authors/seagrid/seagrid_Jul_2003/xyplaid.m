function [xout, yout, zout] = xyplaid(x, y, z, interpFlag)

% xyplaid -- Make (x, y) data roughly plaid.
%  [xout, yout, zout] = xyplaid(x, y, z) places the
%   given (x, y) points into a plaid-like sequence,
%   then rearranges z accordingly.  Unoccupied
%   points are given a value of NaN.
%   ... = xplaid(x, y, z, interpFlag) interpolates
%   the missing values if the "interpFlag" is TRUE.
%  xyplaid(N) demonstrates itself for an N-by-N
%   array of points (default = 3).
 
% Copyright (C) 2001 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 16-Oct-2001 13:11:24.
% Updated    22-Oct-2001 16:45:37.


if nargin < 4, interpFlag = ~~0; end

% Demonstration:
%  We create (x, y, z) data with a few NaNs in z,
%  randomize the ordering, then call "xyplaid"
%  to reconstruct the original (x, y, z).

if nargin < 1, help(mfilename), x = 'demo'; end

if isequal(x, 'demo'), x = 3; end
if ischar(x), x = eval(x); end

if length(x) == 1
	n = x;
	[x, y] = meshgrid(1:n, 1:n);
	z = floor(rand(n, n)*10);
	z(z == 0) = NaN;   % Set zeros to NaN.
	zi = z(:); [zi, i] = sort(zi);  % Randomize.
	xi = x(i);
	yi = y(i);
	f = find(isnan(zi));   % Delete NaNs, for fun.
	zi(f) = []; xi(f) = []; yi(f) = [];
	tic
	[xo, yo, zo] = feval(mfilename, xi, yi, zi);
	disp(' ')
	disp([' ## ' mfilename '(' int2str(n) ')'])
	disp([' ## Elapsed time: ' num2str(fix(10*toc)/10) ' s.'])
	f = ~isnan(z);
	if any(z(f) ~= zo(f))   % Compare result with original.
		if n < 11, z, zo, end
		disp([' ## Round-trip NOT successful.'])
	else
		disp([' ## Round-trip successful.'])
	end
	disp(' ')
	if nargout > 0
		xout = x; yout = y; zout = z;
	end
	return
end

% Compute the destination array size.

x = x(:);
y = y(:);
z = z(:);

nPoints = prod(size(x));

[xs, xind] = sort(x);   % Later, use "unsort".
[ys, yind] = sort(y);

xd = (diff(xs) ~= 0);
yd = (diff(ys) ~= 0);

xf = find(xd);
yf = find(yd);

xftemp = [0; xf; nPoints];
yftemp = [0; yf; nPoints];

m = max(diff(yftemp));
n = max(diff(xftemp));

xftemp = [0; xf] + 1;
yftemp = [0; yf] + 1;

xtic = xs(xftemp);   % Unique x values.
ytic = ys(yftemp);   % Unique y values.

% Create the destination arrays.

% Populate the arrays in orderly fashion.
%  Easily done if we convert each original
%   (x, y) pair into a pair of indices.
%   Use cumsum() on xd and yd, then unsort
%   to get back to the original sequence.

jj = cumsum([1; (xd ~= 0)]);
ii = cumsum([1; (yd ~= 0)]);

m = max(ii);
n = max(jj);

jj = unsort(jj, xind);
ii = unsort(ii, yind);

mask = full(sparse(ii, jj, 0*x+1, m, n));
mask(~mask) = NaN;
mask(mask == 1) = 0;

xout = full(sparse(ii, jj, x, m, n)) + mask;
yout = full(sparse(ii, jj, y, m, n)) + mask;
zout = full(sparse(ii, jj, z, m, n)) + mask;

% Fill-in the x and y values.

[m, n] = size(xout);
for j = 1:n
	f = find(~isnan(xout(:, j)));
	if any(f)
		xout(:, j) = xout(f(1), j);
	end
end

[m, n] = size(yout);
for i = 1:m
	f = find(~isnan(yout(i, :)));
	if any(f)
		yout(i, :) = yout(i, f(1));
	end
end

% Interpolate the NaN values, if requested.
%  Would a flood fill scheme be suitable, in
%  which we fill single pixels before multiple?

if any(interpFlag) & any(any(isnan(zout)))
	[m, n] = size(zout);
	z = zeros(m+2, n+2) + NaN;
	z(2:end-1, 2:end-1) = zout;
	[m, n] = size(z);
	for j = 2:n-1
		for i = 2:m-1
			if isnan(z(i, j))
				w = z(i-1:i+1, j-1:J+1);   % Neighbors.
				f = find(~isnan(w));
				if any(f)
					z(i, j) = mean(w(f));
				end
			end
		end
	end
	zout = z(2:end-1, 2:end-1);
end
