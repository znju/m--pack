function teta = atan3(y,x)
%ATAN3   Inverse tangent [0:360[
%   Is the same as atan2(x,y)*180/pi, but with positive output.
%
%   Syntax:
%      TETA = ATAN3(Y,X)
%
%   Inputs:
%      Y, X   Same as in atan2
%
%   Output:
%      TETA   Angle (deg)
%
%   MMA 13-1-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

teta=atan2(y,x)*180/pi;
I=find(teta<0);
teta(I)=teta(I)+360;
