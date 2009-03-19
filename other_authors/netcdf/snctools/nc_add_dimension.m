function [dimid, return_status] = nc_add_dimension ( ncfile, dimension_name, dimension_length )
% NC_ADD_DIMENSION:  adds a dimension to an existing netcdf file
%
% USAGE:  [dimid, status] = nc_add_dimension ( ncfile, dimension_name, dimension_size );
%
% PARAMETERS:
% Input:
%     ncfile:  path to netcdf file
%     dimension_name:  name of dimension to be added
%     dimension_size:  length of new dimension.  If zero, it will be an
%         unlimited dimension.
% Output:
%     dimid:  netcdf dimension id of newly-created dimension
%     status:  -1 if routine not successful, 0 if it is successful
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_add_dimension.m,v 1.4 2005/08/02 11:53:36 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout < 2
	throw_exception = 1;
else
	throw_exception = 0;
end

dimid = -1;
return_status = -1;

if nargin ~= 3
	msg = sprintf ( '%s:  Must provide three input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

if ~ischar(dimension_name)
	msg = sprintf ( '%s:  second input must be character.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

if ~isnumeric(dimension_length)
	msg = sprintf ( '%s:  third input must be numeric.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

[ncid, status] = mexnc ( 'open', ncfile, nc_write_mode );
if status
	ncerr = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  mexnc:open failed on ''%s'', error message ''%s''.\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end

%
% go into define mode
status = mexnc ( 'redef', ncid );
if status
	ncerr = mexnc ( 'strerror', status );
	mexnc ( 'close', ncid );
	msg = sprintf ( '%s:  mexnc:redef failed on %s, ''%s''.\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end

[dimid, status] = mexnc ( 'def_dim', ncid, dimension_name, dimension_length );
if status
	ncerr = mexnc ( 'strerror', status );
	mexnc ( 'close', ncid );
	msg = sprintf ( '%s:  mexnc:def_dim failed on %s, ''%s''.\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end

status = mexnc ( 'endef', ncid );
if status
	ncerr = mexnc ( 'strerror', status );
	mexnc ( 'close', ncid );
	msg = sprintf ( '%s:  mexnc:redef failed on %s, ''%s''.\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end


status = mexnc ( 'close', ncid );
if status 
	ncerr = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  mexnc:close failed on %s, ''%s''.\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end


return_status = 0;

return



function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
