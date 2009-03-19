function test_attput ( ncfile )
% TEST_ATTPUT
%
% Test 1:  Write a double attribute.
% Test 2:  Write a float attribute.
% Test 3:  Write an int attribute.
% Test 4:  Write a short int attribute.
% Test 5:  Write a uchar attribute.
% Test 6:  Write an schar attribute.
% Test 7:  Write a character attribute.
% Test 8:  Read said double attribute.
% Test 9:  Read said float attribute.
% Test 10:  Read said int attribute.
% Test 11:  Read said short int attribute.
% Test 12:  Read said uchar attribute.
% Test 13:  Read said schar attribute.
% Test 14:  Read said character attribute.
% Test 15:  Write with a bad ncid.
% Test 16:  Write with a bad varid.
% Test 17:  Write with a bad type.
% Test 18:  Write with a bad length.
% Test 19:  Read with a bad ncid.
% Test 20:  Read with a bad varid.
% Test 21:  Read with a bad name.
%


double_data = 3.14159;
float_data = single(double_data);
int_data = int32(double_data);
short_int_data = int16(double_data);
uchar_data = uint8(double_data);
schar_data = int8(double_data);
char_data = 'It was a dark and stormy night.  Suddenly a shot rang out.';



[ncid, status] = mexnc ( 'create', ncfile, nc_clobber_mode );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end


%
% DIMDEF
[xdimid, status] = mexnc ( 'def_dim', ncid, 'x', 20 );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

