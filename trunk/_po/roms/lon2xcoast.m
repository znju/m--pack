function dcoast=lon2xcoast(grd,varargin)
%LON2XCOAST   Convert lon/lat to distance to coast
%   This function converts longitudes or latitudes to distance to
%   coast. The coast is defined as the first indice found with
%   mask_rho = 0 and the search direction can be specified, either
%   increasing j(i) or decreasing.
%
%   Syntax:
%      D = LON2XCOAST(GRD,VARARGIN)
%
%   Inputs:
%      GRD   ROMS grid file
%      VARAARGIN:
%         'i', longitude is used
%         'j', latitude is used
%         'dir', [ 0 | 1 ], direction used while searching for
%             mask = 0. If 1 (default) J(i) is increasing.
%   Output:
%     D   Lon/lat converted to distance to coast (km)
%
%   Example;
%      grd = 'ocean_grid.nc';
%      x   = lon2xcoast(grd,'j',10)
%
%   MMA 3-2005, martinho@fis.ua.pt
%
%   See Also ROMS_GRID

%   Department of Physics
%   University of Aveiro, Portugal

dcoast = [];

doi = 0;
doj = 0;
dir = 1; % W-E or S-N
I   = nan;
J   = nan;

vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'j')
    doj = 1;
    doi = 0;
    J = vin{i+1};
  end
  if isequal(vin{i},'i')
    doi = 1;
    doj = 0;
    I = vin{i+1};
  end
  if isequal(vin{i},'dir')
    dir = vin{i+1};
  end
end

if isnan(I) & isnan(J)
  if doi
    disp('## I not specified');
  elseif doj
    disp('## J not specified');
  else
    disp('## I or J not specified');
  end
  return
end

% slice:
if doj
  [x,y,h,m] = roms_grid(grd,'eta',J);
else
  [x,y,h,m] = roms_grid(grd,'xi',I);
end

% direction:
if dir == 1
  i1 = 1; is = 1; i2 = length(m);
else
  i1 = length(m); is = -1; i2 = 1;
end

for i=i1:is:i2
  if m(i)==0,  break, end
end

Rt = 6370;
if doj
  lat    = mean(y);
  lonc   =  x(i);
  dlon   = lonc-x;
  rt     = Rt * cos(lat*pi/180);
  dcoast = dlon*pi/180 * rt;
else
  latc   =  y(i);
  dlat   = latc-y;
  dcoast = dlat*pi/180 * Rt;
end
