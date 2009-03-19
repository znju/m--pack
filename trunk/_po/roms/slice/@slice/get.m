function varargout = get(self,what)
%    GET method for class slice
%    There is no need to call this method... better use
%    subsref

% MMA, martinho@fis.ua.pt
% 21-07-2005

if nargin == 1
  disp(help(mfilename));
  return
end

switch lower(what)
  case 'figure_label'
    if nargout < 2, varargout = {self.figure_label};             else varargout = err('1',nargout); end
  case 'figure_tag'
    if nargout < 2, varargout = {self.figure_label};             else varargout = err('1',nargout); end
  case 'axes_label'
    if nargout < 2, varargout = {self.axes_label};               else varargout = err('1',nargout); end
  case 'axes_tag'
    if nargout < 2, varargout = {self.axes_label};               else varargout = err('1',nargout); end
  case 'axes_ishold'
    if nargout < 2, varargout = {self.axes_ishold};              else varargout = err('1',nargout); end


  case 'echo_load'
    if nargout < 2, varargout = {self.echo_load};                else varargout = err('1',nargout); end

  case 'slice_data'
    if nargout < 2
      varargout = {self.slice_data.v};
    elseif nargout == 3
      varargout(1) = {self.slice_data.x};
      varargout(2) = {self.slice_data.y};
      varargout(3) = {self.slice_data.z};
    elseif nargout == 4;
      varargout(1) = {self.slice_data.x};
      varargout(2) = {self.slice_data.y};
      varargout(3) = {self.slice_data.z};
      varargout(4) = {self.slice_data.v};
    else varargout = err('1 ,3 or 4',nargout); end

  case 'slice_label'
    if nargout < 2, varargout = {self.slice_data.label};         else varargout = err('1',nargout); end
  case 'slice_labelcb'
    if nargout < 2, varargout = {self.slice_data.labelColorbar}; else varargout = err('1',nargout); end
  case 'slice_tag'
    if nargout < 2, varargout = {self.slice_data.tag};           else varargout = err('1',nargout); end
  case 'slice_shading'
    if nargout < 2, varargout = {self.slice_style.shading};      else varargout = err('1',nargout); end
  case 'slice_caxis'
    if nargout < 2, varargout = {self.slice_style.caxis};        else varargout = err('1',nargout); end
  case 'slice_show_colorbar'
    if nargout < 2, varargout = {self.slice_style.colorbar};     else varargout = err('1',nargout); end
  case 'slice_colorbar_label'
    if nargout < 2, varargout = {self.slice_data.labelColorbar}; else varargout = err('1',nargout); end

  case 'slice_cs_ch'
    if nargout == 2
      varargout(1) = {self.slice_data.cont_cs};
      varargout(2) = {self.slice_data.cont_ch};
    else varargout = err('2',nargout); end

  case 'vel_slice_transf'
    if nargout == 3
      varargout(1) = {self.slice_vel.transfx};
      varargout(2) = {self.slice_vel.transfy};
      varargout(3) = {self.slice_vel.transfz};
    else varargout = err('3',nargout); end

  case 'slice_iso_data'
    if nargout == 5
      varargout(1) = {self.slice_iso.edgecolor};
      varargout(2) = {self.slice_iso.edgealpha};
      varargout(3) = {self.slice_iso.facecolor};
      varargout(4) = {self.slice_iso.facealpha};
      varargout(5) = {self.slice_iso.redpatch};
    else varargout = err('5',nargout); end

  case 'slice_info'
    if nargout < 2
      out.file    = self.file;
      out.ind     = self.slice_indice;
      out.time    = self.slice_time;
      out.ind2    = self.slice_indice2;
      out.var     = self.slice_variable;
      out.dim     = self.slice_dim;
      out.dimv    = self.slice_dimv;
      out.type    = self.slice_type;
      out.graph2d = self.slice_2dtype;
      out.graph3d = self.slice_3dtype;
      out.cvals   = self.slice_data.cont_vals;

      out.is2d    = isequal(self.slice_dim,'2d');
      out.is3d    = isequal(self.slice_dim,'3d');
      out.ishoriz = ismember(self.slice_type,{'slicek','slicez'});
      out.isi     = ismember(self.slice_type,{'slicei','slicelon'});
      out.isj     = ismember(self.slice_type,{'slicej','slicelat'});
      out.isvel   = ismember(self.slice_variable,{'vel','velbar'});
      out.isvelbar= isequal(self.slice_variable,'velbar');

      out.isiso   =  isequal(self.slice_type,'sliceiso');

      out.vel_dind  = self.slice_vel.dind;
      out.vel_scale = self.slice_vel.scale;
      out.vel_color = self.slice_vel.color;

      out.iscontour = (out.is2d & isequal(out.graph2d,'contour')) | (out.is3d & isequal(out.graph3d,'contourz'));

      varargout   = {out};
    else varargout = err('1',nargout); end

  case 'limits2d'
    if nargout < 2
      varargout = {[self.slice_limits.xlim self.slice_limits.ylim]}
    elseif nargout == 2
      varargout(1) = {self.slice_limits.xlim};
      varargout(2) = {self.slice_limits.ylim};
    else varargout = err('1 or 2',nargout); end

  case 'limits3d'
    if nargout == 6
      varargout(1) = {self.slice_limits.xlim3d};
      varargout(2) = {self.slice_limits.ylim3d};
      varargout(3) = {self.slice_limits.zlim3d};
      varargout(4) = {self.slice_limits.CameraPosition};
      varargout(5) = {self.slice_limits.CameraTarget};
      varargout(6) = {self.slice_limits.CameraViewAngle};
    else varargout = err('6',nargout); end

  case 'scoord'
    tmp = self.file_scoord;
    if nargout == 4
      for i=1:nargout, varargout(i) = {tmp(i)}; end
    elseif nargout < 2
       out.tts = tmp(1);
       out.ttb = tmp(2);
       out.hc  = tmp(3);
       out.N   = tmp(4);
       varargout = {out};
    else varargout = err('1 or 4',nargout); end

