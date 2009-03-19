function test_ssnc2mat ( ncfile )
% TEST_SNC2MAT
% Relies upon nc_varput, nc_add_dimension, nc_addvar
%
% Tests
% Test 1:  netcdf file does not exist.
% Test 2:  try a pretty generic netcdf file

%
% Test 1:  netcdf file does not exist.
testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
matfile_name = [ ncfile '.mat' ];
status = snc2mat ( 'bad.nc', matfile_name );
if status >= 0
	format = '%s:  snc2mat succeeded with a bad netcdf file when it should have failed.\n';
	msg = sprintf ( format, mfilename);
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




%
% Test 2:  try a pretty generic netcdf file
testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
create_empty_file ( ncfile );
len_x = 4; len_y = 6;
nc_add_dimension ( ncfile, 'x', len_x );
nc_add_dimension ( ncfile, 'y', len_y );

clear varstruct;
varstruct.Name = 'z_double';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'y', 'x' };
nc_addvar ( ncfile, varstruct );




input_data = [1:1:len_y*len_x];
input_data = reshape ( input_data, len_y, len_x );

status = nc_varput ( ncfile, 'z_double', input_data );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_varput failed on z_double, file %s.\n', mfilename, ncfile );
	error ( msg );
end



matfile_name = [ ncfile '.mat' ];
status = snc2mat ( ncfile, matfile_name );
if status < 0
	msg = sprintf ( '%s:  snc2mat failed on file %s.\n', mfilename, ncfile );
	error ( msg );
end


%
% now check it
d = load ( matfile_name );
output_data = d.z_double.data;



d = max(abs(output_data-input_data))';
if (any(d))
	msg = sprintf ( '%s:  values written by NC2MAT do not match what was retrieved by LOAD\n', mfilename  );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





fprintf ( 1, 'NC2MAT succeeded\n' );

return







