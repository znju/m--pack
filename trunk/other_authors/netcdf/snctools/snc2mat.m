function return_status = snc2mat ( ncfile, matfile )
% SNC2MAT:  saves netcdf file to *.mat format
%
% USAGE:  snc2mat ( ncfile, matfile );
%
% PARAMETERS:
% Input:
%     ncfile:
%         path of input netcdf file
%     matfile:
%         path of output MATLAB mat file 
% Output:
%     status:
%         -1 if the routine fails, 0 if it returns successfully
%         If no return argument is given, the routine throws an
%         exception in case of an error.
% 
% The basic structure of the netcdf file is maintained in the *.mat file.
% If one does
%
% >> b = load ( matfile );
%
% then b will be a matlab structure with fields corresponding to the
% netcdf variables and global attributes.   See NC_GETALL to get a 
% general idea of how the structure is put together.
%
% This routine will break down on files or single datasets that would
% constitute a large percentage of your system RAM.  So just be aware
% of that.  This routine will not be supported with SNCTOOLS(netcdf-4).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: snc2mat.m,v 1.1 2005/10/26 14:06:45 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout < 1
	throw_exception = 1;
else
	throw_exception = 0;
end
return_status = -1;

%
% create the MATLAB file
[ncdata, status] = nc_getall ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_getall failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end

fnames = fieldnames ( ncdata );
save_command = '';
global_atts = [];
for j = 1:length(fnames)
	theVar = fnames{j};
	if ( strcmp(theVar,'global_atts' ) )
		global_atts = ncdata.global_atts;
	else
		command = sprintf ( '%s = ncdata.%s;', theVar, theVar );
		eval(command);
		save_command = sprintf ( '%s''%s'',', save_command, theVar );
	end
end
if ~isempty(global_atts)
	save_command = sprintf ( '%s''global_atts''', save_command );
else
	%
	% This chops off a bad comma that's not needed if no global attributes.
	save_command(end) = '';
end
save_command = sprintf ( 'save ( matfile, %s );', save_command );
try
	eval(save_command);
catch
	fprintf ( 2, '%s:  Could not execute ''%s'', got error message ''%s''\n', mfilename, save_command, lasterr );
	handle_error ( msg, throw_exception );
	return_status = -1;
	return;
end


	

return_status = 0;
return





function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
