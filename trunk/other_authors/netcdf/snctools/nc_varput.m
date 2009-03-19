function return_status = nc_varput(ncfile, variable, data, start,count, stride)
% NC_VARPUT:  Write data into a NetCDF file.
%
% USAGE:  status = nc_varput(file, var, data, start, count, stride );
%
% PARAMETERS:
% Input:
%     ncfile:
%         Name of NetCDF file.
%     variable:
%         Variable whose data we want
%     start, count:
%         Zero-based indices that describe how much of the data is
%         requested.  If neither start nor count are supplied, then
%         all of the data is to be written.  
%     stride: 
%         Zero-based indices that describe the contiguity of the
%         data to be written.  If a stride argument is 2, then every
%         other datum in the file is written to.  If stride is not 
%         supplied, it defaults to 1 along each dimension.
% Output:
%     status:  
%         Optional.  If not requested, the routine throws an exception
%         in case of an error.  Otherwise a negative value is returned 
%         for failure, 0 for success.
%     
%   
% Examples:
%    Suppose you have a netcdf variable called 'x' of size 6x4.  If you 
%    have an array of data called 'mydata' that is 6x4, then you can 
%    write to the entire variable with 
% 
%        >> status = nc_varput ( 'foo.nc', 'x', mydata );
%
%    And the variable status will tell you if the operation was 
%    successful or not.
%
%    If you wish to only write to the first 2 rows and three columns,
%    you could do the following
%
%        >> subdata = mydata(1:2,1:3);
%        >> nc_varput ( 'foo.nc', 'x', subdata, [0 0], [2 3] );
%
%    This time, since no return status was requested, the result will 
%    be than an exception will be thrown if the operation was invalid.
%
%  
%    status = nc_varput('foo.cdf', 'x', data, [0 0], [2 3])
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_varput.m,v 1.21 2006/04/25 18:47:14 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if nargout < 1
	throw_exception = 1;
else
	throw_exception = 0;
end




%
% Assume failure until told otherwise.
return_status = -1;




