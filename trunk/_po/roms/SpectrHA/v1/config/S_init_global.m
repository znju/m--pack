function S_init_global(var)
%function S_init_global(var)
%Init globalvariables
%set null global variable var, or all if nargin==0:
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FGRID FSTA LOOK FLOAD ELLIPSE ETC

if nargin == 0
  var='';
end

%--------------------------------------------------------------------

if nargin == 0 | strcmp(var,'FGRID')

FGRID.name='';
FGRID.contours=[];
FGRID.contour_values=[];
FGRID.hmin=[];

end
if nargin == 0 | strcmp(var,'FSTA')

FSTA.name='';
FSTA.current=[];
FSTA.selected=[];
FSTA.i=[];
FSTA.positions=[];
FSTA.nlevels=[];
FSTA.interval=[];
FSTA.type='';
FSTA.lat=[];

end
if nargin == 0 | strcmp(var,'LOOK')

LOOK.color.grid_axes=[];
LOOK.color.spectrum_axes=[];
LOOK.color.mask=[];
LOOK.color.bg=[];
LOOK.color.fig=[];
LOOK.color.controls=[];
LOOK.color.controls_fg=[];
LOOK.color.labels=[];
LOOK.color.xlabel_grid=[];
LOOK.color.legend_fg=[];
LOOK.color.plot_axis=[];
LOOK.color.coastline=[];
LOOK.color.mask_line=[];
LOOK.color.plot=[];
LOOK.color.contours=[];
LOOK.color.clabel_marker=[];
LOOK.color.clabel_label=[];
LOOK.fontsize=[];
LOOK.fontname='';
LOOK.marker.select='';
LOOK.marker.file='';
LOOK.marker.struc='';
LOOK.marker.plotit='';
LOOK.marker.stations='';
LOOK.markerColor.select=[];
LOOK.markerColor.file=[];
LOOK.markerColor.struc=[];
LOOK.markerColor.plotit=[];
LOOK.markerColor.stations=[];
LOOK.markerColorOld.select=[];
LOOK.markerColorOld.file=[];
LOOK.markerColorOld.struc=[];
LOOK.markerSize.select=[];
LOOK.markerSize.file=[];
LOOK.markerSize.struc=[];
LOOK.markerSize.plotit=[];
LOOK.markerSize.stations=[];
LOOK.defaultEllipseColor=[];
end
if nargin == 0 | strcmp(var,'FLOAD')

FLOAD.name='';
FLOAD.current=[];
FLOAD.position=[];
FLOAD.serie=[];
FLOAD.interval=[];
FLOAD.dim=[];
FLOAD.start_time=[];

end
if nargin == 0 | strcmp(var,'ELLIPSE')

ELLIPSE.name='';
ELLIPSE.position=[];
ELLIPSE.tidestruc=[];
ELLIPSE.current=[];
ELLIPSE.color=[];

end
if nargin == 0 | strcmp(var,'ETC')

ETC.plotit=[];
ETC.ellipse=[];
ETC.legend='';
ETC.default_xlim=[];
ETC.tidestruc=[];
ETC.tidestruc_origin=''; % lsf, t_tide or fsa (if fsa, cant be used in t_predic)
ETC.datenum.end=[];
ETC.datenum.dt=[];
ETC.plotted='';  % use 'series', 'ellipse', 'fsa', 'LeastSquares'
ETC.netcdf_ext='';
ETC.logname='';
ETC.handles.plot_axis=[];
ETC.handles.coastline=[];
ETC.handles.mask_line=[];
ETC.handles.plot=[];
ETC.handles.contours=[];
ETC.handles.clabel_marker=[];
ETC.handles.clabel_label=[];
ETC.release_t1=[];
ETC.release_t2=[];
ETC.txt_head=[];

end


