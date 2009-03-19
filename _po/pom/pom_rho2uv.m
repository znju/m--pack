function [lonu,latu,lonv,latv] = pom_rho2uv(lon,lat)
%POM_RHO2UV   Transform lon,lat from rho to u and v points
%
%   Syntax:
%      [LONU,LATU,LONV,LATV] = POM_RHO2U_2D(LONR,LATR)
%
%   Inputs:
%      LONR,LATR   Longitude and latitude at rho points
%
%   Outputs:
%      LONU,LATU   Longitude and latitude at u points
%      LONV,LATV   Longitude and latitude at v points
%
%   Example:
%       [lon,lat]=pom_grid(grd);
%       [lonu,latu,lonv,latv] = pom_rho2uv(lon,lat);
%
%   See also POM_RHO2U_2D, POM_RHO2V_2D, POM_GRID
%
%   MMA 27-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

lonu = pom_rho2u_2d(lon,1);
latu = pom_rho2u_2d(lat,1);

lonv = pom_rho2v_2d(lon,1);
latv = pom_rho2v_2d(lat,1);
