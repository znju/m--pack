function test_inq ( ncfile )
% TEST_INQ
%
% Tests number of dimensions, variables, global attributes, record dimension for
% foo.nc.  Also tests helper routines, "nc_inq_ndims", "nc_inq_nvars", "nc_inq_ncatts".
%
% Tests bad ncid as well.
%
% Test 1:  Normal retrieval
% Test 2:  Bad ncid.
% Test 3:  Empty set ncid.
% Test 4:  Non numeric ncid
% Test 5:  INQ_NDIMS normal retrieval
% Test 6:  INQ_NDIMS Bad ncid.
% Test 7:  INQ_NDIMS Empty set ncid.
% Test 8:  INQ_NDIMS Non numeric ncid
% Test 9:  INQ_NVARS normal retrieval
% Test 10:  INQ_NVARS Bad ncid.
% Test 11:  INQ_NVARS Empty set ncid.
% Test 12:  INQ_NVARS Non numeric ncid
% Test 13:  INQ_NATTS normal retrieval
% Test 14:  INQ_NATTS Bad ncid.
% Test 15:  INQ_NATTS Empty set ncid.
% Test 16:  INQ_NATTS Non numeric ncid

error_condition = 0;



%
% Create a netcdf file with
[ncid, status] = mexnc ( 'create', ncfile, nc_clobber_mode );
if ( status < 0 )
	error ( 'CREATE failed' );
end


%
% DIMDEF
[xdimid, status] = mexnc ( 'def_dim', ncid, 'x', 20 );
if ( status < 0 )
	error ( 'DEF_DIM failed on X' );
end
[ydimid, status] = mexnc ( 'def_dim', ncid, 'y', 24 );
if ( status < 0 )
	error ( 'DEF_DIM failed on y' );
end
[zdimid, status] = mexnc ( 'def_dim', ncid, 'z', 32 );
if ( status < 0 )
	error ( 'DEF_DIM failed on z' );
end


%
% VARDEF
[xdvarid, status] = mexnc ( 'def_var', ncid, 'x_double', 'double', 1, xdimid );
if ( status < 0 )
	error ( 'DEF_VAR failed on x_double' );
end
[xmvarid, status] = mexnc ( 'def_var', ncid, 'xm_double', 'double', 3, [zdimid ydimid xdimid] );
if ( status < 0 )
	error ( 'DEF_VAR failed on xa_double' );
end
[xfvarid, status] = mexnc ( 'def_var', ncid, 'x_float', 'float', 1, xdimid );
if ( status  < 0 )
	error ( 'DEF_VAR failed on x_float' );
end
[xmvarid, status] = mexnc ( 'def_var', ncid, 'xm_float', 'float', 3, [zdimid ydimid xdimid] );
if ( status < 0 )
	error ( 'DEF_VAR failed on xm_float' );
end
[xlvarid, status] = mexnc ( 'def_var', ncid, 'x_long', 'long', 1, xdimid );
if ( status < 0 )
	error ( 'DEF_VAR failed on x_long' );
end
[xmvarid, status] = mexnc ( 'def_var', ncid, 'xm_int', 'long', 3, [zdimid ydimid xdimid] );
if ( status < 0 )
	error ( 'DEF_VAR failed on xm_int' );
end
[x_short_varid, status] = mexnc ( 'def_var', ncid, 'x_short', 'short', 1, xdimid );
if ( status < 0 )
	error ( 'DEF_VAR failed on x_short' );
end
[xmvarid, status] = mexnc ( 'def_var', ncid, 'xm_short', 'short', 3, [zdimid ydimid xdimid] );
if ( status < 0 )
	error ( 'DEF_VAR failed on xm_short' );
end
[x_byte_varid, status] = mexnc ( 'def_var', ncid, 'x_byte', 'byte', 1, xdimid );
if ( status < 0 )
	error ( 'DEF_VAR failed on x_byte' );
end
[xmvarid, status] = mexnc ( 'def_var', ncid, 'xm_byte', 'byte', 3, [zdimid ydimid xdimid] );
if ( status < 0 )
	error ( 'DEF_VAR failed on xm_byte' );
