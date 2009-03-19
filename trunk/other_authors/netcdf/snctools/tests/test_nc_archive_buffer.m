function test_nc_archive_buffer ( ncfile )
% TEST_NC_ADDNEWRECS
%
% Relies upon nc_addvar, nc_getvarinfo
%
% Test run include
%    1.  No inputs, should fail.
%    2.  One inputs, should fail.
%    3.  Two inputs, 2nd is not a structure, should fail.
%    4.  Two inputs, 2nd is an empty structure, should fail.
%    5.  Two inputs, 2nd is a structure with bad variable names, should fail.
%    6.  Three inputs, 3rd is non existant unlimited dimension.
%    7.  Two inputs, write to two variables, should succeed.
%    8.  Two inputs, write to two variables, one of them not unlimited, should fail.
%    9.  Try to write to a file with no unlimited dimension.
%   10.  Do two successive writes.  Should succeed.
%   10.  Do two successive writes, but on the 2nd write let the coordinate
%        variable overlap with the previous write.  Should still succeed,
%        but fewer datums will be written out.


fprintf ( '%s:  starting tests.\n' );

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


len_t = 0;
[ydimid, status] = mexnc ( 'def_dim', ncid, 'time', 0 );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim time, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end





%
% CLOSE
status = mexnc ( 'close', ncid );
if ( status ~= 0 )
	error ( 'CLOSE failed' );
end

%
% Add a variable along the time dimension
varstruct.Name = 'test_var';
varstruct.Nctype = 'float';
varstruct.Dimension = { 'time' };
varstruct.Attributes(1).Name = 'long_name';
varstruct.Attributes(1).Value = 'This is a test';
varstruct.Attributes(2).Name = 'short_val';
varstruct.Attributes(2).Value = int16(5);

nc_addvar ( ncfile, varstruct );


clear varstruct;
varstruct.Name = 'test_var2';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'time' };

nc_addvar ( ncfile, varstruct );


clear varstruct;
varstruct.Name = 'time';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'time' };

nc_addvar ( ncfile, varstruct );


clear varstruct;
varstruct.Name = 'test_var3';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };

nc_addvar ( ncfile, varstruct );



%
% Try no inputs
test_id = 'Test 1';
[nb, status] = nc_archive_buffer;
if ( status >= 0 )
	error ( [ test_id ':' ' nc_archive_buffer succeeded on no inputs, should have failed'] );
end
fprintf ( '%s:  passed\n', test_id );




%
% Try one inputs
test_id = 'Test 2';
[nb, status] = nc_archive_buffer ( [] );
if ( status >= 0 )
	error ( 'nc_archive_buffer succeeded on one input, should have failed' );
end
fprintf ( '%s:  passed\n', test_id );



%
% Try with 2nd input that isn't a structure.
test_id = 'Test 3';
[nb, status] = nc_archive_buffer ( [], ncfile );
if ( status >= 0 )
	error ( 'nc_archive_buffer succeeded on one input, should have failed' );
end
fprintf ( '%s:  passed\n', test_id );



%
% Try with 2nd input that is an empty structure.
test_id = 'Test 4';
[nb, status] = nc_archive_buffer ( struct([]), ncfile );
if ( status >= 0 )
	error ( 'nc_archive_buffer succeeded on empty structure, should have failed' );
end
fprintf ( '%s:  passed\n', test_id );



%
% Try a structure with bad names
test_id = 'Test 5';
input_data.a = [3 4];
input_data.b = [5 6];
[nb, status] = nc_archive_buffer ( input_data, ncfile );
if ( status >= 0 )
	error ( 'nc_archive_buffer succeeded on a structure with bad names, should have failed' );
end
fprintf ( '%s:  passed\n', test_id );



%
% Try good data with a bad record variable name
test_id = 'Test 6';
input_data.test_var = [3 4]';
input_data.test_var2 = [5 6]';
[nd, status] = nc_archive_buffer ( input_data, ncfile, 'bad_time' );
if ( status >= 0 )
	error ( 'nc_archive_buffer succeeded with a badly named record variable, should have failed' );
end
fprintf ( '%s:  passed\n', test_id );




