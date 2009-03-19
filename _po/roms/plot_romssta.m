function plot_romssta(sta)
%PLOT_ROMSSTA   Fast way to see all stations of ROMS output
%
%   Syntax:
%      PLOT_ROMSSTA(STA)
%
%   Input:
%      STA   ROMS output stations file
%
%   MMA 2-4-2007, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

plot_romsgrd(sta,'proj','none')

lon=use(sta,'lon');
lat=use(sta,'lat');

hold on

plot(lon,lat,'.')

try
  load coastline
  plot(lon,lat)
end

