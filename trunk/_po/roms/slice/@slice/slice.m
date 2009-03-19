function self = slice(file)
%   SLICE  Object constructor for the slice class
%   sc = slice(filename);
%   sc = slice;
%
%   make one slice:
%   sc.sliceType = {varname,time,ind,options};
%   sliceType = slicei, j, k, lon, lat, z and iso
%
%   --> options:
%       1) for currents: varname = vel or velbar (use ubar and vbar)
%          [dx [dy [dz]]]
%          [scaleu [scalev [scalew]]]
%          color, if none CData of speed is used
%          ps: ind not needed if velbar
%       2) for isoslices:
%          [FaceColor, [FaceAlpha, [EdgeColo,r [EdgeAlpha, [reduce patch]]]]
%
%   --> to know:
%       1) to use currents over something else (hold is on)
%       the arrows should be the last and the option color shold be used
%
% :: slice related ::
% ----------------------------
% show current values:
%     sc.slice;
%
% change current values:
% (the option with {val} mean that the figure will not be redrawn
% and values will be only stored)
%  time indice:
%     sc.time = val; sc.time = {val}; % set new time index
%     sc.inct = val; sc.inct = {val}; % increse/decrease time index
%  slice indice:
%     sc.ind  = val;  sc.ind = {val};
%     sc.inci = val; sc.inci = {val}; % increse/decrease slice index
%  slice type:
%     sc.type = SliceType; sc.type = {SliceType};
%  slice variable:
%     sc.var  = varname; sc.var = {varname}:
%  slice dim (val=2,3, for 2d or 3d output):
%     sc.dim = val; sc.dim = {val};
%  slice output graphic type:
%     sc.g2 = type; sc.g2 = {type};  for 2d output: pcolor  or contour
%     sc.g3 = type; sc.g3 = {type};  for 3d output: surf or contourz
%  slice caxis:
%     sc.caxis = val; sc.caxis = []; if empty, the default is used
%  slice surfaces shading:
%     sc.shading = val; (interp, flat or faceted)
%  slice contour values:
%     sc.cvals = val; sc.cvals = {val};
%  slice clabels:
%     sc.clabel = val; (manual, man, labelspacing number)
%  slice hold on/off:
%     sc.hold = 0/1;
%  slice s-coordinates values:
%     sc.scoord = [theta_s theta_b hc]; sc.scoord = [];
%     if empty, the default (from file) is used
%
%
% :: axes limits and camera ::
% ----------------------------
% show current values:
%     sc.limits;
%
% set new values:
%     sc.limits = 'get'; get current values
%     sc.limits = [];    set limits auto
%     sc.limits = 'set';  set limits as the stored ones
%
% :: coastline related ::
% ----------------------------
% show current values:
%     sc.coastline;
%
% load new one:
%     sc.coastline = filename; sc.coastline = 'load';
%
% show/hide coastline:
%     sc.show_coastline = 0/1;
%
% set coastline properties:
%    sc.set_coastline = {PropName,PropValue}
%    PropName = color, linestyle, linewidth
%
% :: mask related ::
% ----------------------------
% show current values:
%    sc.mask;
%
% show/hide mask:
%    sc.show_mask = 0/1;
%
% set mask properties:
%    sc.set_mask = {PropName,PropValue}
%    PropName = color, linestyle, linewidth, marker, markersize,
%              markeredgecolor, markerfacecolor
%
% :: region border related ::
% ----------------------------
% show current values:
%    sc.border;
%
% show/hide region border:
%    sc.show_border = 0/1;
%
% set region border properties:
%    sc.set_border = {PropName,PropValue}
%    PropName = color, linestyle, linewidth, marker, markersize,
%               markeredgecolor, markerfacecolor
%
% :: zeta related ::
% ----------------------------
% show current values:
%    sc.zeta;
%
% show/hide zeta:
%    sc.show_zeta = 0/1;
%
% set zeta properties:
%    sc.set_zeta = {PropName,PropValue}
%    PropName = color, linestyle, linewidth
%
% :: bottom related ::
% ----------------------------
% show current values:
%    sc.zeta;
%
% show/hide bottom:
%    sc.show_bottom = 0/1;
%
% set bottom properties:
%    sc.set_bottom = {PropName,PropValue}
%    PropName = color, linestyle, linewidth
%
% :: bathy related ::
% ----------------------------
% show current values:
%    sc.bathy;
%
% show/hide bathy:
%    sc.show_bathy = 0/1;
%
% bathy contour values:
%    sc.bathy_vals = val;
%
% bathy clabels:
%    sc.clabelh = val; (manual, man, labelspacing number)
%
% set bathy properties:
%    sc.set_bathy = {PropName,PropValue}
%    PropName = color, linestyle, linewidth, marker, markersize,
%               markeredgecolor, markerfacecolor, material
%
%
% ********************************************************************
%
%   Created by Martinho Marta Almeida
%   Phys. Dep, Univ. of Aveiro, Portugal
%   August 2005
%   For an easy tutorial check the site:
%   http://neptuno.fis.ua.pt/~mma
%   For any question use the email:
%   martinho@fis.ua.pt
%
%   For a demo, run:
%   slice('demo')
%
%   notice: if you find problems with opengl do not use the bathy
%   edgealpha property.
%   For that you can edit this file or execute:
%
%   sc.set_bathy = {'edgealpha','default'}

