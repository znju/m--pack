function [Dimension, return_status] = nc_getdiminfo ( arg1, arg2 )
% NC_GETDIMINFO:  returns metadata about a specific NetCDF dimension
%
% USAGE:  [Dimension, status] = nc_getdiminfo ( file_id, dim_id );
%
% PARAMETERS:
% Input:
%    file_id:  
%        either a string that specifies the name of the NetCDF file, or
%        the already opened NetCDF file id
%    dim_id:  
%        either a string that specifies the name of the NetCDF variable,
%        or the already accessed NetCDF variable id
%
%    If the filename and dimension name are given, then the file will
%    be closed upon either successful completion of the routine or also
%    in the case of an error.  If the NetCDF IDs are given, then the
%    file is not closed (the calling routine has to take care of that).
%
% Output:
%    Dimension:
%        A structure whose fields metadata about the NetCDF dimension.
%        The set of fields returned in Dimension are:
%
%        Name:  
%            a string containing the name of the dimension.
%        Length:  
%            a scalar equal to the length of the dimension
%        Dimid:  
%            a scalar specifying the NetCDF dimension id 
%        Record_Dimension:  
%            Flag, either 1 if the dimension is an unlimited dimension
%            or 0 if not.
%    status:
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 is the routine succeeds
%
% This routine purposefully mimics that of Mathwork's hdfinfo.
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_getdiminfo.m,v 1.6 2006/04/25 18:47:14 johnevans007 Exp $
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
Dimension = [];


%
% Check for proper inputs.
if nargin ~= 2
	msg = sprintf ( '%s:  two input arguments are required.\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end


%
% If we are here, then we must have been given something local.
if ischar(arg1) && ischar(arg2)

	ncfile = arg1;
	dimname = arg2;


	%
	% Open netCDF file
	%
	[ncid,status ]=mexnc('open', ncfile, nc_nowrite_mode );
	if status ~= 0
		msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
		handle_error ( msg, throw_exception );
		return
	end


	[dimid, status] = mexnc('DIMID', ncid, dimname);
	if ( status < 0 )
		mexnc('close',ncid);
		msg = sprintf ( '%s:  mexnc:dimid failed on file ''%s'', dimension ''%s''.\n', mfilename, ncfile, dimname );
		handle_error ( msg, throw_exception );
		return
	end

	
	% 
	% Get the information.
	[Dimension, status] = get_diminfo ( ncid,  dimid );
	if ( status < 0 )
		msg = sprintf ( '%s:  get_diminfo failed on %s, file %s.\n', mfilename, ncfile, dimname );
		handle_error ( msg, throw_exception );
		return
	end

	%
	% close whether or not we were successful.
	mexnc('close',ncid);


elseif isnumeric ( arg1 ) && isnumeric ( arg2 )

	ncid = arg1;
	dimid = arg2;

	%
	% Ok, we were passed the file id and variable id.
	[Dimension, status] = get_diminfo ( ncid,  dimid );
	if ( status < 0 )
		msg = sprintf ( '%s:  get_diminfo failed on dimid %d.\n', mfilename, dimid );
		handle_error ( msg, throw_exception );
		return
	end


else
	msg = sprintf ( '%s:  cannot have mixed input types.  Either specify the filename and dimension name, or give the NetCDF file id and dimid.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


return_status = 0;

return





function [Dimension, status] = get_diminfo ( ncid, dimid )


[unlimdim, status] = mexnc ( 'inq_unlimdim', ncid );
if status < 0
	fprintf ( 2, '%s:  mexnc:inq_unlimdim failed.\n', mfilename );
	mexnc('close',ncid);
	Dimension = [];
	status = -1;
	return
end



[dimname, dimlength, status] = mexnc('DIMINQ', ncid, dimid);
if status < 0
	fprintf ( 2, '%s:  mexnc:inquire failed.\n', mfilename );
	mexnc('close',ncid);
	return
end

Dimension.Name = dimname;
Dimension.Length = dimlength;
Dimension.Dimid = dimid;

if dimid == unlimdim
	Dimension.Record_Dimension = 1;
else
	Dimension.Record_Dimension = 0;
end

status = 0;

return


function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
