function return_status = nc_attput ( ncfile, varname, attribute_name, attval )
% NC_ATTPUT:  put an attribute into a netcdf file
%
% USAGE:  status = nc_attput ( ncfile, varname, attribute_name, attval );
%
% PARAMETERS:
% Input:
%    ncfile:  name of netcdf file being altered
%    varname:  
%        name of variable being altered.  
%        'GLOBAL' or '' denotes a global attribute.
%        If a numeric -1 is passed in, this will also indicate
%        a global attribute.
%    attribute_name:  name of attribute being altered
%    attval:  value of attribute to be written
% Output:
%       Optional.  If status is not asked for, then nc_attput will
%       throw an exception if unsuccessful.  If asked for, then the
%       return values could be -1 for failure, 0 for success
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_attput.m,v 1.15 2006/04/25 18:47:14 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargout < 1
	throw_exception = 1;
else
	throw_exception = 0;
end



%
% assume failure until success is known
return_status = -1;

if nargin ~= 4
	msg = sprintf ( '%s:  must have 4 input arguments.\n\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end



[ncid, status] =mexnc( 'open', ncfile, nc_write_mode );
if  status ~= 0 
	ncerror_msg = mexnc ( 'strerror', status );
	msg = sprintf ( 'nc_attput:  mexnc failed on %s with ''write'' mode, (%s).\n\n', ncfile, ncerror_msg );
	handle_error ( msg, throw_exception );
	return;
end


%
% Put into define mode.
status = mexnc ( 'redef', ncid );
if ( status ~= 0 )
	mexnc ( 'close', ncid );
	ncerror_msg = mexnc ( 'strerror', status );
	msg = sprintf ( 'nc_attput:  mexnc operation ''redef'' failed on %s (%s).\n\n', ...
	          ncfile, ncerror_msg );
	handle_error ( msg, throw_exception );
	return;
end


%
% If the user passed in the name 'GLOBAL' then we need to check
% that 'GLOBAL' is not the name of a variable.  If it is not, then
% the user must have meant global attribute.
%
% Assume at first that the user did not mean a global attribute.  Then
% test all the conditions under which this could be invalidated.
user_intent_is_global=0;
lvarname = lower(varname);
if ( (ischar(varname)) && ( strcmp(lvarname,'global') || strcmp(lvarname,'nc_global') ) )
	[varid, status] = mexnc ( 'inq_varid', ncid, varname );
	if ( status ~= 0 )
		%
		% There is NO variable called 'global'.
		user_intent_is_global=1;
		varname = 'NC_GLOBAL';
	end
end

%
% -1 is the varid corresponding to NC_GLOBAL.
if ( (isnumeric(varname)) && (varname == -1) )
	user_intent_is_global = 1;
end

%
% I suppose that '' is invalid as a variable name, so
% it could work to signify a global attribute.
if ( (ischar(varname)) && ( strcmp(varname, '') ) )
	varid = -1;
end

if user_intent_is_global
	varid = -1;
	varname = 'NC_GLOBAL';
else
	[varid, status] = mexnc ( 'inq_varid', ncid, varname );
	if ( status ~= 0 )
		mexnc ( 'close', ncid );
		ncerror_msg = mexnc ( 'strerror', status );
		msg = sprintf ( '%s:  mexnc operation ''inq_varid'' failed on %s (%s).\n\n', ...
		          mfilename, ncfile, ncerror_msg );
		handle_error ( msg, throw_exception );
		return;
	end
end

switch class(attval)

	case 'double'
		status = mexnc ( 'put_att_double', ncid, varid, attribute_name, nc_double, length(attval), attval);
	case 'single'
		status = mexnc ( 'put_att_float', ncid, varid, attribute_name, nc_float, length(attval), attval);
	case 'int32'
		status = mexnc ( 'put_att_int', ncid, varid, attribute_name, nc_int, length(attval), attval);
	case 'int16'
		status = mexnc ( 'put_att_short', ncid, varid, attribute_name, nc_short, length(attval), attval);
	case 'int8'
		status = mexnc ( 'put_att_schar', ncid, varid, attribute_name, nc_byte, length(attval), attval);
	case 'uint8'
		status = mexnc ( 'put_att_uchar', ncid, varid, attribute_name, nc_byte, length(attval), attval);
	case 'char'
		status = mexnc ( 'put_att_text', ncid, varid, attribute_name, nc_char, length(attval), attval);
	otherwise
		mexnc ( 'close', ncid );
		msg = sprintf ( '%s:  attribute class %s is not handled.\n\n', ...
				mfilename, ncfile );
		handle_error ( msg, throw_exception );
		return;
end



if ( status ~= 0 )
	mexnc ( 'close', ncid );
	ncerror_msg = mexnc ( 'strerror', status );
	msg = sprintf ( 'nc_attput:  mexnc operation ''put_att_xxx'' failed on %s, %s, %s attribute (%s).\n\n', ...
	          ncfile, varname, attribute_name, ncerror_msg );
	handle_error ( msg, throw_exception );
	return;
end



%
% End define mode.
status = mexnc ( 'end_def', ncid );
if ( status ~= 0 )
	mexnc ( 'close', ncid );
	ncerror_msg = mexnc ( 'strerror', status );
	msg = sprintf ( 2, ...
	          'nc_attput:  mexnc operation ''endef'' failed on %s.\n\n', ...
	          ncfile );
	handle_error ( msg, throw_exception );
	return;
end


status = mexnc('close',ncid);
if ( status ~= 0 )
	ncerror_msg = mexnc ( 'strerror', status );
	msg = sprintf ( 'nc_attput:  mexnc operation ''close'' failed on %s (%s).\n\n', ...
	          ncfile, ncerror_msg );
	handle_error ( msg, throw_exception );
	return;
end


%
% if we got this far, we must have succeeded.
return_status = 0;
return;






function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
