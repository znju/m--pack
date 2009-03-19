function test_nc_getlast ( ncfile )
% TEST_NC_GETLAST:
%
% This first set of tests should all fail.
% Test 1:  No inputs.
% Test 2:  One input.
% Test 3:  Four inputs.
% Test 4:  1st input is not character.
% Test 5:  2nd input is not character.
% Test 6:  3rd input is not numeric.
% Test 7:  1st input is not a netcdf file.
% Test 8:  2nd input is not a netcdf variable.
% Test 9:  2nd input is a netcdf variable, but not unlimited.
% Test 10:  Non-positive "num_records"
% Test 11:  Time series variables have no data.
% Test 12:  Time series variables have data, but fewer than what was 
%           requested.
%
% This second set of tests should all succeed.
% Test 13:  Two inputs, should return the last record.
% Test 14:  Three valid inputs.
% Test 15:  Three valid inputs, but get everything.



fprintf ( 1, '%s:  starting...\n', upper ( mfilename ) );

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 'ocean_time', 0 );
status = nc_add_dimension ( ncfile, 'x', 2 );

testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( ncfile );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 3';
fprintf ( 1, '%s.\n', testid );
try
	[nb, status] = nc_getlast ( ncfile, 't1', 3, 4 );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );





testid = 'Test 4';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( 0, 't1' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 5';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( ncfile, 0 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 6';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( ncfile, 't1', 'a' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 7';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( '/dev/null', 't1', 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 8';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( ncfile, 't4', 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 9';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( ncfile, 'x', 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 10';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( ncfile, 't1', 0 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );






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
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't3';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );




testid = 'Test 11';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( ncfile, 't1', 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




%
% write ten records
x = [0:9]';
b.ocean_time = x;
b.t1 = x;
b.t2 = 1./(1+x);
b.t3 = x.^2;
[nb,status] = nc_addnewrecs ( ncfile, b, 'ocean_time' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_addnewrecs failed on %s.\n', mfilename, ncfile );
	error ( msg );
end



testid = 'Test 12';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getlast ( ncfile, 't1', 12 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 13';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_getlast ( ncfile, 't1' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( length(v) ~= 1 )
	msg = sprintf ( '%s:  %s: return value length was wrong.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );


testid = 'Test 14';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_getlast ( ncfile, 't1', 7 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( length(v) ~= 7 )
	msg = sprintf ( '%s:  %s: return value length was wrong.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



testid = 'Test 15';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_getlast ( ncfile, 't1', 10 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ( length(v) ~= 10 )
	msg = sprintf ( '%s:  %s: return value length was wrong.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );







fprintf ( 1, '%s:  all tests succeeded...\n', upper ( mfilename ) );
return


