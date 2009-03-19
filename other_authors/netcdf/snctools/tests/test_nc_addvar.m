function test_nc_addvar ( ncfile )
% TEST_NC_ADDVAR
%
% Relies upon nc_getvarinfo.
%
% Need to have more tests
% Test 1:  no inputs
% test 2:  too many inputs
% test 3:  first input not a netcdf file
% test 4:  2nd input not character
% test 5:  3rd input not numeric
% test 6:  Add a double variable, no dimensions
% test 7:  Add a float variable
% test 8:  Add a int32 variable
% test 9:  Add a int16 variable
% test 10:  Add a byte variable
% test 11:  Add a char variable
% test 12:  Add a variable with a named fixed dimension.
% test 13:  Add a variable with a named unlimited dimension.
% test 14:  Add a variable with a named unlimited dimension and named fixed dimension.
% test 15:  Add a variable with attribute structures.
% test 17:  Add a variable with a numeric Nctype

% test 1:  no input arguments
testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );






% test 2:  too many inputs
testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'test_var';
try
	[status] = nc_addvar ( ncfile, varstruct );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );










% test 3:  first input not a netcdf file
testid = 'Test 3';
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'test_var';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( '/dev/null', varstruct );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );






% test 4:  2nd input not character
testid = 'Test 4';
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'test_var';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, 5 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% test 5:  No name provided in varstruct
testid = 'Test 5';
create_empty_file ( ncfile );
clear varstruct;
varstruct = struct([]);
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% test 6:  Add a double variable, no dimensions
testid = 'Test 6';
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_DOUBLE' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( v.Size ~= 1 ) 
	msg = sprintf ( '%s:  %s:  data size was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( ~isempty(v.Dimension) ) 
	msg = sprintf ( '%s:  %s:  dimensions were wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );






% test 7:  Add a float variable
testid = 'Test 7';
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'float';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_FLOAT' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );






% test 8:  Add a int32 variable
testid = 'Test 8';
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'int';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_INT' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );






% test 9:  Add a int16 variable
testid = 'Test 9';
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'short';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_SHORT' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );






% test 10:  Add a byte variable
testid = 'Test 10';
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'byte';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_BYTE' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );






% test 11:  Add a char variable
testid = 'Test 11';
create_empty_file ( ncfile );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'char';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_CHAR' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );






% test 12:  Add a variable with a named fixed dimension.
testid = 'Test 12';
create_empty_file ( ncfile );
nc_add_dimension ( ncfile, 'x', 5 );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_DOUBLE' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end
if any(v.Size - 5)
	msg = sprintf ( '%s:  %s:  variable size was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length(v.Dimension) ~= 1 ) 
	msg = sprintf ( '%s:  %s:  dimensions were wrong.\n', mfilename, testid );
	error ( msg );
end
if ( ~strcmp(v.Dimension{1}, 'x' ) ) 
	msg = sprintf ( '%s:  %s:  dimensions were wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );






% test 13:  Add a variable with a named unlimited dimension.
testid = 'Test 13';
create_empty_file ( ncfile );
nc_add_dimension ( ncfile, 'x', 0 );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_DOUBLE' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end
if (v.Size ~= 0)
	msg = sprintf ( '%s:  %s:  variable size was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( ~v.IsUnlimitedVariable)
	msg = sprintf ( '%s:  %s:  unlimited classifaction was wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );





% test 14:  Add a variable with a named unlimited dimension and named fixed dimension.
testid = 'Test 14';
create_empty_file ( ncfile );
nc_add_dimension ( ncfile, 'x', 0 );
nc_add_dimension ( ncfile, 'y', 5 );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x', 'y' };
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_DOUBLE' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end
if (v.Size(1) ~= 0) & (v.Size(2) ~= 5 )
	msg = sprintf ( '%s:  %s:  variable size was wrong.\n', mfilename, testid );
	error ( msg );
end
if (v.Rank ~= 2 )
	msg = sprintf ( '%s:  %s:  variable rank was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( ~v.IsUnlimitedVariable)
	msg = sprintf ( '%s:  %s:  unlimited classifaction was wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );





% test 15:  Add a variable with attribute structures.
testid = 'Test 15';
create_empty_file ( ncfile );
nc_add_dimension ( ncfile, 'x', 0 );
nc_add_dimension ( ncfile, 'y', 5 );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };
varstruct.Attribute(1).Name = 'test';
varstruct.Attribute(1).Value = 'blah';
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_DOUBLE' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end
if (v.Size(1) ~= 0) & (v.Size(2) ~= 5 )
	msg = sprintf ( '%s:  %s:  variable size was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( ~v.IsUnlimitedVariable)
	msg = sprintf ( '%s:  %s:  unlimited classifaction was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length(v.Attribute) ~= 1)
	msg = sprintf ( '%s:  %s:  number of attributes was wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );



% test 17:  Add a variable with a numeric Nctype
testid = 'Test 17';
create_empty_file ( ncfile );
nc_add_dimension ( ncfile, 'x', 5 );
clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 6;
varstruct.Dimension = { 'x' };
fprintf ( 1, '%s.\n', testid );
[status] = nc_addvar ( ncfile, varstruct );
if ( status < 0 )
	msg = sprintf ( '%s:  %s: failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

[v,s] = nc_getvarinfo ( ncfile, 'x' );
if ~strcmp(nc_datatype_string(v.Nctype),'NC_DOUBLE' )
	msg = sprintf ( '%s:  %s:  data type was wrong.\n', mfilename, testid );
	error ( msg );
end
if any(v.Size - 5)
	msg = sprintf ( '%s:  %s:  variable size was wrong.\n', mfilename, testid );
	error ( msg );
end
if ( length(v.Dimension) ~= 1 ) 
	msg = sprintf ( '%s:  %s:  dimensions were wrong.\n', mfilename, testid );
	error ( msg );
end
if ( ~strcmp(v.Dimension{1}, 'x' ) ) 
	msg = sprintf ( '%s:  %s:  dimensions were wrong.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );









fprintf ( 1, 'NC_ADDVAR succeeded\n' );

return