if nargin == 1
  if isequal(file,'demo')
    runslicedemo
    self = [];
    return
  end
end

if nargin == 0
    [filename, pathname] = uigetfile('*', 'Pick the file');
    if isequal(filename,0) | isequal(pathname,0)
        self=[];
        return
    else
        file=fullfile(pathname, filename);
    end
end

if isa(file,'slice')
    self = file;
else
    % check file:
    if exist(file,'file')

        % file
        self.file                                = file                   ;

        % figure:
        self.figure_label                        = 'slice figure'         ;
        self.figure_tag                          = ''                     ;

        % axes:
        self.axes_label                          = 'slice axes'           ;
        self.axes_tag                            = ''                     ;
        self.axes_ishold                         = 0                      ;


        % debug:
        self.echo_load                           = 0                      ;

        % about s coordinates:
        [tts, ttb, hc, n] = s_params(file)                                ;
        self.file_scoord  = [tts ttb hc n]                                ;

        % about slice:
        self.slice_type                          = ''                     ;
        self.slice_indice                        = []                     ;
        self.slice_time                          = []                     ;
        self.slice_indice2                       = []                     ;
        self.slice_variable                      = ''                     ;
        self.slice_dim                           = '2d'                   ;
        self.slice_dimv                          = []                     ;
        self.slice_2dtype                        = 'pcolor'               ;
        self.slice_3dtype                        = 'surf'                 ;
        % data:
        self.slice_data.label                    = 'the slice'            ;
        self.slice_data.labelColorbar            = 'slice colorbar'       ;
        self.slice_data.tag                      = []                     ;
        self.slice_data.x                        = []                     ;
        self.slice_data.y                        = []                     ;
        self.slice_data.z                        = []                     ;
        self.slice_data.v                        = []                     ;
        self.slice_data.cont_vals                = 5                      ;
        self.slice_data.cont_cs                  = []                     ;
        self.slice_data.cont_ch                  = []                     ;
        % style:
        self.slice_style.shading                 = 'interp'               ;
        self.slice_style.caxis                   = []                     ;
        self.slice_style.colorbar                = 1                      ;
        % limits:
        self.slice_limits.xlim                   = []                     ;
        self.slice_limits.ylim                   = []                     ;
        self.slice_limits.CameraPosition         = []                     ;
        self.slice_limits.CameraTarget           = []                     ;
        self.slice_limits.CameraViewAngle        = []                     ;
        self.slice_limits.xlim3d                 = []                     ;
        self.slice_limits.ylim3d                 = []                     ;
        self.slice_limits.zlim3d                 = []                     ;
        % currents:
        self.slice_vel.dind                      = [1 1 1]                ;
        self.slice_vel.scale                     = [1 1 1]                ;
        self.slice_vel.color                     = []                     ;
        self.slice_vel.transfx                   = [1 0 0]                ;
        self.slice_vel.transfy                   = [1 0 0]                ;
        self.slice_vel.transfz                   = [1 0 0]                ;
        % iso slices:
        self.slice_iso.edgecolor                 = 'none'                 ;
        self.slice_iso.edgealpha                 = 1;                     ;
        self.slice_iso.facecolor                 = 'b'                    ;
        self.slice_iso.facealpha                 = 1                      ;
        self.slice_iso.redpatch                  = []                     ;


        % about labels:
        self.axes_labels_show                    = 1                      ;
        self.axes_labels.xlabel                  = ''                     ;
        self.axes_labels.ylabel                  = ''                     ;
        self.axes_labels.zlabel                  = ''                     ;
        self.axes_labels.title                   = ''                     ;
        self.axes_labels.colorbar_ylabel         = ''                     ;
        self.axes_labels.label                   = 'slice labels'         ;
        self.axes_labels.tag                     = ''                     ;

        % about bottom:
        self.bottom_show                         = 1                      ;
        self.bottom_data.x                       = []                     ;
        self.bottom_data.y                       = []                     ;
        self.bottom_data.h                       = []                     ;
        self.bottom_data.label                   = 'slice bottom'         ;
        self.bottom_data.tag                     = []                     ;
        self.bottom_style.Color                  = 'default'              ;
        self.bottom_style.LineStyle              = 'default'              ;
        self.bottom_style.LineWidth              = 'default'              ;

        % about bathy:
        self.bathy_show                          = 1                      ;
        self.bathy_data.vals                     = 2                      ;
        self.bathy_data.cs                       = []                     ;
        self.bathy_data.ch                       = []                     ;
        self.bathy_data.x                        = []                     ;
        self.bathy_data.y                        = []                     ;
        self.bathy_data.z                        = []                     ;
        self.bathy_data.label                    = 'slice bathy'          ;
        self.bathy_data.labelc                   = 'slice bathy contours' ;
        self.bathy_data.tag                      = []                     ;
        self.bathy_data.tagc                     = []                     ;
        self.bathy_style.cont_Color              = 'default'              ;
        self.bathy_style.cont_LineStyle          = 'default'              ;
        self.bathy_style.cont_LineWidth          = 'default'              ;
        self.bathy_style.h_FaceColor             = 'green'                ;
        self.bathy_style.h_FaceAlpha             = 'default'              ;
        self.bathy_style.h_EdgeColor             = 'white'                ;
      % self.bathy_style.h_EdgeAlpha             =  'default'             ;
        self.bathy_style.h_EdgeAlpha             = 0.2                    ;
        self.bathy_style.h_material              = 'default'              ;

        % about zeta:
        self.zeta_show                           = 1                      ;
        self.zeta_data.x                         = []                     ;
        self.zeta_data.y                         = []                     ;
        self.zeta_data.z                         = []                     ;
        self.zeta_data.label                     = 'slice zeta'           ;
        self.zeta_data.tag                       = []                     ;
        self.zeta_style.Color                    = 'default'              ;
        self.zeta_style.LineStyle                = 'default'              ;
        self.zeta_style.LineWidth                = 'default'              ;

        % about mask:
        self.mask_show                           = 1                      ;
        self.mask_data.x                         = []                     ;
        self.mask_data.y                         = []                     ;
        self.mask_data.m                         = []                     ;
        self.mask_data.label                     = 'slice mask'           ;
        self.mask_data.tag                       = []                     ;
        self.mask_style.Color                    = 'default'              ;
        self.mask_style.LineStyle                = 'default'              ;
        self.mask_style.LineWidth                = 'default'              ;
        self.mask_style.Marker                   = '+'                    ;
        self.mask_style.MarkerSize               = 'default'              ;
        self.mask_style.MarkerEdgeColor          = 'r'                    ;
        self.mask_style.MarkerFaceColor          = 'default'              ;

        % region border:
        self.region_border_show                  = 1                      ;
        self.region_border_data.x                = []                     ;
        self.region_border_data.y                = []                     ;
        self.region_border_data.z                = []                     ;
        self.region_border_data.label            = 'slice region border'  ;
        self.region_border_data.tag              = []                     ;
        self.region_border_style.Color           = 'r'                    ;
        self.region_border_style.LineStyle       = 'default'              ;
        self.region_border_style.LineWidth       = 'default'              ;
        self.region_border_style.Marker          = ':'                    ;
        self.region_border_style.MarkerSize      = 'default'              ;
        self.region_border_style.MarkerEdgeColor = 'r'                    ;
        self.region_border_style.MarkerFaceColor = 'default'              ;

        % about coastline:
        self.coastline_show                      = 1                      ;
        self.coastline_file                      = []                     ;
        self.coastline_data.x                    = []                     ;
        self.coastline_data.y                    = []                     ;
        self.coastline_data.label                = 'slice coastline'      ;
        self.coastline_data.tag                  = []                     ;
        self.coastline_style.Color               = 'default'              ;
        self.coastline_style.LineStyle           = 'default'              ;
        self.coastline_style.LineWidth           = 'default'              ;

        self = class(self,'slice');
    else
        disp([':: file ',file,' not found'])
        self = [];
    end
end
