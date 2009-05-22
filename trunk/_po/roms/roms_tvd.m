function [V,D,len]=roms_tvd(file)
%ROMS_TVD   ROMS time varname and dim name
%
%   Syntax:
%      [V,D,LEN] = ROMS_TVD(FILE)
%
%      ... TODO
%


varnames=n_filevars(file);
dims=n_dim(file);
dimnames=dims.name;
names={'time','scrum_time','ocean_time','ftime'};
V=[];
D=[];
for i=1:length(names)
  if ismember(names{i},varnames), V=names{i}; end
  if ismember(names{i},dimnames), D=names{i}; end
end

if D, len=n_dim(file,D);
else, len=[];
end