%
% Must have at least 3 input arguments, no more than 6
% Three inputs means to write an entire dataset (put_var_xxx or put_var1_xxx).
% Five inputs means to write part of a dataset with default stride (put_vara_xxx).
% Six inputs means strided writes (put_vars_xxx).
if nargin < 3 || nargin == 4 || nargin > 6
	msg = sprintf ( '%s:  number of input arguments is cannot possibly be correct.\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end





%
% One optional output argument.
if ( nargout > 1 )
	msg = sprintf ( '%s:  at most 1 output argument is allowed.\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end


%
% open the file.  
[ncid, status] = mexnc('open', ncfile, nc_write_mode);
if (status ~= 0)

	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''open'' failed on %s (%s).\n', mfilename, ncfile, ncerr_msg  );
	handle_error ( msg, throw_exception );
	return;

end




%
% check to see if the variable already exists.  If it does,
% then we should only have 5 input arguments.
[varid, status] = mexnc('INQ_VARID', ncid, variable );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  INQ_VARID failed on %s (%s).\n' , mfilename, variable, ncerr_msg );	
	mexnc ( 'close', ncid );
	handle_error ( msg, throw_exception );
	return;
end
if ( varid < 0 )
	msg = sprintf ( '%s:  Could not find variable %s in file %s.\n' , mfilename, variable, ncfile );	
	mexnc ( 'close', ncid );
	handle_error ( msg, throw_exception );
	return;
end



%
% Get variable information.
[dud,var_type,nvdims,var_dim,dud, status]=mexnc('INQ_VAR',ncid,varid);
if status < 0 
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''inq_var'' operation failed on %s, variable (%s).\n', mfilename, ncfile, variable, ncerr_msg );
	mexnc ( 'close', ncid );
	handle_error ( msg, throw_exception );
	return;
end



%
% Make sure that the dimensionality is correct.
if ( (nvdims > 1) && (nvdims ~= ndims(data)) )

	%
	% There is one exception to all this.  If the netcdf variable 
	% is 1D, then "ndims" will still report a minimum of 2.  So 
	% this case is not really a mismatch.
	if ( (nvdims ~= 1) && (ndims(data)~= 2) )
		efmt = '%s:  Number of dimensions (%d) of the input data does not equal the number of dimensions (%d) of the netcdf variable %s.\n';
		msg = sprintf ( efmt, mfilename, ndims(data), nvdims, variable );
		mexnc ( 'close', ncid );
		return_status = -1;
		handle_error ( msg, throw_exception );
		return;
	end
end




%
% Figure out which write routine we will use.  If the target variable is a singleton, then we must use
% VARPUT1.  If a stride was given, we must use VARPUTG.  Otherwise just use VARPUT.
if nvdims == 0
	write_op = 'put_var1';
elseif nargin == 3
	write_op = 'put_var';
elseif nargin == 5
	write_op = 'put_vara';
elseif nargin == 6
	write_op = 'put_vars';
else
	msg = sprintf ( '%s:  unhandled write op.  How did we come to this??\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end



%
% Must determine how big the target variable is in order to properly set
% the start and count arguments.
if nvdims == 0

	%
	% Must be a singleton variable with no defined dimensions.  
	switch nargin

	case 3
		%
		% This is the case of "nc_varput ( file, var, data );"
		start = 0;
		count = 1;

	case 5
		%
		% This is the case of "nc_varput ( file, var, data, start, count );"
		if ( start ~= 0 ) || (count ~= 1 )
			msg = sprintf ( '%s:  in case of singleton variable, ''start'' and ''count'' need not (and probably shoud not) be supplied.  If you are the pedantic type (and you know if you are), then make start = [0] and count = [1].  Nothing else makes sense anyway.\n', mfilename );
			mexnc ( 'close', ncid );
			handle_error ( msg, throw_exception );
			return;
		end

	otherwise
		msg = sprintf ( '%s:  The output variable is a singleton, but the number of input arguments are not consistent with that.\n', mfilename );
		handle_error ( msg, throw_exception );
		return
	end

	nc_count = 1;

else
	%
	% Case of variable with well-defined dimensions.  Much easier.
	for n=1:nvdims,
		dimid=var_dim(n);
		[dim_size,status]=mexnc('INQ_DIMLEN',ncid,dimid);
		if status < 0 
			ncerr_msg = mexnc ( 'strerror', status );
			format = '%s:  ''INQ_DIM'' operation failed on dimid %d, variable (%s).\n';
			msg = sprintf ( format, mfilename, ncfile, variable, ncerr_msg );
			mexnc ( 'close', ncid );
			handle_error ( msg, throw_exception );
			return_status = -1;
			return;
		end
		nc_count(n)=dim_size;
		var_size(n) = dim_size;
	end
end







%
% If restrictions were specified, set them here.
if ( nargin > 3 )
	
	if ( length(start) ~= length(count) )
		msg = sprintf ( '%s:  start and count arguments do not have the same length.\n', mfilename );
		mexnc ( 'close', ncid );
		handle_error ( msg, throw_exception );
		return
	end

end


%
% If only 3 inputs and if not a singleton variable, then START is [0,..] and COUNT is 
% the size of the data.  
if ( nargin ==3 ) && ( nvdims > 0 )
	start = zeros(1,nvdims);
	count = size(data);
end


%
% if using the stride, then the non-singleton dimensions have to be set to 
% what the user gave us
% For example.  If we have a variable with time, depth, lat, and lon 
% as dimensions, but depth, lat, and lon are all singleton dimensions,
% then nc_size would be [nt 1 1 1], but var_size could be [5 1].  What
% we need to do is to padd
if nargin >= 6
	rank = length(nc_count);
	if ( length(stride) ~= rank )
		format = '%s:  we were given a stride, but it does not match the rank %d of the variable in the netcdf file.\n';
		msg = sprintf ( format.\n', mfilename, rank );
		handle_error ( msg, throw_exception );
		return
	end
end


%
% We are now in a position to do a check on the input var size vs. 
% the known size in the netcdf file.  If we don't do this, it would 
% be possible to send a larger then expected chunk of data to the 
% netcdf file, have parts of it get lopped off in order to fit, and 
% never be the wiser.
switch ( write_op )

case 'put_var1'

	%
	% Just check that the length of the input data was 1.
	dsize = numel(data);
	if dsize ~= 1
		msg = sprintf ( '%s:  write_op was ''put_var1'', but the length of the data was %d.\n', mfilename, dsize );
		handle_error ( msg, throw_exception );
		return
	end

case 'put_var'

	%
	% Since 'put_var' writes all the data, check that the
	% extents match up exactly.  
	%
	% Are there any singleton dimensions?  If so, we need to ac
	dsize = size(data);
	bad_size = 0;
	for k = 1:length(nc_count)
		if nc_count(k) == 1
			continue;
		end
		if nc_count(k) ~= dsize(k)
			bad_size = 1;
		end
	end
	if bad_size
		ncsize_string = sprintf ( '%d ', nc_count );
		varsize_string = sprintf ( '%d ', dsize );
		format = '%s:  write_op was ''put_var'', but the input data size is [ %s] and the netcdf variable size is [ %s].\n';
		msg = sprintf ( format, mfilename, varsize_string, ncsize_string );
		handle_error ( msg, throw_exception );
		return
	end


case { 'put_vara', 'put_vars' }

	%
	% Just check that the chunk of data the user gave us is the same
	% size as the given count.  This works for put_vars as well.
	dsize = size(data);
	n = length(dsize);

	%
	% special case for singleton variable.
	if nvdims == 1

		%
		% check length of input.
		if prod(dsize) ~= count
			format = '%s:  write_op was ''%s'', but the input data size is %d and the given count size is %d.\n';
			msg = sprintf ( format, mfilename, write_op, prod(dsize), count );
			handle_error ( msg, throw_exception );
			return
		end

	else

		if n < nvdims
			%
			% There were trailing singleton dimensions.  Handle them
			% by appending ones on out to the end.
			ndiff = nvdims - n;
			dsize = [dsize ones(1,ndiff)];
		end
		if any(dsize-count)
			dsize_string = sprintf ( '%d ', dsize );
			count_string = sprintf ( '%d ', count );
			format = '%s:  write_op was ''%s'', but the input data size is [ %s] and the given count size is [ %s].\n';
			msg = sprintf ( format, mfilename, write_op, dsize_string, count_string );
			handle_error ( msg, throw_exception );
			return
		end
	end

otherwise
	%
	% do nothing, wait until later to check
end


%
% Scale the data if we have the appropriate attributes.
have_scale_factor = 0;
have_add_offset = 0;
[dud, dud, status] = mexnc('INQ_ATT', ncid, varid, 'scale_factor' );
if ( status == 0 )
	have_scale_factor = 1;
end
[dud, dud, status] = mexnc('INQ_ATT', ncid, varid, 'add_offset' );
if ( status == 0 )
	have_add_offset = 1;
end
if ( have_scale_factor && have_add_offset )

	[scale_factor, status] = mexnc ( 'get_att_double', ncid, varid, 'scale_factor' );
	if ( status ~= 0 )
		msg = sprintf ( '%s:  ATT_GET_DOUBLE failed on scale_factor.\n', mfilename );
		mexnc('close',ncid);
		handle_error ( msg, throw_exception );
		return
	end
	[add_offset, status] = mexnc ( 'get_att_double', ncid, varid, 'add_offset' );
	if ( status ~= 0 )
		msg = sprintf ( '%s:  ATT_GET_DOUBLE failed on add_offset.\n', mfilename );
		mexnc('close',ncid);
		handle_error ( msg, throw_exception );
		return
	end

	data = (double(data) - add_offset) / scale_factor;

end


%
% Handle the fill value, if any.  Change those values into NaN.
[dud, dud, status] = mexnc('INQ_ATT', ncid, varid, '_FillValue' );
if ( status == 0 )

	switch ( class(data) )
	case 'double'
		[fill_value, status] = mexnc ( 'get_att_double', ncid, varid, '_FillValue' );
	case 'single'
		[fill_value, status] = mexnc ( 'get_att_float', ncid, varid, '_FillValue' );
	case 'int32'
		[fill_value, status] = mexnc ( 'get_att_int', ncid, varid, '_FillValue' );
	case 'int16'
		[fill_value, status] = mexnc ( 'get_att_short', ncid, varid, '_FillValue' );
	case 'int8'
		[fill_value, status] = mexnc ( 'get_att_schar', ncid, varid, '_FillValue' );
	case 'uint8'
		[fill_value, status] = mexnc ( 'get_att_uchar', ncid, varid, '_FillValue' );
	case 'char'
		[fill_value, status] = mexnc ( 'get_att_text', ncid, varid, '_FillValue' );
	otherwise
		mexnc('close',ncid);
		msg = sprintf ( '%s:  unhandled datatype %s\n', mfilename, nc_datatype_string(var_type) );
		handle_error ( msg, throw_exception );
		return
	end

	if ( status ~= 0 )
		mexnc('close',ncid);
		ncerrmsg = mexnc ( 'strerror', status );
		msg = sprintf ( '%s:  GET_ATT_XXX failed on _FillValue, var %s, file %s (%s).\n', mfilename, varname, ncfile, ncerrmsg );
		handle_error ( msg, throw_exception );
		return
	end


	ind = find(isnan(data));
	data(ind) = fill_value;

end

	

%
% write the data
pdata = permute(data, fliplr( 1:ndims(data) ));
switch ( write_op )

	case 'put_var1'
		switch ( class(data) )
		case 'double'
			status = mexnc ( 'put_var1_double', ncid, varid, start, pdata  );
		case 'single'
			status = mexnc ( 'put_var1_float', ncid, varid, start, pdata );
		case 'int32'
			status = mexnc ( 'put_var1_int', ncid, varid, start, pdata );
		case 'int16'
			status = mexnc ( 'put_var1_short', ncid, varid, start, pdata );
		case 'int8'
			status = mexnc ( 'put_var1_schar', ncid, varid, start, pdata );
		case 'uint8'
			status = mexnc ( 'put_var1_uchar', ncid, varid, start, pdata );
		case 'char'
			status = mexnc ( 'put_var1_text', ncid, varid, start, pdata );
		otherwise
			msg = sprintf ( '%s:  unhandled data class %s\n', mfilename, class(pdata) );
			mexnc('close',ncid);
			handle_error ( msg, throw_exception );
			return
		end

	case 'put_var'
		switch ( class(data) )
		case 'double'
			status = mexnc ( 'put_var_double', ncid, varid,  pdata  );
		case 'single'
			status = mexnc ( 'put_var_float', ncid, varid,  pdata );
		case 'int32'
			status = mexnc ( 'put_var_int', ncid, varid,  pdata );
		case 'int16'
			status = mexnc ( 'put_var_short', ncid, varid,  pdata );
		case 'int8'
			status = mexnc ( 'put_var_schar', ncid, varid,  pdata );
		case 'uint8'
			status = mexnc ( 'put_var_uchar', ncid, varid,  pdata );
		case 'char'
			status = mexnc ( 'put_var_text', ncid, varid,  pdata );
		otherwise
			msg = sprintf ( '%s:  unhandled data class %s\n', mfilename, class(pdata) );
			mexnc('close',ncid);
			handle_error ( msg, throw_exception );
			return
		end
	
	case 'put_vara'
		switch ( class(data) )
		case 'double'
			status = mexnc ( 'put_vara_double', ncid, varid, start, count,  pdata  );
		case 'single'
			status = mexnc ( 'put_vara_float', ncid, varid,  start, count, pdata );
		case 'int32'
			status = mexnc ( 'put_vara_int', ncid, varid, start, count,  pdata );
		case 'int16'
			status = mexnc ( 'put_vara_short', ncid, varid, start, count,  pdata );
		case 'int8'
			status = mexnc ( 'put_vara_schar', ncid, varid,  start, count, pdata );
		case 'uint8'
			status = mexnc ( 'put_vara_uchar', ncid, varid, start, count,  pdata );
		case 'char'
			status = mexnc ( 'put_vara_text', ncid, varid, start, count,  pdata );
		otherwise
			msg = sprintf ( '%s:  unhandled data class %s\n', mfilename, class(pdata) );
			mexnc('close',ncid);
			handle_error ( msg, throw_exception );
			return
		end

	case 'put_vars'
		switch ( class(data) )
		case 'double'
			status = mexnc ( 'put_vars_double', ncid, varid, start, count, stride,  pdata  );
		case 'single'
			status = mexnc ( 'put_vars_float', ncid, varid,  start, count, stride, pdata );
		case 'int32'
			status = mexnc ( 'put_vars_int', ncid, varid, start, count, stride,  pdata );
		case 'int16'
			status = mexnc ( 'put_vars_short', ncid, varid, start, count, stride,  pdata );
		case 'int8'
			status = mexnc ( 'put_vars_schar', ncid, varid, start, count, stride, pdata );
		case 'uint8'
			status = mexnc ( 'put_vars_uchar', ncid, varid, start, count, stride,  pdata );
		case 'char'
			status = mexnc ( 'put_vars_text', ncid, varid, start, count, stride,  pdata );
		otherwise
			msg = sprintf ( '%s:  unhandled data class %s\n', mfilename, class(pdata) );
			mexnc('close',ncid);
			handle_error ( msg, throw_exception );
			return
		end

	otherwise 
		msg = sprintf ( 2, '%s:  unknown write operation''%s''.\n', mfilename, write_op );
		mexnc ( 'close', ncid );
		handle_error ( msg, throw_exception );
		return;


end

if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  write operation ''%s'' failed on %s with error ''%s'', file %s.\n', mfilename, write_op, variable, ncerr, ncfile );
	mexnc ( 'close', ncid );
	handle_error ( msg, throw_exception );
	return;
end

status = mexnc ( 'close', ncid );
if ( status < 0 )
	msg = sprintf ( '%s:  ''%s''.\n', mfilename, mexnc('STRERROR',status));
	handle_error ( msg, throw_exception );
	return;
end


%
% If we got this far, then we must have succeeded.
return_status = 0;


return





function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
