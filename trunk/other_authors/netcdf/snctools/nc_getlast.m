function [values, return_status] = nc_getlast(ncfile, var, num_records)
% NC_GETLAST:  Get last few datums from an unlimited NetCDF variable.
%
% USAGE: [values, status] = nc_getlast( netcdf_file, variable, n )
%
% PARAMETERS:
% Input:
%    netcdf_file:  
%        Name of input netcdf file.
%    variable:  
%        Name of NetCDF variable whose last few records we want.
%    n:  
%        Optional, default is 1.
%        This is the number of records to get, starting at the end
% Output:
%    values:  return data
%    status:  
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 if the routine succeeds
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_getlast.m,v 1.8 2005/08/03 12:13:59 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargout < 2
	throw_exception = 1;
else
	throw_exception = 0;
end






%
% assume failure until success is known
values = [];
return_status = -1;


% Show usage if too few arguments.
%
if (nargin <= 1)
	msg = sprintf ( '%s:  not enough input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end
if (nargin > 3) 
	msg = sprintf ( '%s:  must supply at least 2 and no more than 3 input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

if ~ischar(ncfile) 
	msg = sprintf ( '%s:  First argument must be character.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

if ~ischar(var) 
	msg = sprintf ( '%s:  2nd argument must be character.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

if ( nargin == 2 )
	num_records = 1;
else
	if ~isnumeric(num_records) 
		msg = sprintf ( '%s:  3rd argument must be numeric.\n', mfilename );
		handle_error ( msg, throw_exception );
		return
	end
	if num_records <= 0
		msg = sprintf ( '%s:  3rd argument must be positive.\n', mfilename );
		handle_error ( msg, throw_exception );
		return
	end

end

varlist = { var };
[nb, status] = nc_getbuffer ( ncfile, varlist, -1, num_records );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_getbuffer failed on %s, file %s.\n', mfilename, var, ncfile );
	handle_error ( msg, throw_exception );
	return
end

values = getfield ( nb, var );
return_status = 0;

return





function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
