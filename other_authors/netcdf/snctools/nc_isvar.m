function [yn, return_status] = nc_isvar ( ncfile, varname )
% NC_ISVAR:  yes if the given variable is in the netcdf file
%
% USAGE:  [yn, status] = nc_isvar ( ncfile, varname );
%
% PARAMETERS:
% Input:
%     ncfile:  
%        Input netcdf file name.
%     varname:  
%        variable to check
% Output:
%     yn:  
%        0 if the answer is no, 1 if yes.
%     status:  
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 if the routine succeeds
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_isvar.m,v 1.9 2005/08/04 14:07:11 johnevans007 Exp $
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
	return;
end


%
% Open netCDF file
%
[ncid,status ]=mexnc('open',ncfile, nc_nowrite_mode );
if status ~= 0
	msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end


[varid, status] = mexnc('INQ_VARID', ncid, varname);
if ( status < 0 )
	yn = 0;
	return_status = 0;
elseif varid >= 0
	yn = 1;
	return_status = 0;
else
	return_status = -1;
end

mexnc('close',ncid);
return




function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return

