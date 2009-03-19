function yy = interp_mp(x,y,xi)
%INTERP_MP   MeetPoint interpolation
%   Inverse of interp1, ie, calculates YI for a given XI.
%   YI can have lenght>1.
%
%   Syntax:
%      YI = INTERP_MP(X,Y,XI)
%
%   Inputs:
%      X,Y   Some 1-D curve
%      XI   Intersection abscissa
%
%   Outputs:
%      YI   Intersection ordenates
%
%   See also MEETPOINT
%
%   MMA 10-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

xi=[xi xi];
yi=[min(y) max(y)];
[xx,yy,m0,m1]=meetpoint(x,y,xi,yi);
