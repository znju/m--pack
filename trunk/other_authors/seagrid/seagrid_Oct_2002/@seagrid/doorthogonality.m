function theResult = doorthogonality(self)

% seagrid/doorthogonality -- Compute/show orthogonality.
%  doorthogonality(self) computes and displays the orthogonality
%   of the grid generated by self, a "seagrid" object.  The
%   associated colorbar shows the orthogonality error in degrees.
 
% Copyright (C) 1999 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 19-May-1999 10:26:06.
% Updated    11-Feb-2000 16:48:03.

if nargout > 0, theResult = []; end

if nargin < 1, help(mfilename), return, end

if nargout > 0, theResult = self; end

h = findobj('Type', 'surface', 'Tag', 'orthogonality');
if any(h), delete(h), end

delete(colorbar)
setsafe(gca, 'CLimMode', 'auto')

theSpacedGrids = psget(self, 'itsSpacedGrids');
if isempty(theSpacedGrids), return, end

u = theSpacedGrids{1};
v = theSpacedGrids{2};
if isempty(u), return, end

z = u + sqrt(-1)*v;
result = zeros(size(z));

% Store the maximum deviation from a right-angle
%  for each grid-crossing.  The graph shows best
%  with 'shading interp', but "xor" erase-mode
%  is not allowed there.

for i = 1:4
	du = diff(z); du = du ./ abs(du);
	dv = diff(z.').'; dv = dv ./ abs(dv);
	ddu = du(:, 1:end-1);
	ddv = dv(1:end-1, :);
	ang = acos(real(ddu).*real(ddv) + imag(ddu).*imag(ddv));
	result(1:end-1, 1:end-1) = max(result(1:end-1, 1:end-1), ang);
	z = flipud(z.');
	result = flipud(result.');
end

result = 180 * abs(result - pi/2) / pi;   % Error from 90 degrees.

edgeExemption = 1;   % Are edges exempt?

if edgeExemption
	result([1 end], :) = 0;
	result(:, [1 end]) = 0;
end

result([1 end], [1 end]) = 0;

if (0)
	angular_error_range = [min(result(:)) max(result(:))]
end

hold on

theEraseMode = psget(self, 'itsEraseMode');
theEraseMode = 'normal';

theGridLineColor = psget(self, 'itsGridLineColor');
theFaceColor = 'interp';
theTag = psget(self, 'itsOrthogonalityTag');

h = surf(u, v, result);
set(h, 'EraseMode', theEraseMode, ...
			'FaceColor', theFaceColor, ...
			'EdgeColor', theGridLineColor, ...
			'Tag', theTag)

hold off

h = colorbar;
lab = get(h, 'Ylabel');
set(get(h, 'Ylabel'), 'String', 'Orthogonality Error (degrees)')

if nargout > 0, theResult = self; end