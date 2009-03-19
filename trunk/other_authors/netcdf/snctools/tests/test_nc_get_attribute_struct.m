function test_nc_test_get_attribute_struct ( ncfile )
% TEST_NC_DUMP:  runs series of tests for nc_dump.m
%
% Relies upon nc_addvar, nc_add_dimension, nc_info
%
% Test 1:  no input arguments, should fail
% Test 2:  three input arguments, should fail
% Test 3:  dump an empty file
% Test 4:  just one dimension
% Test 5:  one fixed size variable
% Test 6:  add some global attributes
% Test 7:  another variable with attributes

[version_num, release_name, release_date] = mexnc ( 'get_mexnc_info' );

%
% Test 1:  no input arguments
fprintf ( 1, 'Test 1\n' );
create_test_file ( ncfile );
status = nc_add_dimension ( ncfile, 'x', 6 );


clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };

nc_addvar ( ncfile, varstruct );

status = nc_add_dimension ( ncfile, 'time', 0 );

clear varstruct;
varstruct.Name = 'y';
varstruct.Nctype = 'float';
varstruct.Dimension = { 'time', 'x' };
varstruct.Attribute(1).Name = 'long_name';
varstruct.Attribute(1).Value = 'long_name';
varstruct.Attribute(2).Name = 'double';
varstruct.Attribute(2).Value = double(32);
varstruct.Attribute(3).Name = 'float';
varstruct.Attribute(3).Value = single(32);
varstruct.Attribute(4).Name = 'int';
varstruct.Attribute(4).Value = int32(32);
varstruct.Attribute(5).Name = 'int16';
varstruct.Attribute(5).Value = int16(32);
varstruct.Attribute(6).Name = 'int8';
varstruct.Attribute(6).Value = int8(32);
varstruct.Attribute(7).Name = 'uint8';
varstruct.Attribute(7).Value = uint8(32);

nc_addvar ( ncfile, varstruct );


[nc, status] = nc_info ( ncfile );
if ( status < 0 )
	error ( '%s:  nc_info failed on %s', mfilename, ncfile );
end


