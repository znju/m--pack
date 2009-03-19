function test_nc_attget ( ncfile )
% TEST_NC_ATTGET
%
% Tests run include
%
% 1.  write/retrieve a double attribute
% 2.  write/retrieve a float attribute
% 3.  write/retrieve a int attribute
% 4.  write/retrieve a short int attribute
% 5.  write/retrieve a uint8 attribute
% 6.  write/retrieve a int8 attribute
% 7.  write/retrieve a text attribute
% 8.  write/retrieve a global attribute, using '' as the variable name.
% 9.  write/retrieve a global attribute, using -1 as the variable name.
% 10.  write/retrieve a global attribute, using nc_global as the variable name.
% 11.  write/retrieve a global attribute, using 'GLOBAL' as the variable name.
% 12.  Try to retrieve a non existing attribute, should fail

[version_num, release_name, release_date] = mexnc ( 'get_mexnc_info' );

fprintf ( 1, 'Testing NC_ATTGET, NC_ATTPUT...\n' );
%
% ok, first create this baby.
[ncid, status] = mexnc ( 'create', ncfile, nc_clobber_mode );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''create'' failed, error message '' %s ''\n', mfilename, ncerr_msg );
	error ( msg );
end



%
% Create a fixed dimension.  
len_x = 4;
[xdimid, status] = mexnc ( 'def_dim', ncid, 'x', len_x );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim x, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end


len_y = 6;
[ydimid, status] = mexnc ( 'def_dim', ncid, 'y', len_y );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim y, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end


[xvarid, status] = mexnc ( 'def_var', ncid, 'x_db', 'NC_DOUBLE', 2, [ydimid xdimid] );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_var'' failed on var x_short, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end


[zvarid, status] = mexnc ( 'def_var', ncid, 'z_double', 'NC_DOUBLE', 2, [ydimid xdimid] );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_var'' failed on var x_short, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end

