function S_settings(what)
%function S_settings
%Default SpectrHA settings
%configures: colors, markers, fonts,...
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global ETC LOOK


if nargin == 0
  what = 'all';
end

if isequal(what,'theme') | isequal(what,'all')
  %---------------------------------------------------------------------
  % main interface colors:
  %---------------------------------------------------------------------
  grid_axes=[1 0 0];         % grid axes
  spectrum_axes=[0 1 0];     % spectrum axes
  bg=[ 0.937 0.937 0.827 ];  % axes background
  mask=[.8 .8 .8];           % mask
  fig=[.2 .2 .2];            % figure 
  controls='default';        % controls
  controls_fg='default';     % controls foreground
  labels=[0 1 0];            % labels
  xlabel_grid=[0 1 0];       % xlabel of grid
  legend_fg=[0 0 0];         % spectrum axes legend
  plot_axis=[0 0 0];         % ellipse axis
  coastline=[0 0 0];         % coastline
  mask_line=[0 0 1];         % mask contour; view S_load_grid.m
  plot=[0 0 1];              % default color for plots
  contours=[0 0 0];          % bathymetric contours
  clabel_marker=[0 0 1];     % clabel marker color
  clabel_label=[0 0 0];      % clabel string color

  grid_axes=[0 0 0];
  spectrum_axes=[0 0 0];
  bg=[0.929    0.933    0.953 ];
  fig=[0.6706   0.6902   0.8039] ;
  labels=[0 0 0];
  xlabel_grid=[0 0 0];
  controls = bg;

  %---------------------------------------------------------------------
  % markers and colors
  %---------------------------------------------------------------------
  marker_select='o';   % to use when selecting station
  marker_file='+';     % to use in lon,lat of loaded mat file
  marker_struc='x';    % to use in lon,lat of loaded ellipse mat file
  marker_plotit='o';   % to use when selecting data in spectrum from output
  marker_stations='.'; % to use in position of stations

  markerColor_select='b';
  markerColor_file='r';
  markerColor_struc='r';
  markerColor_plotit='r';
  markerColor_stations='b';

  markerColorOld_select=[.7 .7 .7]; % colors of old points, last used or loaded
  markerColorOld_file=[.7 .7 .7];
  markerColorOld_struc=[.7 .7 .7];

  markerSize_select=6;
  markerSize_file=6;
  markerSize_struc=6;
  markerSize_plotit=6;
  if strcmpi(computer,'PCWIN')
    markerSize_stations=2;
  else
    markerSize_stations=5;
  end

end

if isequal(what,'misc') | isequal(what,'all')
  %---------------------------------------------------------------------
  % misc
  %---------------------------------------------------------------------
  % fonts:
  fontsize=10;
  fontname='courier';

  % default xlim:
  default_xlim=[-5 40]; % hour

  % default datenum vars (for prediction)
  default_datenum_end=1; % mounth
  default_datenum_dt=1;   % hour

  % default ellipse color, to use with all not specified
  defaultEllipseColor=[1 .75 1];

  % default NetCDF file extensions
  netcdf_extensions={'*.nc';'*.cdl'};

  % default log filename:
  logname='log.dat';

  % default time index when release s_levels
  release_t1=1;   % for slices
  release_t2=100; % to display in z_r time serie

end


%*********************************************************************
% store:
%*********************************************************************

if isequal(what,'theme') | isequal(what,'all')
  %main interface colors:
  LOOK.color.grid_axes=grid_axes;
  LOOK.color.spectrum_axes=spectrum_axes;
  LOOK.color.mask=mask;
  LOOK.color.bg=bg;
  LOOK.color.fig=fig;
  LOOK.color.controls=controls;
  LOOK.color.controls_fg=controls_fg;
  LOOK.color.labels=labels;
  LOOK.color.xlabel_grid=xlabel_grid;
  LOOK.color.legend_fg=legend_fg;
  LOOK.color.plot_axis=plot_axis;
  LOOK.color.coastline=coastline;
  LOOK.color.mask_line=mask_line;
  LOOK.color.plot=plot;
  LOOK.color.contours=contours;
  LOOK.color.clabel_marker=clabel_marker;
  LOOK.color.clabel_label=clabel_label;

  %markers and colors:
  LOOK.marker.select=marker_select;
  LOOK.marker.file=marker_file;
  LOOK.marker.struc=marker_struc;
  LOOK.marker.plotit=marker_plotit;
  LOOK.marker.stations=marker_stations;

  LOOK.markerColor.select=markerColor_select;
  LOOK.markerColor.file=markerColor_file;
  LOOK.markerColor.struc=markerColor_struc;
  LOOK.markerColor.plotit=markerColor_plotit;
  LOOK.markerColor.stations=markerColor_stations;

  LOOK.markerColorOld.select=markerColorOld_select;
  LOOK.markerColorOld.file=markerColorOld_file;
  LOOK.markerColorOld.struc=markerColorOld_struc;

  LOOK.markerSize.select=markerSize_select;
  LOOK.markerSize.file=markerSize_file;
  LOOK.markerSize.struc=markerSize_struc;
  LOOK.markerSize.plotit=markerSize_plotit;
  LOOK.markerSize.stations=markerSize_stations;

end

if isequal(what,'misc') | isequal(what,'all')
  % misc:
  LOOK.fontsize=fontsize;
  LOOK.fontname=fontname;

  ETC.default_xlim=default_xlim;
  ETC.datenum.end=default_datenum_end;
  ETC.datenum.dt=default_datenum_dt;

  LOOK.defaultEllipseColor=defaultEllipseColor;

  ETC.netcdf_ext=netcdf_extensions;

  ETC.logname=logname;

  ETC.release_t1=release_t1;
  ETC.release_t2=release_t2;

end
