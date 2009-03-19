function [theta_s,theta_b,Tcline,N] = get_sigma(roms_file)
%GET_SIGMA   Get s-coordinates parameters from ROMS file (deprecated)
%   Gets variables from ROMS output files needed to calculate
%   vertical sigma coordinate levels (the other needed variables are
%   h, hmin and zeta, at each location).
%
%   Syntax:
%      [THETA_S,THETHA_B,TCLINE,N] = GET_SIGMA(ROMS_FILE)
%
%   Input:
%      ROMS_FILE   ROMS output file
%
%   Output:
%      THETA_S   S-coordinate surface control parameter
%      THETA_B   S-coordinate bottom control parameter
%      TCLINE    S-coordinate surface/bottom layer width
%      N         Number of vertical levels
%
%  Comment:
%     This function is ** DEPRECATED **, use S_PARAMS instead
%
%   MMA 22-5-2003, martinho@fis.ua.pt
%
%   See also S_LEVELS, S_PARAMS

%   Department of Physics
%   University of Aveiro, Portugal

if nargin==0
  [filename, pathname] = uigetfile('*.nc', 'Select ROMS output file');
  roms_file=[pathname,filename];
end

nc=netcdf(roms_file,'nowrite');
  theta_s=nc{'theta_s'}(:);
  theta_b=nc{'theta_b'}(:);
  Tcline=nc{'Tcline'}(:);
  sc_r=nc{'sc_r'}(:);
nc=close(nc);
N=length(sc_r);
