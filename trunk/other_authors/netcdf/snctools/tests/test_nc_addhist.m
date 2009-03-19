function test_nc_addhist ( ncfile )
% TEST_NC_ADDHIST
%
% Relies upon nc_attget, nc_add_dimension, nc_addvar
% Test 1:  no inputs
% test 2:  too many inputs
% test 3:  first input not a netcdf file
% test 4:  2nd input not character
% test 5:  3rd input not character
% Test 6:  Add history first time to global attributes
% Test 7:  Add history again
% Test 8:  Add history first time to variable
% Test 9:  Add history again

% test 1:  no input arguments
testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addhist;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



% test 2:  too many input arguments
testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addhist ( ncfile, 'x', 'blurb', 'blurb' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );






% test 3:  first input not a netcdf file
testid = 'Test 3';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[status] = nc_addhist ( '/dev/null', 'test' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% test 4:  2nd input not character
testid = 'Test 4';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[status] = nc_addhist ( ncfile, 5 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 5:  3rd input not character
testid = 'Test 5';
fprintf ( 1, '%s.\n', testid );
create_empty_file ( ncfile );
[dimid, status] = nc_add_dimension ( ncfile, 't', 0 );
clear varstruct;
varstruct.Name = 'T';
nc_addvar ( ncfile, varstruct );
[status] = nc_addhist ( ncfile, 'T', 5 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% Test 6:  Add history first time to variable
testid = 'Test 6';
fprintf ( 1, '%s.\n', testid );
create_empty_file ( ncfile );
histblurb = 'blah';
[status] = nc_addhist ( ncfile, histblurb );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
[hista,status] = nc_attget ( ncfile, nc_global, 'history' );
s = findstr(hista, histblurb );
if isempty(hista)
	msg = sprintf ( '%s:  %s:  history attribute did not contain first attribution.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 7:  Add history again
testid = 'Test 7';
fprintf ( 1, '%s.\n', testid );
create_empty_file ( ncfile );
histblurb = 'blah a';
[status] = nc_addhist ( ncfile, histblurb );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
histblurb2 = 'blah b';
[status] = nc_addhist ( ncfile, histblurb2 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
[histatt,status] = nc_attget ( ncfile, nc_global, 'history' );
s = findstr(histatt, histblurb2 );
if isempty(histatt)
	msg = sprintf ( '%s:  %s:  history attribute did not contain second attribution.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



% Test 8:  Add history first time to variable
testid = 'Test 8';
fprintf ( 1, '%s.\n', testid );
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'T';
nc_addvar ( ncfile, varstruct );
histblurb = 'blah';
[status] = nc_addhist ( ncfile, 'T', histblurb );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
[hista,status] = nc_attget ( ncfile, 'T', 'history' );
s = findstr(hista, histblurb );
if isempty(hista)
	msg = sprintf ( '%s:  %s:  history attribute did not contain first attribution.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 9:  Add history again
testid = 'Test 9';
fprintf ( 1, '%s.\n', testid );
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'T';
nc_addvar ( ncfile, varstruct );
histblurb = 'blah a';
[status] = nc_addhist ( ncfile, 'T', histblurb );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
histblurb2 = 'blah b';
[status] = nc_addhist ( ncfile, 'T', histblurb2 );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
[histatt,status] = nc_attget ( ncfile, 'T', 'history' );
s = findstr(histatt, histblurb2 );
if isempty(histatt)
	msg = sprintf ( '%s:  %s:  history attribute did not contain second attribution.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





fprintf ( 1, 'NC_ADDHIST succeeded\n' );

return








