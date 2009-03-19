function [values, return_status] = nc_varget(ncfile, varname, varargin )
% NC_VARGET:  Retrieve data from a NetCDF variable.
%
% NC_VARGET tries to be intelligent about retrieving the data.
% Since most general matlab operations are done in double precision,
% retrieved numeric data will be cast to double precision, while 
% character data remains just character data.  If this is not what you 
% want, then you should consider nc_native_varget.m
%
% The _FillValue attribute is honored by flagging those datums as NaN.
% Except for char.  Does char and fill value even make sense?
%
% Singleton dimensions are removed from the output data.  
%
% If the named NetCDF variable has valid scale_factor and add_offset 
% attributes, then the data is scaled accordingly.  
%
% USAGE:  [values, status] = nc_varget(ncfile,varname);
%         
%     Retrieve an entire dataset.
%
%
% USAGE:  [values, status] = nc_varget(ncfile,varname,start,count);
%         
%     Retrieve a contiguous section of a dataset, but not necessarily
%     all of it.
%
%
% USAGE:  [values, status] = nc_varget(ncfile,varname,start,count,stride);
%         
%     Retrieve a non-contiguous section of a dataset.
%
%
% PARAMETERS:
% Input:
%    ncfile:  
%       name of netcdf file.  This can also be a DODS url.
%    varname:  
%       name of variable whose data is requested
%    start:  
%       Optional, starting index for the retrieval.  Remember that 
%       NetCDF has zero-based indexing, not one-based indexing.
%    count:  
%       Optional, length of the retrieval along each dimension.  If the
%       count for any dimension is -1, then everything is retrieved up
%       to the end of that dimension.  Requires that the "start" 
%       argument be given as well.
%    stride:  
%       Optional.  If not provided, then contiguous elements are used.
%       For example, if STRIDE were [2 2], then every other element
%       is chosen.  Requires that both the "start" and "count" arguments
%       be given as well.
%
% Output:
%    values:  the requested data
%    status:  
%        If status is not asked for, the routine will throw an 
%        exception if it fails.  Otherwise status is returned as -1
%        for failure, 0 for success.
%
% Example:
%    This example retrieves from a local file.
%    >> [values, status] = nc_varget('foo.cdf', 'x', [0 0], [2 3])
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_varget.m,v 1.32 2006/04/25 16:45:23 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%
% assume failure until success is known
values = [];
return_status = -1;


% One of these is set when we figure out what arguments we
% were given.
USE_GET_VAR = 0;   % get the entire variable?
USE_GET_VARA = 0;  % get a contiguous part of the variable?
USE_GET_VARS = 0;  % get a variable with some stride%
USE_GET_VAR1 = 0;  % get just a single value?

% Don't assume we are given coordinates unless we know otherwise.
start = [];
count = [];
stride = [];

%
% figure out what inputs we were given for varargin.
if nargout < 2
	throw_exception = 1;
else
	throw_exception = 0;
