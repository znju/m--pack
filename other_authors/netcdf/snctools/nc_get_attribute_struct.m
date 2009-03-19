function [attribute, return_status] = nc_get_attribute_struct ( cdfid, varid, attnum )
% NC_GET_ATTRIBUTE_STRUCT:  Returns a NetCDF attribute as a structure
%
% You don't want to be calling this routine directly.  Just don't use 
% it.  Use nc_attget instead.  Go away.  Nothing to see here, folks.  
% Move along, move along.
%
% USAGE:  [attstruct, status] = nc_get_attribute_struct ( cdfid, varid, attnum );
%
% PARAMETERS:
% Input:
%     cdfid:  NetCDF file id
%     varid:  NetCDF variable id
%     attnum:  number of attribute
% Output:
%     attstruct:  structure with "Name", "Nctype", "Attnum", and "Value" fields
%     status:  
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 is the routine succeeds
%
% USED BY:  nc_getinfo.m, nc_getvarinfo.m
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_get_attribute_struct.m,v 1.11 2006/04/25 18:47:14 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargout < 2
	throw_exception = 1;
else
	throw_exception = 0;
end

return_status = -1;

%
% Fill the attribute struct with default values
attribute.Name = '';
attribute.Nctype = NaN;
attribute.Attnum = attnum;   % we know this at this point
attribute.Value = NaN;       % In case the routine fails?


[attname, status] = mexnc('INQ_ATTNAME', cdfid, varid, attnum);
if status < 0 
	msg = sprintf ( '%s:  mexnc:inq_attname failed on varid %d.\n', mfilename, varid );
	handle_error ( msg, throw_exception );
	return
end
attribute.Name = attname;

[att_datatype, status] = mexnc('INQ_ATTTYPE', cdfid, varid, attname);
if status < 0 
	msg = sprintf ( '%s:  mexnc:inq_att failed on varid %d, attribute %s.\n', mfilename, varid, attname );
	handle_error ( msg, throw_exception );
	return
end
attribute.Nctype = att_datatype;

switch att_datatype
case 0
	attval = NaN;
case nc_char
	[attval, status]=mexnc('get_att_text',cdfid,varid,attname);
case { nc_double, nc_float, nc_int, nc_short, nc_byte }
	[attval, status]=mexnc('get_att_double',cdfid,varid,attname);
otherwise
	msg = sprintf ( 'att_datatype is %d.\n', att_datatype );
	handle_error ( msg, throw_exception );
	return
end
if status < 0 
	msg = sprintf ( '%s:  mexnc:attget failed on varid %d, attribute %s.\n', mfilename, varid, attname );
	handle_error ( msg, throw_exception );
	return
end

%
% this puts the attribute into the variable structure
attribute.Value = attval;

return_status = 0;

return




function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
