function test_nc_getdiminfo ( ncfile )
% TEST_NC_GETDIMINFO:
%
% Relies upon nc_add_dimension, nc_addvar, nc_addnewrecs
%
% This first set of tests should fail
% Test 1:   no input arguments
% Test 2:   one input argument
% Test 3:   3 inputs
% Test 4:   2 character inputs, but 1st is not a NetCDF file
% Test 5:   2 character inputs, but 2nd is not a variable name
% Test 6:   2 numeric inputs, but 1st is not an ncid 
% Test 7:   2 numeric inputs, but 2nd is not a dimid
% Test 8:   1st input character, 2nd is numeric
% Test 9:   1st input numeric, 2nd is character
%
% These tests should be successful.
% Test 10:  test an unlimited dimension, character input
% Test 11:  test a limited dimension, character input
% Test 12:  test an unlimited dimension, numeric input
% Test 13:  test a limited dimension, numeric input

fprintf ( 1, '%s:  starting...\n', upper ( mfilename ) );

testid = 'Test 1';
fprintf ( 1, '%s:\n', testid );
[nb, status] = nc_getdiminfo;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



testid = 'Test 2';
fprintf ( 1, '%s:\n', testid );
[nb, status] = nc_getdiminfo ( ncfile );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



testid = 'Test 3';
fprintf ( 1, '%s:\n', testid );
try
	[diminfo, status] = nc_getdiminfo ( ncfile, 'x', 'y' );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );


%
% Ok, create a valid netcdf file now.
create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 'ocean_time', 0 );
status = nc_add_dimension ( ncfile, 'x', 2 );

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





testid = 'Test 4';
fprintf ( 1, '%s:\n', testid );
[diminfo, status] = nc_getdiminfo ( 'does_not_exist.nc', 'x' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



testid = 'Test 5';
fprintf ( 1, '%s:\n', testid );
[diminfo, status] = nc_getdiminfo ( ncfile, 'var_does_not_exist' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



testid = 'Test 6';
fprintf ( 1, '%s:\n', testid );
[diminfo, status] = nc_getdiminfo ( 1, 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



testid = 'Test 7';
fprintf ( 1, '%s:\n', testid );
[ncid, status] = mexnc ( 'open', ncfile, nc_nowrite_mode );
if ( status ~= 0 )
	msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
	error ( msg );
end
[diminfo, status] = nc_getdiminfo ( ncid, 25 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	mexnc ( 'close', ncid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );
mexnc ( 'close', ncid );



testid = 'Test 8';
fprintf ( 1, '%s:\n', testid );
[diminfo, status] = nc_getdiminfo ( ncfile, 25 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	mexnc ( 'close', ncid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );






testid = 'Test 9';
fprintf ( 1, '%s:\n', testid );
[ncid, status] = mexnc ( 'open', ncfile, nc_nowrite_mode );
if ( status ~= 0 )
	msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
	error ( msg );
end
[diminfo, status] = nc_getdiminfo ( ncid, 'ocean_time' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	mexnc ( 'close', ncid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );
mexnc ( 'close', ncid );





testid = 'Test 10';
fprintf ( 1, '%s:\n', testid );
[diminfo, status] = nc_getdiminfo ( ncfile, 'ocean_time' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp ( diminfo.Name, 'ocean_time' )
	msg = sprintf ( '%s:  diminfo.Name was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Length ~= 10 )
	msg = sprintf ( '%s:  diminfo.Length was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Dimid ~= 0 )
	msg = sprintf ( '%s:  diminfo.Dimid was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Record_Dimension ~= 1 )
	msg = sprintf ( '%s:  diminfo.Record_Dimension was incorrect.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





testid = 'Test 11';
fprintf ( 1, '%s:\n', testid );
[diminfo, status] = nc_getdiminfo ( ncfile, 'x' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp ( diminfo.Name, 'x' )
	msg = sprintf ( '%s:  diminfo.Name was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Length ~= 2 )
	msg = sprintf ( '%s:  diminfo.Length was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Dimid ~= 1 )
	msg = sprintf ( '%s:  diminfo.Dimid was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Record_Dimension ~= 0 )
	msg = sprintf ( '%s:  diminfo.Record_Dimension was incorrect.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





testid = 'Test 12';
[ncid, status] = mexnc ( 'open', ncfile, nc_nowrite_mode );
if ( status ~= 0 )
	msg = sprintf ( '%s:  mexnc:open failed on %s.\n', mfilename, ncfile );
	error ( msg );
end
fprintf ( 1, '%s:\n', testid );
[diminfo, status] = nc_getdiminfo ( ncid, 0 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp ( diminfo.Name, 'ocean_time' )
	msg = sprintf ( '%s:  diminfo.Name was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Length ~= 10 )
	msg = sprintf ( '%s:  diminfo.Length was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Dimid ~= 0 )
	msg = sprintf ( '%s:  diminfo.Dimid was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Record_Dimension ~= 1 )
	msg = sprintf ( '%s:  diminfo.Record_Dimension was incorrect.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





testid = 'Test 13';
fprintf ( 1, '%s:\n', testid );
[diminfo, status] = nc_getdiminfo ( ncid, 1 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp ( diminfo.Name, 'x' )
	msg = sprintf ( '%s:  diminfo.Name was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Length ~= 2 )
	msg = sprintf ( '%s:  diminfo.Length was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Dimid ~= 1 )
	msg = sprintf ( '%s:  diminfo.Dimid was incorrect.\n', mfilename, testid );
	error ( msg );
end
if ( diminfo.Record_Dimension ~= 0 )
	msg = sprintf ( '%s:  diminfo.Record_Dimension was incorrect.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



fprintf ( 1, '%s:  all tests succeeded...\n', upper ( mfilename ) );
return

