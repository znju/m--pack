function presto_bundle

% presto_bundle -- Bundle "presto" software.
%  presto_bundle (no argument) bundles the
%   "presto" software into "presto_install.p".
 
% Copyright (C) 1999 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 03-Nov-1999 08:11:48.
% Updated    31-May-2002 09:37:07.

theMFiles = {
	'README'
	'setdef'
	'presto_bundle'
	'inherit'
	'super'
	'isps'
	'psbind'
	'psevent'
	'ps_test'
};

theMFiles = sort(theMFiles);

theClasses = {
	'presto'
	'ps'
	'pst'
};

theMessage = {
	' '
	' ## To get started, put the "presto" folder in your Matlab'
	' ##  path, then execute "ps_test" at the Matlab prompt.'
};

for i = 1:length(theClasses)
	newversion(theClasses{i})
end

at(mfilename)

bund new presto
bund setdir presto
bund('class', theClasses)
bund('mfile', theMFiles)
bund('cd', '..')
bund('disp', theMessage)
bund close
