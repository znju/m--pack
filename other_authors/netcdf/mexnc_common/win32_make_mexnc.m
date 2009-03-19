% Build Single-Threaded and Multi-Threaded 
% versions of mexnc for win32 with NetCDF 3.6.0 (w/large file support)  
% Note: the NetCDF library locations are hard-wired into
% the .bat options files called below.

% Single-Threaded
mex -v -f mexnc_msvc71_st.bat -output mexnc mexgateway.c netcdf2.c netcdf3.c common.c

% Single-Threaded R11 version
mex -v -f mexnc_msvc71_st_R11.bat -output mexnc mexgateway.c netcdf2.c netcdf3.c common.c
