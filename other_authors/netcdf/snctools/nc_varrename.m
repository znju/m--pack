function return_status = nc_varrename ( ncfile, old_variable_name, new_variable_name )
% NC_VARRENAME:  Renames a NetCDF variable.
%
% USAGE:  status = nc_varrename ( netcdf_file, old_variable_name, new_variable_name );
%
% PARAMETERS:
% Input:
%     netcdf_file:  
%        Input netcdf file name.
%     old_variable_name:
%        Name of variable that we wish to rename.
%     new_variable_name:
%        The variable is renamed to this.
% Output:
%     status:
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 if the routine succeeds
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_varrename.m,v 1.11 2006/04/25 18:47:14 johnevans007 Exp $
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



% Show usage if too few arguments.
%
if nargin~=3 
	msg = sprintf ( '%s:  must have three input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


%
% Open netCDF file
%
[ncid,status ]=mexnc('OPEN',ncfile,nc_write_mode);
if status < 0
	msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end


%
% Put into redef mode
status = mexnc('REDEF', ncid);
if status < 0
	mexnc('close',ncid);
	msg = sprintf ( '%s:  mexnc:redef failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end



% 
% Find the old variable.
[varid, status] = mexnc('INQ_VARID', ncid, old_variable_name);
if status < 0
	mexnc('close',ncid);
	msg = sprintf ( '%s:  mexnc:varid failed on %s:%s.\n', mfilename, ncfile, old_variable_name );
	handle_error ( msg, throw_exception );
	return
end


status = mexnc('RENAME_VAR', ncid, varid, new_variable_name);
if status < 0
	mexnc('close',ncid);
	msg = sprintf ( '%s:  mexnc:varrename failed on %s:%s.\n', mfilename, ncfile, old_variable_name );
	handle_error ( msg, throw_exception );
	return
end

%
% Leave redef mode
status = mexnc('END_DEF', ncid);
if status < 0
	mexnc('close',ncid);
	msg = sprintf ( '%s:  mexnc:endef failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end

mexnc('close',ncid);

return_status = 0;

return;






function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return

