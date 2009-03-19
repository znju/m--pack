function status = nc_addhist ( ncfile, varargin )
% NC_ADDHIST:  Either appends or constructs a history attribute.
%
% USAGE: status = nc_addhist ( ncfile, attval );
% USAGE: status = nc_addhist ( ncfile, varname, attval );
%
% This follows the NCO convention that history is prepended, rather 
% than appended.  In other words, ncdumping the file will have the
% most recent history attribution at the top.
% 
% In the first case, a global attribute is written.  In the second,
% a variable attribute is written.
%
% PARAMETERS:
% Input:
%    ncfile:  name of netcdf file
%    varname:  Optional.  If not supplied, assume usage of
%       global history attribute.  If present, assume usage
%       of variable history attribute.
%    attval:  String of information to be tacked on to the
%       history attribute.  If the history attribute is not
%       present, create it.
% Output:
%    status:  
%         If no return argument is given, the routine throws an
%         exception in case of an error.
%         Otherwise, -1 for failure, 0 for success.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_addhist.m,v 1.12 2006/04/25 18:47:14 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if nargout < 1
	throw_exception = 1;
else
	throw_exception = 0;
end



%
% assume failure until we know it succeeded
status = -1;

if nargin < 2 
	msg = sprintf ( '%s:  too few input arguments.\n\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end
if nargin > 3 
	msg = sprintf ( '%s:  too many input arguments.\n\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end

if ( nargin == 2 )
	varname = 'GLOBAL';
	attval = varargin{1};
else
	varname = varargin{1};
	attval = varargin{2};
end

if ~strcmp(class(attval),'char')
	msg = sprintf ( '%s:  history attribute addition must be character.\n\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end

%
% Attempt to retrieve the old history.  If we fail,
% assume the history does not exist.
[ncid, status] = mexnc ( 'OPEN', ncfile, nc_nowrite_mode );
if status
	msg = sprintf ( '%s:  ''''mexnc(''OPEN'', ...'''' failed, ''%s''.\n\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end

[datatype, attlen, status] = mexnc ( 'INQ_ATT', ncid, nc_global, 'history' );
if status
	%
	% It does not exist.
	old_hist = '';

else

	%
	% It does exist.  Is it character?
	if datatype ~= nc_char
		fmt = '%s:  existing history attribute must be character\n';
		msg = sprintf ( fmt, mfilename );
		error ( msg );
	end

	[old_hist, status] = mexnc ( 'GET_ATT_TEXT', ncid, nc_global, 'history' );
	if status 
		efmt = '%s:  %s\n';
		ncerr = mexnc('STRERROR', status);
		errmsg = sprintf ( efmt, mfilename, ncerr );
		error ( errmsg )
	end

end

[status] = mexnc ( 'CLOSE', ncid );
if status
	msg = sprintf ( '%s:  %s\n', mfilename, mexnc('STRERROR', status) ); 
	error ( msg ), 
end




if isempty(old_hist)
	new_history = sprintf ( '%s:  %s', datestr(now), attval );
else
	new_history = sprintf ( '%s:  %s\n%s', datestr(now), attval, old_hist );
end
status = nc_attput ( ncfile, varname, 'history', new_history );
if status
	msg = sprintf ( 'nc_addhist:  nc_attput failed on %s, %s, history attribute.\n\n', ncfile, varname );
	handle_error ( msg, throw_exception );
	return;
end


status = 0;
return;



function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
