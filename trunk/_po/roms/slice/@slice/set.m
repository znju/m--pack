function varargout = set(self,varargin)
%    SET method for class slice
%    There is no need to call this method... better use
%    subsasgn

% MMA, martinho@fis.ua.pt
% 21-07-2005

if nargin == 1
  disp(help(mfilename));
  return
end

if nargout == 0
  disp(':: output argument is required')
  return
elseif nargout > 1
  disp(':: use 1 output argument')
  varargout(1:nargout)={[]};
  return
end

vin = varargin(2:end);
nin = length(vin);

switch lower(varargin{1})
  case 'figure_tag'
    if nin == 1,  self.figure_tag = vin{1};      else err('1'), return, end
  case 'axes_tag'
    if nin == 1,  self.axes_tag = vin{1};        else err('1'), return, end
  case 'axes_ishold'
    if nin == 1,  self.axes_ishold = vin{1};     else err('1'), return, end


  case 'echo_load'
    if nin == 1,  self.echo_load = vin{1};       else err('1'), return, end

  case 'vel_vars'
    if nin == 3
      self.slice_vel.dind  = vin{1};
      self.slice_vel.scale = vin{2};
      self.slice_vel.color = vin{3};
    else err('3'), return, end
  case 'vel_slice_transf'
    if nin == 3
      self.slice_vel.transfx = vin{1};
      self.slice_vel.transfy = vin{2};
      self.slice_vel.transfz = vin{3};
    else err('3'), return, end

  case 'slice_iso_data'
    if nin == 5
      self.slice_iso.edgecolor = vin{1};
      self.slice_iso.edgealpha = vin{2};
      self.slice_iso.facecolor = vin{3};
      self.slice_iso.facealpha = vin{4};
      self.slice_iso.redpatch  = vin{5};
    else err('5'), return, end

  case 'slice_vars'
    if nin == 4
      self.slice_type     = vin{1};
      self.slice_variable = vin{2};
      self.slice_time     = vin{3};
      self.slice_indice   = vin{4};
    else err('4'), return, end
  case 'slice_data'
    if nin == 4
      self.slice_data.x = vin{1};
      self.slice_data.y = vin{2};
      self.slice_data.z = vin{3};
      self.slice_data.v = vin{4};
     else err('4'), return, end
  case 'slice_tag'
    if nin == 1,  self.slice_data.tag = vin{1};       else err('1'), return, end
  case 'indice'
    if nin == 1,  self.slice_indice   = vin{1};       else err('1'), return, end
  case 'indice2'
    if nin == 1,  self.slice_indice2  = vin{1};       else err('1'), return, end
  case 'time'
    if nin == 1,  self.slice_time     = vin{1};       else err('1'), return, end
  case 'variable'
    if nin == 1,  self.slice_variable = vin{1};       else err('1'), return, end
  case 'dim'
    if nin == 1,  self.slice_dim      = vin{1};       else err('1'), return, end
  case 'dimv'
    if nin == 1,  self.slice_dimv     = vin{1};       else err('1'), return, end
  case 'type'
    if nin == 1,  self.slice_type     = vin{1};       else err('1'), return, end
  case 'graph2d'
    if nin == 1,  self.slice_2dtype   = vin{1};       else err('1'), return, end
  case 'graph3d'
    if nin == 1,  self.slice_3dtype   = vin{1};       else err('1'), return, end
  case 'cvals'
    if nin == 1,  self.slice_data.cont_vals = vin{1}; else err('1'), return, end
  case 'slice_cs_ch'
    if nin == 2
      self.slice_data.cont_cs   = vin{1};
      self.slice_data.cont_ch   = vin{2};
    else err('2'), return, end
  case 'slice_shading'
    if nin == 1,  self.slice_style.shading  = vin{1}; else err('1'), return, end
  case 'slice_caxis'
    if nin == 1,  self.slice_style.caxis    = vin{1}; else err('1'), return, end
  case 'colorbar'
    if nin == 1,  self.slice_style.colorbar = vin{1}; else err('1'), return, end
  case 'limits2d'
    if nin == 1 & isempty(vin{1})
      self.slice_limits.xlim = [];
      self.slice_limits.ylim = [];
    elseif nin == 2
      self.slice_limits.xlim = vin{1};
      self.slice_limits.ylim = vin{2};
    else err('2, length=2'), return, end
  case 'limits3d'
    if nin == 1 & isempty(vin{1})
      self.slice_limits.CameraPosition  = [];
      self.slice_limits.CameraTarget    = [];
      self.slice_limits.CameraViewAngle = [];
      self.slice_limits.xlim3d          = [];
      self.slice_limits.ylim3d          = [];
      self.slice_limits.zlim3d          = [];
    elseif nin == 6
      self.slice_limits.xlim3d          = vin{1};
      self.slice_limits.ylim3d          = vin{2};
      self.slice_limits.zlim3d          = vin{3};
      self.slice_limits.CameraPosition  = vin{4};
      self.slice_limits.CameraTarget    = vin{5};
      self.slice_limits.CameraViewAngle = vin{6};
    else err('6, 3*length=1 +3*length=2'), return, end

  case 'scoord'
    if  nin == 4
      self.file_scoord = [vin{1}(1) vin{2}(1) vin{3}(1) vin{4}(1)];
    elseif nin == 3
      self.file_scoord(1:3) =  [vin{1}(1) vin{2}(1) vin{3}(1)];
    elseif nin == 1 & length(vin{1}) == 4
      self.file_scoord = vin{1};
    else err('1 (length=4) or 3 or 4'), return, end

