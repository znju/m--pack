function test_nc_getvarinfo ( ncfile )
% TEST_NC_GETVARINFO:
%
% Depends upon nc_add_dimension, nc_addvar
%
% 1st set of tests should fail
% test 1:  no input arguments, should fail
% test 2:  one input
% test 3:  too many inputs
% test 4:  2 inputs, 1st is not a netcdf file
% test 5:  2 inputs, 2nd is not a netcdf variable
% test 6:  2 inputs, 1st is character, 2nd is numeric
% test 7:  2 inputs, 2nd is character, 1st is numeric
%
% 2nd set of tests should succeed
% test 8:  empty netcdf variable with no data or attributes
% test 9:  empty netcdf variable (unlimited) with no data or attributes
% test 10:  singleton netcdf variable 
% test 11:  1d netcdf variable with data and attributes
% test 12:  2d netcdf variable with data and attributes


fprintf ( 1, '%s:  starting...\n', upper ( mfilename ) );

create_empty_file ( ncfile );



testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getvarinfo;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 2';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getvarinfo ( ncfile );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 3';
fprintf ( 1, '%s.\n', testid );
try
	[nb, status] = nc_getvarinfo ( ncfile, 't1' );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 4';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getvarinfo ( '/dev/null', 't1' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




%
% make all the variable definitions.
status = nc_add_dimension ( ncfile, 'ocean_time', 0 );
status = nc_add_dimension ( ncfile, 'x', 2 );
status = nc_add_dimension ( ncfile, 'y', 6 );

clear varstruct;
varstruct.Name = 'x';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'x' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 'ocean_time';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't1';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't2';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
varstruct.Attribute(1).Name = 'test_att';
varstruct.Attribute(1).Value = 'dud';
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 't3';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'ocean_time' };
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 'y';
varstruct.Nctype = 'double';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );

clear varstruct;
varstruct.Name = 'z';
varstruct.Nctype = 'double';
varstruct.Dimension = { 'y', 'x' };
nc_addvar ( ncfile, varstruct );




