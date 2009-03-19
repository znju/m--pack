function [new_data, return_status] = nc_archive_buffer ( input_buffer, ncfile, record_variable )
% NC_ARCHIVE_BUFFER:  Tacks on new data from simple matlab structure to an unlimited-dimension netcdf file
% 
% This function is deprecated.  Please use nc_addnewrecs.m instead.  All 
% this function really does is call nc_addnewrecs anyway.
%
% If a field is present in the structure, but not in the netcdf file, then that
% field is ignored.  Only data that is more recent than the last record currently
% in the NetCDF file is written.  This routine is written with time series data in mind.
%
% USAGE:  [new_data, status] = nc_archive_buffer ( buffer, ncfile, record_variable, unlimited_dimension )
% 
% PARAMETERS:
%   Input:
%      buffer:  
%          structure of (hopefully) time series data.  
%      ncfile:  
%          netcdf file that we write information to
%      record_variable:
%          hopefully this is something like "time".  In ROMS, it is "ocean_time".
%   Output:
%      new_data:  
%          Matlab structure of data corresponding in structure to "buffer", but
%          consisting only of those records which were actually written to file.
%      status:
%          Optional.  If not requested, an exception is thrown if an
%          error condition arises.  Otherwise, -1 is returned if the 
%          routine fails, or 0 is the routine succeeds
%
%  
%   The dimensions of the data should match that of the target netcdf file.  For example, 
%   suppose an ncdump of the
%   NetCDF file looks something like
%
%       netcdf a_netcdf_file {
%       dimensions:
%       	lat = 1 ;
%       	lon = 2 ;
%       	depth = 2 ; 
%       	time = UNLIMITED ; // (500 currently)
%       variables:
%       	double time(time) ;
%       	float var1(time, depth) ;
%       	float var2(time, depth, lat, lon) ;
%       	float var3(time, depth, lat) ;
%       
%       // global attributes:
%       }
% 
%   The "input_buffer" should look something like the following:
%
%       >> input_buffer
%
%       input_buffer =
%
%           time: [3x1 double]
%           var1: [3x2 double]
%           var2: [4-D double]
%           var3: [3x2 double]
%
%   The reason for the possible size discrepency here is that matlab will
%   ignore trailing singleton dimensions (but not interior ones, such as
%   that in var2.
%
%   If a variable is not present, then the corresponding NetCDF variable will
%   populate with the appropriate _FillValue.
%          
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_archive_buffer.m,v 1.12 2006/04/25 18:47:14 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout < 2
	throw_exception = 1;
else
	throw_exception = 0;
end
new_data = [];
return_status = -1;

if nargin < 2 || nargin > 4
	msg = sprintf ( '%s:  must have at least two input arguments, no more than 4.\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end

switch nargin
case 2
	[new_data, status] = nc_addnewrecs ( ncfile, input_buffer );
case { 3, 4 }
	[new_data, status] = nc_addnewrecs ( ncfile, input_buffer, record_variable );
end
if ( status < 0 )
	msg = sprintf ( '%s:  nc_addnewrecs failed.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
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
