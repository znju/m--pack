function todo
 
% Copyright (C) 2001 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 22-Oct-2001 14:37:15.
% Updated    22-Oct-2001 16:15:54.

1.	Bathymetry from already-gridded depths,
		using "xyplaid", "gridfill", and
		"interp2".  These routines exist,
		but need to be integrated and
		activated in the "dobathymetry"
		method.   % DONE.

2.	Preserve depths that are already editted
		by hand, rather than computing over
		them.  When a "SeaGrid" file is read,
		a "show-depths" flag needs to be
		activated.
		
3.	Non-orthogonality of grid when spacers
		are not evenly distributed.  This
		comes from calling "sepeli" incorrectly,
		but I don't know the specific error.
		
4.	More control over which Mex-files are 
		to be used.  We can add a couple
		of buttons to the "Setup" dialog.
		
5.	Grid-lines falling exactly on the data
		points themselves.  This would solve
		the spacing problem somewhat.
		
