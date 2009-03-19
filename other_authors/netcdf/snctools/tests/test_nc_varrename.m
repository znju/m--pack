function test_nc_varrename ( ncfile )
% TEST_NC_ISVAR:
%
% Depends upon nc_add_dimension, nc_addvar
%
% 1st set of tests, routine should fail
% test 1:  no input arguments
% test 2:  1 input
% test 3:  2 input
% test 4:  too many inputs
% test 5:  inputs are not all character
% test 6:  not a netcdf file
% test 7:  empty netcdf file
% test 8:  given variable is not present
%
% 2nd set of tests, routine should succeed
% test 9:  given variable is present

%
% 3rd set should fail
% test 10:  given variable is present, but another exists with the same name


fprintf ( 1, '%s:  starting...\n', upper ( mfilename ) );





% test 1:  no input arguments
testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
try
	[status] = nc_varrename;
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 2:  1 input
testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
try
	[status] = nc_varrename ( ncfile );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



% test 3:  2 inputs
testid = 'Test 3';
fprintf ( 1, '%s.\n', testid );
try
	[status] = nc_varrename ( ncfile, 'x' );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% test 4:  too many inputs
testid = 'Test 4';
fprintf ( 1, '%s.\n', testid );
try
	nc = nc_varrename ( ncfile, 'blah', 'blah2', 'blah3' );
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





% test 5:  inputs are not all character
testid = 'Test 5';
fprintf ( 1, '%s.\n', testid );
[status] = nc_varrename ( '/dev/null', 'x', 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 6:  not a netcdf file
testid = 'Test 5';
fprintf ( 1, '%s.\n', testid );
[status] = nc_varrename ( '/dev/null', 't', 'u' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 6:  empty netcdf file
testid = 'Test 6';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[status] = nc_varrename ( ncfile, 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succceeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 7:  empty netcdf file
testid = 'Test 7';

create_empty_file ( ncfile );
[status] = nc_varrename ( ncfile, 'x', 'y' );
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
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[status] = nc_varrename ( ncfile, 't2', 't3' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );








% test 9:  given variable is present
testid = 'Test 9';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[status] = nc_varrename ( ncfile, 't', 't2' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end



v = nc_getvarinfo ( ncfile, 't2' );
if ~strcmp ( v.Name, 't2' )
	msg = sprintf ( '%s:  %s:  rename did not seem to work.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );




% test 10:  given variable is present, but another exists with the same name
testid = 'Test 10';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );
varstruct.Name = 't2';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[status] = nc_varrename ( ncfile, 't', 't2' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end



v = nc_getvarinfo ( ncfile, 't2' );
if ~strcmp ( v.Name, 't2' )
	msg = sprintf ( '%s:  %s:  rename did not seem to work.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );




fprintf ( 1, '%s:  all tests succeeded...\n', upper ( mfilename ) );
return


