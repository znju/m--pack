function test_nc_varsize ( ncfile )
% TEST_NC_VARSIZE:
%
% Depends upon nc_add_dimension, nc_addvar
%
% 1st set of tests, routine should fail
% test 1:  no input arguments
% test 2:  1 input
% test 3:  too many inputs
% test 4:  inputs are not all character
% test 5:  not a netcdf file
% test 6:  empty netcdf file
% test 7:  given variable is not present
%
% 2nd set of tests, routine should succeed
% test 8:  given singleton variable is present
% test 9:  given 1D variable is present
% test 10:  given 1D-unlimited-but-empty variable is present
% test 11:  given 2D variable is present



fprintf ( 1, '%s:  starting...\n', upper ( mfilename ) );





% test 1:  no input arguments
testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_varsize;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 2:  1 input
testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_varsize ( ncfile );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



% test 3:  too many inputs
testid = 'Test 3';
fprintf ( 1, '%s.\n', testid );
try
	[v, status] = nc_varsize ( ncfile, 'x', 'y' );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );





% test 4:  inputs are not all character
testid = 'Test 4';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_varsize ( ncfile, 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



% test 5:  not a netcdf file
testid = 'Test 5';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_varsize ( '/dev/null', 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );











% test 6:  not a netcdf file
testid = 'Test 6';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_varsize ( '/dev/null', 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 6:  empty netcdf file
testid = 'Test 6';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_varsize ( ncfile, 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succceeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 7:  given variable is not present
testid = 'Test 7';

create_empty_file ( ncfile );
[v, status] = nc_varsize ( ncfile, 'x' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );











% test 8:  given singleton variable is present
testid = 'Test 9';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[varsize, status] = nc_varsize ( ncfile, 's' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( varsize ~= 1 )
	msg = sprintf ( '%s:  %s: varsize was not right.\n', mfilename, testid );
	error ( msg );
end







% test 9:  given 1D variable is present
testid = 'Test 9';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's' };
nc_addvar ( ncfile, varstruct );
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[varsize, status] = nc_varsize ( ncfile, 's' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( varsize ~= 5 )
	msg = sprintf ( '%s:  %s: varsize was not right.\n', mfilename, testid );
	error ( msg );
end








% test 10:  given 1D unlimited-but-empty variable is present
testid = 'Test 10';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't', 's' };
nc_addvar ( ncfile, varstruct );
clear varstruct;
varstruct.Name = 'w';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[varsize, status] = nc_varsize ( ncfile, 't' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( varsize(1) ~= 0 ) & ( varsize(2) ~= 5 )
	msg = sprintf ( '%s:  %s: varsize was not right.\n', mfilename, testid );
	error ( msg );
end








% test 11:  given 2D variable is present
testid = 'Test 11';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 7 );
clear varstruct;
varstruct.Name = 'st';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's', 't' };
nc_addvar ( ncfile, varstruct );

fprintf ( 1, '%s.\n', testid );
[varsize, status] = nc_varsize ( ncfile, 'st' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( varsize(1) ~= 5 ) & ( varsize(2) ~= 7 )
	msg = sprintf ( '%s:  %s: varsize was not right.\n', mfilename, testid );
	error ( msg );
end









