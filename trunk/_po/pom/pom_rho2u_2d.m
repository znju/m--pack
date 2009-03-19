function u = pom_rho2u_2d(r,isll)
%POM_RHO2U_2D   Transform 2D array from rho to u points
%
%   Syntax:
%      AU = POM_RHO2U_2D(AR,ISLL)
%
%   Inputs:
%      AR     2D array at rho points
%      ISLL   Is lon or lat flag, defualt 0; if 1 the first column
%             will be not copied from the second one, but extrapolated
%
%   Outputs:
%      AU   2D array at u points
%
%   Examples:
%       tempu = pom_rho2u_2d(temp,0);
%       lonu  = pom_rho2u_2d(lon,1);
%
%   See also POM_RHO2V_2D, POM_RHO2UV
%
%   MMA 27-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin<2
  isll=0;
end

u=(r(:,2:end)+r(:,1:end-1))/2;
u(:,2:end+1)=u;
if isll
  u(:,1)=r(:,1)-(r(:,2)-r(:,1));
end
