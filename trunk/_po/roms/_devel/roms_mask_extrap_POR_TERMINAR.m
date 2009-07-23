function roms_mask_extrap(file,grid)

[xr,yr,hr,mr]=roms_grid(file,'r');
[xu,yu,hu,mu]=roms_grid(file,'u');
[xv,yv,hv,mv]=roms_grid(file,'v');

vars=n_filevars(file)
for i=1:length(vars)
  dims=n_vardim(file,vars{i});
  if length(dims)>2
    [name,len]=tdim(dims)
    if ismember('xi_rho',dims.name) && ismember('eta_rho',dims.name)
      for t=1:len
        
      end
  end

end


function [name,len]=tdim(dims)
for i=1:length(dims.name)
  if ~(strmatch('eta',d.name{i}) || strmatch('xi',d.name{i}))
    name=d.name{i};
    len=d.length{i};
    break
  end
end