end
[x_char_varid, status] = mexnc ( 'def_var', ncid, 'x_char', 'char', 1, xdimid );
if ( status < 0 )
	error ( 'DEF_VAR failed on x_char' );
end
[xmvarid, status] = mexnc ( 'def_var', ncid, 'xm_char', 'char', 3, [zdimid ydimid xdimid] );
if ( status < 0 )
	error ( 'DEF_VAR failed on xm_double' );
end


%
% Define some attributes
attvalue = 'this is a test';
attlen = length(attvalue);
status = mexnc ( 'put_att_text', ncid, -1, 'test_global_attributes', 'char', attlen, attvalue );
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  put_att_double failed on global attribute, ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end


%
% ENDEF
[status] = mexnc ( 'enddef', ncid );
if ( status < 0 )
	error ( 'ENDEF failed with write' );
end




% Test 1:  Normal retrieval
testid = 'Test 1';
[ndims, nvars, natts, recdim, status] = mexnc('INQ', ncid);
if ( status ~= 0 )
	error ( 'INQ failed on nowrite' );
end

if ndims ~= 3
	msg = sprintf ( 'INQ returned %d dimensions when there should only have been 1\n', ndims );
	error ( msg );
end

if nvars ~= 12 
	msg = sprintf ( 'INQ returned %d variables when there should have been 12\n', nvars );
	error ( msg );
end

if natts ~= 1
	msg = sprintf ( 'INQ returned %d attributes when there should have been 1\n', natts );
	error ( msg );
end

if recdim ~= -1
	msg = sprintf ( 'INQ returned an unlimited dimension when there should not have been one\n' );
	error ( msg );
end

fprintf ( 1, 'INQ succeeded\n' );


% Test 2:  Bad ncid.
testid = 'Test 2';
[ndims, nvars, natts, recdim, status] = mexnc('INQ', -2000);
if ( status == 0 )
	err_msg = sprintf ( '%s:  %s:  Succeeded when it should have failed\n', mfilename, testid );
	error ( err_msg );
end




% Test 3:  Empty set ncid.
testid = 'Test 3';
try
	[ndims, nvars, natts, recdim, status] = mexnc('INQ', [] );
	error_condition = 1;
end
if error_condition == 1
	err_msg = sprintf ( '%s:  %s:  Succeeded when it should have failed\n', mfilename, testid );
	error ( err_msg );
end






% Test 4:  Non numeric ncid
testid = 'Test 4';
try
	[ndims, nvars, natts, recdim, status] = mexnc('INQ', 'blah' );
	error_condition = 1;
end
if error_condition == 1
	err_msg = sprintf ( '%s:  %s:  Succeeded when it should have failed\n', mfilename, testid );
	error ( err_msg );
end






% Test 5:  INQ_NDIMS Normal retrieval
testid = 'Test 1';
[ndims, status] = mexnc('INQ_NDIMS', ncid);
if ( status ~= 0 )
	msg = sprintf ( '%s:  %s:  ''%s''', mfilename, testid, mexnc ( 'strerror', status ) );
	error ( msg );
end

if ndims ~= 3
	msg = sprintf ( 'INQ_NDIMS returned %d dimensions when there should only have been 1\n', ndims );
	error ( msg );
end


% Test 6:  INQ_NDIMS Bad ncid.
testid = 'Test 6';
[ndims, status] = mexnc('INQ_NDIMS', -2000);
if ( status == 0 )
	msg = sprintf ( '%s:  %s:  ''%s''', mfilename, testid, mexnc ( 'strerror', status ) );
	error ( msg );
end




% Test 7:  INQ_NDIMS Empty set ncid.
testid = 'Test 7';
try
	[ndims, status] = mexnc('INQ_NDIMS', [] );
	error_condition = 1;
end
if error_condition == 1
	err_msg = sprintf ( '%s:  %s:  Succeeded when it should have failed\n', mfilename, testid );
	error ( err_msg );
end






% Test 8:  Non numeric ncid
testid = 'Test 8';
try
	[ndims, status] = mexnc('INQ_NDIMS', 'blah' );
	error_condition = 1;
end
if error_condition == 1
	err_msg = sprintf ( '%s:  %s:  Succeeded when it should have failed\n', mfilename, testid );
	error ( err_msg );
