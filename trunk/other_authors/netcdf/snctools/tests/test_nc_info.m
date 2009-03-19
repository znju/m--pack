function test_nc_info ( ncfile )
% TEST_NC_INFO:
%
% Depends upon nc_add_dimension, nc_addvar
%
% 1st set of tests should fail
% test 1:  no input arguments, should fail
% test 2:  too many inputs
% test 3:  1 input, not a netcdf file
%
% 2nd set of tests should succeed
% test 4:  empty netcdf file
% test 5:  netcdf file has dimensions, but no variables.
% test 6:  netcdf file has singleton variables, but no dimensions.
% test 7:  netcdf file has global attributes, but no variables or dimensions
% test 8:  netcdf file with dimensions, variables, both unlimited variables 
%          and fixed variables, and global attributes


fprintf ( 1, '%s:  starting...\n', upper ( mfilename ) );





testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_info;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
try
	nc = nc_info ( ncfile, 'blah' );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );





testid = 'Test 3';
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_info ( '/dev/null' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 4';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_info ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp ( nc.Filename, ncfile )
	msg = sprintf ( '%s:  %s:  Filename was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Dimension ) ~= 0 )
	msg = sprintf ( '%s:  %s:  Dimension was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.DataSet ) ~= 0 )
	msg = sprintf ( '%s:  %s:  DataSet was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Attribute ) ~= 0 )
	msg = sprintf ( '%s:  %s:  Attribute was wrong.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









testid = 'Test 5';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 'ocean_time', 0 );
status = nc_add_dimension ( ncfile, 'x', 2 );
status = nc_add_dimension ( ncfile, 'y', 6 );

fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_info ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp ( nc.Filename, ncfile )
	msg = sprintf ( '%s:  %s:  Filename was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Dimension ) ~= 3 )
	msg = sprintf ( '%s:  %s:  Dimension was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.DataSet ) ~= 0 )
	msg = sprintf ( '%s:  %s:  DataSet was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Attribute ) ~= 0 )
	msg = sprintf ( '%s:  %s:  Attribute was wrong.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );










testid = 'Test 6';

create_empty_file ( ncfile );

clear varstruct;
varstruct.Name = 'y';
varstruct.Nctype = 'double';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_info ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp ( nc.Filename, ncfile )
	msg = sprintf ( '%s:  %s:  Filename was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Dimension ) ~= 0 )
	msg = sprintf ( '%s:  %s:  Dimension was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.DataSet ) ~= 1 )
	msg = sprintf ( '%s:  %s:  DataSet was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Attribute ) ~= 0 )
	msg = sprintf ( '%s:  %s:  Attribute was wrong.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );







testid = 'Test 7';

create_empty_file ( ncfile );

clear varstruct;
status = nc_attput ( ncfile, nc_global, 'test1', 'this' );
status = nc_attput ( ncfile, nc_global, 'test2', 'is' );
status = nc_attput ( ncfile, nc_global, 'test3', 'a' );
status = nc_attput ( ncfile, nc_global, 'test4', 'test' );

fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_info ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp ( nc.Filename, ncfile )
	msg = sprintf ( '%s:  %s:  Filename was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Dimension ) ~= 0 )
	msg = sprintf ( '%s:  %s:  Dimension was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.DataSet ) ~= 0 )
	msg = sprintf ( '%s:  %s:  DataSet was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Attribute ) ~= 4 )
	msg = sprintf ( '%s:  %s:  Attribute was wrong.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









testid = 'Test 8';

create_empty_file ( ncfile );

status = nc_add_dimension ( ncfile, 'ocean_time', 0 );
status = nc_add_dimension ( ncfile, 'x', 2 );
status = nc_add_dimension ( ncfile, 'y', 6 );

clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 'ocean_time';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't1';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't2';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
varstruct.Attribute(1).Name = 'test_att';
varstruct.Attribute(1).Value = 'dud';
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't3';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 'y';
varstruct.Nctype = 'double';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 'z';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'y', 'x' };
nc_addvar ( ncfile, varstruct );




clear varstruct;
status = nc_attput ( ncfile, nc_global, 'test1', 'this' );
status = nc_attput ( ncfile, nc_global, 'test2', 'is' );
status = nc_attput ( ncfile, nc_global, 'test3', 'a' );
status = nc_attput ( ncfile, nc_global, 'test4', 'test' );

fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_info ( ncfile );
if ( status < 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp ( nc.Filename, ncfile )
	msg = sprintf ( '%s:  %s:  Filename was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Dimension ) ~= 3 )
	msg = sprintf ( '%s:  %s:  Dimension was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.DataSet ) ~= 7 )
	msg = sprintf ( '%s:  %s:  DataSet was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length ( nc.Attribute ) ~= 4 )
	msg = sprintf ( '%s:  %s:  Attribute was wrong.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );










fprintf ( 1, '%s:  all tests succeeded...\n', upper ( mfilename ) );
return


