function [x,y,z,v,mask]=roms_slicelon(fname,varname,lon,time,varargin)
%ROMS_SLICELON   Make ROMS slice across zonal direction (lon=const)
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICELON(FILE,VARNAME,LON,T,VARARGIN)
%      V  = ROMS_SLICELON(FILE,VARNAME,LON,T,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
%      VARNAME   Variable to extract (array or dimension >= 2)
%      LON       Longitude [ lon [npts] ] (npts = number of points to
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
%      lon = [-10 30]; % use interpolation at 30 points
%      t = 10;
%      [x,y,z,v,mask]=roms_slicelon(file,varname,lon,t);
%      figure
%      surf(x,y,z,v);
%      figure
%      pcolor(y,z,v)
%
%      varname = 'ubar';    % 3-d array
%      [x,y,z,v,mask]=roms_slicelon(file,varname,lon,t);
%      figure
%      plot3(x,y,v)
%
%      varname = 'h';       % 2-d array
%      [x,y,z,v,mask]=roms_slicelon(file,varname,lon);
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
if length(lon)==1
  [eta,xi]=size(x);
  n=max(eta,xi);
else
  n=lon(2);
  lon=lon(1);
end
X=lon*ones(1,n);
Y=linspace(min(y(:)),max(y(:)),n);

if nargout<=4
  [d,z,v,mask] = roms_slicell(fname,varname,X,Y,time,varargin{:});
  x=d;
  y=z;
  z=v;
  v=mask;
else
  [x,y,z,v,mask] = roms_slicell(fname,varname,X,Y,time,varargin{:});
end
