function [x,y,z,v,mask]=roms_slicelat(fname,varname,lat,time,varargin)
%ROMS_SLICELAT   Make ROMS slice across meridional direction (lat=const)
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICELAT(FILE,VARNAME,LAT,T,VARARGIN)
%      V  = ROMS_SLICELAT(FILE,VARNAME,LAT,T,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
%      VARNAME   Variable to extract (array or dimension >= 2)
%      LAT       Latitude [ lat [npts] ] (npts = number of points to
%                Use in interpolation [ max(eta,xi) ]
%      T         Time indice
%      VARARGIN:
%        Options of ROMS_SLICELL
%
%   Outputs:
%     X,Y   Same as LON, LAT, but with size of extracted variable
%     Z     Depth
%     DIST  Distance (m)
%     V     Variable at slice
%     M     Mask
%
%   Examples:
%      file = 'roms_his.nc';
%      varname = 'temp';      % 4-d array
%      lat = [-10 30]; % use interpolation at 30 points
%      t = 10;
%      [x,y,z,v,mask]=roms_slicelat(file,varname,lat,t);
%      figure
%      surf(x,y,z,v);
%      figure
%      pcolor(y,z,v)
%
%      varname = 'ubar';    % 3-d array
%      [x,y,z,v,mask]=roms_slicelat(file,varname,lat,t);
%      figure
%      plot3(x,y,v)
%
%      varname = 'h';       % 2-d array
%      [x,y,z,v,mask]=roms_slicelat(file,varname,lat);
%      figure
%      plot3(x,y,-v)
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See also ROMS_SLICELL

%   Department of Physics
%   University of Aveiro, Portugal

%   Latest version, aug-2010

[x,y]=roms_grid(fname,varname(1));
if length(lat)==1
  [eta,xi]=size(x);
  n=max(eta,xi);
else
  n=lat(2);
  lat=lat(1);
end
Y=lat*ones(1,n);
X=linspace(min(x(:)),max(x(:)),n);

if nargout<=4
  [d,z,v,mask] = roms_slicell(fname,varname,X,Y,time,varargin{:});
  x=d;
  y=z;
  z=v;
  v=mask;
else
  [x,y,z,v,mask] = roms_slicell(fname,varname,X,Y,time,varargin{:});
end