%
% Try a good test.
test_id = 'Test 7';
before = nc_getvarinfo ( ncfile, 'test_var2' );


clear input_buffer;
input_buffer.test_var = single([3 4 5]');
input_buffer.test_var2 = [3 4 5]';
input_buffer.time = [1 2 3]';

[new_data, status] = nc_archive_buffer ( input_buffer, ncfile, 'time' );
if ( status < 0 )
	error ( 'nc_archive_buffer failed' );
end

after = nc_getvarinfo ( ncfile, 'test_var2' );
if ( (after.Size - before.Size) ~= 3 )
	error ( 'nc_archive_buffer failed to add the right number of records.' );
end
fprintf ( '%s:  passed\n', test_id );




%
% Try writing to a fixed size variable
test_id = 'Test 8';


input_buffer.test_var = single([3 4 5]');
input_buffer.test_var2 = [3 4 5]';
input_buffer.test_var3 = [3 4 5]';

status = nc_archive_buffer ( input_buffer, ncfile );
if ( status >= 0 )
	error ( 'nc_archive_buffer succeeded on writing to a fixed size variable, should have failed.' );
end

fprintf ( '%s:  passed\n', test_id );







test_id = 'Test 9';
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


%
% CLOSE
status = mexnc ( 'close', ncid );
if ( status ~= 0 )
	error ( 'CLOSE failed' );
end

clear varstruct;
varstruct.Name = 'test_var3';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };

nc_addvar ( ncfile, varstruct );


input_buffer.time = [1 2 3]';
[nb, status] = nc_archive_buffer ( input_buffer,  ncfile );
if ( status >= 0 )
	error ( 'nc_archive_buffer passed when writing to a file with no unlimited dimension' );
end
fprintf ( '%s:  passed\n', test_id );








test_id = 'Test 10';
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


len_t = 0;
[ydimid, status] = mexnc ( 'def_dim', ncid, 'time', 0 );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim time, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end





%
% CLOSE
status = mexnc ( 'close', ncid );
if ( status ~= 0 )
	error ( 'CLOSE failed' );
end

clear varstruct;
varstruct.Name = 'time';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'time' };
nc_addvar ( ncfile, varstruct );




before = nc_getvarinfo ( ncfile, 'time' );

clear input_buffer;
input_buffer.time = [1 2 3]';


[new_data, status] = nc_archive_buffer ( input_buffer, ncfile );
if ( status < 0 )
	error ( 'nc_archive_buffer failed' );
end
input_buffer.time = [4 5 6]';
[new_data, status] = nc_archive_buffer ( input_buffer, ncfile );
if ( status < 0 )
	error ( 'nc_archive_buffer failed' );
end

after = nc_getvarinfo ( ncfile, 'time' );
if ( (after.Size - before.Size) ~= 6 )
	error ( 'nc_archive_buffer failed to add the right number of records.' );
end
fprintf ( '%s:  passed\n', test_id );








test_id = 'Test 11';
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


len_t = 0;
[ydimid, status] = mexnc ( 'def_dim', ncid, 'time', 0 );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim time, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end





%
% CLOSE
status = mexnc ( 'close', ncid );
if ( status ~= 0 )
	error ( 'CLOSE failed' );
end

clear varstruct;
varstruct.Name = 'time';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'time' };
nc_addvar ( ncfile, varstruct );




before = nc_getvarinfo ( ncfile, 'time' );

clear input_buffer;
input_buffer.time = [1 2 3]';


[new_data, status] = nc_archive_buffer ( input_buffer, ncfile );
if ( status < 0 )
	error ( 'nc_archive_buffer failed' );
end
input_buffer.time = [3 4 5]';
[new_data, status] = nc_archive_buffer ( input_buffer, ncfile );
if ( status < 0 )
	error ( 'nc_archive_buffer failed' );
end

after = nc_getvarinfo ( ncfile, 'time' );
if ( (after.Size - before.Size) ~= 5 )
	error ( 'nc_archive_buffer failed to add the right number of records.' );
end
fprintf ( '%s:  passed\n', test_id );


fprintf ( 1, 'NC_ARCHIVE_BUFFER succeeded\n' );

return