% --------------------------------------------------------------------
% about bathy:
% --------------------------------------------------------------------
  case 'bathy_show'
    if nargout < 2, varargout = {self.bathy_show};  else varargout = err('1',nargout); end
  case 'bathy_data'
    if nargout < 2
      varargout = {self.bathy_data.z};
    elseif nargout == 3;
      varargout(1) = {self.bathy_data.x};
      varargout(2) = {self.bathy_data.y};
      varargout(3) = {self.bathy_data.z};
    else varargout = err('1 or 3',nargout); end

  case 'bathy_cvals'
    if nargout < 2, varargout = {self.bathy_data.vals};   else varargout = err('1',nargout); end
  case 'bathy_cs_ch'
    if nargout == 2
      varargout(1) = {self.bathy_data.cs};
      varargout(2) = {self.bathy_data.ch};
    else varargout = err('2',nargout); end
  case 'bathy_label'
    if nargout < 2, varargout = {self.bathy_data.label};  else varargout = err('1',nargout); end
  case 'bathy_tag'
    if nargout < 2, varargout = {self.bathy_data.tag};    else varargout = err('1',nargout); end
  case 'bathy_labelc'
    if nargout < 2, varargout = {self.bathy_data.labelc}; else varargout = err('1',nargout); end
  case 'bathy_tagc'
    if nargout < 2, varargout = {self.bathy_data.tagc};   else varargout = err('1',nargout); end

  case 'bathy_style_contours'
    if nargout < 2
      out.Color     = self.bathy_style.cont_Color;
      out.LineStyle = self.bathy_style.cont_LineStyle;
      out.LineWidth = self.bathy_style.cont_LineWidth;
      varargout = {out};
    else varargout = err('1',nargout); end
  case 'bathy_style_surface'
    if nargout < 2
      out.FaceColor = self.bathy_style.h_FaceColor;
      out.FaceAlpha = self.bathy_style.h_FaceAlpha;
      out.EdgeColor = self.bathy_style.h_EdgeColor;
      out.EdgeAlpha = self.bathy_style.h_EdgeAlpha;
      varargout = {out};
    else varargout = err('1',nargout); end
  case 'bathy_style_material'
    if nargout < 2, varargout = {self.bathy_style.h_material}; else varargout = err('1',nargout); end

