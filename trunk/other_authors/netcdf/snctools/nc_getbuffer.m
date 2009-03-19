function [theBuffer, return_status] = nc_getbuffer ( ncfile, varargin )
% NC_GETBUFFER:  read the record variables of a netcdf file into a structure
%
% USAGE:  theBuffer = nc_getbuffer ( ncfile );
% USAGE:  theBuffer = nc_getbuffer ( ncfile, varlist );
% USAGE:  theBuffer = nc_getbuffer ( ncfile, start, stop );
% USAGE:  theBuffer = nc_getbuffer ( ncfile, varlist, start, stop );
%
% PARAMETERS:
% INPUT:
%     ncfile:  
%        Input netcdf file name.
%     varlist:
%        cell array of named variables.  Only data for these variables 
%        will be retrieved from the file
%     start, count:
%        starting index and number of records to retrieve.  This is 
%        optional.  If not provided, all of the record variables will
%        be retrieved.
%        
%        If start is negative, then the last few records (total of
%        "count") are retrieved.
%
%        If count is negative, then everything beginning at "start" 
%        and going all the way to the end is retrieved.
% 
% OUTPUT:
%     theBuffer:
%        Structure with fields corresponding to each netcdf record variable.  
%        Each such field contains the data for that variable.
%     status:
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 is the routine succeeds
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_getbuffer.m,v 1.16 2006/04/25 18:47:14 johnevans007 Exp $
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
theBuffer = [];


%
% Check for proper number of input arguments
if nargin < 1 
	msg = sprintf ( '%s:  must have at least one input argument.\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end
if nargin > 4 
	msg = sprintf ( '%s:  must have no more than four input arguments.\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end

%
% check that the first argument is a char
if ~ischar ( ncfile )
   	msg = sprintf (  '%s:  first argument must be character.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


%
% figure out what the inputs actually were
start_count_supplied = 0;
varlist_supplied = 0;
switch nargin
case 2
	if iscell(varargin{1})
		varlist = varargin{1};
		varlist_supplied = 1;
	else
		msg = sprintf ( '%s:  2nd of two input arguments must be a cell array.\n', mfilename );
		handle_error ( msg, throw_exception );
		return;
	end
case 3
	if isnumeric(varargin{1}) && isnumeric(varargin{2})
		start_count_supplied = 1;
		start = varargin{1};
		count = varargin{2};
	else
		msg = sprintf ( '%s:  2nd and 3rd of three input arguments must be numeric.\n', mfilename );
		handle_error ( msg, throw_exception );
		return;
	end
case 4
	if iscell(varargin{1})
		varlist = varargin{1};
		varlist_supplied = 1;
	else
		msg = sprintf ( '%s:  2nd of four input arguments must be a cell array.\n', mfilename );
		handle_error ( msg, throw_exception );
		return;
	end
	if isnumeric(varargin{2}) && isnumeric(varargin{3})
		start_count_supplied = 1;
		start = varargin{2};
		count = varargin{3};
	else
		msg = sprintf ( '%s:  3rd and 4th of four input arguments must be numeric.\n', mfilename );
		handle_error ( msg, throw_exception );
		return;
	end
end



[metadata, status] = nc_info ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_info failed on file ''%s''\n', mfilename, ncfile );
	handle_error ( msg, throw_exception );
	return
end

num_datasets = length(metadata.DataSet);

if varlist_supplied

	we_dont_want_it = ones(num_datasets,1);

	%
	% Go thru and quickly set up a flag for each DataSet
	for j = 1:num_datasets
		for k = 1:length(varlist)
			if strcmp(varlist{k}, metadata.DataSet(j).Name)
				we_dont_want_it(j) = 0;
			end
		end
	end

else
	we_dont_want_it = zeros(num_datasets,1);
end

retrievable_datasets = find(1 - we_dont_want_it);
if ~any(retrievable_datasets)
	msg = sprintf ( '%s:  No datasets found.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


%
% Find the unlimited dimension and it's length
record_length = -1;
num_dims = length(metadata.Dimension);
for j = 1:num_dims
	if metadata.Dimension(j).Record_Dimension
		record_length = metadata.Dimension(j).Length;
	end
end
if record_length < 0
	msg = sprintf ( '%s:  no unlimited dimension was found.\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end

%
% figure out what the start and count really are.
if start_count_supplied == 1
	if start < 0
		start = record_length - count;
	end
	if count < 0
		count = record_length - start;
	end
	if (start < 0) && (count < 0)
		msg = sprintf ( '%s:  both start and count cannot be less than zero.\n', mfilename );
		handle_error ( msg, throw_exception );
		return;
	end
end




for j = 1:num_datasets
	
	%
	% Did we restrict retrieval to a few variables?
	if varlist_supplied
		if we_dont_want_it(j)
			continue
		end
	end

	if metadata.DataSet(j).IsUnlimitedVariable

		if start_count_supplied 
			varstart = zeros(size(metadata.DataSet(j).Size));
			varstart(1) = start;
			varcount = metadata.DataSet(j).Size;
			varcount(1) = count;
			[vardata, status] = nc_varget ( ncfile, metadata.DataSet(j).Name, varstart, varcount );
		else
			[vardata, status] = nc_varget ( ncfile, metadata.DataSet(j).Name );
		end

		if ( status < 0 )
			format = '%s:  nc_varget failed on file %s, variable %s.\n';
			msg = sprintf ( format, mfilename, ncfile, metadata.DataSet(j).Name );
			handle_error ( msg, throw_exception );
			return
		end

		theBuffer = setfield ( theBuffer, metadata.DataSet(j).Name, vardata );

	end
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
