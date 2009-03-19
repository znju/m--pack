function add_hraw(grd)
%ADD_HRAW   Copy h from ROMS grid to hr
%   Should be used before smooth, in order to keep a copy of the
%   original depth. The new variable is used by default by B_SMOOTH.
%
%
%   Syntax:
%      ADD_HRAW(GRD)
%
%   Input:
%      GRD   ROMS grid file
%
%   MMA 12-2006, martinho@fis.ua.pt
%
%   See also B_SMOOTH

% Department of Physics
% University of Aveiro, Portugal

if n_varexist(grd,'hr')
  ans=input(':: hr already exist, wanna continue? [y/n] ','s');
  if ~(isequal(lower(ans),'y') | isempty(ans))
    disp(':: stop')
    return
  end
end

nc=netcdf(grd,'w');
nc{'hr'} = ncdouble('eta_rho', 'xi_rho');
nc{'hr'}.long_name = ncchar('Initial bathymetry at RHO-points');
nc{'hr'}.units = ncchar('meter');

nc{'hr'}(:)=use(grd,'h');

close(nc)