% --------------------------------------------------------------------
% about bathy:
% --------------------------------------------------------------------
  case 'bathy_show'
   if nin == 1, self.bathy_show                  =  vin{1}; else err('1'), return, end
  case 'bathy_data'
    if nin == 3
      self.bathy_data.x = vin{1};
      self.bathy_data.y = vin{2};
      self.bathy_data.z = vin{3};
    else err('1'), return, end
  case 'bathy_cvals'
    if nin == 1, self.bathy_data.vals            =  vin{1}; else err('1'), return, end
  case 'bathy_cs_ch'
    if nin == 2
      self.bathy_data.cs   = vin{1};
      self.bathy_data.ch   = vin{2};
    else err('2'), return, end
  case 'bathy_tag'
    if nin == 1, self.bathy_data.tag             =  vin{1}; else err('1'), return, end
  case 'bathy_tagc'
    if nin == 1, self.bathy_data.tagc            =  vin{1}; else err('1'), return, end
  case 'bathy_color'
    if nin == 1, self.bathy_style.cont_Color     =  vin{1}; else err('1'), return, end
  case 'bathy_linestyle'
    if nin == 1, self.bathy_style.cont_LineStyle =  vin{1}; else err('1'), return, end
  case 'bathy_linewidth'
    if nin == 1, self.bathy_style.cont_LineWidth =  vin{1}; else err('1'), return, end
  case 'bathy_facecolor'
    if nin == 1, self.bathy_style.h_FaceColor    =  vin{1}; else err('1'), return, end
  case 'bathy_facealpha'
    if nin == 1, self.bathy_style.h_FaceAlpha    =  vin{1}; else err('1'), return, end
  case 'bathy_edgecolor'
    if nin == 1, self.bathy_style.h_EdgeColor    =  vin{1}; else err('1'), return, end
  case 'bathy_edgealpha',
    if nin == 1, self.bathy_style.h_EdgeAlpha    =  vin{1}; else err('1'), return, end
  case 'bathy_material'
    if nin == 1, self.bathy_style.h_material     =  vim{1}; else err('1'), return, end

% --------------------------------------------------------------------
% about border:
% --------------------------------------------------------------------
  case 'border_show'
    if nin == 1, self.region_border_show                  =  vin{1}; else err('1'), return, end
  case 'border_data'
    if nin == 3
      self.region_border_data.x = vin{1};
      self.region_border_data.y = vin{2};
      self.region_border_data.z = vin{3};
    else err('1'), return, end
  case 'border_tag'
    if nin == 1, self.region_border_data.tag              =  vin{1}; else err('1'), return, end
  case 'border_color'
    if nin == 1, self.region_border_style.Color           =  vin{1}; else err('1'), return, end
  case 'border_linestyle'
    if nin == 1, self.region_border_style.LineStyle       =  vin{1}; else err('1'), return, end
  case 'border_linewidth'
    if nin == 1, self.region_border_style.LineWidth       =  vin{1}; else err('1'), return, end
  case 'border_marker'
    if nin == 1, self.region_border_style.Marker          =  vin{1}; else err('1'), return, end
  case 'border_markersize'
    if nin == 1, self.region_border_style.MarkerSize      =  vin{1}; else err('1'), return, end
  case 'border_markeredgecolor'
    if nin == 1, self.region_border_style.MarkerEdgeColor =  vin{1}; else err('1'), return, end
  case 'border_markerfacecolor'
    if nin == 1, self.region_border_style.MarkerFaceColor =  vin{1}; else err('1'), return, end

% --------------------------------------------------------------------
% about bottom:
% --------------------------------------------------------------------
  case 'bottom_show'
    if nin == 1, self.bottom_show            =  vin{1}; else err('1'), return, end
  case 'bottom_data'
    if nin == 3
      self.bottom_data.x = vin{1};
      self.bottom_data.y = vin{2};
      self.bottom_data.h = vin{3};
    else err('3'), return, end
  case 'bottom_tag'
    if nin == 1, self.bottom_data.tag        =  vin{1}; else err('1'), return, end
  case 'bottom_color'
    if nin == 1, self.bottom_style.Color     =  vin{1}; else err('1'), return, end
  case 'bottom_linestyle'
    if nin == 1, self.bottom_style.LineStyle =  vin{1}; else err('1'), return, end
  case 'bottom_linewidth'
    if nin == 1, self.bottom_style.LineWidth =  vin{1}; else err('1'), return, end