[varid, status] = mexnc ( 'def_var', ncid, 'x', nc_double, 1, xdimid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

%
% Test 1:  Write a double attribute.
input_data = double_data;
status = mexnc ( 'ATTPUT', ncid, varid, 'test_double', nc_double, 1, input_data );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end



% Test 2:  Write a float attribute.
status = mexnc ( 'ATTPUT', ncid, varid, 'test_float', nc_float, 1, double(input_data) );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end




% Test 3:  Write an int attribute.
status = mexnc ( 'ATTPUT', ncid, varid, 'test_int', nc_int, 1, double(input_data) );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end






% Test 4:  Write a short int attribute.
status = mexnc ( 'ATTPUT', ncid, varid, 'test_short_int', nc_short, 1, double(input_data) );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end



% Test 5:  Write a uchar attribute.
status = mexnc ( 'ATTPUT', ncid, varid, 'test_uchar', nc_byte, 1, double(input_data) );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end


% Test 6:  Write an schar attribute.
status = mexnc ( 'ATTPUT', ncid, varid, 'test_schar', nc_byte, 1, double(input_data) );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end




% Test 7:  Write a character attribute.
input_data = char_data;
status = mexnc ( 'ATTPUT', ncid, varid, 'test_char', nc_char, length(input_data), input_data );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end






[status] = mexnc ( 'enddef', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
status = mexnc ( 'sync', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end







% Test 8:  Read said double attribute.
testid = 'Test 8';
[return_value, status] = mexnc ( 'ATTGET', ncid, varid, 'test_double' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ( return_value ~= double_data )
	err_msg = sprintf ( '%s:  %s:  return value did not match input for ATT[GET,PUT]\n', mfilename, testid  );
	error ( err_msg );
end




% Test 9:  Read said float attribute.
testid = 'Test 9';
[return_value, status] = mexnc ( 'ATTGET', ncid, varid, 'test_float' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ( single(return_value) ~= float_data )
	err_msg = sprintf ( '%s:  %s:  return value did not match input for ATT[GET,PUT]\n', mfilename, testid  );
	error ( err_msg );
end




% Test 10:  Read said int attribute.
testid = 'Test 10';
[return_value, status] = mexnc ( 'ATTGET', ncid, varid, 'test_int' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ( int32(return_value) ~= int_data )
	err_msg = sprintf ( '%s:  %s:  return value did not match input for ATT[GET,PUT]\n', mfilename, testid  );
	error ( err_msg );
end







% Test 11:  Read said short int attribute.
testid = 'Test 11';
[return_value, status] = mexnc ( 'ATTGET', ncid, varid, 'test_short_int' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ( int16(return_value) ~= short_int_data )
	err_msg = sprintf ( '%s:  %s:  return value did not match input for ATT[GET,PUT]\n', mfilename, testid  );
	error ( err_msg );
end










% Test 12:  Read said uchar attribute.
testid = 'Test 12';
[return_value, status] = mexnc ( 'ATTGET', ncid, varid, 'test_uchar' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ( return_value ~= floor(double_data) )
	err_msg = sprintf ( '%s:  %s:  return value did not match input for ATT[GET,PUT]\n', mfilename, testid  );
	error ( err_msg );
end





% Test 13:  Read said schar attribute.
testid = 'Test 13';
[return_value, status] = mexnc ( 'ATTGET', ncid, varid, 'test_schar' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  %s:  ''%s''\n', mfilename, testid, ncerr );
	error ( err_msg );
end
if ( return_value ~= floor(double_data) )
	err_msg = sprintf ( '%s:  %s:  return value did not match input for ATT[GET,PUT]\n', mfilename, testid  );
	error ( err_msg );
end



% Test 14:  Read said character attribute.
testid = 'Test 14';
[return_value, status] = mexnc ( 'ATTGET', ncid, varid, 'test_char' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ~strcmp(class(return_value),'char')
	err_msg = sprintf ( '%s:  return value class did not match ''char''\n', mfilename  );
	error ( err_msg );
end
if ( ~strcmp(deblank(return_value),input_data ) )
	err_msg = sprintf ( '%s:  return value did not match input for [PUT,GET]_ATT_TEXT\n', mfilename );
	error ( err_msg );
end





[status] = mexnc ( 'redef', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end



% Test 15:  Write with a bad ncid.
testid = 'Test 15';
status = mexnc ( 'ATTPUT', -2, varid, 'test_double', nc_double, 1, input_data );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  %s:  ATTPUT succeeded with a bad ncid\n', mfilename, testid );
	error ( err_msg );
end



% Test 16:  Write with a bad varid.
testid = 'Test 16';
status = mexnc ( 'ATTPUT', ncid, -2000, 'test_double', nc_double, 1, input_data );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  %s:  ATTPUT succeeded with a bad varid\n', mfilename, testid );
	error ( err_msg );
end


% Test 17:  Write with a bad type.
testid = 'Test 17';
status = mexnc ( 'ATTPUT', ncid, varid, 'test_blah17', -2000, 1, input_data );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  %s:  ATTPUT succeeded with a bad nc_type\n', mfilename, testid );
	error ( err_msg );
end




% Test 18:  Write with a bad length.
%    This should actually succeed.  The old code is set to try to 
%    dynamically figure out how long the attribute is in case of
%    a negative length.
testid = 'Test 18';
status = mexnc ( 'ATTPUT', ncid, varid, 'test_blah18', nc_double, -2, double_data );
if ( status ~= 0 )
	err_msg = sprintf ( '%s:  %s:  ATTPUT failed when it should have succeeded\n', mfilename, testid );
	error ( err_msg );
end








% Test 19:  Read with a bad ncid.
testid = 'Test 19';
[return_value, status] = mexnc ( 'ATTGET', -2, varid, 'test_char_19' );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  %s:  ATTGET succeeded with a bad ncid\n', mfilename, testid );
	error ( err_msg );
end


% Test 20:  Read with a bad varid.
testid = 'Test 20';
[return_value, status] = mexnc ( 'ATTGET', ncid, -2, 'test_char_20' );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  %s:  ATTGET succeeded with a bad varid\n', mfilename, testid );
	error ( err_msg );
end


% Test 21:  Read with a bad name.
testid = 'Test 21';
[return_value, status] = mexnc ( 'ATTGET', ncid, varid, 'test_blah_21' );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  %s:  ATTGET succeeded with a bad name\n', mfilename, testid );
	error ( err_msg );
end




status = mexnc ( 'close', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

fprintf ( 1, 'ATTGET succeeded.\n' );
fprintf ( 1, 'ATTPUT succeeded.\n' );


return















