function test_attcopy ( ncfile1, ncfile2 )
% TEST_ATTCOPY
%
% Test 1:  Copy a double precision attribute.
% Test 2:  Copy from a bad source ncid.  Should fail.
% Test 3:  Copy from a bad source varid.  Should fail.
% Test 4:  Copy to a bad destination ncid.  Should fail.
% Test 5:  Copy to a bad destination varid.  Should fail.


% Test 1:  Copy a double precision attribute.
[ncid1, status] = mexnc ( 'create', ncfile1, nc_clobber_mode );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end


[xdimid1, status] = mexnc ( 'def_dim', ncid1, 'x', 20 );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

[varid1, status] = mexnc ( 'def_var', ncid1, 'x', nc_double, 1, xdimid1 );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

input_data = [3.14159];
status = mexnc ( 'put_att_double', ncid1, varid1, 'test_double', nc_double, 1, input_data );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
[status] = mexnc ( 'enddef', ncid1 );

status = mexnc ( 'sync', ncid1 );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end



[ncid2, status] = mexnc ( 'create', ncfile2, nc_clobber_mode );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end


[xdimid2, status] = mexnc ( 'def_dim', ncid2, 'x', 20 );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

[varid2, status] = mexnc ( 'def_var', ncid2, 'x', nc_double, 1, xdimid2 );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end


status = mexnc ( 'attcopy', ncid1, varid1, 'test_double', ncid2, varid2 );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

[status] = mexnc ( 'enddef', ncid2 );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

[return_value, status] = mexnc ( 'get_att_double', ncid2, varid2, 'test_double' );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

if return_value ~= 3.14159
	err_msg = sprintf ( '%s:  ATTCOPY did not seem to work\n', mfilename, ncerr );
	error ( err_msg );
end





%
% try a bad ncid1
% Test 2:  Copy from a bad source ncid.  Should fail.
status = mexnc ( 'attcopy', -12, varid1, 'test_double', ncid2, varid2 );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  ATTCOPY succeeded with a bad 1st ncid\n', mfilename);
	error ( err_msg );
end





% Test 3:  Copy from a bad source varid.  Should fail.
status = mexnc ( 'attcopy', ncid1, -7, 'test_double', ncid2, varid2 );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  ATTCOPY succeeded with a bad 1st varid\n', mfilename);
	error ( err_msg );
end





% Test 4:  Copy to a bad destination ncid.  Should fail.
status = mexnc ( 'attcopy', ncid1, varid1, 'test_double', -12, varid2 );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  ATTCOPY succeeded with a bad 2nd ncid\n', mfilename);
	error ( err_msg );
end





% Test 5:  Copy to a bad destination varid.  Should fail.
status = mexnc ( 'attcopy', ncid1, varid1, 'test_double', ncid2, -12 );
if ( status >= 0 )
	err_msg = sprintf ( '%s:  ATTCOPY succeeded with a bad 2nd varid\n', mfilename );
	error ( err_msg );
end



status = mexnc ( 'close', ncid1 );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end

fprintf ( 1, 'ATTCOPY succeeded.\n' );

return

















