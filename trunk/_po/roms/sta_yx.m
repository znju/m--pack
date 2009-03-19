function [y,x] = sta_yx(lon_sta,param)
%STA_YX   Get dimensions of longitude in ROMS stations file
%   The aim is to transform variables from stations file into a
%   matrice format, instead of vector.
%   This will be only possible if positions are previously defined to allow
%   it.
%
%   Syntax:
%      [Y,X] = STA_YX(LON_STA,PARAM)
%
%   Inputs:
%      LON_STA   Longitude from ROMS stations file
%      PARAM     Parameter of new column selection, by default is the
%                average of the difference between values
%   Outputs:
%      Y, X   Size to use in variables (reshaping)
%
%   Example:
%      [y,x]=sta_yx(lon_sta);
%      lon=reshape(lon_sta,y,x);
%      lat=reshape(lat_sta,y,x);
%
%   MMA 18-9-2002, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

L=length(lon_sta);

if nargin < 2
  param=(lon_sta(end)-lon_sta(1))/L;
end

n=1;
while lon_sta(n+1)-lon_sta(n)< param
  n=n+1;
end
y=n;
x=L/n;
