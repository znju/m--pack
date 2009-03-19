function [yn, return_status] = nc_isunlimitedvar ( ncfile, varname )
% NC_ISUNLIMITEDVAR:  yes if the given variable has a record dimension
%
% USAGE:  [yn, status] = nc_isunlimitedvar ( ncfile, varname );
%
% PARAMETERS:
% Input:
%   ncfile:  
%      Input netcdf file name.
%   varname:  
%      variable to check
% Output:
%   yn:
%        1 if it does indeed have an unlimited dimension, 0 otherwise
%   status:
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 if the routine succeeds
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_isunlimitedvar.m,v 1.6 2005/08/03 12:13:59 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout < 2
	throw_exception = 1;
else
	throw_exception = 0;
end


yn = 0;
return_status = -1;

if ( nargin ~= 2 )
	msg = sprintf ( '%s:  Must have two input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

if ~ischar ( varname )
	msg = sprintf ( '%s:  varname argument must be of character datatype.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

[DataSet, status] = nc_getvarinfo ( ncfile, varname );
if ( status < 0 )
	format = '%s:  nc_getvarinfo failed on file ''%s'', variable ''%s''.\n';
	msg = sprintf ( format, mfilename, ncfile, varname );
	handle_error ( msg, throw_exception );
	return
end

if DataSet.IsUnlimitedVariable
	yn = 1;
else
	yn = 0;
end

return_status = 0;

return;









function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return


