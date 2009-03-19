function [values, return_status] = nc_attget(ncfile, varname, attribute_name )
% NC_ATTGET: Get the values of a NetCDF attribute.
%
% USAGE:  [values, status] = nc_attget(ncfile, varname, attribute_name);
%
% PARAMETERS:
% Input:
%   ncfile:  
%       name of netcdf file in question
%   varname:  
%       name of variable in question.  Use nc_global to retrieve a 
%       global attribute.
%   attribute_name:  
%       name of attribute in question
% Output:    
%   values:  
%       value of attribute asked for.  Returns the empty matrix 
%       in case of an error.  There is an ambiguity in the case of 
%       NC_BYTE data, so it is always retrieved as an int8 datatype.
%       If you wanted uint8, then you must cast it yourself.
%   status:  
%       Optional.  If status is not asked for, then nc_attget will
%       throw an exception if unsuccessful.  If asked for, then the
%       return values could be.
%           0 if nc_attget is successful.
%           -1 if nc_attget fails badly.
%           -2 if nc_attget does not locate the attribute.  This is not
%               necessarily a bad thing.  No error message will be
%               printed.
%
% Example:
%    [values, status] = nc_attget('foo.cdf', 'x', 'scale_factor')
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_attget.m,v 1.17 2006/04/25 18:47:14 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%
% assume failure until we know otherwise.
return_status = -1;
values = [];

if nargout < 2
	throw_exception = 1;
else
	throw_exception = 0;
end

if nargin < 3
	msg = sprintf ( '%s:  need at least three input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


[ncid, status] =mexnc('open', ncfile, nc_nowrite_mode );
if ( status ~= 0 )
	ncerror = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  mexnc:open failed on %s (%s).\n', mfilename, ncfile, ncerror );
	handle_error ( msg, throw_exception );
	return
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
	user_intent_is_global = 1;
	varid = nc_global;
end

if user_intent_is_global
	varid = nc_global;
	varname = 'NC_GLOBAL';
else
	[varid, status] = mexnc ( 'inq_varid', ncid, varname );
	if ( status ~= 0 )
		mexnc('close',ncid);
		ncerror = mexnc ( 'strerror', status );
		msg = sprintf ( '%s:  ''inq_varid'' failed, ''%s''.\n', ...
		          mfilename, ncerror );
		handle_error ( msg, throw_exception );
		return
	end
end



[dt, len, status]=mexnc('inq_att',ncid,varid,attribute_name);
if ( status ~= 0 )

	%
	% If the attribute doesn't exist, then this is a special case.
	return_status = -2;
	mexnc('close',ncid);
	ncerr = mexnc ( 'strerror', status );
	handle_error ( ncerr, throw_exception );
	return

end

datatype_string = nc_datatype_string(dt);
switch ( datatype_string )
case 'NC_DOUBLE'
	[values, status]=mexnc('get_att_double',ncid,varid,attribute_name);
case 'NC_FLOAT'
	[values, status]=mexnc('get_att_float',ncid,varid,attribute_name);
case 'NC_INT'
	[values, status]=mexnc('get_att_int',ncid,varid,attribute_name);
case 'NC_SHORT'
	[values, status]=mexnc('get_att_short',ncid,varid,attribute_name);
case 'NC_BYTE'
	[values, status]=mexnc('get_att_schar',ncid,varid,attribute_name);
case 'NC_CHAR'
	[values, status]=mexnc('get_att_text',ncid,varid,attribute_name);
otherwise
	format = '%s:  unrecognized datatype %s.\n';
	msg = sprintf ( 2, format, mfilename, datatype_string );
	handle_error ( msg, throw_exception );
	return
end

if ( status ~= 0 )
	ncerror = mexnc ( 'strerror', status );
	msg = sprintf ( 2, '%s:  ''get_att____'' failed on %s, %s, %s, (%s).\n', ...
	          mfilename, ncfile, varname, attribute_name, ncerror );
	mexnc('close',ncid);
	handle_error ( msg, throw_exception );
	return
end

status = mexnc('close',ncid);
if ( status ~= 0 )
	ncerror = mexnc ( 'strerror', status );
	msg = sprintf ( 2, '%s:  ''close'' failed on %s, (%s).\n', ...
	          mfilename, ncfile, ncerror );
	handle_error ( msg, throw_exception );
	return
end


return_status = 0;
return;





function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
