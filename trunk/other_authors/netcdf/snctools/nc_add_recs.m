function return_status = nc_add_recs ( ncfile, new_data, unlimited_dimension_name )
% NC_ADD_RECS:  add records onto the end of a netcdf file
%
% USAGE:  status = nc_add_recs ( ncfile, new_data, unlimited_dimension );
% 
% INPUT:
%   ncfile:  netcdf file
%   new_data:  Matlab structure.  Each field is a data array
%      to be written to the netcdf file.  Each array had
%      better be the same length.  All arrays are written
%      in the same fashion.
%   unlimited_dimension:
%      Optional.  Name of the unlimited dimension along which the data 
%      is written.  If not provided, we query for the first unlimited 
%      dimension (looking ahead to HDF5/NetCDF4).
%     
% OUTPUT:
%     status:  
%         Optional.  If status is not requested, then an exception is
%         thrown in case of an error.  Otherwise, status is set to -1 
%         if the routine fails, 0 if the routine succeeds
%
% AUTHOR: 
%   johnevans@acm.org
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_add_recs.m,v 1.14 2006/04/25 18:47:14 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargout < 1
	throw_exception = 1;
else
	throw_exception = 0;
end


return_status = -1;

if nargin < 2
	msg = sprintf ( '%s:  need at least two input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


%
% Check that we were given good inputs.
if ~isstruct ( new_data )
	msg = sprintf ( '%s:  2nd input argument must be a structure .\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

%
% Check that each field of the structure has the same length.
varnames = fieldnames ( new_data );
num_fields = length(varnames);
if ( num_fields <= 0 )
	msg = sprintf ( '%s:  2nd input cannot be an empty structure.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end
field_length = zeros(num_fields,1);
for j = 1:num_fields
	command = sprintf ( 'field_length(j) = size(new_data.%s,1);', varnames{j} );
	eval ( command );
end
if any(diff(field_length))
	msg = sprintf ( '%s:  Some of the fields do not have the same length.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

%
% So we have this many records to write.
record_count(1) = field_length(1);


%
% Open netCDF file
%
[ncid,status ]=mexnc( 'open', ncfile, nc_nowrite_mode );
if status < 0
	ncerr = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  mexnc:open failed on %s, error message ''%s''\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end



%
% If we were not given the name of an unlimited dimension, ask for it now.
if nargin < 3
	[unlimited_dimension_dimid, status] = mexnc ( 'inq_unlimdim', ncid );
	if status < 0
		ncerr = mexnc ( 'strerror', status );
		msg = sprintf ( '%s:  mexnc:inq_unlimdim failed on %s, error message ''%s''\n', mfilename, ncfile, ncerr );
		handle_error ( msg, throw_exception );
		return
	end

	if unlimited_dimension_dimid == -1
		msg = sprintf ( '%s:  NetCDF file %s has no unlimited dimension.  Cannot write to it.\n', mfilename, ncfile );
		handle_error ( msg, throw_exception );
		return
	end

	[unlimited_dimension_name, unlimited_dimension_length, status] = mexnc ( 'inq_dim', ncid, unlimited_dimension_dimid );
	if status < 0
		ncerr = mexnc ( 'strerror', status );
		msg = sprintf ( '%s:  mexnc:inq_dim failed on %s, error message ''%s''\n', mfilename, ncfile, ncerr );
		handle_error ( msg, throw_exception );
		return
	end
else
	
	%
	% Get the dimension info for the dimension we were given
	[unlimited_dimension_dimid, status] = mexnc ( 'inq_dimid', ncid, unlimited_dimension_name );
	if status < 0
		ncerr = mexnc ( 'strerror', status );
		msg = sprintf ( '%s:  mexnc:inq_dimid failed, error message ''%s''\n', mfilename, ncerr );
		handle_error ( msg, throw_exception );
		return
	end
	
	
	[unlimited_dimension_name, unlimited_dimension_length, status] = mexnc( 'inq_dim', ncid, unlimited_dimension_dimid );
	if status < 0
		ncerr = mexnc ( 'strerror', status );
		msg = sprintf ( '%s:  mexnc:inq_dim failed, error message ''%s''\n', mfilename, ncerr );
		handle_error ( msg, throw_exception );
		return
	end

end

%
% So we start writing here.
record_corner(1) = unlimited_dimension_length;

%
% For each field of "new_data" buffer, inquire as to the dimensions in the
% NetCDF file.  We need this data to properly tell nc_varput how to write
% the data
input_variable = fieldnames ( new_data );
num_vars = length(input_variable);
varsize = [];
for j = 1:num_vars
	dimsize = [];
	[varid, status] = mexnc('INQ_VARID', ncid, input_variable{j} );
	if ( status < 0 )
		mexnc('close',ncid);
		ncerr = mexnc ( 'strerror', status );
		msg = sprintf ( '%s:  mexnc::inq_varid failed on %s, file %s, error message ''%s''.\n', mfilename, input_variable{j}, ncfile, ncerr );
		handle_error ( msg, throw_exception );
		return
	end

	[varname, datatype, ndims, dimids, natts, status] = mexnc('INQ_VAR', ncid, varid);
	if ( status < 0 )
		mexnc('close',ncid);
		ncerr = mexnc ( 'strerror', status );
		msg = sprintf ( '%s:  mexnc::inq_var failed on %s, %s, error message ''%s''.\n', mfilename, input_variable{j}, ncfile, ncerr );
		handle_error ( msg, throw_exception );
		return
	end


	%
	% make sure that this variable is defined along the unlimited dimension.
	if ~any(find(dimids==unlimited_dimension_dimid))
		mexnc('close',ncid);
		format = '%s:  variable %s is not defined along dimension %s, not going to write anything.\n';
		msg = sprintf ( format, mfilename, input_variable{j}, unlimited_dimension_name );
		handle_error ( msg, throw_exception );
		return
	end

	for k = 1:ndims
		[dimname, dim_length, status] = mexnc('INQ_DIM', ncid, dimids(k) );
		if ( status < 0 )
			mexnc('close',ncid);
			ncerr = mexnc ( 'strerror', status );
			format = '%s:  mexnc::inq_dim failed on dimid %d, variable %s, file %s, error message ''%s''.\n';
			msg = sprintf ( format, mfilename, dimid, input_variable{j}, ncfile, ncerr );
			handle_error ( msg, throw_exception );
			return
		end
		dimsize(k) = dim_length;
	end

	varsize = setfield ( varsize, input_variable{j}, dimsize);

end

status = mexnc('close',ncid);
if status < 0 
	ncerr = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  mexnc::close failed on %s, error message ''%s''.\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end




%
% write out each data field, as well as the minimum and maximum
for i = 1:num_vars

	current_var = input_variable{i};
	%fprintf ( 1, '%s:  processing %s...\n', mfilename, current_var );

	current_var_data = getfield ( new_data, current_var );
	var_buffer_size = size(current_var_data);

	netcdf_var_size = getfield ( varsize, current_var );

	corner = zeros( 1, length(netcdf_var_size) );
	count = ones( 1, length(netcdf_var_size) );

	corner(1) = record_corner(1);
	count(1) = record_count(1);


	
	for j = 2:length(var_buffer_size(:))
		if ( var_buffer_size(j) > 1 )
			count(j) = var_buffer_size(j);
		end
	end



    status = nc_varput ( ncfile, current_var, current_var_data, corner, count );
    if ( status < 0 )
        msg = sprintf ( '%s:  nc_varput failed on %s:%s\n', mfilename, ncfile, current_var );
	handle_error ( msg, throw_exception );
        return
    end
   

end


%
% If here, we know we did ok
return_status = 0;

return





function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
