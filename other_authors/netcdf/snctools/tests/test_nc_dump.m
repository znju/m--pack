function test_nc_dump ( ncfile )
% TEST_NC_DUMP:  runs series of tests for nc_dump.m
%
% Relies upon nc_add_dimension, nc_addvar, nc_attput
%
% Test 1:  no input arguments, should fail
% Test 2:  three input arguments, should fail
% Test 3:  dump an empty file
% Test 4:  just one dimension
% Test 5:  one fixed size variable
% Test 6:  add some global attributes
% Test 7:  another variable with attributes
% Test 8:  singleton variable

%
% Test 1:  no input arguments
fprintf ( 1, 'Test 1\n' );
create_test_file ( ncfile );
status = nc_dump;
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_dump succeeded on Test 1 when it should have failed.\n' );
	error ( msg );
end
fprintf ( 1, 'Test 1 Succeeded.\n' );





%
% Test 2:  three input arguments
fprintf ( 1, 'Test 2\n' );
try
	status = nc_dump ( ncfile, 'a', 'b' );
	if ( status >= 0 )
		msg = sprintf ( '%s:  nc_dump succeeded on Test 2 when it should have failed.\n' );
		error ( msg );
	end
catch
	;		
end
fprintf ( 1, 'Test 2 Succeeded.\n' );




%
% Test 3:  empty file
fprintf ( 1, 'Test 3\n' );
status = nc_dump ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_dump failed on Test 3.\n' );
	error ( msg );
end
fprintf ( 1, 'Test 3 Succeeded.\n' );




%
% Test 4:  just one dimension
fprintf ( 1, 'Test 4\n' );
status = nc_add_dimension ( ncfile, 'x', 6 );
status = nc_dump ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_dump failed on Test 4.\n' );
	error ( msg );
end
fprintf ( 1, 'Test 4 Succeeded.\n' );




%
% Test 5:  one fixed size variable
fprintf ( 1, 'Test 5\n' );

clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };

nc_addvar ( ncfile, varstruct )

status = nc_dump ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_dump failed on Test 5.\n' );
	error ( msg );
end
fprintf ( 1, 'Test 5 Succeeded.\n' );



%
% Test 6:  add some global attributes
fprintf ( 1, 'Test 6\n' );

status = nc_attput ( ncfile, nc_global, 'double', 3.14159 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed on Test 6.\n' );
	error ( msg );
end
status = nc_attput ( ncfile, nc_global, 'single', single(3.14159) );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed on Test 6.\n' );
	error ( msg );
end
status = nc_attput ( ncfile, nc_global, 'int32', int32(314159) );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed on Test 6.\n' );
	error ( msg );
end
status = nc_attput ( ncfile, nc_global, 'int16', int16(31415) );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed on Test 6.\n' );
	error ( msg );
end
status = nc_attput ( ncfile, nc_global, 'int8', int8(-31) );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed on Test 6.\n' );
	error ( msg );
end
status = nc_attput ( ncfile, nc_global, 'uint8', uint8(31) );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed on Test 6.\n' );
	error ( msg );
end


status = nc_dump ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_dump failed on Test 5.\n' );
	error ( msg );
end
fprintf ( 1, 'Test 6 Succeeded.\n' );




%
% Test 7:  another variable with attributes
fprintf ( 1, 'Test 7\n' );

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

nc_addvar ( ncfile, varstruct )

status = nc_dump ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_dump failed on Test 5.\n' );
	error ( msg );
end
fprintf ( 1, 'Test 7 Succeeded.\n' );



fprintf ( 1, '%s succeeded\n', upper ( mfilename ) );








% Test 8:  singleton variable
testid = 'Test 8';
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'double_var';
varstruct.Nctype = 'double';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct )
fprintf ( 1, '%s.\n', testid );
status = nc_dump ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  %s:   nc_dump failed.\n', testid, mfilename );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





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


