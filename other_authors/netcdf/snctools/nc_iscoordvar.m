function [ yn, return_status ] = nc_iscoordvar ( ncfile, varname )
% NC_ISCOORDVAR:  yes if the given variable is also a coordinate variable.
%
% A coordinate variable is a variable with just one dimension.  That 
% dimension has the same name as the variable itself.
%
% USAGE:  [yn, status] = nc_iscoordvar ( ncfile, varname );
%
% PARAMETERS:
% Input:
%     ncfile:  
%        Input netcdf file name.
%     varname:  
%        variable to check
% Output:
%     yn:
%         1 if the variable is a coordinate variable
%         0 if the variable is not a coordinate variable
%     status:
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 if the routine succeeds
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_iscoordvar.m,v 1.10 2005/08/03 12:13:59 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargout < 2
	throw_exception = 1;
else
	throw_exception = 0;
end




% assume false until we know otherwise
yn = 0;
return_status = -1;




% Show usage if too few arguments.
%
if nargin~=2 
	msg = sprintf ( '%s:  must have two input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

if ~ischar ( varname )
	msg = sprintf ( '%s:  varname input must be character.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

[ncvar, status] = nc_getvarinfo ( ncfile, varname );
if status < 0
	msg = sprintf ( '%s:  nc_getvarinfo failed on variable %s.\n', mfilename, varname );
	handle_error ( msg, throw_exception );
	return
end

%
% Check that it's not a singleton.  If it is, then the answer is no.
if isempty(ncvar.Dimension)
	return_status = 0;
	return
end

%
% Check that the names are the same.
if strcmp ( ncvar.Dimension{1}, varname )
	yn = 1;
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
