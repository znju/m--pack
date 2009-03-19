function theResult = loadboundary(self, theBoundaryFile)

% seagrid/loadboundary -- Load a boundary file.
%  loadboundary(self, 'theBoundaryFile') loads the given
%   ascii boundary file on behalf of self, a "seagrid"
%   object.  The three-columns contain [lon lat corner],
%   where "corner" = 1 for a corner-point; 0 otherwise.
 
% Copyright (C) 2002 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 11-Apr-2002 10:16:42.
% Updated    07-Oct-2002 14:47:34.

if nargout > 0, theResult = self; end

if nargin < 1, help(mfilename), return, end
if nargin < 2 | isempty(theBoundaryFile), theBoundaryFile = '*'; end

if any(theBoundaryFile == '*')
	theFilterSpec = theBoundaryFile;
	[theFile, thePath] = uigetfile(theFilterSpec, 'Select a Boundary File:');
	if ~any(theFile), return, end
	if thePath(end) ~= filesep, thePath = [thePath filesep]; end
	theBoundaryFile = [thePath theFile];
end

self = psset(self, 'itsBoundaryFile', theBoundaryFile);
thePoints = load(theBoundaryFile, '-ascii');

if size(thePoints, 2) < 3
	disp(' Boundary file requires 3 columns [lon lat corner].')
	return
end

if sum(thePoints(:, 3)) ~= 4
	disp(' ## Boundary requires exactly 4 marked corners.')
	return
end

lon = thePoints(:,1); lat = thePoints(:,2);
    
theProjection = psget(self, 'itsProjection');
switch lower(theProjection)   % Needs cleaning up.
case {'none', 'geographic'}
	theProjection = 'Geographic';
	x = lon; y = lat;
otherwise
	sg_proj(theProjection)
	[x, y] = sg_ll2xy(lon, lat);
	x = real(x);
	y = real(y);
end
thePoints(:,1) = x; thePoints(:,2) = y;

% Rearrange to counter-clockwise sense,
%  and keep the original first point
%  at the top.

if ~isccw(x, y)
    thePoints = flipud(thePoints);
	f = find(thePoints(:, 3));
	f = f(4);
    thePoints = thePoints([f:end 1:f-1], :);
    lon = thePoints(:,1); lat = thePoints(:,2);
end

self = psset(self, 'itsPoints', thePoints);
doupdate(self, 1)
set(gca, 'ButtonDownFcn', '')

if nargout > 0
	theResult = self;
end
