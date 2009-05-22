function ncx_update_dimlen(theHandle,file,varname,dimName)

dim  = n_dim(file,varname,dimName);
set(theHandle,'string',dim);