% --------------------------------------------------------------------
% about border:
% --------------------------------------------------------------------
  case 'border_show'
    if nargout < 2, varargout = {self.region_border_show};  else varargout = err('1',nargout); end
  case 'border_data'
    if nargout == 3;
      varargout(1) = {self.region_border_data.x};
      varargout(2) = {self.region_border_data.y};
      varargout(3) = {self.region_border_data.z};
    else varargout = err('1 or 3',nargout); end

  case 'border_label'
    if nargout < 2, varargout = {self.region_border_data.label};  else varargout = err('1',nargout); end
  case 'border_tag'
    if nargout < 2, varargout = {self.region_border_data.tag};    else varargout = err('1',nargout); end

  case 'border_style_line'
    if nargout < 2
      out.Color     = self.region_border_style.Color;
      out.LineStyle = self.region_border_style.LineStyle;
      out.LineWidth = self.region_border_style.LineWidth;
      varargout = {out};
    else varargout = err('1',nargout); end
  case 'border_style_marker'
    if nargout < 2
      out.Marker          = self.region_border_style.Marker;
      out.MarkerSize      = self.region_border_style.MarkerSize;
      out.MarkerEdgeColor = self.region_border_style.MarkerEdgeColor;
      out.MarkerFaceColor = self.region_border_style.MarkerFaceColor;
      varargout = {out};
    else varargout = err('1',nargout); end

% --------------------------------------------------------------------
% about bottom:
% --------------------------------------------------------------------
  case 'bottom_show'
    if nargout < 2, varargout = {self.bottom_show};  else varargout = err('1',nargout); end
  case 'bottom_data'
    if nargout == 3;
      varargout(1) = {self.bottom_data.x};
      varargout(2) = {self.bottom_data.y};
      varargout(3) = {self.bottom_data.h};
    else varargout = err('1 or 3',nargout); end

  case 'bottom_label'
    if nargout < 2, varargout = {self.bottom_data.label};  else varargout = err('1',nargout); end
  case 'bottom_tag'
    if nargout < 2, varargout = {self.bottom_data.tag};    else varargout = err('1',nargout);end

  case 'bottom_style'
    if nargout < 2
      out.Color     = self.bottom_style.Color;
      out.LineStyle = self.bottom_style.LineStyle;
      out.LineWidth = self.bottom_style.LineWidth;
      varargout = {out};
    else varargout = err('1',nargout); end

% --------------------------------------------------------------------
% about coastline:
% --------------------------------------------------------------------
  case 'coastline_show'
    if nargout < 2, varargout = {self.coastline_show};  else varargout = err('1',nargout); end
  case 'coastline_file'
    if nargout < 2, varargout = {self.coastline_file};  else varargout = err('1',nargout); end
  case 'coastline_data'
    if nargout == 2;
      varargout(1) = {self.coastline_data.x};
      varargout(2) = {self.coastline_data.y};
    else varargout = err('2',nargout); end

  case 'coastline_label'
    if nargout < 2, varargout = {self.coastline_data.label};  else varargout = err('1',nargout); end
  case 'coastline_tag'
    if nargout < 2, varargout = {self.coastline_data.tag};    else varargout = err('1',nargout); end

  case 'coastline_style'
    if nargout < 2
      out.Color     = self.coastline_style.Color;
      out.LineStyle = self.coastline_style.LineStyle;
      out.LineWidth = self.coastline_style.LineWidth;
      varargout = {out};
    else varargout = err('1',nargout); end

