function return_status = nc_dump(file_name, wanted_variable )
% NC_DUMP is a Matlab counterpart to the NetCDF utility 'ncdump'.
%
% USAGE: status = nc_dump ( file_name )
% USAGE: status = nc_dump ( file_name, variable )
%
% PARAMETERS:
% Input:
%    file_name:  path to NetCDF file
%    variable: optional.  If present, output is restricted to just
%        this variable.
% Output:
%     status:
%         Optional.  If not requested, an exception is thrown if an
%         error condition arises.  Otherwise, -1 is returned if the 
%         routine fails, or 0 is the routine succeeds
%    
% Examples: 
%
%   1.  >> nc_dump('ecomsi.cdf');
%
%       produces a paged output describing the NetCDF
%       file 'ecomsi.cdf'.  The  status  is 0 if the operation
%       was successful.  If the file does not exist, or 
%       if it is corrupted somehow, a -1 is returned. 
%
%       Information about the dimensions, variables, and
%       global attributes is sent to the terminal.
%
%
%   2.  >> status = nc_dump ( 'ecomsi.cdf', 'x' );
%      
%       This dumps only information about variable 'x'.
%
%       John Evans (johnevans@acm.org)
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Name: snctools-2_0_21 $
% $Id: nc_dump.m,v 1.17 2006/04/25 18:47:14 johnevans007 Exp $
% AUTHOR:  johnevans@acm.org
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargout < 1
	throw_exception = 1;
else
	throw_exception = 0;
end

return_status = -1;


if ( (nargin < 1) || (nargin > 2) )
	msg = sprintf ( '%s:  must have at least one input argument and no more than two.\n', mfilename );
	handle_error ( msg, throw_exception );
	return;
end



if nargin == 2
	do_restricted_variable = 1;
else
	do_restricted_variable = 0;	
end


% Try to open the file.  If it's not there, then this will be
% a real short little function...
if nargin == 0,  % if no file provided, ask for one
	[buf, path]=uigetfile('*.cdf','Select a netCDF file');
	file_name=[path buf];
	clear path buf
end

[metadata, status] = nc_info ( file_name );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_info failed on file ''%s''\n', mfilename, file_name );
	handle_error ( msg, throw_exception );
	return
end


%
% print out name of file
fprintf ( 1, 'netcdf %s { \n\n', metadata.Filename );


%
% print out dimension information
if isfield ( metadata, 'Dimension' )
	num_dims = length(metadata.Dimension);
else
	num_dims = 0;
end


if num_dims > 0
	fprintf ( 1, 'dimensions:\n' );
	for j = 1:num_dims
		if metadata.Dimension(j).Record_Dimension
			fprintf( 1, '\t%s = UNLIMITED ; (%i currently)\n', ...
			         deblank(metadata.Dimension(j).Name), ...
				 metadata.Dimension(j).Length );
		else
			fprintf ( '\t%s = %i ;\n', metadata.Dimension(j).Name, metadata.Dimension(j).Length );
		end
	end
	fprintf('\n\n');
end
	

if isfield ( metadata, 'DataSet' )
	num_vars = length(metadata.DataSet);
else
	num_vars = 0;
end

if num_vars > 0
	fprintf ( 'variables:\n' );
	for j = 1:num_vars
	
		if do_restricted_variable
			if ~strcmp ( wanted_variable, metadata.DataSet(j).Name )
				continue
			end
		end
	
		switch ( metadata.DataSet(j).Nctype )
		case 1
			fprintf ( 1, '\tbyte ' );
		case 2
			fprintf ( 1, '\tchar ' );
		case 3
			fprintf ( 1, '\tshort ' );
		case 4
			fprintf ( 1, '\tlong ' );
		case 5
			fprintf ( 1, '\tfloat ' );
		case 6
			fprintf ( 1, '\tdouble ' );
		end
	
		fprintf ( 1, '%s', metadata.DataSet(j).Name );
	
		if isempty(metadata.DataSet(j).Dimension) 
			fprintf ( 1, '([]), ' );
		else
			fprintf ( 1, '(%s', metadata.DataSet(j).Dimension{1} );
			for k = 2:metadata.DataSet(j).Rank
				fprintf ( 1, ',%s', metadata.DataSet(j).Dimension{k} );
			end
			fprintf ( 1, '), ');
		end
		fprintf ( 1, 'varid %d, ', metadata.DataSet(j).Varid );
		if metadata.DataSet(j).Rank == 0
			fprintf ( 1, 'shape = [1]\n' );
		else
			fprintf ( 1, 'shape = [%d', metadata.DataSet(j).Size(1)  );
			for k = 2:metadata.DataSet(j).Rank
				fprintf ( 1, ' %d', metadata.DataSet(j).Size(k)  );
			end
			fprintf ( 1, ']\n');
		end
	
		
		%
		% Now do all attributes for each variable.
		num_atts = length(metadata.DataSet(j).Attribute);
		for k = 1:num_atts
			switch ( metadata.DataSet(j).Attribute(k).Nctype )
			case 0
				att_val = '';
				att_type = 'NC_NAT';
			case 1
				att_val = sprintf ('%d ', fix(metadata.DataSet(j).Attribute(k).Value) );
				att_type = 'x';
			case 2
				att_val = sprintf ('"%s" ', metadata.DataSet(j).Attribute(k).Value );
				att_type = '';
			case 3
				att_val = sprintf ('%i ', metadata.DataSet(j).Attribute(k).Value );
				att_type = 's';
			case 4
				att_val = sprintf ('%i ', metadata.DataSet(j).Attribute(k).Value );
				att_type = 'd';
			case 5
				att_val = sprintf ('%f ', metadata.DataSet(j).Attribute(k).Value );
				att_type = 'f';
			case 6
				att_val = sprintf ('%g ', metadata.DataSet(j).Attribute(k).Value );
				att_type = '';
			end
			fprintf( 1, '\t\t%s:%s = %s%s\n', ...
			         metadata.DataSet(j).Name, ...
			         metadata.DataSet(j).Attribute(k).Name, ...
				 att_val, att_type);
			
		end
			
	end
end % if num_vars > 0

fprintf ( '\n\n' );




% Finally, print out info about the global attributes.  
if ( do_restricted_variable == 0 )

	if isfield ( metadata, 'Attribute' )
		num_atts = length(metadata.Attribute);
	else
		num_atts = 0;
	end

	if num_atts > 0
		fprintf ( 1, '//global attributes:\n' );
	end

	for k = 1:num_atts
		switch ( metadata.Attribute(k).Nctype )
		case 1
			att_val = sprintf ('%d ', fix(metadata.Attribute(k).Value) );
			att_type = 'x';
		case 2
			att_val = sprintf ('"%s" ', metadata.Attribute(k).Value );
			att_type = '';
		case 3
			att_val = sprintf ('%i ', metadata.Attribute(k).Value );
			att_type = 's';
		case 4
			att_val = sprintf ('%i ', metadata.Attribute(k).Value );
			att_type = 'd';
		case 5
			att_val = sprintf ('%f ', metadata.Attribute(k).Value );
			att_type = 'f';
		case 6
			att_val = sprintf ('%g ', metadata.Attribute(k).Value );
			att_type = '';
		end
		fprintf( 1, '\t\t:%s = %s%s\n', ...
		         metadata.Attribute(k).Name, ...
			 att_val, att_type);
		
	end
end


fprintf ( 1, '}\n' );

%
% If we got this far, then all is well.
return_status = 0;

return;



function handle_error ( msg, throw_exception )
if throw_exception
	error ( msg );
else
	fprintf ( 2, msg );
end
return
