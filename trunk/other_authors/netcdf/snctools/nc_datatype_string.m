function str = nc_datatype_string ( type_number )
% NC_DATATYPE_STRING:  convert an enumerated datatype to human-readable string
%
% USAGE:  str = nc_datatype_string ( type_number );
%
% PARAMETERS:
% Input:
%    type_number:
%        This is typically retrieved from a MexCDF 'inq_att' or 
%        'inq_var'.  MexCDF retrieves it as a number.  
% Output:
%        A string version of the datatype mnemonic.  For example,
%          0 ==> 'NC_NAT'.
%          1 ==> 'NC_BYTE'.
%          2 ==> 'NC_CHAR'.
%          3 ==> 'NC_SHORT'.
%          4 ==> 'NC_INT'.
%          5 ==> 'NC_FLOAT'.
%          6 ==> 'NC_DOUBLE'.
%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_datatype_string.m,v 1.5 2005/07/21 14:34:11 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin ~= 1
	msg = sprintf ( '%s:  Must have only one input\n', mfilename );
	error ( msg );
end

if ~isnumeric ( type_number )
	msg = sprintf ( '%s:  input must be numeric\n', mfilename );
	error ( msg );
end

switch ( type_number )
case 0
	str = 'NC_NAT';
case 1
	str = 'NC_BYTE';
case 2
	str = 'NC_CHAR';
case 3
	str = 'NC_SHORT';
case 4
	str = 'NC_INT';
case 5
	str = 'NC_FLOAT';
case 6
	str = 'NC_DOUBLE';
otherwise
	msg = sprintf ( '%s:  unhandled type number %d\n', mfilename, type_number );
	error ( msg );
end

return
