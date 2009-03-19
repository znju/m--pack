function [varsize, return_status] = nc_varsize(ncfile, varname)
% NC_VARSIZE:  return the size of the requested netncfile variable
%
% USAGE: [varsize, status] = nc_varsize( netncfile_file, variable )
%
% PARAMETERS:
%   Input:
%      ncfile:  path to netncfile file
%      var:  name of requested variable
%   Output:
%      varsize: size of requested variable 
%      status:  
%        Optional.  If not requested, an exception is thrown if an
%        error condition arises.  Otherwise, -1 is returned if the 
%        routine fails, or 0 if the routine succeeds
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_varsize.m,v 1.7 2005/08/04 14:07:11 johnevans007 Exp $
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
varsize = [];
return_status = -1;

% Show usage if too few arguments.
%
if nargin~=2 
	msg = sprintf ( '%s:  Must have two input arguments.\n', mfilename  );
	handle_error ( msg, throw_exception );
	return
end

if ~strcmp(class(ncfile),'char')
	msg = sprintf ( '%s:  Both inputs must be character.\n', mfilename  );
	handle_error ( msg, throw_exception );
	return
end
if ~strcmp(class(varname),'char')
	msg = sprintf ( '%s:  Both inputs must be character.\n', mfilename  );
	handle_error ( msg, throw_exception );
	return
end


[v, status] = nc_getvarinfo ( ncfile, varname );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_getvarinfo failed on %s, %s.\n', mfilename, ncfile, varname );
	handle_error ( msg, throw_exception );
	return
end

varsize = v.Size;
return_status = 0;



function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return

