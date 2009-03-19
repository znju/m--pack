function tdays = octime(self)

tdays = [];
out   = get(self,'slice_info');
file  = out.file;
t     = out.time;

tvar  = {'ocean_time','scrum_time'};

tvarname = [];
for i=1:length(tvar)
  if n_varexist(file,tvar{i})
    tvarname = tvar{i};
    break
  end
end

if ~isempty(tvarname)
  nc=netcdf(file);
  tdays = nc{tvarname}(t);
  close(nc);
end
tdays = tdays/86400;
