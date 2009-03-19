function [new_data, return_status] = nc_addnewrecs ( ncfile, input_buffer, record_variable )
% NC_ADDNEWRECS:  Tacks on new data from simple matlab structure to an unlimited-dimension netcdf file
% 
% The difference between this m-file and nc_add_recs is that this 
% routine assumes that the unlimited dimension has a monotonically
% increasing coordinate variable, e.g. time series.  This routine
% actually calls nc_add_recs with suitable arguments.
%
% From this point foreward, assume we are talking about time series.
% It doesn't have to be that way (the record variable could be 
% monotonically increasing spatially instead ), but talking about it
% in terms of time series is just easier.  If a field is present in 
% the structure, but not in the netcdf file, then that field is 
% ignored.  Only data that is more recent than the last record 
% currently in the NetCDF file is written.   Older data is discarded.
%
% USAGE:  [new_data, status] = nc_addnewrecs ( ncfile, input_buffer, record_variable )
% 
% PARAMETERS:
%   Input:
%      ncfile:  
%          netcdf file that we write information to
%      input_buffer:  
%          structure of time series data.  
%      record_variable:
%          Coordinate variable that is monotonically increasing.  
%          In ROMS, it is "ocean_time".  For purposes of backwards
%          compatibility, if this is not provided, it is assumed
%          to be "time".
%   Output:
%      new_data:  
%          Matlab structure of data corresponding in structure to "input_buffer", but
%          consisting only of those records which were actually written to file.
%      status:  
%          Optional.  If status is not requested, then an exception is
%          thrown in case of an error.  Otherwise, status is set to -1 
%          if the routine fails, 0 if the routine succeeds
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
%   The "input_input_buffer" should look something like the following:
%
%       >> input_input_buffer
%
%       input_input_buffer =
%
%           time: [3x1 double]
%           var1: [3x2 double]
%           var2: [4-D double]
%           var3: [3x2 double]
%
% The reason for the possible size discrepency here is that matlab will
% ignore trailing singleton dimensions (but not interior ones, such as
% that in var2.
%
% If a netcdf variable has no corresponding field in the input input_buffer,
% then the corresponding NetCDF variable will populate with the appropriate
% _FillValue for each new time step.
%          
% In case of an error, an exception is thrown.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_addnewrecs.m,v 1.10 2005/07/28 14:48:59 johnevans007 Exp $
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

if nargin < 2
	error_msg = sprintf ( '%s:  must have at least two inputs.\n', mfilename ); 
	handle_error ( error_msg, throw_exception );
	return
end

if nargin == 2
	record_variable = 'time';
end

if isempty ( input_buffer )
	return
end

%
% Check that the record variable is present in the input buffer.
if ~isfield ( input_buffer, record_variable )
	msg = sprintf ( '%s:  input buffer is missing the record variable %s.\n', mfilename, record_variable );
	handle_error ( msg, throw_exception );
	return
end

%
% check to see that all fields are actually there.
nc = nc_info ( ncfile );
num_vars = length(nc.DataSet);


fnames = fieldnames ( input_buffer );
num_fields = length(fnames);
for j = 1:num_fields
	not_present = 1;
	for k = 1:num_vars
		if strcmp(fnames{j}, nc.DataSet(k).Name)
			not_present = 0;
		end
	end
	if not_present
		fprintf ( 1, '  %s not present in file %s.  Ignoring it...\n', fnames{j}, ncfile );
		input_buffer = rmfield ( input_buffer, fnames{j} );
	end
end


%
% Retrieve the dimension id of the unlimited dimension upon which
% all depends.  It must be the first dimension listed.
[varinfo, status] = nc_getvarinfo ( ncfile, record_variable );
if ( status < 0 )
	error_msg = sprintf ( '%s:  nc_getvarinfo failed on %s, file %s.\n', mfilename, record_variable, ncfile  ); 
	handle_error ( error_msg, throw_exception );
	return
end
unlimited_dimension_name = varinfo.Dimension{1};

%
% Get the last time value.   If the record variable is empty, then
% only take datums that are more recent than the latest old datum
input_buffer_time_values = getfield ( input_buffer, record_variable );
if varinfo.Size > 0
	[last_time,s] = nc_getlast ( ncfile, record_variable, 1 );
	if status < 0
		error_msg = sprintf ( '%s:  nc_getlast failed on %s.\n\n\n', mfilename, ncfile );
		handle_error ( error_msg, throw_exception );
		return
	end
    	recent_inds = find( input_buffer_time_values > last_time );
else
	last_time = [];
    	recent_inds = [1:length(input_buffer_time_values)];
end



%
% if no data is new enough, just return.  There's nothing to do.
if isempty(recent_inds)
	return_status = 0;
	return
end



%
% Go thru each variable.  Restrict to what's new.
varnames = fieldnames ( input_buffer );
num_vars = length(varnames);
for j = 1:num_vars
	data = getfield ( input_buffer, varnames{j} );
	switch ndims(data)
		case 2
			input_buffer = setfield ( input_buffer, varnames{j}, data(recent_inds,:) );
		case 3
			input_buffer = setfield ( input_buffer, varnames{j}, data(recent_inds,:,:) );
		case 4
			input_buffer = setfield ( input_buffer, varnames{j}, data(recent_inds,:,:,:) );
		case 5
			input_buffer = setfield ( input_buffer, varnames{j}, data(recent_inds,:,:,:,:) );
		otherwise
			msg = sprintf ( '%s:  Too many dimensions for %s.\n', mfilename, varnames{j} );
			error ( msg );
	end
end



%
% Write the records out to file.
status = nc_add_recs ( ncfile, input_buffer, unlimited_dimension_name );
if status == -1
	msg = sprintf ( '%s:  nc_add_recs failed on %s.\n\n\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
end


new_data = input_buffer;
return_status = 0;




return;



function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
