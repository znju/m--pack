function n_filenans(f,minMax)
%N_FILENANS   Count NaNs inside NetCDF file
%   Displays the number of NaNs in each variable of a NetCDF file,
%   also shows min and max.
%
%   Syntax:
%      n_FILENANS(FILE,MM)
%
%   Input:
%      FILE   NetCDF file
%      MM     If true, also show min and nax [1]
%
%   MMA 31-3-2007, martinho@fis.ua.pt
%
%   See also N_FILEVARS, NAN_COUNT

% Department of Physics
% University of Aveiro, Portugal

if nargin <2
  minMax=1;
end

v=n_filevars(f);
for i=1:length(v)
  [c,I]=nan_count(use(f,v{i}));
  vv=use(f,v{i});
  [c,I]=nan_count(vv);
  if minMax
    mx=max(vv(:));
    mi=min(vv(:));
    fprintf(1,' found %3d nans in %15s . max = %8.4f  min = %8.4f\n',c,v{i},mx,mi)
  else
    fprintf(1,' found %3d nans in %15s\n',c,v{i})
  end
end
