function test_nc_add_dimension ( ncfile )
% TEST_NC_ADD_DIMENSION
%
% Relies upon nc_getdiminfo, nc_add_dimension.
%
% Test 1:  no inputs
% test 2:  too many inputs
% test 3:  first input not a netcdf file
% test 4:  2nd input not character
% test 5:  3rd input not numeric
% test 6:  3rd input is negative
% Test 7:  Add a normal length dimension.
% Test 8:  Add an unlimited dimension.
% test 9:  named dimension already exists (should fail)

fprintf ( '%s:  starting tests...\n', upper(mfilename) );


% test 1:  no input arguments
testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
[dimid, status] = nc_add_dimension;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% test 2:  too many inputs
testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
create_empty_file ( ncfile );
try
	[dimid, status] = nc_add_dimension ( ncfile, 'x', 10 );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 3:  first input not a netcdf file
testid = 'Test 3';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[dimid, status] = nc_add_dimension ( '/dev/null', 'x', 3 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );


% test 4:  2nd input not char
testid = 'Test 4';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[dimid, status] = nc_add_dimension ( ncfile, 3, 3 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



% test 5:  3rd input not numeric
testid = 'Test 5';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[dimid, status] = nc_add_dimension ( ncfile, 't', 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );


% test 6:  3rd input is negative
testid = 'Test 6';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[dimid, status] = nc_add_dimension ( ncfile, 't', -1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );


% test 7:  add a normal dimension
testid = 'Test 7';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[dimid, status] = nc_add_dimension ( ncfile, 't', 5 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

%
% Now check that the new dimension are there.
[d, status] = nc_getdiminfo ( ncfile, 't' );
if ( status < 0 )
	error ( '%s:  nc_getdiminfo failed on %s', mfilename, ncfile );
end
if ( ~strcmp(d.Name,'t') )
	error ( '%s:  nc_add_dimension failed on fixed dimension add name', mfilename  );
end
if ( d.Length ~= 5 )
	error ( '%s:  nc_add_dimension failed on fixed dimension add length', mfilename  );
end
if ( d.Record_Dimension ~= 0  )
	error ( '%s:  nc_add_dimension incorrectly classified the dimension', mfilename  );
end

fprintf ( 1, '%s:  passed.\n', testid );






% test 8:  add an unlimited dimension
testid = 'Test 8';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[dimid, status] = nc_add_dimension ( ncfile, 't', 0 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

%
% Now check that the new dimension are there.
[d, status] = nc_getdiminfo ( ncfile, 't' );
if ( status < 0 )
	error ( '%s:  nc_getdiminfo failed on %s', mfilename, ncfile );
end
if ( ~strcmp(d.Name,'t') )
	error ( '%s:  nc_add_dimension failed on fixed dimension add name', mfilename  );
end
if ( d.Length ~= 0 )
	error ( '%s:  nc_add_dimension failed on fixed dimension add length', mfilename  );
end
if ( d.Record_Dimension ~= 1  )
	error ( '%s:  nc_add_dimension incorrectly classified the dimension', mfilename  );
end

fprintf ( 1, '%s:  passed.\n', testid );






% test 9:  try to add a dimension that is already there
testid = 'Test 9';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[dimid, status] = nc_add_dimension ( ncfile, 't', 0 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
[dimid, status] = nc_add_dimension ( ncfile, 't', 0 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
[dimid, status] = nc_add_dimension ( ncfile, 'x', 1 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
[dimid, status] = nc_add_dimension ( ncfile, 'x', 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );


fprintf ( '%s:  succeeded...\n', upper(mfilename) );

return;


