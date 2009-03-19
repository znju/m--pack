function return_status = nc_addvar ( ncfile, varstruct )
% NC_ADDVAR:  adds a variable to a NetCDF file
%
% USAGE:  status = nc_addvar ( ncfile, varstruct );
%
% PARAMETERS:
% Input
%    ncfile:
%    varstruct:
%        This is a structure with four fields:
%
%        Name
%        Nctype
%        Dimension
%        Attribute
%
%      "Name" is just that, the name of the variable to be defined.
%
%      "Nctype" should be 
%          'double', 'float', 'int', 'short', or 'byte', or 'char'
%          'NC_DOUBLE', 'NC_FLOAT', 'NC_INT', 'NC_SHORT', 'NC_BYTE', 'NC_CHAR'
%
%      "Dimension" is a cell array of dimension names.
%
%      "Attribute" is also a structure array.  Each element has two
%      fields, "Name", and "Value".
%
% Output: 
%     status:
%         Optional.  If not requested, an exception is thrown if an
%         error condition arises.  Otherwise, -1 is returned if the 
%         routine fails, or 0 is the routine succeeds
%
% AUTHOR:
%    johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_addvar.m,v 1.17 2006/04/25 18:47:14 johnevans007 Exp $
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
	msg = sprintf ( '%s:  must have two input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


if ( ~strcmp(class(ncfile),'char') )
	msg = sprintf ( '%s:  1st input argument must be char.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

if ( ~isstruct(varstruct) )
	msg = sprintf ( '%s:  2nd input argument must be a structure.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

%
% Check that required fields are there.
% Must at least have a name.
if ~isfield ( varstruct, 'Name' )
	msg = sprintf ( '%s:  variable structure must at least have ''Name'' field.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

%
% Check that required fields are there.
% Default Nctype is double.
if ~isfield ( varstruct, 'Nctype' )
	varstruct.Nctype = 'double';
end


% If the datatype is not a string.
% Change suggested by Brian Powell
if ( isa(varstruct.Nctype, 'double') && varstruct.Nctype < 7 )
	types={ 'byte' 'char' 'short' 'int' 'float' 'double'};
	varstruct.Nctype = char(types(varstruct.Nctype));
end


%
% Check that the datatype is known.
switch ( varstruct.Nctype )
case { 'NC_DOUBLE', 'double', ...
	'NC_FLOAT', 'float', ...
	'NC_INT', 'int', ...
	'NC_SHORT', 'short', ...
	'NC_BYTE', 'byte', ...
	'NC_CHAR', 'char'  }
	%
	% Do nothing
otherwise
	msg = sprintf ( '%s:  unknown Nctype ''%s''\n', mfilename, varstruct.Nctype );
	handle_error ( msg, throw_exception );
	return
end

%
% Check that required fields are there.
% Default Dimension is none.  Singleton scalar.
if ~isfield ( varstruct, 'Dimension' )
	varstruct.Dimension = [];
end

%
% Check that required fields are there.
% Default Attributes are none
if ~isfield ( varstruct, 'Attribute' )
	varstruct.Attribute = [];
end

[ncid, status] = mexnc ( 'open', ncfile, nc_write_mode );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  mexnc:open failed on ''%s'', error message ''%s''.\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end

%
% determine the dimids of the named dimensions
num_dims = length(varstruct.Dimension);
dimids = [];
for j = 1:num_dims
	[dimids(j), status] = mexnc ( 'dimid', ncid, varstruct.Dimension{j} );
	if ( status < 0 )
		ncerr = mexnc ( 'strerror', status );
		mexnc ( 'close', ncid );
		strformat = '%s:  mexnc:dimid failed to return a dimid for %s, file %s, error ''%s''.\n';
		msg = sprintf ( strformat, mfilename, varstruct.Dimension{j}, ncfile, ncerr );
		handle_error ( msg, throw_exception );
		return
	end
end


%
% go into define mode
status = mexnc ( 'redef', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	mexnc ( 'close', ncid );
	msg = sprintf ( '%s:  mexnc:redef failed on %s, ''%s''.\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end

status = mexnc ( 'def_var', ncid, varstruct.Name, varstruct.Nctype, num_dims, dimids );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	mexnc ( 'endef', ncid );
	mexnc ( 'close', ncid );
	msg = sprintf ( '%s:  mexnc:def_var failed on %s, ''%s''.\n', mfilename, ncfile, ncerr );
	handle_error ( msg, throw_exception );
	return
end



status = mexnc ( 'endef', ncid );
if ( status < 0 )
	mexnc ( 'close', ncid );
	msg = sprintf ('%s:  mexnc:endef failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end

status = mexnc ( 'close', ncid );
if ( status < 0 )
	msg = sprintf ( '%s:  mexnc:close failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return;
end



%
% Now just use nc_attput to put in the attributes
for j = 1:length(varstruct.Attribute)
	attname = varstruct.Attribute(j).Name;
	attval = varstruct.Attribute(j).Value;
	status = nc_attput ( ncfile, varstruct.Name, attname, attval );
	if ( status == -1 )
		msg = sprintf ( '%s:  nc_attput failed to write %s to variable %s, file %s.\n', mfilename, attname, varstruct.Name, ncfile );
		handle_error ( msg, throw_exception );
		return
	end
end

return_status = 0;






function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
