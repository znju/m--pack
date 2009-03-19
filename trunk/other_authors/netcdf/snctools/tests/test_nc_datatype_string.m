function test_nc_datatype_string()
% TEST_NC_DATATYPE_STRING:
%
% Bad input argument tests.
% Test 1:  no inputs
% Test 2:  two inputs
% test 3:  input not numeric
% test 4:  input is outside of 0-6
%
% These tests should succeed
% test 5:  input is 0 ==> 'NC_NAT'
% test 6:  input is 1 ==> 'NC_BYTE'
% test 7:  input is 2 ==> 'NC_CHAR'
% test 8:  input is 3 ==> 'NC_SHORT'
% test 9:  input is 4 ==> 'NC_INT'
% test 10:  input is 5 ==> 'NC_FLOAT'
% test 11:  input is 6 ==> 'NC_DOUBLE'





fprintf ( 1, '%s:  starting...\n', upper(mfilename) );

% Test 1:  no inputs
testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
try
	dt = nc_datatype_string;
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );







% Test 2:  two inputs
testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
try
	dt = nc_datatype_string ( 0, 1 );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );







% test 3:  input not numeric
testid = 'Test 3';
fprintf ( 1, '%s.\n', testid );
try
	dt = nc_datatype_string ( 'a' );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );







% test 4:  input is outside of 0-6
testid = 'Test 4';
fprintf ( 1, '%s.\n', testid );
try
	dt = nc_datatype_string ( -1 );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );







%
% These tests should succeed
% test 5:  input is 0 ==> 'NC_NAT'
testid = 'Test 5';
fprintf ( 1, '%s.\n', testid );
dt = nc_datatype_string ( 0 );
if ~strcmp(dt,'NC_NAT')
	msg = sprintf ( '%s:  %s: failed to convert 0.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 6:  input is 1 ==> 'NC_BYTE'
testid = 'Test 6';
fprintf ( 1, '%s.\n', testid );
dt = nc_datatype_string ( 1 );
if ~strcmp(dt,'NC_BYTE')
	msg = sprintf ( '%s:  %s: failed to convert 1.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 7:  input is 2 ==> 'NC_CHAR'
testid = 'Test 7';
fprintf ( 1, '%s.\n', testid );
dt = nc_datatype_string ( 2 );
if ~strcmp(dt,'NC_CHAR')
	msg = sprintf ( '%s:  %s: failed to convert 2.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 8:  input is 3 ==> 'NC_SHORT'
testid = 'Test 8';
fprintf ( 1, '%s.\n', testid );
dt = nc_datatype_string ( 3 );
if ~strcmp(dt,'NC_SHORT')
	msg = sprintf ( '%s:  %s: failed to convert 3.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 9:  input is 4 ==> 'NC_INT'
testid = 'Test 9';
fprintf ( 1, '%s.\n', testid );
dt = nc_datatype_string ( 4 );
if ~strcmp(dt,'NC_INT')
	msg = sprintf ( '%s:  %s: failed to convert 4.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 10:  input is 5 ==> 'NC_FLOAT'
testid = 'Test 10';
fprintf ( 1, '%s.\n', testid );
dt = nc_datatype_string ( 5 );
if ~strcmp(dt,'NC_FLOAT')
	msg = sprintf ( '%s:  %s: failed to convert 5.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 11:  input is 6 ==> 'NC_DOUBLE'
testid = 'Test 11';
fprintf ( 1, '%s.\n', testid );
dt = nc_datatype_string ( 6 );
if ~strcmp(dt,'NC_DOUBLE')
	msg = sprintf ( '%s:  %s: failed to convert 6.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );











fprintf ( 1, '%s:  all tests passed.\n', upper(mfilename) );

