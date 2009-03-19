function self = runslice(Obj,opt)
%   RUNSLICE method for class slice
%   Plots the current slice and all the extras

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

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
isvel   = out.isvel;
vel_color = out.vel_color;

if isempty(type) | isempty(varname)
  disp(':: slice values were not assingned yet');
  return
end

% about the figure:
% if current one is empty, use it
if isempty(get(gcf,'children'))
  % set figure tag:
  label   = get(self,'figure_label');
  figtag  = gentag(self,label);
  set(gcf,'tag',figtag);
end
fig = figfind(self);
if isempty(fig)
  figure;
  % set figure tag:
  label   = get(self,'figure_label');
  figtag  = gentag(self,label);
  set(gcf,'tag',figtag);
end

% about hold:
hold off
ish = get(self,'axes_ishold');
if ish
  hold on
end

% but need to hold off when dim changes:
% get dim from axes:
axTag    = get(gca,'tag');
prev_dim = getfromtag(self,axTag,'dim');
if ~isequal(dim, prev_dim)
  hold off
  % also better store it as 0:
  res = set(self,'axes_ishold',0);
  if isa(res,'slice'), self = res; else disp(':: error in set axes_ishold'); end
end
if ~ishold, clf, end

doslice = 1;
dovel   = 0;
doiso   = 0;
if nargin==2
  if isequal(opt,'noslice')
    doslice=0;
  end
end
if ismember(varname,{'vel','velbar'}), dovel = 1; end
if isequal(type,'sliceiso');           doiso = 1; end
if doslice
  if doiso
    if is2d, clf, end
    [self,dimv]=showisoslice(self);
    is3d = 1;
    is2d = 0;
    dim = '3d';
  elseif dovel
    if is3d, clf, end
    [self,dimv]=showvelslice(self);
    is3d = 0;
    is2d = 1;
     dim = '2d';
  else
    [self,dimv]=showslice(self);
  end
else
  dimv=9; % option for show grid
end

% store dimv:
res = set(self,'dimv',dimv);
if isa(res,'slice'), self = res; else disp(':: error in set dimv'); end

% set tag of  axes:
label  = get(self,'axes_label');
tag    = gentag(self,label);
set(gca,'tag',tag);


if dimv == 0
  return
end

if dimv > 1

  % deal with show bottom, show zeta and show_mask, ...:
  show_bottom        = get(self,'bottom_show');
  show_bathy         = get(self,'bathy_show');
  show_bathyc        = ~isempty(get(self,'bathy_cvals'));
  show_region_border = get(self,'border_show');
  show_mask          = get(self,'mask_show');
  show_zeta          = get(self,'zeta_show');
  show_coastline     = get(self,'coastline_show');

  if ~n_varexist(file,'mask_rho'), show_mask=0; end

  if show_bottom
    self = showbottom(self);
  else
    % delete, cos is allways changing
    self.bottom_data.x   = [];
    self.bottom_data.y   = [];
    self.bottom_data.h   = [];
    self.bottom_data.tag = [];
  end

  if show_bathy & show_bathyc
    self = showbathy(self);
  elseif show_bathy
    self = showbathy(self,'surface');
  elseif show_bathyc
    self = showbathy(self,'contours');
  end

  if show_region_border
    self = showborder(self);
  end

  if show_mask
    self = showmask(self);
  else
    self.mask_data.x   = [];
    self.mask_data.y   = [];
    self.mask_data.m   = [];
    self.mask_data.tag = [];
  end

  if show_zeta
    self = showzeta(self);
  else
    % delete, cos is allways changing
    self.zeta_data.z   = [];
    self.zeta_data.x   = [];
    self.zeta_data.y   = [];
    self.zeta_data.tag = [];
  end

  if show_coastline
    self = showcoastline(self);
  else
    self.coastline_data.x   = [];
    self.coastline_data.y   = [];
    self.coastline_data.tag = [];
    % dont need to delete coastline_file
  end


  % deal with caxis, shading, colorbar and:
  if dimv ~= 9 % dont do next when only showing grid
    if ((isempty(vel_color) & isvel) | ~isvel) & ~doiso
      self = add(self,'caxis');
      self = add(self,'colorbar');
    end
    self = add(self,'shading');
  end

  % deal with light:
  if (is3d & show_bathy) | doiso
    % turns off previous possible lighting
    delete(findobj(gca,'type','light'))
    camlight
  end

end

% trsnform for arrows:
if dimv ~= 9
  veltransf(self);
end

show_labels = get(self,'labels_show');
if show_labels % must be after colorbar is plotted!
  self = showlabels(self);
end

if is3d
  view(3);
end

if dimv == 1
  view(2);
end

% about limits:
self = limits(self,'set',gca);


if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
