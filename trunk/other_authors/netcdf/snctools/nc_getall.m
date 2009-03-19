function [data, return_status] = nc_getall ( ncfile )
% NC_GETALL:  read the entire contents of a netcdf file into a nested structure
%
% This routine was a good idea, but is really kind of flawed.  What 
% can be a valid NetCDF variable name is not necessarily a valid
% matlab structure field name.  Getting around this is fairly 
% clumsy.  
%
% USAGE:  [structure, status] = nc_getall ( ncfile );
%
% PARAMETERS:
% Input:
%     ncfile:  
%        Input netcdf file name.
% Output:
%     structure:
%        Structure with all netcdf data present.  Each variable will
%        be a substructure.  Within each variable lies the data and 
%        each attribute.  The global attributes are stored in a 
%        sub-structure called 'global_atts'
% return_status:
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 is the routine succeeds
%       -1 if the routine fails, 0 if successful
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_getall.m,v 1.14 2006/04/25 18:47:14 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




if nargout < 2
	throw_exception = 1;
else
	throw_exception = 0;
end




%
% assume failure until success is known
return_status = -1;
data = [];


% Show usage if too few arguments.
%
if nargin~=1 
	msg = sprintf ( '%s:  must have one input argument.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


%
% Open netCDF file
%
[cdfid,status ]=mexnc('open',ncfile,'NOWRITE');
if status ~= 0
	msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end



[ndims, nvars, ngatts, recdim, status] = mexnc('INQ', cdfid);
if status < 0
	mexnc('close',cdfid);
	msg = sprintf ( '%s:  mexnc:inq failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end

for varid=0:nvars-1

	varstruct = [];

	[varname, datatype, ndims, dims, natts, status] = mexnc('INQ_VAR', cdfid, varid);
	if status < 0 
		mexnc('close',cdfid);
		msg = sprintf ( '%s:  mexnc:inq_var failed on varid %d, file %s.\n', mfilename, varid, ncfile );
		handle_error ( msg, throw_exception );
		return;
	end


	%
	% If ndims is zero, then it must be a singleton variable.  Don't bother trying
	% to retrieve the data, there is none.
	if ( ndims == 0 )
		varstruct.data = [];
	else
		[values, status] = nc_varget(ncfile, varname);
		if status < 0 
			mexnc('close',cdfid);
			msg = sprintf ( '%s:  nc_varget failed on %s, file %s.\n', mfilename, varname, ncfile );
			handle_error ( msg, throw_exception );
			return
		end

		varstruct = setfield ( varstruct, 'data', values );
	end



	%
	% get all the attributes
	for attnum = 0:natts-1

		[attname, status] = mexnc('inq_attname', cdfid, varid, attnum);
		if status < 0 
			mexnc('close',cdfid);
			msg = sprintf ( '%s:  mexnc:inq_attname failed on %s, file %s.\n', mfilename, varname, ncfile );
			handle_error ( msg, throw_exception );
			return
		end

		[attval, status] = nc_attget(ncfile, varname, attname);
		if status < 0 
			mexnc('close',cdfid);
			msg = sprintf ( '%s:  nc_attget failed on %s, %s, file %s.\n', mfilename, attname, varname, ncfile );
			handle_error ( msg, throw_exception );
			return
		end
		
		%
		% Matlab structures don't like the leading '_'
		if strcmp(attname,'_FillValue' )
			attname = 'FillValue';
		end


		sanitized_attname = matlab_sanitize_attname ( attname );


		%
		% this puts the attribute into the variable structure
		varstruct = setfield ( varstruct, sanitized_attname, attval );


	end


	%
	% Add this variable to the entire file structure
	data = setfield ( data, varname, varstruct );

end


%
% Do the same for the global attributes
%
% get all the attributes
varname = 'global';
global_atts = [];
for attnum = 0:ngatts-1

	[attname, status] = mexnc('inq_attname', cdfid, nc_global, attnum);
	if status < 0 
		mexnc('close',cdfid);
		fprintf ( '%s:  mexnc:inq_attname failed on %s, file %s.\n', mfilename, varname, ncfile );
		handle_error ( msg, throw_exception );
		return
	end

	[attval, status] = nc_attget(ncfile, nc_global, attname);
	if status < 0 
		mexnc('close',cdfid);
		msg = sprintf ( '%s:  nc_attget failed on %s, %s, file %s.\n', mfilename, attname, varname, ncfile );
		handle_error ( msg, throw_exception );
		return
	end
	
	sanitized_attname = matlab_sanitize_attname ( attname );


	%
	% this puts the attribute into the variable structure
	global_atts = setfield ( global_atts, sanitized_attname, attval );



end

if ~isempty ( global_atts )
	data = setfield ( data, 'global_atts', global_atts );
end

mexnc('close',cdfid);

if isempty(data)
	data = struct([]);
end

return_status = 1;

return



function sanitized_attname = matlab_sanitize_attname ( attname )
	%
	% could the attribute name  be interpreted as a number?
	% If so, must fix this.
	% An attribute name of, say, '0' is not permissible in matlab
	if ~isnan(str2double(attname))
		sanitized_attname = ['x_' attname];
	else

		sanitized_attname = attname;

		%
		% Does the attribute have non-letters in the leading 
		% position?  Convert these to underscores.  
		if ( ~isletter(attname(1)) );
			sanitized_attname(1) = '_';
		end
	end
return





function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