end
if (nargin < 2)
	msg = sprintf ( '%s:  too few input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end
if (nargin > 5)
	msg = sprintf ( '%s:  too many input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

switch nargin
case 2
	USE_GET_VAR = 1;


case 3
	msg = sprintf ( '%s:  there cannot be three input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return

case 4
	%
	% 3rd and 4th must be numeric.  start and count.
	if (ischar(varargin{1}) || ischar(varargin{2}))
		msg = sprintf ( '%s:  if four inputs, the third and fourth must be numeric\n', mfilename );
		handle_error ( msg, throw_exception );
		return
	else
		USE_GET_VARA = 1;
		start = varargin{1};
		count = varargin{2};
	end

case 5
	%
	% 3rd and 4th must be numeric.  start and count.
	if (~isnumeric(varargin{3}))
		msg = sprintf ( '%s:  if five inputs, the fifth must be numeric\n', mfilename );
		handle_error ( msg, throw_exception );
		return
	end
	USE_GET_VARS = 1;
	start = varargin{1};
	count = varargin{2};
	stride = varargin{3};

end



%
% Open netCDF file
%
[ncid,status]=mexnc('open',ncfile,'NOWRITE');
if status ~= 0
	ncerr = mexnc('strerror', status);
	mexnc('close',ncid);
	strformat = '%s:  mexnc:open failed on file ''%s'', error msg ''%s''.\n';
	msg = sprintf ( strformat, mfilename, ncfile, ncerr ); 
	handle_error ( msg, throw_exception );
	return
end


%
% Get variable id
%
[varid, status]=mexnc('inq_varid',ncid,varname);
if status ~= 0
	ncerr = mexnc('strerror', status);
	mexnc('close',ncid);
	strformat = '%s:  mexnc:inq_varid failed on variable ''%s'', file ''%s'', error msg ''%s''.\n';
	msg = sprintf ( strformat, mfilename, varname, ncfile, ncerr ); 
	handle_error ( msg, throw_exception );
	return
end

[dud,var_type,nvdims,var_dim,dud,status]=mexnc('inq_var',ncid,varid);
if status ~= 0
	ncerr_msg = mexnc ( 'strerror', status );
	mexnc('close',ncid);
	msg = sprintf ( '%s:  INQ_VAR failed on %s, file %s (%s)\n', mfilename, varname, ncerr_msg );
	handle_error ( msg, throw_exception );
	return
end



%
% Check that the start, count, stride parameters have appropriate lengths.
% Otherwise we get confusing error messages later on.
if ( USE_GET_VAR1 || USE_GET_VARA || USE_GET_VARS )
	if (length(start) ~= nvdims)
		mexnc('close',ncid);
		msg = sprintf ( '%s:  length of the start argument (%d) does not equal the number of dimensions (%d) for %s\n', mfilename, length(start), nvdims, varname );
		handle_error ( msg, throw_exception );
		return
	end
end
if ( USE_GET_VARA || USE_GET_VARS )
	if (length(count) ~= nvdims)
		mexnc('close',ncid);
		msg = sprintf ( '%s:  length of the count argument (%d) does not equal the number of dimensions (%d) for %s\n', mfilename, length(count), nvdims, varname );
		handle_error ( msg, throw_exception );
		return
	end
end
if ( USE_GET_VARS )
	if (length(stride) ~= nvdims)
		mexnc('close',ncid);
		msg = sprintf ( '%s:  length of the stride argument (%d) does not equal the number of dimensions (%d) for %s\n', mfilename, length(stride), nvdims, varname );
		handle_error ( msg, throw_exception );
		return
	end
end


%
% If a singleton, then use GET_VAR1.  This is only because some 
% opendap-enabled mexnc clients have trouble using GET_VAR on 
% singletons.  It is annoying to have to do this, but it works just as
% well.
if nvdims == 0

	%
	% Must be a scalar variable.  
	the_var_size = 1;
	USE_GET_VAR1 = 1;
	USE_GET_VAR = 0;
	start = 0;
	count = 1;

%
% otherwise we need to figure out how big the variable is.
else
	for n=1:nvdims,
	    dimid=var_dim(n);
	    [dud,dim_size,status]=mexnc('inq_dim', ncid, dimid);
	    if ( status ~= 0 )
		ncerr_msg = mexnc ( 'strerror', status );
		mexnc('close',ncid);
		msg = sprintf ( '%s:  INQ_DIM failed on dimid %d, file %s (%s)\n', mfilename, dimid, ncerr_msg );
		handle_error ( msg, throw_exception );
		return
	    end
	    the_var_size(n)=dim_size;
	end
end


%
% If the user had set non-positive numbers in "count", then
% we replace them with what we need to get the
% rest of the variable.
if USE_GET_VARA || USE_GET_VARS

	
	for j=1:nvdims
		if ( count(j) <= 0 )
			count(j) = the_var_size(j) - start(j);
		end
	end

end



%
% Is the requested size negative?
ind = find(count<0);
if ~isempty(ind)
	mexnc('close',ncid);
	hyperslab_start = sprintf ( '[%d]', start );
	hyperslab_request = sprintf ( '[%d]', count );
	hyperslab_extent = sprintf ( '[%d]', the_var_size );
	strformat = '%s:  requested ''%s'' data hyperslab extent %s + %s is negative, restate to fit existing data bounds %s.\n';
	msg = sprintf ( strformat, mfilename, varname, hyperslab_start, hyperslab_request, hyperslab_extent );
	handle_error ( msg, throw_exception );
	return_status = -1;
	return
end


if isempty(stride)
	stride = ones(size(count));
end


%
% Make sure that all three of start, count, and stride have
% the same length
if ( length(start) ~= length(count) )
	msg = sprintf ( '%s:  length of start argument must be the same as the count argument.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
else
	if ( length(start) ~= length(stride) )
		msg = sprintf ( '%s:  length of start argument must be the same as the stride argument.\n', mfilename );
		handle_error ( msg, throw_exception );
		return
	end
end

%
% Does the hyperslab exceed the dataset size?
if USE_GET_VARA || USE_GET_VARS
	last_datum_location_retrieved = start + (count-1).*stride;
	ind = find (last_datum_location_retrieved >= the_var_size );
	if ~isempty(ind)
		return_status = -1;
		mexnc('close',ncid);
		hyperslab_start = sprintf ( '[%d]', start );
		hyperslab_request = sprintf ( '[%d]', count );
		hyperslab_stride = sprintf ( '[%d]', stride );
		hyperslab_extent = sprintf ( '[%d]', the_var_size );
		format = '%s:  requested ''%s'' data hyperslab start %s, count %s, stride %s exceeds existing data bounds %s.\n';
		msg = sprintf ( format, mfilename, varname, hyperslab_start, hyperslab_request, hyperslab_stride, hyperslab_extent );
		handle_error ( msg, throw_exception );
		return
	end
end




%
% Get slab, unless the count is zero.
%
% There is a bug in Mexcdf.  If the count of the
% first dimension is zero, it core dumps.  Something to figure
% out later.
if prod(count) == 0
	mexnc('close',ncid);
	return
end


nc_datatype = nc_datatype_string(var_type);


%
% want slowest varying dimension to be # of rows
%if nvdims == 0
if USE_GET_VAR1


	switch ( nc_datatype )
		case 'NC_CHAR'
			[values, status] = mexnc ( 'get_var1_text', ncid, varid, 0 );
		case { 'NC_DOUBLE', 'NC_FLOAT', 'NC_INT', 'NC_SHORT', 'NC_BYTE' }
			[values, status] = mexnc ( 'get_var1_double', ncid, varid, 0 );
		otherwise
			ncerr_msg = mexnc ( 'strerror', status );
			msg = sprintf ( '%s:  unhandled datatype in GET_VAR1_XXX block, varname %s, file %s (%s)\n', mfilename, varname, ncfile, ncerr_msg );
			mexnc('close',ncid);
			handle_error ( msg, throw_exception );
			return

	end



%
% Get everything.
%elseif nargin == 2
elseif USE_GET_VAR

	switch ( nc_datatype )
		case 'NC_CHAR'
			[values, status] = mexnc ( 'get_var_text', ncid, varid);
		case { 'NC_DOUBLE', 'NC_FLOAT', 'NC_INT', 'NC_SHORT', 'NC_BYTE' }
			[values, status] = mexnc ( 'get_var_double', ncid, varid);
		otherwise
			ncerr_msg = mexnc ( 'strerror', status );
			msg = sprintf ( '%s:  unhandled datatype in GET_VAR_XXX block, varname %s, file %s (%s)\n', mfilename, varname, ncfile, ncerr_msg );
			mexnc('close',ncid);
			handle_error ( msg, throw_exception );
			return

	end

%elseif nargin == 5
elseif USE_GET_VARS

	switch ( nc_datatype )
		case 'NC_CHAR'
			[values, status] = mexnc ( 'get_vars_text', ncid, varid, start, count, stride );
		case { 'NC_DOUBLE', 'NC_FLOAT', 'NC_INT', 'NC_SHORT', 'NC_BYTE' }
			[values, status] = mexnc ( 'get_vars_double', ncid, varid, start, count, stride );
		otherwise
			ncerr_msg = mexnc ( 'strerror', status );
			msg = sprintf ( '%s:  unhandled datatype in GET_VARS_XXX block, varname %s, file %s (%s)\n', mfilename, varname, ncfile, ncerr_msg );
			mexnc('close',ncid);
			handle_error ( msg, throw_exception );
			return

	end


elseif USE_GET_VARA

	switch ( nc_datatype )
		case 'NC_CHAR'
			[values, status] = mexnc ( 'get_vara_text', ncid, varid, start, count);
		case { 'NC_DOUBLE', 'NC_FLOAT', 'NC_INT', 'NC_SHORT', 'NC_BYTE' }
			[values, status] = mexnc ( 'get_vara_double', ncid, varid, start, count);
		otherwise
			ncerr_msg = mexnc ( 'strerror', status );
			msg = sprintf ( '%s:  unhandled datatype in GET_VARA_XXX block, varname %s, file %s (%s)\n', mfilename, varname, ncfile, ncerr_msg );
			mexnc('close',ncid);
			handle_error ( msg, throw_exception );
			return

	end

else

	msg = sprintf ( '%s:  We could not figure out which one of the ''get_var?_xxx'' routines to use.\n', mfilename );
	handle_error ( msg, throw_exception );
	return

end



if ( status < 0 )
	mexnc('close',ncid);
	msg = sprintf ( '%s:  varget operation failed on %s, %s.\n', mfilename, varname, ncfile );
	handle_error ( msg, throw_exception );
	return
end

%
% If it's a 1D vector, make it a column vector.
if length(the_var_size) == 1
	values = values(:);
	%values = values';
elseif ( length(the_var_size) > 1 )
	pv = fliplr ( 1:length(the_var_size) );
	values = permute(values,pv);
end                                                                                   


%
% Handle the fill value, if any.  Change those values into NaN.
[dud, dud, status] = mexnc('INQ_ATT', ncid, varid, '_FillValue' );
if ( status == 0 )

	switch ( nc_datatype )
	case 'NC_CHAR'
		%
		% For now, do nothing.  Does a fill value even make sense with char data?
		% If it does, please tell me so.
		%

	case { 'NC_DOUBLE', 'NC_FLOAT', 'NC_INT', 'NC_SHORT', 'NC_BYTE' }
		[fill_value, status] = mexnc ( 'get_att_double', ncid, varid, '_FillValue' );
		fill_value_indices = find(values==fill_value);
		values(fill_value_indices) = NaN;

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



end









%
% Handle the scale factor and add_offsets. 
have_scale = 0;
have_addoffset = 0;
[dud, dud, status] = mexnc('INQ_ATT', ncid, varid, 'scale_factor' );
if ( status == 0 )
	have_scale = 1;
end
[dud, dud, status] = mexnc('INQ_ATT', ncid, varid, 'add_offset' );
if ( status == 0 )
	have_addoffset = 1;
end

if have_scale && have_addoffset
	switch ( nc_datatype )
	case 'NC_CHAR'
		%
		% do nothing.

	case { 'NC_DOUBLE', 'NC_FLOAT', 'NC_INT', 'NC_SHORT', 'NC_BYTE' }
		[scale_factor, status] = mexnc ( 'get_att_double', ncid, varid, 'scale_factor' );
		if ( status ~= 0 )
			mexnc('close',ncid);
			sprintf ( '%s:  ATT_GET_DOUBLE failed on scale_factor.\n', mfilename );
			handle_error ( msg, throw_exception );
			return
		end
		[add_offset, status] = mexnc ( 'get_att_double', ncid, varid, 'add_offset' );
		if ( status ~= 0 )
			mexnc('close',ncid);
			sprintf ( '%s:  ATT_GET_DOUBLE failed on add_offset.\n', mfilename );
			handle_error ( msg, throw_exception );
			return
		end
		
		values = values * scale_factor + add_offset;
	
	otherwise
		mexnc('close',ncid);
		msg = sprintf ( '%s:  unhandled datatype %s\n', mfilename, nc_datatype_string(var_type) );
		handle_error ( msg, throw_exception );
		return
	end
end





%
% remove any singleton dimensions.
values = squeeze ( values );



mexnc('close',ncid);


return_status = 0;
return






function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
