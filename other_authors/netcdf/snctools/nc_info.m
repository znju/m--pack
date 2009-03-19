function [fileinfo, return_status] = nc_info ( ncfile )
% NC_INFO:  information about a NetCDF 2 or 3 file
%
% USAGE:  [fileinfo, status] = nc_info ( ncfile );
%
% PARAMETERS:
% Input:
%    ncfile:  
%        a string that specifies the name of the NetCDF file
% Output:
%    fileinfo:
%        A structure whose fields contain information about the contants
%        of the NetCDF file.  The set of fields return in "fileinfo" are:
%
%        Filename:  
%            a string containing the name of the file.
%        Dimension:  
%            an array of structures describing the NetCDF dimensions.
%        DataSet:  
%            an array of structures describing the NetCDF datasets.
%        Attributes:  
%            An array of structures These correspond to the global attributes.
%
%
%        Each "Dimension" element contains the following fields:
%       
%        Name:
%            a string containing the name of the dimension.
%        Length:
%            a scalar value, the size of this dimension
%        Record_Dimension:
%            Set to 1 if the dimension is the record dimension, set to
%            0 otherwise.
%
%
%        Each "DataSet" element contains the following structures.
%
%        Name:  
%            a string containing the name of the variable.
%        Nctype:  
%            a string specifying the NetCDF datatype of this variable.
%        Varid:  
%            a scalar specifying the NetCDF variable id (varid)
%        Dimensions:  
%            a cell array with the names of the dimensions upon which
%            this variable depends.
%        IsUnlimitedVariable:  
%            Flag, either 1 if the variable has an unlimited dimension
%            or 0 if not.
%        Rank:  
%            Array that describes the size of each dimension upon which 
%            this dataset depends.
%        DataAttributes:  
%            Same as "Attributes" above, but here they are the variable 
%            attributes.
%                         
%        Each "Attribute" or "DataAttribute" element contains the following 
%        fields.
%
%        Name:  
%            a string containing the name of the attribute.
%        Nctype:  
%            a string specifying the NetCDF datatype of this attribute.
%        Attnum:  
%            a scalar specifying the attribute id
%        Value: 
%            either a string or a double precision value corresponding to
%            the value of the attribute
%
%     return_status:
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 if the routine succeeds
%
% The "DataSet" elements are not populated with the actual data values.
%
% This routine purposefully mimics that of Mathwork's hdfinfo.
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_info.m,v 1.24 2006/04/25 18:47:14 johnevans007 Exp $
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
fileinfo = [];


% Show usage if too few arguments.
%
if nargin<1 
	msg = sprintf ( '%s:  must have at least one input argument.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

fileinfo.Filename = ncfile;

%
% Open netCDF file
%
[ncid, status]=mexnc('open', ncfile, nc_nowrite_mode );
if status ~= 0
	fileinfo = [];
	msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end



[ndims, nvars, ngatts, record_dimension, status] = mexnc('INQ', ncid);
if status < 0
	mexnc('close',ncid);
	msg = sprintf ( '%s:  mexnc:inq failed on %s.\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end


%
% retrieve the sizes of each dimension
if ndims == 0
	Dimension = struct ( [] );
else
	for dimid = 0:ndims-1
		Dimension(dimid+1)=nc_getdiminfo ( ncid, dimid );
	end
end

fileinfo.Dimension = Dimension;

if nvars == 0
	fileinfo.DataSet = struct([]);
else
	for varid=0:nvars-1
	

		[fileinfo.DataSet(varid+1), status] = nc_getvarinfo ( ncid, varid );
		if status < 0 
			mexnc('close',ncid);
			msg = sprintf ( '%s:  nc_getvarinfo failed on varid %d, file %s.\n', mfilename, varid, ncfile );
			handle_error ( msg, throw_exception );
			return
		end
	
	
	end
end




%
% Do the same for the global attributes
%
% get all the attributes
if ngatts == 0
	fileinfo.Attribute = struct([]);
else
	for attnum = 0:ngatts-1
		Attribute(attnum+1) = nc_get_attribute_struct ( ncid, nc_global, attnum );
	end
	fileinfo.Attribute = Attribute;
end

mexnc('close',ncid);




return_status = 0;

return


function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
