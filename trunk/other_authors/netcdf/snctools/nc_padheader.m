function nc_padheader ( ncfile, num_bytes )
% NC_PADHEADER:  pads the metadata header of a netcdf file
%
% When a netCDF file gets very large, adding new attributes can become
% a time-consuming process.  This can be mitigated by padding the 
% netCDF header with additional bytes.  Subsequent new attributes will
% not result in long time delays unless the length of the new 
% attribute exceeds that of the header.
%
% USAGE:  nc_padheader ( ncfile, num_bytes );
%

[ncid,status] = mexnc ( 'open', ncfile, nc_write_mode );
if ( status ~= 0 )
	msg = sprintf ( '%s:  open failed, ''%s''.\n', ncfile, mexnc('strerror',status)   )
	error ( msg );
end

status = mexnc ( 'redef', ncid );
if ( status ~= 0 )
	msg = sprintf ( '%s:  redef failed, ''%s''.\n', ncfile, mexnc('strerror',status) );
	error ( msg );
end

%
% Sets the padding to be "num_bytes" at the end of the header section.  The other
% values are default values used by "ENDDEF".
status = mexnc ( '_enddef', ncid, num_bytes, 4, 0, 4 );
if ( status ~= 0 )
	msg = sprintf ( '%s:  _enddef failed, ''%s''.\n', ncfile, mexnc('strerror',status) )
	error ( msg );
end

status = mexnc ( 'close', ncid );
if ( status ~= 0 )
	msg = sprintf ( '%s:  close failed, ''%s''.\n', ncfile, mexnc('strerror',status) )
	error ( msg );
end
