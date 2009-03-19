function test_nc_varput ( ncfile )
% TEST_NC_VARPUT:
%
% Relies upon nc_attput
%
% If all works as expected, you should NOT see any message like
%
%     ??? Error using ==> test_nc_varput
%
% If you do, because an exception was thrown, it will be at the 
% end of the output, so you don't have to go scrolling back thru
% all of it.
%
% Generic Tests
% Test a:  pass 0 arguments.
% Test b:  pass 1 arguments.
% Test c:  pass 2 arguments.
% Test d:  bad filename
% Test e:  bad varname
%
% put_var1
% Test 1:  write to a singleton variable and read it back.
% Test 1a:  write to a 1D variable with 3 input args.
% Test 1b:  write to a 1D variable with a bad start
% Test 1c:  write to a 1D variable with a bad count
% Test 1d:  write to a 1D variable with a good count
% Test 1e:  write to a 1D variable with a bad stride
% Test 1f:  write to a 1D variable with a good stride.
% Test 2:  write more than 1 datum to a singleton variable.  This should fail.
% Test 3:  write 1 datum to a singleton variable, bad start.  Should fail.
% Test 4:  write 1 datum to a singleton variable, bad count.  Should fail.
% Test 5:  write 1 datum to a singleton variable, give a stride.  Should fail.
%
% put_var
% Test 6:  using put_var, write all the data to a 2D dataset.
% Test 6a:  using put_vara, write a chunk of the data to a 2D dataset.
% Test 6b:  using put_vara, write a chunk of data to a 2D dataset.
% Test 6c:  using put_vars, write a chunk of data to a 2D dataset.
% Test 7:  write too much to a 2D dataset (using put_var).  Should fail.
% Test 8:  write too little to a 2D dataset (using put_var).  Should fail.
% Test 9:  use put_vara, write with a bad offset.  Should fail.
% Test 10:  use put_vars, write with a bad start.  Should fail.
% Test 11:  use put_vara, write with a bad count.  Should fail.
% Test 12:  use put_vars, write with a bad stride.  Should fail.
%
% Test 13:  test reading with scale factors, add offsets.
% Test 14:  test writing with scale factors, add offsets.
%
% 

%!ncgen -o test.nc test.cdl
create_test_file ( ncfile );

%
% Test a
disp ( 'Test a' );
status = nc_varput;
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test a when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test a succeeded' );


%
% Test b
disp ( 'Test b' );
status = nc_varput ( ncfile );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test b when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test b succeeded' );


%
% Test c
disp ( 'Test c' );
status = nc_varput ( ncfile, 'test_2d' );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test c when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test c succeeded' );



%
% Test d
disp ( 'Test d' );
status = nc_varput ( 'bad.nc', 'test_2d' );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test d when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test d succeeded' );



%
% Test e
disp ( 'Test e' );
status = nc_varput ( ncfile, 'bad', 5 );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test d when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test e succeeded' );




%
% Test1
disp ( 'Test 1' );
input_data = 3.14159;
status = nc_varput ( ncfile, 'test_singleton', input_data );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 1.\n', mfilename );
	error ( msg );