%
% Define attributes for all datatypes for x_db, but not z_double
% The short int attribute will have length 2
status = mexnc ( 'put_att_double', ncid, xvarid, 'test_double_att', nc_double, 1, 3.14159 );
if ( status < 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  put_att_double failed, ''%s''\n', mfilename, ncerr_msg );
	error ( msg );
end
status = mexnc ( 'put_att_float', ncid, xvarid, 'test_float_att', nc_float, 1, single(3.14159) );
if ( status < 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  put_att_double failed, ''%s''\n', mfilename, ncerr_msg );
	error ( msg );
end
status = mexnc ( 'put_att_int', ncid, xvarid, 'test_int_att', nc_int, 1, int32(3) );
if ( status < 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  put_att_double failed, ''%s''\n', mfilename, ncerr_msg );
	error ( msg );
end
status = mexnc ( 'put_att_short', ncid, xvarid, 'test_short_att', nc_short, 2, int16([5 7]) );
if ( status < 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  put_att_double failed, ''%s''\n', mfilename, ncerr_msg );
	error ( msg );
end
status = mexnc ( 'put_att_uchar', ncid, xvarid, 'test_uchar_att', nc_byte, 1, uint8(100) );
if ( status < 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  put_att_double failed, ''%s''\n', mfilename, ncerr_msg );
	error ( msg );
end
status = mexnc ( 'put_att_schar', ncid, xvarid, 'test_schar_att', nc_byte, 1, int8(-100) );
if ( status < 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  put_att_double failed, ''%s''\n', mfilename, ncerr_msg );
	error ( msg );
end
status = mexnc ( 'put_att_text', ncid, xvarid, 'test_text_att', nc_char, 26, 'abcdefghijklmnopqrstuvwxyz' );
if ( status < 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  put_att_double failed, ''%s''\n', mfilename, ncerr_msg );
	error ( msg );
end
status = mexnc ( 'put_att_double', ncid, nc_global, 'test_double_att', nc_double, 1, 3.14159 );
if ( status < 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  put_att_double failed, ''%s''\n', mfilename, ncerr_msg );
	error ( msg );
end




[status] = mexnc ( 'end_def', ncid );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''end_def'' failed, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end


%
% CLOSE
status = mexnc ( 'close', ncid );
if ( status ~= 0 )
	error ( 'CLOSE failed' );
end



%
% Test 1
test_id = 'Test 1';
[attvalue, status] = nc_attget ( ncfile, 'x_db', 'test_double_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'double' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not double.\n', mfilename );
	error ( msg );
end
if ( attvalue ~= 3.14159 )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 2
test_id = 'Test 2';
[attvalue, status] = nc_attget ( ncfile, 'x_db', 'test_float_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'single' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not single.\n', mfilename );
	error ( msg );
end
if ( attvalue ~= single(3.14159) )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 3
test_id = 'Test 3';
[attvalue, status] = nc_attget ( ncfile, 'x_db', 'test_int_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'int32' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not int32.\n', mfilename );
	error ( msg );
end
if ( attvalue ~= int32(3) )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 4
test_id = 'Test 4';
[attvalue, status] = nc_attget ( ncfile, 'x_db', 'test_short_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'int16' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not int16.\n', mfilename );
	error ( msg );
end
if ( length(attvalue) ~= 2 )
	msg = sprintf ( '%s:  retrieved attribute length differs from what was written.\n', mfilename );
	error ( msg );
end
if ( any(double(attvalue) - [5 7])  )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );






%
% Test 5
test_id = 'Test 5';
[attvalue, status] = nc_attget ( ncfile, 'x_db', 'test_uchar_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'int8' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not int8.\n', mfilename );
	error ( msg );
end
if ( uint8(attvalue) ~= uint8(100) )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 6
test_id = 'Test 6';
[attvalue, status] = nc_attget ( ncfile, 'x_db', 'test_schar_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'int8' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not int8.\n', mfilename );
	error ( msg );
end
if ( attvalue ~= int8(-100) )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 7
% 7.  write/retrieve a text attribute
test_id = 'Test 7';
[attvalue, status] = nc_attget ( ncfile, 'x_db', 'test_text_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'char' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not char.\n', mfilename );
	error ( msg );
end
%
% There was a bug up to version 2.0.10 that had a null character tacked onto 
% the end of each returned character attribute.
switch ( release_name )
case { 'MEXNC 2.0.6', 'MEXNC 2.0.9' }
	if ( ~strncmp(attvalue,'abcdefghijklmnopqrstuvwxyz', 26) )
		msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
		error ( msg );
	end
	fprintf ( 1, '********************************************************************\n' );
	fprintf ( 1, '*                                                                  *\n' );
	fprintf ( 1, '* WARNING WARNING WARNING                                          *\n' );
	fprintf ( 1, '*                                                                  *\n' );
	fprintf ( 1, '* MEXNC releases prior to 2.0.10 have a bug where a null character *\n' );
	fprintf ( 1, '* gets tacked onto the end of each character attribute read from   *\n' );
	fprintf ( 1, '* a netcdf file.  Your version is ''%s''                    *\n', release_name );
	fprintf ( 1, '*                                                                  *\n' );
	fprintf ( 1, '* Compensating for this bug, this particular test succeeds.        *\n' );
	fprintf ( 1, '* Please hit any key to continue.                                  *\n' );
	fprintf ( 1, '*                                                                  *\n' );
	fprintf ( 1, '********************************************************************\n' );
	pause;


otherwise
	if ( ~strcmp(attvalue,'abcdefghijklmnopqrstuvwxyz') )
		msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
		error ( msg );
	end
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 8
test_id = 'Test 8';
[attvalue, status] = nc_attget ( ncfile, '', 'test_double_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'double' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not double.\n', mfilename );
	error ( msg );
end
if ( attvalue ~= 3.14159 )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 9
test_id = 'Test 9';
[attvalue, status] = nc_attget ( ncfile, -1, 'test_double_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'double' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not double.\n', mfilename );
	error ( msg );
end
if ( attvalue ~= 3.14159 )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 10 
test_id = 'Test 10';
[attvalue, status] = nc_attget ( ncfile, nc_global, 'test_double_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'double' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not double.\n', mfilename );
	error ( msg );
end
if ( attvalue ~= 3.14159 )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 11 
test_id = 'Test 11';
[attvalue, status] = nc_attget ( ncfile, 'GLOBAL', 'test_double_att' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attget failed.\n', mfilename );
	error ( msg );
end
if ( ~strcmp(class(attvalue), 'double' ) )
	msg = sprintf ( '%s:  class of retrieved attribute was not double.\n', mfilename );
	error ( msg );
end
if ( attvalue ~= 3.14159 )
	msg = sprintf ( '%s:  %s:  retrieved attribute differs from what was written.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );





%
% Test 12 
test_id = 'Test 12';
[attvalue, status] = nc_attget ( ncfile, 'z_double', 'test_double_att' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s:  nc_attget succeeded when it should have failed.\n', mfilename, test_id );
	error ( msg );
end
fprintf ( 1, '%s succeeded\n', test_id );







fprintf ( 1, 'NC_ATTGET succeeded\n' );
fprintf ( 1, 'NC_ATTPUT succeeded\n' );

return








