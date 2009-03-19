function [self,dimv]=showvelslice(Obj)
%   SHOWVELSLICE method of class slice
%   Plots current slice

% MMA, martinho@fis.ua.pt
% 21-07-2005


self = Obj;

dimv = 0;

label   = get(self,'slice_label');
dataTag = get(self,'slice_tag');
tag     = gentag(self,label);
% check if is already plotted:
handle  = getbytag(self,tag);
if ~isempty(handle)
  return
end


out = get(self,'slice_info');
file    = out.file;
type    = out.type;
i       = out.ind;
t       = out.time;
dim     = out.dim;
varname = out.var;
graph2d = out.graph2d;
graph3d = out.graph3d;
is2d    = out.is2d;
is3d    = out.is3d;
cvals   = out.cvals;
isi     = out.isi;
isj     = out.isj;
ishoriz = out.ishoriz;
vel_dind  = out.vel_dind;
vel_scale = out.vel_scale;
vel_color = out.vel_color;
isvelbar = out.isvelbar;

if is3d
  disp(':: currents not implemented yet for 3d...');
  disp(':: changing to 2-D ...');
  self = set(self,'dim','2d');
  is2d = 1;
  is3d = 0;
end

if isvelbar & ~ishoriz
  disp(':: use velbar with slicek(z)');
  return
end

if ~isequal(tag(1:end-2),dataTag(1:end-2))
  if echoload(self)
    disp([' :-]  loading slice']);
  end

  sparams = get(self,'scoord');
  if isequal(varname,'velbar'), curr = -2; else curr = 2; end
  [x,y,z,v] = roms_slice(file,'slice',type,'currents',curr,'ind',i,'time',t,'s_params',sparams);

  if isempty(v)
    disp([':: output is empty !?'])
    return
  end

   res = set(self,'slice_data',x,y,z,v);
  if isa(res,'slice'), self = res; else disp(':: error in set slice_data'); end
else
  [x,y,z,v] = get(self,'slice_data');
end

if ndims(squeeze(v)) > 2
  return
end

if any(size(v) == 1)
  % find x:
  if isi
    x=y;
  end
  shandle = plot(x,v);
  dimv = 1;
else
  dimv = 2;
  if is2d
    if isi
      x=y;
      y=z;
    elseif isj
      y=z;
    end

    % about dind and scale:
    di = vel_dind(1);
    dj = vel_dind(2);
    x=x(1:dj:end,1:di:end);
    y=y(1:dj:end,1:di:end);
    v=v(1:dj:end,1:di:end);
    v = v;

    scale_u = vel_scale(1);
    if length(vel_scale > 1)
      scale_v = vel_scale(2);
    else
      scale_v = vel_scale(1);
    end

    % ----------------------------------------------------------------
    % deal with vertical slices => axis equal:
    if ~ishoriz
      ampx = max(max(x)) - min(min(x));
      xi   = min(min(x));
      ampxf = 1;
      xif   = 0;

      ampy = max(max(y)) - min(min(y));
      yi   = min(min(y));
      ampyf = 1;
      yif   = 0;

      mx = ampxf/ampx;
      my = ampyf/ampy;

      x = mx*(x-xi) + xif;
      y = my*(y-yi) + yif;
    else
      mx = 1; xi  = 0; xif = 0;
      my = 1; yi  = 0; yif = 0;
    end

    res = set(self,'vel_slice_transf',[mx xi xif],[my yi yif],[1 0 0]);
    if isa(res,'slice'), self = res; else disp(':: error in set vel_slice_transf'); end
    % ----------------------------------------------------------------


    speed = sqrt(real(v).^2 + imag(v).^2);
    if isempty(vel_color)
      handle = vfield(x,y,real(v*scale_u),imag(v*scale_v),speed);
    else
      handle = vfield(x,y,real(v*scale_u),imag(v*scale_v),'color',vel_color);
    end

    ish = ishold; hold on
    % key: -------------------------------------------------
    [val,n,ex] = vscale(max(max(speed)));
    if ex==-2
      txt = sprintf('%.0d %s',n,'cm.s^-1');
    elseif ex== -1
      txt = sprintf('%.0d %s',n*10,'cm.s^-1');
    elseif ex== -3
      txt = sprintf('%.0d %s',n,'mm.s^-1');
    else
      txt = sprintf('%.0d %s',val,'m.s^-1');
    end
    x1 = min(min(x)); x2 = max(max(x)); ampx = x2-x1;
    y1 = min(min(y)); y2 = max(max(y)); ampy = y2-y1;
    kx = x2-ampx/4;
    ky = y1-ampy/10;

    if isempty(vel_color) 
      hk=vfield(kx,ky,val*scale_u,0*scale_v);
    else
      hk=vfield(kx,ky,val*scale_u,0*scale_v,'color',vel_color);
    end
    set(hk,'clipping','off');
    tk = text(kx,ky,txt,'VerticalAlignment','top');
    % ------------------------------------------------------

    if ~ish, hold off; end

  elseif is3d
    % UNDER CONSTRUCTION
  end
end

set(handle,'tag',tag);
res = set(self,'slice_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set slice_tag'); end

% remove light from slice:
evalc('set(shandle,''facelight'',''none'');','');

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
