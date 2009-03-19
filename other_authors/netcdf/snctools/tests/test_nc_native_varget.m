function test_nc_native_varget ( ncfile )
% TEST_NC_NATIVE_VARGET:
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
% Bad input argument tests.
% Test 1:  no inputs
% Test 2:  one input
% Test 3:  three inputs (have to have start and count)
% Test 4:  too many inputs
% test 5:  first input not character
% test 6:  second input not character
% test 7:  third input not numeric
% test 8:  fourth input not numeric
% test 9:  fifth input not numeric
% test 10:  third and fourth inputs not the same length
% test 11:  third and fourth and fifth inputs not the same length
% test 12:  first input not a netcdf file
% test 13:  2nd input not a netcdf variable
% test 14:  invalid start argument
% test 15:  invalid count argument
% test 16:  invalid stride argument
%
% put_var1
% Test 17:  read a singleton double
% Test 18:  read a singleton single
% Test 19:  read a singleton int
% Test 20:  read a singleton short int
% Test 21:  read a singleton uchar
% Test 22:  read a singleton schar
% Test 23:  read a singleton text
%
% Test 24:  read a 1D double
% Test 25:  read a 1D single
% Test 26:  read a 1D int
% Test 27:  read a 1D short int
% Test 28:  read a 1D uchar
% Test 29:  read a 1D schar
% Test 30:  read a 1D text
%
% Test 31:  read a 2D single
% Test 32:  read a 2D single with scale factor, add_offset
% Test 33:  read a 2D double with fill value






% Test 1:  no inputs
testid = 'Test 1';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget;
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% Test 2:  one input
testid = 'Test 2';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% Test 3:  three inputs (have to have start and count)
testid = 'Test 3';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'x', [0 3] );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% Test 4:  too many inputs
testid = 'Test 4';
create_empty_file ( ncfile );
fprintf ( 1, '%s.\n', testid );
try
	[vardata, status] = nc_native_varget ( ncfile, 'x', [0 3], [4 4], [5 5], [6 6] );
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
catch
	;
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 5:  first input not character
testid = 'Test 5';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( 5, 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 6:  second input not character
testid = 'Test 6';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 5 );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 7:  third input not numeric
testid = 'Test 7';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 't', 't', [0 5] );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 8:  fourth input not numeric
testid = 'Test 8';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 't', [0 5], 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 9:  fifth input not numeric
testid = 'Test 9';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 's', [0], [2], 't' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 10:  third and fourth inputs not the same length
testid = 'Test 10';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 's', [0], [2 2] );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 11:  third and fourth and fifth inputs not the same length
testid = 'Test 11';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 's', [2], [2], [3 4] );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 12:  first input not a netcdf file
testid = 'Test 12';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( '/dev/null', 's' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 13:  2nd input not a netcdf variable
testid = 'Test 13';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'u' );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 14:  invalid start argument
testid = 'Test 14';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 's', [18], [2] );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 15:  invalid count argument
testid = 'Test 15';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 's', [0], [22] );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









% test 16:  invalid stride argument
testid = 'Test 16';

create_empty_file ( ncfile );
status = nc_add_dimension ( ncfile, 's', 5 );
status = nc_add_dimension ( ncfile, 't', 0 );

clear varstruct;
varstruct.Name = 's';
varstruct.Nctype = 'double';
varstruct.Dimension = { 's'};
nc_addvar ( ncfile, varstruct );;
clear varstruct;
varstruct.Name = 't';
varstruct.Nctype = 'double';
varstruct.Dimension = { 't' };
nc_addvar ( ncfile, varstruct );;

fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 's', [0], [3], [4] );
if ( status >= 0 )
	msg = sprintf ( '%s:  %s succeeded when it should have failed.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );









%
% put_var1
% Test 17:  read a singleton double
% Test 18:  read a singleton single
% Test 19:  read a singleton int
% Test 20:  read a singleton short int
% Test 21:  read a singleton uchar
% Test 22:  read a singleton schar
% Test 23:  read a singleton text
%
create_empty_file ( ncfile );

clear varstruct;
varstruct.Name = 'double_var';
varstruct.Nctype = 'double';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'double_var', 1 );

clear varstruct;
varstruct.Name = 'float_var';
varstruct.Nctype = 'float';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'float_var', single(1) );

clear varstruct;
varstruct.Name = 'int_var';
varstruct.Nctype = 'int';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'int_var', int32(1) );

clear varstruct;
varstruct.Name = 'short_int_var';
varstruct.Nctype = 'short';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'short_int_var', int16(1) );

clear varstruct;
varstruct.Name = 'uchar_var';
varstruct.Nctype = 'byte';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'uchar_var', uint8(1) );

clear varstruct;
varstruct.Name = 'schar_var';
varstruct.Nctype = 'byte';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'schar_var', int8(1) );

clear varstruct;
varstruct.Name = 'text_var';
varstruct.Nctype = 'char';
varstruct.Dimension = [];
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'text_var', 'a' );


% Test 17:  read a singleton double
testid = 'Test 17';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'double_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'double')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if vardata ~= 1
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );





% Test 18:  read a singleton single
testid = 'Test 18';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'float_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'single')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if double(vardata) ~= 1
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 19:  read a singleton int
testid = 'Test 19';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'int_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'int32')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if double(vardata) ~= 1
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 20:  read a singleton short int
testid = 'Test 20';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'short_int_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'int16')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if double(vardata) ~= 1
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 21:  read a singleton uchar
testid = 'Test 21';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'uchar_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'int8')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if double(vardata) ~= 1
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 22:  read a singleton schar
testid = 'Test 22';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'schar_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'int8')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if double(vardata) ~= 1
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 23:  read a singleton text
testid = 'Test 23';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'text_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'char')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if vardata ~= 'a'
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