end
[output_data, status] = nc_varget ( ncfile, 'test_singleton' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 1.\n', mfilename );
	error ( msg );
end

ddiff = abs(input_data - output_data);
if any( find(ddiff > eps) )
	msg = sprintf ( '%s:  input data ~= output data in Test 1.\n', mfilename );
	error ( msg );
end
disp ( 'Test 1 succeeded' );



%
% Test1a
disp ( 'Test 1a' );
input_data = 3.14159;
status = nc_varput ( ncfile, 'test_1D', input_data );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput passed Test 1a when it should have failed.\n', mfilename );
	error ( msg );
end
disp ( 'Test 1a succeeded' );


%
% Test1b
disp ( 'Test 1b' );
input_data = 3.14159;
status = nc_varput ( ncfile, 'test_1D', input_data, 8 );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 1b when it should have failed.\n', mfilename );
	error ( msg );
end
disp ( 'Test 1b succeeded' );


%
% Test1c
disp ( 'Test 1c' );
input_data = 3.14159;
status = nc_varput ( ncfile, 'test_1D', input_data, 4, 2 );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 1c when it should have failed.\n', mfilename );
	error ( msg );
end
disp ( 'Test 1c succeeded' );




%
% Test1d
disp ( 'Test 1d' );
input_data = 3.14159;
status = nc_varput ( ncfile, 'test_1D', input_data, 0, 1 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 1d.\n', mfilename );
	error ( msg );
end
[output_data, status] = nc_varget ( ncfile, 'test_1D', 0, 1 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 1a.\n', mfilename );
	error ( msg );
end

ddiff = abs(input_data - output_data);
if any( find(ddiff > eps) )
	msg = sprintf ( '%s:  input data ~= output data in Test 1d.\n', mfilename );
	error ( msg );
end
disp ( 'Test 1d succeeded' );




%
% Test1e
disp ( 'Test 1e' );
input_data = [3.14159; 2];
status = nc_varput ( ncfile, 'test_1D', input_data, 0, 2, 8 );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 1e when it should have failed.\n', mfilename );
	error ( msg );
end
disp ( 'Test 1e succeeded' );




%
% Test1f
disp ( 'Test 1f' );
input_data = [3.14159; 2];
status = nc_varput ( ncfile, 'test_1D', input_data, 0, 2, 2 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 1f.\n', mfilename );
	error ( msg );
end
[output_data, status] = nc_varget ( ncfile, 'test_1D', 0, 2, 2 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 1f.\n', mfilename );
	error ( msg );
end

ddiff = abs(input_data - output_data);
if any( find(ddiff > eps) )
	msg = sprintf ( '%s:  input data ~= output data in Test 1f.\n', mfilename );
	error ( msg );
end
disp ( 'Test 1f succeeded' );





%
% Test2
disp ( 'Test 2' );
input_data = [3.14159 2];
status = nc_varput ( ncfile, 'test_singleton', input_data );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 2 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 2 succeeded' );



%
% Test3
disp ( 'Test 3' );
input_data = 3.14159;
status = nc_varput ( ncfile, 'test_singleton', input_data, 4, 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 3 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 3 succeeded' );



%
% Test4
disp ( 'Test 4' );
input_data = 3.14159;
status = nc_varput ( ncfile, 'test_singleton', input_data, 0, 2 );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 4 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 4 succeeded' );


%
% Test5
disp ( 'Test 5' );
input_data = 3.14159;
status = nc_varput ( ncfile, 'test_singleton', input_data, 0, 1, 1 );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 5 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 5 succeeded' );





%
% Test6
disp ( 'Test 6' );
input_data = [1:24];
input_data = reshape(input_data,6,4);
status = nc_varput ( ncfile, 'test_2D', input_data );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 6.\n', mfilename );
	error ( msg );
end
[output_data, status] = nc_varget ( ncfile, 'test_2D' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 6.\n', mfilename );
	error ( msg );
end

ddiff = abs(input_data - output_data);
if any( find(ddiff > eps) )
	msg = sprintf ( '%s:  input data ~= output data in Test 6.\n', mfilename );
	error ( msg );
end
disp ( 'Test 6 succeeded' );


%
% Test6a
disp ( 'Test 6a' );
input_data = [1:20];
input_data = reshape(input_data,5,4);
status = nc_varput ( ncfile, 'test_2D', input_data, [0 0], [5 4] );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 6a.\n', mfilename );
	error ( msg );
end
[output_data, status] = nc_varget ( ncfile, 'test_2D', [0 0], [5 4] );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 6a.\n', mfilename );
	error ( msg );
end

ddiff = abs(input_data - output_data);
if any( find(ddiff > eps) )
	msg = sprintf ( '%s:  input data ~= output data in Test 6a.\n', mfilename );
	error ( msg );
end
disp ( 'Test 6a succeeded' );


%
% Test6b
disp ( 'Test 6b' );
input_data = [1:20] - 5;
input_data = reshape(input_data,5,4);
status = nc_varput ( ncfile, 'test_2D', input_data, [1 0], [5 4] );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 6b.\n', mfilename );
	error ( msg );
end
[output_data, status] = nc_varget ( ncfile, 'test_2D', [1 0], [5 4] );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 6b.\n', mfilename );
	error ( msg );
end

ddiff = abs(input_data - output_data);
if any( find(ddiff > eps) )
	msg = sprintf ( '%s:  input data ~= output data in Test 6b.\n', mfilename );
	error ( msg );
end
disp ( 'Test 6b succeeded' );


%
% Test6c
disp ( 'Test 6c' );
input_data = [1:6];
input_data = reshape(input_data,3,2);
status = nc_varput ( ncfile, 'test_2D', input_data, [0 0], [3 2], [2 2] );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 6c.\n', mfilename );
	error ( msg );
end
[output_data, status] = nc_varget ( ncfile, 'test_2D', [0 0], [3 2], [2 2] );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 6c.\n', mfilename );
	error ( msg );
end

ddiff = abs(input_data - output_data);
if any( find(ddiff > eps) )
	msg = sprintf ( '%s:  input data ~= output data in Test 6c.\n', mfilename );
	error ( msg );
end
disp ( 'Test 6c succeeded' );



%
% Test7
disp ( 'Test 7' );
input_data = [1:28];
input_data = reshape(input_data,7,4);
status = nc_varput ( ncfile, 'test_2D', input_data );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 7 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 7 succeeded' );


%
% Test8
disp ( 'Test 8' );
input_data = [1:20];
input_data = reshape(input_data,5,4);
status = nc_varput ( ncfile, 'test_2D', input_data );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 8 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 8 succeeded' );

%
% Test9
disp ( 'Test 9' );
input_data = [1:24];
input_data = reshape(input_data,6,4);
status = nc_varput ( ncfile, 'test_2D', input_data, [1 1], [6 4] );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 9 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 9 succeeded' );


%
% Test10
disp ( 'Test 10' );
input_data = [1:24] + 3.14159;
input_data = reshape(input_data,6,4);
input_data = input_data(1:2:end,1:2:end);
status = nc_varput ( ncfile, 'test_2D', input_data, [2 2], [3 2], [2 2] );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 10 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 10 succeeded' );


%
% Test11
disp ( 'Test 11' );
input_data = [1:28] + 3.14159;
input_data = reshape(input_data,7,4);
status = nc_varput ( ncfile, 'test_2D', input_data, [0 0], [7 4] );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 11 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 11 succeeded' );


%
% Test12
disp ( 'Test 12' );
input_data = [1:24] + 3.14159;
input_data = reshape(input_data,6,4);
input_data = input_data(1:2:end,1:2:end);
status = nc_varput ( ncfile, 'test_2D', input_data, [0 0], [3 2], [3 3] );
if ( status >= 0 )
	msg = sprintf ( '%s:  nc_varput succeeded in Test 12 when it should not have.\n', mfilename );
	error ( msg );
end
disp ( 'Test 12 succeeded' );


%
% Test13
% Write some data, then put a scale factor of 2 and add offset of 1.  The
% data read back should be twice as large plus 1.
create_test_file ( ncfile );
disp ( 'Test 13' );
input_data = [1:24];
input_data = reshape(input_data,6,4);
status = nc_varput ( ncfile, 'test_2D', input_data );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 13.\n', mfilename );
	error ( msg );
end
status = nc_attput ( ncfile, 'test_2D', 'scale_factor', 2.0 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed in Test 13.\n', mfilename );
	error ( msg );
end
status = nc_attput ( ncfile, 'test_2D', 'add_offset', 1.0 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed in Test 13.\n', mfilename );
	error ( msg );
end
[output_data, status] = nc_varget ( ncfile, 'test_2D' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varget failed in Test 13.\n', mfilename );
	error ( msg );
end
ddiff = abs(input_data - (output_data-1)/2);
if any( find(ddiff > eps) )
	msg = sprintf ( '%s:  input data ~= output data in Test 13.\n', mfilename );
	error ( msg );
end
disp ( 'Test 13 succeeded' );





%
% Test14
% Put a scale factor of 2 and add offset of 1.
% Write some data, 
% Put a scale factor of 4 and add offset of 2.
% data read back should be twice as large 
create_test_file ( ncfile );
disp ( 'Test 14' );
input_data = [1:24];
input_data = reshape(input_data,6,4);
status = nc_attput ( ncfile, 'test_2D', 'scale_factor', 2.0 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed in Test 14.\n', mfilename );
	error ( msg );
end
status = nc_attput ( ncfile, 'test_2D', 'add_offset', 1.0 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed in Test 14.\n', mfilename );
	error ( msg );
end
status = nc_varput ( ncfile, 'test_2D', input_data );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed in Test 14.\n', mfilename );
	error ( msg );
end
status = nc_attput ( ncfile, 'test_2D', 'scale_factor', 4.0 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed in Test l4.\n', mfilename );
	error ( msg );
end
status = nc_attput ( ncfile, 'test_2D', 'add_offset', 2.0 );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_attput failed in Test 14.\n', mfilename );
	error ( msg );
end
[output_data, status] = nc_varget ( ncfile, 'test_2D' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varget failed in Test 14.\n', mfilename );
	error ( msg );
end
ddiff = abs(input_data - (output_data)/2);
if any( find(ddiff > eps) )
	msg = sprintf ( '%s:  input data ~= output data in Test 14.\n', mfilename );
	error ( msg );
end
disp ( 'Test 14 succeeded' );







function create_test_file ( ncfile, arg2 )

%
% ok, first create the first file
[ncid_1, status] = mexnc ( 'create', ncfile, nc_clobber_mode );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''create'' failed, error message '' %s ''\n', mfilename, ncerr_msg );
	error ( msg );
end


%
% Create a fixed dimension.  
len_x = 4;
[xdimid, status] = mexnc ( 'def_dim', ncid_1, 'x', len_x );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim x, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end

%
% Create a fixed dimension.  
len_y = 6;
[ydimid, status] = mexnc ( 'def_dim', ncid_1, 'y', len_y );
if ( status ~= 0 )
	ncerr_msg = mexnc ( 'strerror', status );
	msg = sprintf ( '%s:  ''def_dim'' failed on dim y, file %s, error message '' %s ''\n', mfilename, ncfile, ncerr_msg );
	error ( msg );
end


%
% CLOSE
status = mexnc ( 'close', ncid_1 );
if ( status ~= 0 )
	error ( 'CLOSE failed' );
end

%
% Add a singleton
varstruct.Name = 'test_singleton';
varstruct.Nctype = 'double';
varstruct.Dimension = [];

nc_addvar ( ncfile, varstruct );


clear varstruct;
varstruct.Name = 'test_1D';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'y' };

nc_addvar ( ncfile, varstruct );


clear varstruct;
varstruct.Name = 'test_2D';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'y', 'x' };

nc_addvar ( ncfile, varstruct );


clear varstruct;
varstruct.Name = 'test_var3';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };

nc_addvar ( ncfile, varstruct );
return