% --------------------------------------------------------------------
% about coastline:
% --------------------------------------------------------------------
  case 'coastline_show'
    if nin == 1, self.coastline_show            =  vin{1}; else err('1'), return, end
  case 'coastline_file'
    if nin == 1, self.coastline_file            =  vin{1}; else err('1'), return, end
  case 'coastline_data'
    if nin == 2
      self.coastline_data.x = vin{1};
      self.coastline_data.y = vin{2};
    else err('2'), return, end
  case 'coastline_tag'
    if nin == 1, self.coastline_data.tag        =  vin{1}; else err('1'), return, end
  case 'coastline_color'
    if nin == 1, self.coastline_style.Color     =  vin{1}; else err('1'), return, end
  case 'coastline_linestyle'
    if nin == 1, self.coastline_style.LineStyle =  vin{1}; else err('1'), return, end
  case 'coastline_linewidth'
    if nin == 1, self.coastline_style.LineWidth =  vin{1}; else err('1'), return, end

% --------------------------------------------------------------------
% about mask:
% --------------------------------------------------------------------
  case 'mask_show'
    if nin == 1, self.mask_show            =  vin{1}; else err('1'), return, end
  case 'mask_data'
    if nin == 3
      self.mask_data.x = vin{1};
      self.mask_data.y = vin{2};
      self.mask_data.m = vin{3};
    else err('3'), return, end
  case 'mask_tag'
    if nin == 1, self.mask_data.tag              =  vin{1}; else err('1'), return, end
  case 'mask_color'
    if nin == 1, self.mask_style.Color           =  vin{1}; else err('1'), return, end
  case 'mask_linestyle'
    if nin == 1, self.mask_style.LineStyle       =  vin{1}; else err('1'), return, end
  case 'mask_linewidth'
    if nin == 1, self.mask_style.LineWidth       =  vin{1}; else err('1'), return, end
  case 'mask_marker'
    if nin == 1, self.mask_style.Marker          =  vin{1}; else err('1'), return, end
  case 'mask_markersize'
    if nin == 1, self.mask_style.MarkerSize      =  vin{1}; else err('1'), return, end
  case 'mask_markeredgecolor'
    if nin == 1, self.mask_style.MarkerEdgeColor =  vin{1}; else err('1'), return, end
  case 'mask_markerfacecolor'
    if nin == 1, self.mask_style.MarkerFaceColor =  vin{1}; else err('1'), return, end


% --------------------------------------------------------------------
% about zeta:
% --------------------------------------------------------------------
  case 'zeta_show'
    if nin == 1, self.zeta_show            =  vin{1}; else err('1'), return, end
  case 'zeta_data'
    if nin == 3
      self.zeta_data.x = vin{1};
      self.zeta_data.y = vin{2};
      self.zeta_data.z = vin{3};
    else err('3'), return, end
  case 'zeta_tag'
    if nin == 1, self.zeta_data.tag        =  vin{1}; else err('1'), return, end
  case 'zeta_color'
    if nin == 1, self.zeta_style.Color     =  vin{1}; else err('1'), return, end
  case 'zeta_linestyle'
    if nin == 1, self.zeta_style.LineStyle =  vin{1}; else err('1'), return, end
  case 'zeta_linewidth'
    if nin == 1, self.zeta_style.LineWidth =  vin{1}; else err('1'), return, end

% --------------------------------------------------------------------
% about labels:
% --------------------------------------------------------------------
  case 'labels_show'
    if nin == 1, self.axes_labels_show            =  vin{1}; else err('1'), return, end
  case 'labels_tag'
    if nin == 1, self.axes_labels.tag             =  vin{1}; else err('1'), return, end
  case 'xlabel'
    if nin == 1, self.axes_labels.xlabel          =  vin{1}; else err('1'), return, end
  case 'ylabel'
    if nin == 1, self.axes_labels.ylabel          =  vin{1}; else err('1'), return, end
  case 'zlabel'
    if nin == 1, self.axes_labels.zlabel          =  vin{1}; else err('1'), return, end
  case 'xyzlabel'
    if nin == 3
      self.axes_labels.xlabel = vin{1};
      self.axes_labels.ylabel = vin{2};
      self.axes_labels.zlabel = vin{3};
    else err('3'), return, end      
  case 'title'
    if nin == 1, self.axes_labels.title           =  vin{1}; else err('1'), return, end
  case 'cblabel'
    if nin == 1, self.axes_labels.colorbar_ylabel =  vin{1}; else err('1'), return, end

% --------------------------------------------------------------------
% otherwise
% --------------------------------------------------------------------
  otherwise
    disp([':: set : Unknown PropertyName : ',varargin{1}])
end

varargout = {self};

function err(in)
disp([':: bad number of input variables (use ',in,')']);
