function theResult = switchsafe(x)

% switchsafe -- Make an empty item safe for "switch" command.
%  switchsafe(x) returns a version of x, where x is empty,
%   that is safe to use in a PCWIN Matlab 6+ "switch"
%   statement.  A bug in PCWIN Matlab 6+ prohibits using
%   the empty-matrix [] in a switch.
 
% Copyright (C) 2002 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 19-Mar-2002 14:58:56.
% Updated    19-Mar-2002 14:58:56.

if nargin < 1, help(mfilename), return, end

if isempty(x) & ~ischar(x)
	if any(findstr(lower(computer), 'pcwin'))
		x = '';
	end
end

if nargout > 0
	theResult = x;
else
	assignin('caller', 'ans', x)
end
