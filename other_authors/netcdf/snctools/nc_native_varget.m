function [data, return_status] = nc_native_varget(ncfile, varname, varargin )
% NC_NATIVE_VARGET:  Retrieve data from a NetCDF variable and preserves its class.
%
% Scale factors, add offsets, and fill values are not honored.  The
% data is returned in the matlab equivalent of the netcdf data class.
% I.e. double ==> double
%      float  ==> single
%      int    ==> int32
%      short  ==> int16
%      byte  ==>  int8
%      char   ==> char
%
% If you want uint8 data, you have to cast it yourself.
%
% Basically, this function just calls nc_varget, then undoes the scaling,
% fill values, and casting actions.
%
% USAGE:  [values, status] = nc_native_varget(ncfile,varname);
%         
%         Retrieve an entire variable.
%
%
% USAGE:  [values, status] = nc_native_varget(ncfile,varname,start,count);
%         
%         Retrieve just part of a variable.  The values are contiguous.
%
%
% USAGE:  [values, status] = nc_native_varget(ncfile,varname,start,count,stride);
%         
%         Retrieve just part of a variable using a stride.
%
%
%
% PARAMETERS:
% Input:
%    ncfile:  
%       name of netcdf file.  
%    varname:  
%       name of variable whose data is requested
%    start:  
%       Optional, starting coordinate of the retrieval.  If only "ncfile" 
%       and "varname" are given, then the entire variable is retrieved.
%       Remember that NetCDF has zero-based indexing, not one-based indexing.
%    count:  
%       Optional, length of the retrieval along each dimension.  If the
%       count for any dimension is -1, then everything is retrieved up
%       to the end of that dimension.
%    stride:  
%       Optional.  If not provided, then contiguous elements are used.
%       For example, if STRIDE were [2 2], then every other element
%       is chosen.
%
% Output:
%    values:  the requested data
%    status:  
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 if the routine succeeds
%
% Example:
%    >> [values, status] = nc_varget('foo.cdf', 'x', [0 0], [2 3])
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_native_varget.m,v 1.10 2006/04/25 18:47:14 johnevans007 Exp $
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
data = [];
return_status = -1;

if ( (nargin < 2) || (nargin == 3) )
	msg = sprintf ( '%s:  incorrect number of input arguments (%d).\n', mfilename, nargin );
	handle_error ( msg, throw_exception );
	return
end

if ( ~strcmp(class(ncfile),'char') )
	msg = sprintf ( '%s:  ncfile input argument must be char.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end

if ( ~strcmp(class(varname),'char') )
	msg = sprintf ( '%s:  varname input argument must be char.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


switch ( nargin )
case 2
	[data, status] = nc_varget ( ncfile, varname );
case 4
	start = varargin{1};
	count = varargin{2};
	[data, status] = nc_varget ( ncfile, varname, start, count );
case 5
	start = varargin{1};
	count = varargin{2};
	stride = varargin{3};
	[data, status] = nc_varget ( ncfile, varname, start, count, stride );
end
if status <  0
	msg = sprintf ( '%s:  nc_varget failed.\n', mfilename );
	handle_error ( msg, throw_exception );
	return
end


[vinfo, status] = nc_getvarinfo ( ncfile, varname );
if status <  0
	msg = sprintf ( '%s:  nc_getvarinfo failed on file %s, var %s.\n', mfilename, ncfile, varname );
	handle_error ( msg, throw_exception );
	return
end

scale_factor = 1;
add_offset = 0;
fv = NaN;
num_atts = length(vinfo.Attribute);
for j = 1:num_atts
	switch ( vinfo.Attribute(j).Name )
	case 'scale_factor'
		scale_factor = vinfo.Attribute(j).Value;
	case 'add_offset'
		add_offset = vinfo.Attribute(j).Value;
	case '_FillValue'
		fv = vinfo.Attribute(j).Value;
	end
end

typestring = nc_datatype_string ( vinfo.Nctype );

%
% undo the casting
switch ( typestring )
case { 'NC_DOUBLE', 'NC_FLOAT', 'NC_INT', 'NC_SHORT', 'NC_BYTE' }

	%
	% undo the scaling.
	data = (data - add_offset) / scale_factor;

	%
	% Undo the fill value
	fill_value_inds = find(isnan(data));
	data(fill_value_inds) = fv;

case 'NC_CHAR'
	%
	% Do nothing

otherwise
	msg = sprintf ( '%s:  unhandled datatype %s.\n', mfilename, typestring );
	handle_error ( msg, throw_exception );
	return
end



%
% undo the casting
switch ( typestring )
case { 'NC_DOUBLE', 'NC_CHAR' }

	%
	% These need no conversion

case 'NC_FLOAT'
	data = single(data);
case 'NC_INT'
	data = int32(data);
case 'NC_SHORT'
	data = int16(data);
case 'NC_BYTE'
	data = int8(data);
otherwise
	msg = sprintf ( 2, '%s:  unhandled datatype %s.\n', mfilename, typestring );
	handle_error ( msg, throw_exception );
	return
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

