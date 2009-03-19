function zout = gridfill(z)

% gridfill -- Simple grid-filling of NaNs.
%  gridfill(z) fills in the NaN values of
%   z with the mean of surrounding values,
%   working iteratively until all the
%   voids are filled.
%  gridfill(N) demonstrates itself with
%   an N-by-N grid, with about 10% NaNs
%   (default N = 5).
 
% Copyright (C) 2001 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 17-Oct-2001 15:57:19.
% Updated    17-Oct-2001 15:57:19.

if nargin < 1
	help(mfilename)
	z = 5;
end

if ischar(z), z = eval(z); end

if length(z) == 1
	n = z;
	z = floor(rand(n, n)*10);
	z(z == 0) = NaN;
	zo = feval(mfilename, z);
	subplot(1, 2, 1)
	surf(z), shading interp
	set(gca, 'XLim', [1 n], 'YLim', [1 n])
	title('Original'), view(2)
	[j, i] = find(isnan(z));   % Mark the NaNs.
	hold on
	plot(i, j, 'ko', 'MarkerFaceColor', [0 0 0]);
	hold off
	clim = get(gca, 'CLim');
	subplot(1, 2, 2)
	surf(zo), shading interp
	set(gca, 'XLim', [1 n], 'YLim', [1 n])
	title('Filled'), view(2)
	set(gca, 'CLim', clim)
	if n < 11, z, zo, end
	figure(gcf)
	return
end

[m, n] = size(z);
ztemp = zeros(m+2, n+2) + NaN;

% The following can be vectorized.

while any(any(isnan(z)))
	ztemp(2:end-1, 2:end-1) = z;
	[m, n] = size(ztemp);
	for j = 2:n-1
		if any(isnan(ztemp(2:end-1, j)))
			for i = 2:m-1
				if isnan(ztemp(i, j))
					w = ztemp(i-1:i+1, j-1:j+1);   % Neighbors.
					f = find(~isnan(w));
					if any(f)
						z(i-1, j-1) = mean(w(f));   % Note z, not ztemp.
					end
				end
			end
		end
	end
end

zout = z;