%
% Get the 7 attribute structs
% nc_info did this for us.
Att_output = nc.DataSet(2).Attribute;
Att_input = varstruct.Attribute;
for j = 1:7
	if ~strcmp ( Att_output(j).Name, Att_input(j).Name )
		msg = sprintf ( '%s:  attribute %d did not have the expected name.\n', mfilename, j );
		error ( msg );
	end
	output_datatype_string = nc_datatype_string ( Att_output(j).Nctype );


	if ~strcmp ( Att_output(j).Name, Att_input(j).Name )
		msg = sprintf ( '%s:  attribute %d did not have the expected name.\n', mfilename, j );
		error ( msg );
	end

	switch ( j )
	case 1
		if ~strcmp ( output_datatype_string, 'NC_CHAR' )
			msg = sprintf ( '%s:  attribute %d did not have the expected type.\n', mfilename, j );
			error ( msg );
		end

		switch ( release_name )
		case { 'MEXNC 2.0.6', 'MEXNC 2.0.9' }
			if ~strncmp(Att_output(j).Value,'long_name', 9)
				msg = sprintf ( '%s:  attribute %d did not have the expected value.\n', mfilename, j );
				error ( msg );
			end
			fprintf ( 1, '********************************************************************\n' );
			fprintf ( 1, '*                                                                  *\n' );
			fprintf ( 1, '* WARNING WARNING WARNING                                          *\n' );
			fprintf ( 1, '*                                                                  *\n' );
			fprintf ( 1, '* MEXNC releases prior to 2.0.10 have a bug where a null character *\n' );
			fprintf ( 1, '* gets tacked onto the end of each character attribute read from   *\n' );
			fprintf ( 1, '* a netcdf file.  Your version is ''%s''                    *\n', release_name );
			fprintf ( 1, '*                                                                  *\n' );
			fprintf ( 1, '* Compensating for this bug, this particular test succeeds.        *\n' );
			fprintf ( 1, '* Please hit any key to continue.                                  *\n' );
			fprintf ( 1, '*                                                                  *\n' );
			fprintf ( 1, '********************************************************************\n' );
			pause;
		
		
		otherwise
			if ~strcmp(Att_output(j).Value,'long_name')
				msg = sprintf ( '%s:  attribute %d did not have the expected value.\n', mfilename, j );
				error ( msg );
			end
		end
	case 2
		if ~strcmp ( output_datatype_string, 'NC_DOUBLE' )
			msg = sprintf ( '%s:  attribute %d did not have the expected type.\n', mfilename, j );
			error ( msg );
		end
		if Att_output(j).Value ~= 32
			msg = sprintf ( '%s:  attribute %d did not have the expected value.\n', mfilename, j );
			error ( msg );
		end
	case 3
		if ~strcmp ( output_datatype_string, 'NC_FLOAT' )
			msg = sprintf ( '%s:  attribute %d did not have the expected type.\n', mfilename, j );
			error ( msg );
		end
		if Att_output(j).Value ~= single(32)
			msg = sprintf ( '%s:  attribute %d did not have the expected value.\n', mfilename, j );
			error ( msg );
		end
	case 4
		if ~strcmp ( output_datatype_string, 'NC_INT' )
			msg = sprintf ( '%s:  attribute %d did not have the expected type.\n', mfilename, j );
			error ( msg );
		end
		if Att_output(j).Value ~= int32(32)
			msg = sprintf ( '%s:  attribute %d did not have the expected value.\n', mfilename, j );
			error ( msg );
		end
	case 5
		if ~strcmp ( output_datatype_string, 'NC_SHORT' )
			msg = sprintf ( '%s:  attribute %d did not have the expected type.\n', mfilename, j );
			error ( msg );
		end
		if Att_output(j).Value ~= int16(32)
			msg = sprintf ( '%s:  attribute %d did not have the expected value.\n', mfilename, j );
			error ( msg );
		end
	case 6
		if ~strcmp ( output_datatype_string, 'NC_BYTE' )
			msg = sprintf ( '%s:  attribute %d did not have the expected type.\n', mfilename, j );
			error ( msg );
		end
		if Att_output(j).Value ~= int8(32)
			msg = sprintf ( '%s:  attribute %d did not have the expected value.\n', mfilename, j );
			error ( msg );
		end
	case 7
		if ~strcmp ( output_datatype_string, 'NC_BYTE' )
			msg = sprintf ( '%s:  attribute %d did not have the expected type.\n', mfilename, j );
			error ( msg );
		end
		if Att_output(j).Value ~= uint8(32)
			msg = sprintf ( '%s:  attribute %d did not have the expected value.\n', mfilename, j );
			error ( msg );
		end
	end
end


fprintf ( 1, '%s succeeded\n', upper ( mfilename ) );

return












function create_test_file ( ncfile, arg2 )

%
% ok, first create the first file
[ncid_1, status] = mexnc ( 'create', ncfile, nc_clobber_mode );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''create'' failed, error message '' %s ''\n', mfilename, ncerr_msg );
	error ( msg );
end

%
% CLOSE
status = mexnc ( 'close', ncid_1 );
if ( status ~= 0 )
	error ( 'CLOSE failed' );
end
return

%
% Create a fixed dimension.  
len_x = 4;
[xdimid, status] = mexnc ( 'def_dim', ncid_1, 'x', len_x );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim x, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end

%
% Create a fixed dimension.  
len_y = 5;
[ydimid, status] = mexnc ( 'def_dim', ncid_1, 'y', len_y );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim y, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end


len_t = 0;
[ydimid, status] = mexnc ( 'def_dim', ncid_1, 'time', 0 );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim time, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end





%
% CLOSE
status = mexnc ( 'close', ncid_1 );
if ( status ~= 0 )
	error ( 'CLOSE failed' );
end

%
% Add a variable along the time dimension
varstruct.Name = 'test_var';
varstruct.Nctype = 'float';
if nargin > 1
	varstruct.Dimension = { 'time', 'y' };
else
	varstruct.Dimension = { 'time' };
end
varstruct.Attributes(1).Name = 'long_name';
varstruct.Attributes(1).Value = 'This is a test';
varstruct.Attributes(2).Name = 'short_val';
varstruct.Attributes(2).Value = int16(5);

nc_addvar ( ncfile, varstruct );


clear varstruct;
varstruct.Name = 'test_var2';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'time' };

nc_addvar ( ncfile, varstruct );


clear varstruct;
varstruct.Name = 'time';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'time' };

nc_addvar ( ncfile, varstruct );


clear varstruct;
varstruct.Name = 'test_var3';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };

nc_addvar ( ncfile, varstruct );
return


