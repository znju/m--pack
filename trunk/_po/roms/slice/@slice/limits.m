function self = limits(Obj,value,ax)
%   LIMITS method for class slice
%   Controls the axes limits and camera properties of the
%   desired axes

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

out  = get(self,'slice_info');
is2d = out.is2d;
is3d = out.is3d;

if nargin < 3
  ax = gca;
end
axes(ax);

if isempty(value)
  axis normal
  axis auto
  % delete limits:
  if is2d
    res = set(self,'limits2d',[]);
    if isa(res,'slice'), self = res; else disp(':: error in set limits2d'); end
  elseif is3d
    res = set(self,'limits3d',[]);
    if isa(res,'slice'), self = res; else disp(':: error in set limits3d'); end
  end

elseif isequal(value,'auto')
  axis normal
  axis auto

elseif isnumeric(value)
  if is2d
    if isnumber(value,4)
      eval('xlim(value(1:2));','disp(''::bad value for xlim'')')
      eval('ylim(value(3:4));','disp(''::bad value for ylim'')')
    else
      disp(':: use [xlim ylim]')
    end

  elseif is3d
    if isnumber(value,3)
      eval('set(ax,''CameraPosition'',  value(1));','disp(''::bad value for CameraPosition'');'  );
      eval('set(ax,''CameraTarget'',    value(2));','disp(''::bad value for CameraTarget'');'    );
      eval('set(ax,''CameraViewAngle'', value(3));','disp(''::bad value for CameraViewAngle'');' );
    elseif isnumber(value,6)
      eval('xlim(value(1:2));','disp(''::bad value for xlim'')')
      eval('ylim(value(3:4));','disp(''::bad value for ylim'')')
      eval('zlim(value(5:6));','disp(''::bad value for zlim'')')
    else
      disp(':: use [CameraPosition CameraTarget CameraViewAngle] or [xlim ylim zlim]')
    end
  end

elseif isequal(value,'get')
  % get and store:
  if is2d
    res = set(self,'limits2d',xlim,ylim);
    if isa(res,'slice'), self = res; else disp(':: error in set limits2d'); end
  elseif is3d
    xl = xlim;
    yl = ylim;
    zl = zlim;
    cp = get(ax,'CameraPosition');
    ct = get(ax,'CameraTarget');
    cv = get(ax,'CameraViewAngle');
    res = set(self,'limits3d',xl,yl,zl,cp,ct,cv);
    if isa(res,'slice'), self = res; else disp(':: error in set limits3d'); end
  end

elseif isequal(value,'set')
  axis normal
  axis auto
  if is2d
    [xl,yl] = get(self,'limits2d');
    if isempty(xl) | isempty(yl)
      self = limits(self,'nice');
    else
      evalc('xlim(xl);','');
      evalc('ylim(yl);','');
    end
  elseif is3d
    [xl,yl,zl,cp,ct,cv] = get(self,'limits3d');
    if any([isempty(xl),isempty(yl),isempty(xl),isempty(zl),isempty(cp),isempty(ct),isempty(cv)])
      self = limits(self,'nice');
    else
      evalc('xlim(xl);','');
      evalc('ylim(yl);','');
      evalc('zlim(zl);','');
      evalc('set(ax,''CameraPosition'',  cp  );','');
      evalc('set(ax,''CameraTarget'',    ct  );','');
      evalc('set(ax,''CameraViewAngle'', cv  );','');
    end
  end

elseif isequal(value,'nice')
  if is2d
    %axis tight
    axis_tight(ax,2)
    xl = xlim; dx = xl(2)-xl(1); dx = dx/40;
    yl = ylim; dy = yl(2)-yl(1); dy = dy/40;
    xl=[xl(1)-dx xl(2)+dx];
    yl=[yl(1)-dy yl(2)+dy];
    xlim(xl);
    ylim(yl);
  elseif is3d
    axis_tight(ax,3)
    xl = xlim; dx = xl(2)-xl(1); dx = dx/20;
    yl = ylim; dy = yl(2)-yl(1); dy = dy/20;
    zl = zlim; dz = zl(2)-zl(1); dz = dz/20;
    xl=[xl(1)-dx xl(2)+dx];
    yl=[yl(1)-dy yl(2)+dy];
    zl=[zl(1)-dz zl(2)+dz];
    xlim(xl);
    ylim(yl);
    zlim(zl);
  end

else
  disp(':: bad value for limits');
end

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end

function axis_tight(ax,dim)
if nargin == 1, dim = 3; end
[x1,x2,y1,y2,z1,z2] = range_on_axis(ax,'clipping','on');
if dim == 2,
  axis([x1 x2 y1 y2]);
else
  axis([x1 x2 y1 y2 z1 z2]);
end
% all this is needed cos of matlab 5.3 !!
% something like:
%   viw = view;
%   axis([x1 x2 y1 y2 z1 z2]);
%   view(viw);
% should be enough, but is not, it returns wrong view
