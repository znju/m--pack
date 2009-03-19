function m_axis(lon,lat,param1,param2)
%M_AXIS   Set axis limits
%
%   Syntax:
%      M_AXIS(LON,LAT,PARAM1,PARAM2)
%
%   Inputs:
%      LON, PARAM1   Xlim will be -min(min(LON))-PARAM1 and 
%                    max(max(LON))+PARAM1
%      LON, PARAM2   Ylim will be -min(min(LAT))-PARAM2 and
%                    max(max(LAT))+PARAM2
%
%   Comment:
%      Also executes axis equal
%
%   MMA 6-8-2002, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

axis equal;
axis([min(min(lon))-param1 max(max(lon))+param1 ...
      min(min(lat))-param2 max(max(lat))+param2]);