testid = 'Test 5';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getvarinfo ( ncfile, 't5' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 6';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getvarinfo ( ncfile, 0 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 7';
fprintf ( 1, '%s.\n', testid );
[nb, status] = nc_getvarinfo ( 0, 't1' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 8';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_getvarinfo ( ncfile, 'x' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

if ~strcmp(v.Name, 'x' )
	msg = sprintf ( '%s:  %s:  Name was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Nctype~=6 )
	msg = sprintf ( '%s:  %s:  Nctype was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Varid~=0 )
	msg = sprintf ( '%s:  %s:  Varid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.IsUnlimitedVariable~=0 )
	msg = sprintf ( '%s:  %s:  IsUnlimitedVariable was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Dimension)~=1 )
	msg = sprintf ( '%s:  %s:  Dimension was not correct.\n', mfilename, testid );
	error ( msg );
end
if ( ~strcmp(v.Dimension{1},'x') )
	msg = sprintf ( '%s:  %s:  Dimension was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Size~=2 )
	msg = sprintf ( '%s:  %s:  Size was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Dimid~=1 )
	msg = sprintf ( '%s:  %s:  Dimid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Rank~=1 )
	msg = sprintf ( '%s:  %s:  Rank was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Attribute)~=0 )
	msg = sprintf ( '%s:  %s:  Attribute was not correct.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 9';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_getvarinfo ( ncfile, 't1' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

if ~strcmp(v.Name, 't1' )
	msg = sprintf ( '%s:  %s:  Name was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Nctype~=6 )
	msg = sprintf ( '%s:  %s:  Nctype was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Varid~=2 )
	msg = sprintf ( '%s:  %s:  Varid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.IsUnlimitedVariable~=1 )
	msg = sprintf ( '%s:  %s:  IsUnlimitedVariable was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Dimension)~=1 )
	msg = sprintf ( '%s:  %s:  Dimension was not correct.\n', mfilename, testid );
	error ( msg );
end
if ( ~strcmp(v.Dimension{1},'ocean_time') )
	msg = sprintf ( '%s:  %s:  Dimension was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Size~=0 )
	msg = sprintf ( '%s:  %s:  Size was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Dimid~=0 )
	msg = sprintf ( '%s:  %s:  Dimid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Rank~=1 )
	msg = sprintf ( '%s:  %s:  Rank was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Attribute)~=0 )
	msg = sprintf ( '%s:  %s:  Attribute was not correct.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 10';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_getvarinfo ( ncfile, 'y' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

if ~strcmp(v.Name, 'y' )
	msg = sprintf ( '%s:  %s:  Name was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Nctype~=6 )
	msg = sprintf ( '%s:  %s:  Nctype was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Varid~=5 )
	msg = sprintf ( '%s:  %s:  Varid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.IsUnlimitedVariable~=0 )
	msg = sprintf ( '%s:  %s:  IsUnlimitedVariable was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Dimension)~=0 )
	msg = sprintf ( '%s:  %s:  Dimension was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Size~=1 )
	msg = sprintf ( '%s:  %s:  Size was not correct.\n', mfilename, testid );
	error ( msg );
end
if ( ~isempty(v.Dimid) )
	msg = sprintf ( '%s:  %s:  Dimid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Rank~=1 )
	msg = sprintf ( '%s:  %s:  Rank was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Attribute)~=0 )
	msg = sprintf ( '%s:  %s:  Attribute was not correct.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );





%
% write ten records
x = [0:9]';
b.ocean_time = x;
b.t1 = x;
b.t2 = 1./(1+x);
b.t3 = x.^2;
[nb,status] = nc_addnewrecs ( ncfile, b, 'ocean_time' );
if ( status < 0 )
	msg = sprintf ( '%s:  nc_addnewrecs failed on %s.\n', mfilename, ncfile );
	error ( msg );
end


testid = 'Test 11';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_getvarinfo ( ncfile, 't2' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

if ~strcmp(v.Name, 't2' )
	msg = sprintf ( '%s:  %s:  Name was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Nctype~=6 )
	msg = sprintf ( '%s:  %s:  Nctype was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Varid~=3 )
	msg = sprintf ( '%s:  %s:  Varid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.IsUnlimitedVariable~=1 )
	msg = sprintf ( '%s:  %s:  IsUnlimitedVariable was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Dimension)~=1 )
	msg = sprintf ( '%s:  %s:  Dimension was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Size~=10 )
	msg = sprintf ( '%s:  %s:  Size was not correct.\n', mfilename, testid );
	error ( msg );
end
if ( v.Dimid ~= 0 )
	msg = sprintf ( '%s:  %s:  Dimid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Rank~=1 )
	msg = sprintf ( '%s:  %s:  Rank was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Attribute)~=1 )
	msg = sprintf ( '%s:  %s:  Attribute was not correct.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );




testid = 'Test 12';
fprintf ( 1, '%s.\n', testid );
[v, status] = nc_getvarinfo ( ncfile, 'z' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end

if ~strcmp(v.Name, 'z' )
	msg = sprintf ( '%s:  %s:  Name was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Nctype~=6 )
	msg = sprintf ( '%s:  %s:  Nctype was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Varid~=6 )
	msg = sprintf ( '%s:  %s:  Varid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.IsUnlimitedVariable~=0 )
	msg = sprintf ( '%s:  %s:  IsUnlimitedVariable was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Dimension)~=2 )
	msg = sprintf ( '%s:  %s:  Dimension was not correct.\n', mfilename, testid );
	error ( msg );
end
if ( any(v.Size - [6 2]) )
	msg = sprintf ( '%s:  %s:  Size was not correct.\n', mfilename, testid );
	error ( msg );
end
if ( any(v.Dimid - [2 1] ) )
	msg = sprintf ( '%s:  %s:  Dimid was not correct.\n', mfilename, testid );
	error ( msg );
end
if (v.Rank~=2 )
	msg = sprintf ( '%s:  %s:  Rank was not correct.\n', mfilename, testid );
	error ( msg );
end
if (length(v.Attribute)~=0 )
	msg = sprintf ( '%s:  %s:  Attribute was not correct.\n', mfilename, testid );
	error ( msg );
end

fprintf ( 1, '%s:  passed.\n', testid );




fprintf ( 1, '%s:  all tests succeeded...\n', upper ( mfilename ) );
return