end







fprintf ( 1, 'INQ_NDIMS succeeded\n' );



% Test 9:  INQ_NVARS Normal retrieval
testid = 'Test 9';
[nvars, status] = mexnc('INQ_NVARS', ncid);
if ( status ~= 0 )
	msg = sprintf ( '%s:  %s:  ''%s''', mfilename, testid, mexnc ( 'strerror', status ) );
	error ( msg );
end

if nvars ~= 12 
	msg = sprintf ( 'INQ_NVARS returned %d dimensions when there should have been 12\n', nvars );
	error ( msg );
end


% Test 10:  INQ_NVARS Bad ncid.
testid = 'Test 10';
[nvars, status] = mexnc('INQ_NVARS', -2000);
if ( status == 0 )
	msg = sprintf ( '%s:  %s:  ''%s''', mfilename, testid, mexnc ( 'strerror', status ) );
	error ( msg );
end




% Test 11:  INQ_NVARS Empty set ncid.
testid = 'Test 11';
try
	[nvars, status] = mexnc('INQ_NVARS', [] );
	error_condition = 1;
end
if error_condition == 1
	err_msg = sprintf ( '%s:  %s:  Succeeded when it should have failed\n', mfilename, testid );
	error ( err_msg );
end






% Test 12:  Non numeric ncid
testid = 'Test 12';
try
	[nvars, status] = mexnc('INQ_NVARS', 'blah' );
	error_condition = 1;
end
if error_condition == 1
	err_msg = sprintf ( '%s:  %s:  Succeeded when it should have failed\n', mfilename, testid );
	error ( err_msg );
end







fprintf ( 1, 'INQ_NVARS succeeded\n' );





% Test 13:  INQ_NATTS Normal retrieval
testid = 'Test 13';
[natts, status] = mexnc('INQ_NATTS', ncid);
if ( status ~= 0 )
	msg = sprintf ( '%s:  %s:  ''%s''', mfilename, testid, mexnc ( 'strerror', status ) );
	error ( msg );
end

if natts ~= 1 
	msg = sprintf ( 'INQ_NATTS returned %d attributes when there should have been 1\n', natts );
	error ( msg );
end


% Test 14:  INQ_NATTS Bad ncid.
testid = 'Test 14';
[natts, status] = mexnc('INQ_NATTS', -2000);
if ( status == 0 )
	msg = sprintf ( '%s:  %s:  ''%s''', mfilename, testid, mexnc ( 'strerror', status ) );
	error ( msg );
end




% Test 15:  INQ_NATTS Empty set ncid.
testid = 'Test 15';
try
	[natts, status] = mexnc('INQ_NATTS', [] );
	error_condition = 1;
end
if error_condition == 1
	err_msg = sprintf ( '%s:  %s:  Succeeded when it should have failed\n', mfilename, testid );
	error ( err_msg );
end






% Test 16:  Non numeric ncid
testid = 'Test 16';
try
	[natts, status] = mexnc('INQ_NATTS', 'blah' );
	error_condition = 1;
end
if error_condition == 1
	err_msg = sprintf ( '%s:  %s:  Succeeded when it should have failed\n', mfilename, testid );
	error ( err_msg );
end







fprintf ( 1, 'INQ_NATTS succeeded\n' );





% INQ_NATTS
[natts, status] = mexnc('INQ_NATTS', ncid);
if ( status < 0 )
	ncerr = mexnc ( 'strerror', status );
	err_msg = sprintf ( '%s:  INQ_NVARS failed, ''%s''\n', mfilename, ncerr );
	error ( err_msg );
end
if natts ~= 1
	msg = sprintf ( 'INQ_NATTS returned %d attributes when there should have been 1\n', nvars );
	error ( msg );
end



%
% Try a bogus case
[natts, status] = mexnc('INQ_NATTS', -1);
if ( status >= 0 )
	error ( 'INQ_NATTS return status did not signal an error on bogus ncid case' );
end






status = mexnc ( 'close', ncid );
if ( status < 0 )
	error ( 'CLOSE failed on nowrite' );
end


fprintf ( 1, 'INQ_NATTS succeeded\n' );

return










