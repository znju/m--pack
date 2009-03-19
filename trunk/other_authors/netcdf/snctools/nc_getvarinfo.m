function [DataSet, return_status] = nc_getvarinfo ( arg1, arg2 )
% NC_GETVARINFO:  returns metadata about a specific NetCDF variable
%
% USAGE:  [DataSet, status] = nc_getvarinfo ( file_id, var_id );
%
% PARAMETERS:
% Input:
%    file_id:  
%        either a string that specifies the name of the NetCDF file, or
%        the already opened NetCDF file id
%    var_id:  
%        either a string that specifies the name of the NetCDF variable,
%        or the already accessed NetCDF variable id
%
%    If the filename and variable name are given, then the file will
%    be closed upon either successful completion of the routine or also
%    in the case of an error.  If the NetCDF IDs are given, then the
%    file is not closed (the calling routine has to take care of that).
%
% Output:
%    DataSet:
%        A structure whose fields contain information about the contents
%        of the NetCDF file.  The set of fields return in "fileinfo" are:
%
%        Name:  
%            a string containing the name of the variable.
%        Nctype:  
%            a string specifying the NetCDF datatype of this variable.
%        Varid:  
%            a scalar specifying the NetCDF variable id (varid)
%        IsUnlimitedVariable:  
%            Flag, either 1 if the variable has an unlimited dimension
%            or 0 if not.
%        Dimensions:  
%            a cell array with the names of the dimensions upon which
%            this variable depends.
%        Rank:  
%            Array that describes the size of each dimension upon which 
%            this dataset depends.
%        Attribute:  
%            An array of structures corresponding to the attributes defined
%            for the specified variable.
%                         
%        Each "Attribute" element contains the following fields.
%
%            Name:  
%                a string containing the name of the attribute.
%            Nctype:  
%                a string specifying the NetCDF datatype of this 
%                attribute.
%            Attnum:  
%                a scalar specifying the attribute id
%            Value: 
%                either a string or a double precision value 
%                corresponding to the value of the attribute
%    status:
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 if the routine succeeds
%
% This routine purposefully mimics that of Mathwork's hdfinfo.
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_getvarinfo.m,v 1.25 2006/04/25 18:47:14 johnevans007 Exp $
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
DataSet = [];


% Show usage if too few arguments.
%
if nargin<2 
	msg = sprintf ( '%s:  not enough input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end


%
% If we are here, then we must have been given something local.
if ischar(arg1) && ischar(arg2)

	ncfile = arg1;
	varname = arg2;


	%
	% Open netCDF file
	%
	[ncid,status ]=mexnc('open',ncfile,nc_nowrite_mode);
	if status ~= 0
		msg = sprintf ( '%s:  mexnc:open failed on ''%s''.\n', mfilename, ncfile );
		handle_error ( msg, throw_exception );
		return
	end


	[varid, status] = mexnc('INQ_VARID', ncid, varname);
	if ( status < 0 )
		mexnc('close',ncid);
		msg = sprintf ( '%s:  mexnc:inq_varid failed on ''%s'', variable ''%s''.\n', mfilename, ncfile, varname );
		handle_error ( msg, throw_exception );
		return
	end

	
	% 
	% Get the information.
	[DataSet, status] = get_varinfo ( ncid,  varid );
	if ( status < 0 )
		msg = sprintf ( '%s:  get_varinfo failed on %s, file %s.\n', mfilename, ncfile, varname );
		handle_error ( msg, throw_exception );
		return
	end

	%
	% close whether or not we were successful.
	mexnc('close',ncid);


elseif isnumeric ( arg1 ) && isnumeric ( arg2 )

	ncid = arg1;
	varid = arg2;

	%
	% Ok, we were passed the file id and variable id.
	[DataSet, status] = get_varinfo ( ncid,  varid );
	if ( status < 0 )
		msg = sprintf ( '%s:  get_varinfo failed on varid %d.\n', mfilename, varid );
		handle_error ( msg, throw_exception );
		return
	end


else
	fprintf ( 2, '%s:  cannot have mixed input types.  Either specify the filename and variable name, or give the NetCDF file id and variable id.\n', mfilename );
	return
end


return_status = 0;

return





function [DataSet, status] = get_varinfo ( ncid, varid )

DataSet = [];



[record_dimension, status] = mexnc ( 'INQ_UNLIMDIM', ncid );
if status < 0
	fprintf ( 2, '%s:  mexnc:inq failed, ''%s''.\n', mfilename, mexnc ( 'strerror', status ) );
	mexnc('close',ncid);
    return
end



[varname, datatype, ndims, dims, natts, status] = mexnc('INQ_VAR', ncid, varid);
if status < 0 
	fprintf ( 2, '%s:  mexnc:inq_var failed on varid %d, file %s.\n', mfilename, varid, ncfile );
	return
end



DataSet.Name = varname;
DataSet.Nctype = datatype;
DataSet.Varid = varid;

%
% Assume the current variable does not have an unlimited dimension until
% we know that it does.
DataSet.IsUnlimitedVariable = 0;

if ndims == 0
	DataSet.Dimension = [];
	DataSet.Size = 1;
	DataSet.Dimid = [];
	DataSet.Rank = 1;
else



	for j = 1:ndims
	
		[dimname, dimlength, status] = mexnc('INQ_DIM', ncid, dims(j));
		if ( status < 0 )
			fprintf ( 2, '%s:  mexnc:inq_dim failed on dimid %d.\n', mfilename, dims(j) );
			return
		end
	
		DataSet.Dimension{j} = dimname; 
		DataSet.Size(j) = dimlength;
		DataSet.Dimid(j) = dims(j);
	
		if dims(j) == record_dimension
			DataSet.IsUnlimitedVariable = 1;
		end
	end
	DataSet.Rank = length(dims);
end

%
% get all the attributes
if natts == 0
	DataSet.Attribute = struct([]);
else
	for attnum = 0:natts-1
	
		[theAttribute, status] = nc_get_attribute_struct ( ncid, varid, attnum );
		if ( status < 0 )
			fprintf ( 2, '%s:  nc_get_attribute_struct failed on varid %d\n', mfilename, varid );
			return
		end
		DataSet.Attribute(attnum+1) = theAttribute;
	
	end
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
