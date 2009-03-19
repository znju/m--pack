function test_nc_isunlimitedvar ( ncfile )
% TEST_NC_ISUNLIMITEDVAR:
%
% Depends upon nc_add_dimension, nc_addvar
%
% 1st set of tests, routine should fail
% test 1:  no input arguments
% test 2:  1 input
% test 3:  too many inputs
% test 4:  both inputs are not character
% test 5:  not a netcdf file
% test 6:  empty netcdf file
% test 7:  netcdf file has dimensions, but no variables.
% test 8:  given variable is not present  
%
% 2nd set of tests, routine should succeed
% test 9:  given variable is not an unlimited variable
% test 10:  given 1D variable is an unlimited variable
% test 11:  given 2D variable is an unlimited variable


fprintf ( 1, '%s:  starting...\n', upper ( mfilename ) );





% test 1:  no input arguments
testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_isunlimitedvar;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 2:  1 input
testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_isunlimitedvar ( ncfile );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% test 3:  too many inputs
testid = 'Test 3';
fprintf ( 1, '%s.\n', testid );
try
	nc = nc_isunlimitedvar ( ncfile, 'blah', 'blah2' );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );





%
% Ok, now we'll create the test file
create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );





% test 4:  both inputs are not character
testid = 'Test 4';
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_isunlimitedvar ( '/dev/null', 5 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 5:  not a netcdf file
testid = 'Test 5';
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_isunlimitedvar ( '/dev/null', 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 6:  empty netcdf file
testid = 'Test 6';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_isunlimitedvar ( ncfile, 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 7:  netcdf file has dimensions, but no variables.
testid = 'Test 7';
create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 't', 0 );
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_isunlimitedvar ( ncfile, 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% test 8:  given variable is not present  
testid = 'Test 8';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = [];

nc_addvar ( ncfile, varstruct );
fprintf ( 1, '%s.\n', testid );
[nc, status] = nc_isunlimitedvar ( ncfile, 'y' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% 2nd set of tests should succeed
% test 9:  given variable is not an unlimited variable
testid = 'Test 9';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 0 );
status = nc_add_dimension ( ncfile, 'x', 10 );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };

nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[b, status] = nc_isunlimitedvar ( ncfile, 'x' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( b ~= 0 )
	msg = sprintf ( '%s:  %s:  incorrect result.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% test 10:  given variable is an unlimited variable
testid = 'Test 10';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[b, status] = nc_isunlimitedvar ( ncfile, 't' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( b ~= 1 )
	msg = sprintf ( '%s:  %s:  incorrect result.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 11:  given variable is an unlimited variable
testid = 'Test 11';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't', 's' };
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[b, status] = nc_isunlimitedvar ( ncfile, 't' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( b ~= 1 )
	msg = sprintf ( '%s:  %s:  incorrect result.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );







fprintf ( 1, '%s:  all tests succeeded...\n', upper ( mfilename ) );
return