%
% Test 24:  read a 1D double
% Test 25:  read a 1D single
% Test 26:  read a 1D int
% Test 27:  read a 1D short int
% Test 28:  read a 1D uchar
% Test 29:  read a 1D schar
% Test 30:  read a 1D text
%
% Test 31:  read a 2D single
% Test 32:  read a 2D single with scale factor, add_offset
% Test 33:  read a 2D double with fill value

create_empty_file ( ncfile );

clear varstruct;
nc_add_dimension ( ncfile, 't', 5 );
varstruct.Name = 'double_var';
varstruct.Nctype = 'double';
varstruct.Dimension = {'t'};
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'double_var', [1:5]' );

clear varstruct;
varstruct.Name = 'float_var';
varstruct.Nctype = 'float';
varstruct.Dimension = {'t'};
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'float_var', single([1:5]') );

clear varstruct;
varstruct.Name = 'int_var';
varstruct.Nctype = 'int';
varstruct.Dimension = {'t'};
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'int_var', int32([1:5]') );

clear varstruct;
varstruct.Name = 'short_int_var';
varstruct.Nctype = 'short';
varstruct.Dimension = {'t'};
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'short_int_var', int16([1:5]') );

clear varstruct;
varstruct.Name = 'uchar_var';
varstruct.Nctype = 'byte';
varstruct.Dimension = {'t'};
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'uchar_var', uint8([1:5]') );

clear varstruct;
varstruct.Name = 'schar_var';
varstruct.Nctype = 'byte';
varstruct.Dimension = {'t'};
nc_addvar ( ncfile, varstruct );;
nc_varput ( ncfile, 'schar_var', int8([1:5]') );

clear varstruct;
varstruct.Name = 'text_var';
varstruct.Nctype = 'char';
varstruct.Dimension = {'t'};
nc_addvar ( ncfile, varstruct );;

str = 'abcde';
nc_varput ( ncfile, 'text_var', str' );



% Test 24:  read a 1D double
testid = 'Test 24';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'double_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'double')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if any(vardata - [1:5]')
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



% Test 25:  read a 1D single
testid = 'Test 25';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'float_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'single')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if any(double(vardata) - [1:5]')
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 26:  read a 1D int
testid = 'Test 26';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'int_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'int32')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if any(double(vardata) - [1:5]')
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 27:  read a 1D short int
testid = 'Test 27';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'short_int_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'int16')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if any(double(vardata) - [1:5]')
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 28:  read a 1D uchar
testid = 'Test 28';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'uchar_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'int8')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if any(double(vardata) - [1:5]')
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 29:  read a 1D schar
testid = 'Test 29';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'schar_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'int8')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if any(double(vardata) - [1:5]')
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );




% Test 30:  read a 1D text
testid = 'Test 30';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'text_var' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'char')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(vardata', 'abcde' )
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );










% Test 31:  read a 2D double
% Test 32:  read a 2D double with scale factor, add_offset
% Test 33:  read a 2D double with fill value

create_empty_file ( ncfile );

clear varstruct;
nc_add_dimension ( ncfile, 's', 3 );
nc_add_dimension ( ncfile, 't', 5 );
varstruct.Name = 'var1';
varstruct.Nctype = 'float';
varstruct.Dimension = {'s', 't'};
nc_addvar ( ncfile, varstruct );
values = [1:15];
values = reshape(values,3,5);
nc_varput ( ncfile, 'var1', values );


% Test 31:  read a 2D float
testid = 'Test 31';
fprintf ( 1, '%s.\n', testid );
[vardata, status] = nc_native_varget ( ncfile, 'var1' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'single')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end
if any(double(vardata) - values)
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



% Test 32:  read a 2D double with scale factor, add_offset
testid = 'Test 32';
fprintf ( 1, '%s.\n', testid );

clear varstruct;
varstruct.Name = 'var2';
varstruct.Nctype = 'float';
varstruct.Dimension = {'t'};
varstruct.Attribute(1).Name = 'scale_factor';
varstruct.Attribute(1).Value = 0.5;
varstruct.Attribute(2).Name = 'add_offset';
varstruct.Attribute(2).Value = 1.0;
nc_addvar ( ncfile, varstruct );
nc_varput ( ncfile, 'var2', [1:5]' );

[vardata, status] = nc_native_varget ( ncfile, 'var2' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'single')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end

%
% since we are retrieving, the data will not be scaled.  
if any(double(vardata) - [0 2 4 6 8]')
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );



% Test 33:  read a 2D double with fill value
testid = 'Test 33';
fprintf ( 1, '%s.\n', testid );

clear varstruct;
varstruct.Name = 'var3';
varstruct.Nctype = 'float';
varstruct.Dimension = {'t'};
varstruct.Attribute(1).Name = '_FillValue';
varstruct.Attribute(1).Value = single(2);
nc_addvar ( ncfile, varstruct );
nc_varput ( ncfile, 'var3', [1:5]' );


[vardata, status] = nc_native_varget ( ncfile, 'var3' );
if ( status < 0 )
	msg = sprintf ( '%s:  %s failed when it should have succeeded.\n', mfilename, testid );
	error ( msg );
end
if ~strcmp(class(vardata),'single')
	msg = sprintf ( '%s:  %s:  did not return correct type.\n', mfilename, testid );
	error ( msg );
end

%
% since we are retrieving, the 2nd data point should not be nan.
if isnan(vardata(2))
	msg = sprintf ( '%s:  %s:  did not return correct value.\n', mfilename, testid );
	error ( msg );
end
fprintf ( 1, '%s:  passed.\n', testid );






fprintf ( 1, '%s:  all tests passed.\n', upper(mfilename) );