% --------------------------------------------------------------------
% about mask:
% --------------------------------------------------------------------
  case 'mask_show'
    if nargout < 2, varargout = {self.mask_show};  else varargout = err('1',nargout); end
  case 'mask_data'
    if nargout == 3;
      varargout(1) = {self.mask_data.x};
      varargout(2) = {self.mask_data.y};
      varargout(3) = {self.mask_data.m};
    else varargout = err('1 or 3',nargout); end

  case 'mask_label'
    if nargout < 2, varargout = {self.mask_data.label};  else varargout = err('1',nargout); end
  case 'mask_tag'
    if nargout < 2, varargout = {self.mask_data.tag};    else varargout = err('1',nargout);end

  case 'mask_style_line'
    if nargout < 2
      out.Color     = self.mask_style.Color;
      out.LineStyle = self.mask_style.LineStyle;
      out.LineWidth = self.mask_style.LineWidth;
      varargout = {out};
    else varargout = err('1',nargout); end
  case 'mask_style_marker'
    if nargout < 2
      out.Marker          = self.mask_style.Marker;
      out.MarkerSize      = self.mask_style.MarkerSize;
      out.MarkerEdgeColor = self.mask_style.MarkerEdgeColor;
      out.MarkerFaceColor = self.mask_style.MarkerFaceColor;
      varargout = {out};
    else varargout = err('1',nargout); end


% --------------------------------------------------------------------
% about zeta:
% --------------------------------------------------------------------
  case 'zeta_show'
    if nargout < 2, varargout = {self.zeta_show};  else varargout = err('1',nargout); end
  case 'zeta_data'
    if nargout == 3;
      varargout(1) = {self.zeta_data.x};
      varargout(2) = {self.zeta_data.y};
      varargout(3) = {self.zeta_data.z};
    else varargout = err('3',nargout); end

  case 'zeta_label'
    if nargout < 2, varargout = {self.zeta_data.label};  else varargout = err('1',nargout); end
  case 'zeta_tag'
    if nargout < 2, varargout = {self.zeta_data.tag};    else varargout = err('1',nargout);end

  case 'zeta_style'
    if nargout < 2
      out.Color     = self.zeta_style.Color;
      out.LineStyle = self.zeta_style.LineStyle;
      out.LineWidth = self.zeta_style.LineWidth;
      varargout = {out};
    else varargout = err('1',nargout); end

% --------------------------------------------------------------------
% about labels:
% --------------------------------------------------------------------
  case 'labels_show'
    if nargout < 2, varargout = {self.axes_labels_show};            else varargout = err('1',nargout); end
  case 'labels_label'
    if nargout < 2, varargout = {self.axes_labels.label};           else varargout = err('1',nargout); end
  case 'labels_tag'
    if nargout < 2, varargout = {self.axes_labels.tag};             else varargout = err('1',nargout); end
  case 'xlabel'
    if nargout < 2, varargout = {self.axes_labels.xlabel};          else varargout = err('1',nargout); end
  case 'ylabel'
    if nargout < 2, varargout = {self.axes_labels.ylabel};          else varargout = err('1',nargout); end
  case 'zlabel'
    if nargout < 2, varargout = {self.axes_labels.zlabel};          else varargout = err('1',nargout); end
  case 'xyzlabel'
    if nargout == 3
      varargout(1) = {self.axes_labels.xlabel};
      varargout(2) = {self.axes_labels.ylabel};
      varargout(3) = {self.axes_labels.zlabel};
    else varargout = err('3',nargout); end
  case 'title'
    if nargout < 2, varargout = {self.axes_labels.title};           else varargout = err('1',nargout); end
  case 'cblabel'
    if nargout < 2, varargout = {self.axes_labels.colorbar_ylabel}; else varargout = err('1',nargout); end

% --------------------------------------------------------------------
% otherwise
% --------------------------------------------------------------------
  otherwise
    disp([':: get : Unknown PropertyName : ',what])
    varargout(1:nargout) = {[]};
end

function out = err(in,n)
disp([':: bad number of output arguments (use ',in,')']);
out (1:n) = {[]};

