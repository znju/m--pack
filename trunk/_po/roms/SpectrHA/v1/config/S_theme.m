function S_theme(theme)
%function S_theme(theme)
%Set or change SpectrHA theme
%edit to choose colos, font,...
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global ETC LOOK HANDLES MENU FSTA FLOAD ELLIPSE


if isequal(theme,'default');
  S_settings('theme');
  set(MENU.theme_c,'checked','on');
  set(MENU.theme_k,'checked','off');
elseif isequal(theme,'black')
  set(MENU.theme_c,'checked','off');
  set(MENU.theme_k,'checked','on');

  % see S_settings for available properties of variable LOOK 
  fig=[.2 .2 .2];
  grid_axes=[1 1 1];
  spectrum_axes=[1 1 1];
  bg=[.2 .2 .2];
  controls=[0 0 0];
  controls_fg=[0 1 0];
  labels=[1 1 1]; 
  xlabel_grid=[0 1 0];
  legend_fg=[1 1 1];
  plot_axis=[.8 .8 .8];
  coastline=[0 .7 0];
  mask_line=[1 0 0];
  plot=[0 0.502 0.753];
  contours=[.502 .502 1]; 
  clabel_marker=[0 1 0];
  clabel_label=[.8 .8 .8];

  markerColor_select='r';
  markerColor_file='g';
  markerColor_struc='g';
  markerColor_plotit='g';
  markerColor_stations='w';
  %markerColorOld_select=[1 1 1];
  markerColorOld_file=[1 1 1];
  markerColorOld_struc=[1 1 1];

  % store:
  LOOK.color.fig=fig;
  LOOK.color.grid_axes=grid_axes;
  LOOK.color.spectrum_axes=spectrum_axes;
  LOOK.color.bg=bg;
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

  LOOK.markerColor.select=markerColor_select;
  LOOK.markerColor.file=markerColor_file;
  LOOK.markerColor.struc=markerColor_struc;
  LOOK.markerColor.plotit=markerColor_plotit;
  LOOK.markerColor.stations=markerColor_stations;
  %LOOK.markerColorOld.select=markerColorOld_select;
  LOOK.markerColorOld.file=markerColorOld_file;
  LOOK.markerColorOld.struc=markerColorOld_struc;
end

%*********************************************************************
% update
%*********************************************************************
% update color of stations:
if ishandle(FSTA.positions)
  set(FSTA.positions,'color',LOOK.markerColor.stations);
end
if ishandle(FSTA.current)
  set(FSTA.current,'color',LOOK.markerColor.select);
end

% update color of loaded file:
if ishandle(FLOAD.current);
  set(FLOAD.current,'color',LOOK.markerColor.file);
end

% update color of loaded struc:
if ishandle(ELLIPSE.current);
  set(ELLIPSE.current,'color',LOOK.markerColor.struc);
end

% update figure color:
set(gcf,'color',LOOK.color.fig);

% update axes:
axes(HANDLES.spectrum_axes);
S_axes_prop;
axes(HANDLES.grid_axes);
S_axes_prop;

% update grid labels:
lab1=get(HANDLES.grid_axes,'title');
lab2=get(HANDLES.grid_axes,'ylabel');
lab3=get(HANDLES.grid_axes,'xlabel');
set(lab1,'color',LOOK.color.labels);
set(lab2,'color',LOOK.color.labels);
set(lab3,'color',LOOK.color.xlabel_grid);

% update color of legend:
S_upd_legend;

% update plot_axis color:
if ishandle(ETC.handles.plot_axis)
  set(ETC.handles.plot_axis,'color',LOOK.color.plot_axis);
end

% update coastline color:
if ishandle(ETC.handles.coastline)
  set(ETC.handles.coastline,'color',LOOK.color.coastline);
end

% update mask_line color:
if ishandle(ETC.handles.mask_line)
  set(ETC.handles.mask_line,'color',LOOK.color.mask_line);
end

% update default plot color:
if ishandle(ETC.handles.plot)
  set(ETC.handles.plot,'color',LOOK.color.plot);
end

% update color of contours and clabel:
if ishandle(ETC.handles.contours)
  set(ETC.handles.contours,'color',LOOK.color.contours);
end
if ishandle(ETC.handles.clabel_marker)
  set(ETC.handles.clabel_marker,'color',LOOK.color.clabel_marker);
end
if ishandle(ETC.handles.clabel_label)
  set(ETC.handles.clabel_label,'color',LOOK.color.clabel_label);
end


% output:
set(HANDLES.txt_head,         'BackgroundColor',LOOK.color.bg,'ForegroundColor',LOOK.color.controls_fg,...
                              'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.output,           'BackgroundColor',LOOK.color.bg,'ForegroundColor',LOOK.color.legend_fg,...
                              'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);

% frames:
set(HANDLES.frame_analysis,   'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls);
set(HANDLES.frame_loadMat,    'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls);
set(HANDLES.frame_predic,     'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls);

% controls: colors:
set(HANDLES.radio_is_serie,   'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.radio_is_ell,     'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.radio_is_station, 'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.radio_is_file,    'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.xlim_i,           'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.xlim,             'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.xlim_e,           'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.add_grids_spect,  'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.hold_spect,       'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.zoom,             'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.load_file,        'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.plot_file,        'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.load_struc,       'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.plot_struc,       'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.plot_data,        'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.fsa,              'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.xout,             'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.lsf,              'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.t_tide,           'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.datenum_s,        'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.datenum_e,        'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.datenum_dt,       'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.predic,           'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.load_grid,        'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.load_station,     'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.contours,         'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.label,            'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.axes_equal,       'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.add_grids_grid,   'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.select,           'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.selectN,          'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.vars,             'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.vlevels,          'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.zlevel,           'BackgroundColor',LOOK.color.controls,'ForegroundColor',LOOK.color.controls_fg);
set(HANDLES.zcheck,           'BackgroundColor',LOOK.color.fig,'ForegroundColor',LOOK.color.controls_fg);

% controls: font
set(HANDLES.radio_is_serie,   'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.radio_is_ell,     'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.radio_is_station, 'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.radio_is_file,    'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.xlim_i,           'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.xlim,             'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.xlim_e,           'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.add_grids_spect,  'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.hold_spect,       'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.zoom,             'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.load_file,        'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.plot_file,        'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.load_struc,       'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.plot_struc,       'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.plot_data,        'fontname',LOOK.fontname,'fontsize',LOOK.fontsize,'FontWeight','bold');
set(HANDLES.fsa,              'fontname',LOOK.fontname,'fontsize',LOOK.fontsize,'FontWeight','bold');
set(HANDLES.xout,             'fontname',LOOK.fontname,'fontsize',LOOK.fontsize,'FontWeight','bold');
set(HANDLES.lsf,              'fontname',LOOK.fontname,'fontsize',LOOK.fontsize,'FontWeight','bold');
set(HANDLES.t_tide,           'fontname',LOOK.fontname,'fontsize',LOOK.fontsize,'FontWeight','bold');
set(HANDLES.datenum_s,        'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.datenum_e,        'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.datenum_dt,       'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.predic,           'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.load_grid,        'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.load_station,     'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.contours,         'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.label,            'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.axes_equal,       'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.add_grids_grid,   'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.select,           'fontname',LOOK.fontname,'fontsize',LOOK.fontsize,'FontWeight','bold');
set(HANDLES.selectN,          'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.vars,             'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.vlevels,          'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.zlevel,           'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);
set(HANDLES.zcheck,           'fontname',LOOK.fontname,'fontsize',LOOK.fontsize);

