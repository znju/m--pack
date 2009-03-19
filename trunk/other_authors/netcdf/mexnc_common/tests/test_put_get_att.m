function test_put_get_att ( ncfile )
% TEST_PUT_ATT
%
% Tests the functions 
%    PUT_ATT_TEXT
%    PUT_ATT_UCHAR
%    PUT_ATT_SCHAR
%    PUT_ATT_SHORT
%    PUT_ATT_INT
%    PUT_ATT_FLOAT
%    PUT_ATT_DOUBLE
%    GET_ATT_TEXT
%    GET_ATT_UCHAR
%    GET_ATT_SCHAR
%    GET_ATT_SHORT
%    GET_ATT_INT
%    GET_ATT_FLOAT
%    GET_ATT_DOUBLE
%



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
% Double test
input_data = 3.14159;
status = mexnc ( 'put_att_double', ncid, varid, 'test_double', nc_double, 1, input_data );
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
[return_value, status] = mexnc ( 'get_att_double', ncid, varid, 'test_double' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ( return_value ~= input_data )
	err_msg = sprintf ( '%s:  return value did not match input for [PUT,GET]_ATT_DOUBLE\n', mfilename  );
	error ( err_msg );
end



fprintf ( 1, 'PUT_ATT_DOUBLE succeeded.\n' );
fprintf ( 1, 'GET_ATT_DOUBLE succeeded.\n' );

%
% float test
status = mexnc ( 'redef', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
input_data = single(3.14159);
status = mexnc ( 'put_att_float', ncid, varid, 'test_float', nc_float, 1, input_data );
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
[return_value, status] = mexnc ( 'get_att_float', ncid, varid, 'test_float' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ~strcmp(class(return_value),'single')
	err_msg = sprintf ( '%s:  return value class did not match ''single''\n', mfilename  );
	error ( err_msg );
end
if ( double(return_value) ~= double(input_data) )
	err_msg = sprintf ( '%s:  return value did not match input for [PUT,GET]_ATT_FLOAT\n', mfilename  );
	error ( err_msg );
end



fprintf ( 1, 'PUT_ATT_FLOAT succeeded.\n' );
fprintf ( 1, 'GET_ATT_FLOAT succeeded.\n' );


%
% int test
status = mexnc ( 'redef', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
input_data = int32(3.14159);
status = mexnc ( 'put_att_int', ncid, varid, 'test_int', nc_int, 1, input_data );
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
[return_value, status] = mexnc ( 'get_att_int', ncid, varid, 'test_int' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ~strcmp(class(return_value),'int32')
	err_msg = sprintf ( '%s:  return value class did not match ''int32''\n', mfilename  );
	error ( err_msg );
end
if ( double(return_value) ~= double(input_data) )
	err_msg = sprintf ( '%s:  return value did not match input for [PUT,GET]_ATT_INT\n', mfilename  );
	error ( err_msg );
end



fprintf ( 1, 'PUT_ATT_INT succeeded.\n' );
fprintf ( 1, 'GET_ATT_INT succeeded.\n' );

%
% short test
status = mexnc ( 'redef', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
input_data = int16(-235);
status = mexnc ( 'put_att_short', ncid, varid, 'test_short', nc_short, 1, input_data );
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
[return_value, status] = mexnc ( 'get_att_short', ncid, varid, 'test_short' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ~strcmp(class(return_value),'int16')
	err_msg = sprintf ( '%s:  return value class did not match ''int16''\n', mfilename  );
	error ( err_msg );
end
if ( double(return_value) ~= double(input_data) )
	err_msg = sprintf ( '%s:  return value did not match input for [PUT,GET]_ATT_SHORT\n', mfilename  );
	error ( err_msg );
end



fprintf ( 1, 'PUT_ATT_SHORT succeeded.\n' );
fprintf ( 1, 'GET_ATT_SHORT succeeded.\n' );


%
% schar test
status = mexnc ( 'redef', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
input_data = int8(-100);
status = mexnc ( 'put_att_schar', ncid, varid, 'test_schar', nc_byte, 1, input_data );
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
[return_value, status] = mexnc ( 'get_att_schar', ncid, varid, 'test_schar' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ~strcmp(class(return_value),'int8')
	err_msg = sprintf ( '%s:  return value class did not match ''int8''\n', mfilename  );
	error ( err_msg );
end
if ( double(return_value) ~= double(input_data) )
	err_msg = sprintf ( '%s:  return value did not match input for [PUT,GET]_ATT_SCHAR\n', mfilename  );
	error ( err_msg );
end



fprintf ( 1, 'PUT_ATT_SCHAR succeeded.\n' );
fprintf ( 1, 'GET_ATT_SCHAR succeeded.\n' );


%
% uchar test
status = mexnc ( 'redef', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
input_data = uint8(100);
status = mexnc ( 'put_att_schar', ncid, varid, 'test_uchar', nc_byte, 1, input_data );
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
[return_value, status] = mexnc ( 'get_att_uchar', ncid, varid, 'test_uchar' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ~strcmp(class(return_value),'uint8')
	err_msg = sprintf ( '%s:  return value class did not match ''uint8''\n', mfilename  );
	error ( err_msg );
end
if ( double(return_value) ~= double(input_data) )
	err_msg = sprintf ( '%s:  return value did not match input for [PUT,GET]_ATT_UCHAR\n', mfilename  );
	error ( err_msg );
end



fprintf ( 1, 'PUT_ATT_UCHAR succeeded.\n' );
fprintf ( 1, 'GET_ATT_UCHAR succeeded.\n' );


%
% char test
status = mexnc ( 'redef', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
input_data = 'It was a dark and stormy night.  Suddenly a shot rang out.';
status = mexnc ( 'put_att_text', ncid, varid, 'test_char', nc_char, length(input_data), input_data );
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
[return_value, status] = mexnc ( 'get_att_text', ncid, varid, 'test_char' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if ~strcmp(class(return_value),'char')
	err_msg = sprintf ( '%s:  return value class did not match ''char''\n', mfilename  );
	error ( err_msg );
end
if ( ~strcmp(return_value,input_data ) )
	err_msg = sprintf ( '%s:  return value did not match input for [PUT,GET]_ATT_TEXT\n', mfilename );
	error ( err_msg );
end



fprintf ( 1, 'PUT_ATT_TEXT succeeded.\n' );
fprintf ( 1, 'GET_ATT_TEXT succeeded.\n' );


status = mexnc ( 'close', ncid );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end


return















