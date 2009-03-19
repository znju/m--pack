function handle = plot_border(lon,lat,type,opt)
%PLOT_BORDER   Plot ROMS rho border/extremes box
%   Plots box of LON x LAT region, ie, from min(LON) until max(LON)
%   and from min(LAT) until max(LAT); or the real curvilinear border.
%   LON and LAT are supposed to be from ROMS model.
%
%   Syntax:
%      HANDLE = PLOT_BORDER(LON,LAT,OPT)
%
%   Input:
%      LON    ROMS longitude
%      LAT    ROMS latitude
%      TYPE   Type of box; may be rectangle extremes box, ie,
%             from min(LON) until max(LON) and from min(LAT) until
%             max(LAT), or may be the real curvilinear border
%             [ 'box' {'border'} ]
%      OPT    Plot options [ 'b' ]
%
%   Output:
%      HANDLE   Plot handle
%
%   Examples:
%      fname = 'roms.nc';
%      nc = netcdf(fname);
%        lon = nc{'lon_rho'}(:);
%        lat = nc{'lat_rho'}(:);
%      nc =close(nc);
%      plot_border(lon,lat), hold on
%      plot_border(lon,lat,'border','r.')
%
%   MMA 16-2-2003, martinho@fis.ua.pt
%
%   See also PLOT_BOX

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 4
  opt = 'b';
end
if nargin < 3
  type = 'border';
end

h=ishold;
hold on

if isequal(type,'border')
  handle = plot([lon(:,1) ; lon(end,:)' ; flipud(lon(:,end)) ; flipud(lon(1,:)')],...
                [lat(:,1) ; lat(end,:)' ; flipud(lat(:,end)) ; flipud(lat(1,:)')],opt);
elseif isequal(type,'box')
  handle = plot([lon(1,1) lon(1,end) lon(end,end) lon(end,1) lon(1,1)],...
                [lat(1,1) lat(1,end) lat(end,end) lat(end,1) lat(1,1)],opt);
else
  disp('## unrecognised type...');
end

if ~h
  hold off;
end
