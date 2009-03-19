function self=subsref(Obj,s)
%   SUBSREF method for class slice
%   See SLICE for help
%
% MMA, martinho@fis.ua.pt
% 24-07-2005

self = Obj;

% using varname:
if isequal(s(1).type,'()')
   varname = s(1).subs{:};
   if length(s) == 1
      % show some variable info:
      varinfo(self,varname);
   elseif length(s) >= 2
      if ismember(s(2).subs,{'slicei','slicej','slicek','slicelon','slicelat','slicez'})
         type = s(2).subs;
         i = 1;
         t = 1;
         i = [];
         t = [];
         if length(s) == 3
            inds = s(3).subs;
            t = inds{1};
            if length(inds) == 2
               i = inds{2};
            end
         end
         res = set(self,'slice_vars',type,varname,t,i);
         if isa(res,'slice'), self = res; else disp(':: error in set slice_vars'); end
         self=runslice(self); return
      end% end slices
   end % len s >2

elseif isequal(s(1).subs,'slice')
  out = get(self,'slice_info');
  file    = out.file;
  type    = out.type;
  i       = out.ind;
  t       = out.time;
  varname = out.var;
  dim     = out.dim;
  graph2d = out.graph2d;
  graph3d = out.graph3d;
  cvals   = out.cvals;
  ish     = get(self,'axes_ishold');
  cax     = get(self,'slice_caxis');
  shad    = get(self,'slice_shading');
  vel_dind  = out.vel_dind;
  vel_scale = out.vel_scale;
  vel_color = out.vel_color;

  [tts,ttb,hc,N]=get(self,'scoord');

  fprintf(1,'\n:: slice, current values :');
  fprintf(1,'\n   file      : %s',file);
  fprintf(1,'\n   var       : %s',varname);
  fprintf(1,'\n   type      : %s',type);
  fprintf(1,'\n   ind       : %g',i);
  fprintf(1,'\n   time      : %g',t);
  fprintf(1,'\n   dim       : %s',dim);
  fprintf(1,'\n   g2        : %s',graph2d);
  fprintf(1,'\n   g3        : %s',graph3d);
  fprintf(1,'\n   caxis     : %s',num2str(cax));
  fprintf(1,'\n   shading   : %s',shad);
  fprintf(1,'\n   cvals     : %g',cvals);
  fprintf(1,'\n   ishold    : %g',ish);
  fprintf(1,'\n   scoord    : %.2f %.2f %.2f %g',tts,ttb,hc,N);
  fprintf(1,'\n   vel dind  : %d %d %d',vel_dind);
  fprintf(1,'\n   vel scale : %f %f %f',vel_scale);
  fprintf(1,'\n   vel color : %s',vel_color);
  fprintf(1,'\n');

elseif isequal(s(1).subs,'coastline')
  file   = get(self,'coastline_file');
  showit = get(self,'coastline_show');
  style  = get(self,'coastline_style');
  fprintf(1,'\n:: coastline : %s\n',[file,' ']);
  fprintf(1,'        show : %g\n',showit);
  disp(struct(style));

elseif isequal(s(1).subs,'limits')
  [xl,yl] = get(self,'limits2d');
  [xl3,yl3,zl3,cp,ct,cv] = get(self,'limits3d');
  fprintf(1,'\n:: limits : \n');
  fprintf(1,'   on 2-D : \n');
  fprintf(1,  '    xlim            :  %f %f',xl);
  fprintf(1,'\n    ylim            :  %f %f',yl);
  fprintf(1,'\n   on 3-D           : \n');
  fprintf(1,  '    xlim            :  %f %f',xl3);
  fprintf(1,'\n    ylim            :  %f %f',yl3);
  fprintf(1,'\n    zlim            :  %f %f',zl3);
  fprintf(1,'\n    CameraPosition  :  %f %f %f',cp);
  fprintf(1,'\n    CameraTarget    :  %f %f %f',ct);
  fprintf(1,'\n    CameraViewAngle :  %f',cv);
  fprintf(1,'\n');

elseif isequal(s(1).subs,'mask')
  showit = get(self,'mask_show');
  stylel = get(self,'mask_style_line');
  stylem = get(self,'mask_style_marker');
  fprintf(1,'\n:: mask :\n');
  fprintf(1,'   show : %g\n\n',showit);
  disp(struct(stylel));
  disp(struct(stylem));

elseif isequal(s(1).subs,'border')
  showit = get(self,'border_show');
  stylel = get(self,'border_style_line');
  stylem = get(self,'border_style_marker');
  fprintf(1,'\n:: region border :\n');
  fprintf(1,'   show : %g\n\n',showit);
  disp(struct(stylel));
  disp(struct(stylem));

elseif isequal(s(1).subs,'zeta')
  showit = get(self,'border_show');
  style = get(self,'zeta_style');
  fprintf(1,'\n:: zeta :\n');
  fprintf(1,'   show : %g\n\n',showit);
  disp(struct(style));

elseif isequal(s(1).subs,'bottom')
  showit = get(self,'bottom_show');
  style = get(self,'bottom_style');
  fprintf(1,'\n:: bottom :\n');
  fprintf(1,'     show : %g\n\n',showit);
  disp(struct(style));

elseif isequal(s(1).subs,'bathy')
  showit = get(self,'bathy_show');
  stylec = get(self,'bathy_style_contours');
  styles = get(self,'bathy_style_surface');
  mat    = get(self,'bathy_style_material');
  fprintf(1,'\n::     bathy :\n');
  fprintf(1,'        show : %g\n\n',showit);
  disp(struct(stylec));
  disp(struct(styles));
  if isstr(mat)
    fprintf(1,'     material: %s\n',mat);
  else
    fprintf(1,'     material: %s\n',num2str(mat));
  end

elseif isequal(s(1).subs,'grd')
  figure
  self = runslice(self,'noslice');

elseif isequal(s(1).subs,'mr')
  out   = get(self,'slice_info');
  file  = out.file;
  figure
  show_mask(file);

elseif isequal(s(1).subs,'redo')
  self = runslice(self);
else
  disp([':: unknown option ',s(1).subs])
end
