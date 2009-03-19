test_nc_attget ( 'foo_addget.nc' );
test_nc_varput ( 'foo_nc_varput.nc' );
test_nc_add_dimension ( 'foo_add_dimension.nc' );
test_nc_addhist ( 'foo_addhist.nc' );
test_nc_addvar ( 'foo_addvar.nc' );
test_snc2mat ( 'foo_nc2mat.nc' );
test_nc_add_recs ( 'foo_add_recs.nc' );
test_nc_addnewrecs ( 'foo_addnewrecs.nc' );
test_nc_getvarinfo ( 'foo_getvarinfo.nc' );
test_nc_info ( 'foo_getvarinfo.nc' );
test_nc_iscoordvar ( 'foo_nc_iscoordvar.nc' );
test_nc_isunlimitedvar ( 'foo_nc_isunlimitedvar.nc' );
test_nc_isvar ( 'foo_nc_isvar.nc' );
test_nc_varrename ( 'foo_nc_varrename.nc' );
test_nc_varsize ( 'foo_nc_varsize.nc' );
test_nc_archive_buffer ( 'foo_archive_buffer.nc' );
test_nc_diff ( 'foo1.nc', 'foo2.nc' );
test_nc_get_attribute_struct ( 'foo_get_attribute_struct.nc'  );
test_nc_dump ( 'foo_nc_dump.nc' );
test_nc_getall ( 'foo_nc_getall.nc' );
test_nc_getbuffer ( 'foo_nc_getbuffer.nc' );
test_nc_getdiminfo ( 'foo_nc_getdiminfo.nc' );
test_nc_getlast ( 'foo_nc_getlast.nc' );
test_nc_native_varget ( 'foo_nc_native_varget.nc' );
test_nc_datatype_string;

fprintf ( 1, '\n' );
answer = input ( 'Do you wish to remove all test NetCDF and *.mat files that were created? [y/n]\n', 's' );
if strcmp ( lower(answer), 'y' )
	delete ( '*.nc' );
	delete ( '*.mat' );
end
fprintf ( 1, 'We''re done.\n' );



fprintf ( 1, '\nAll SNCTOOLS tests succeeded.\n' );
