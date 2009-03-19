function self=subsasgn(Obj,s,value)
%   SUBSASGN method for class slice
%   See SLICE for help

% MMA, martinho@fis.ua.pt
% 24-07-2005

self=Obj;

str = s(1).subs;

out = get(self,'slice_info');
file    = out.file;
type    = out.type;
i       = out.ind;
t       = out.time;
varname = out.var;
dim     = out.dim;
graph2d = out.graph2d;
graph3d = out.graph3d;
is2d    = out.is2d;
is3d    = out.is3d;
cvals   = out.cvals;
isi     = out.isi;
isj     = out.isj;
iscont  = out.iscontour;
vel_dind  = out.vel_dind;
vel_scale = out.vel_scale;
vel_color = out.vel_color;

if iscell(value)
  run = 0;
  if length(value) == 1, value = value{:}; end
else
  run = 1;
end

if ismember(str,{'slicei','slicej','slicek','slicelon','slicelat','slicez','sliceiso'})
  type = str;
  varname = value{1};
  eval('t       = value{2};','t=[];');
  eval('i       = value{3};','i=[];');
  res = set(self,'slice_vars',type,varname,t,i);
  if isa(res,'slice'), self = res; else disp(':: error in set slice_vars'); end
  run = 1;

  if isequal(varname,'vel'),    len = 4; end
  if isequal(varname,'velbar'), len = 3; end

  if ismember(varname,{'vel','velbar'})
    if isequal(varname,'vel'),    len = 4; end
    if isequal(varname,'velbar'), len = 3; end

    dind  = vel_dind;
    scale = vel_scale;
    color = vel_color;
    if length(value) >= len,   dind  = value{len};   else dind  = 1;  end
    if length(value) >= len+1, scale = value{len+1}; else scale = 1;  end
    if length(value) >= len+2, color = value{len+2}; else color = []; end

    if isnumber(dind,1,'Z+')     dind = [dind dind dind];
    elseif isnumber(dind,2,'Z+') dind(1:2) = dind;
    elseif isnumber(dind,3,'Z+') dind      = dind;
    else
      disp(':: bad value for vel dind');
      return
    end
    if isnumber(scale,1,'R+')
      scale = [scale scale scale];
    elseif isnumber(scale,2,'R+')
      scale = [scale vel_scale(3)];
    elseif isnumber(scale,3,'R+')
      scale = scale;
    else
      disp(':: bad value for vel scale');
      return
    end

    if ~isempty(color)
      if ~iscolor(color)
        disp(':: bad value for vel color');
        return
      end
    end

    % store:
    res = set(self,'vel_vars',dind,scale,color);
    if isa(res,'slice'), self = res; else disp(':: error in set vel_vars'); end
  end

  if isequal(type,'sliceiso')
    [ec,ea,fc,fa,rp] = get(self,'slice_iso_data');
    if length(value) > 3
      color = value{4};
      if iscolor(color) | isequal(color,'none')
        fc = color;
      else
        disp(':: bad value for iso FaceColor');
      end
    else fc = 'b'; end
    if length(value) > 4
      alpha = value{5};
      if isnumber(alpha,'R0+') & alpha <= 1
        fa = alpha;
      else
        disp(':: bad value for iso FaceAlpha');
      end
    else fa = 1; end
    if length(value) > 5
      color = value{6};
      if iscolor(color) | isequal(color,'none')
        ec = color;
      else
        disp(':: bad value for iso EdgeColor');
      end
    else ec = 'none'; end
   if length(value) > 6
      alpha = value{7};
      if isnumber(alpha,'R0+') & alpha <= 1
        ea = alpha;
      else
        disp(':: bad value for iso EdgeAlpha');
      end
    else ea = 1; end
    if length(value) > 7
      rpatch = value{8};
      if (isnumber(rpatch,'R+') & rpatch <= 1) | isempty(rpatch)
        rp = rpatch;
      else
        disp(':: bad value for iso Reduce Patch');
      end
    else rp = []; end

  % store:
  self = set(self,'slice_iso_data',ec,ea,fc,fa,rp);
  end


elseif ismember(str,{'time','inct'})
  if isnumber(value,1,'Z')
    if isequal(str,'inct'), value = t+value; end
    res = set(self,'time',value);
    if isa(res,'slice'), self = res; else disp(':: error in set time'); end
  else
    disp(':: bad value for time');
    return
  end

elseif ismember(str,{'ind','inci'})
  if isnumber(value,1,'Z')
    if isequal(str,'inci'), value = i+value; end
    res = set(self,'indice',value);
    if isa(res,'slice'), self = res; else disp(':: error in set indice'); end
  else
    disp(':: bad value for indice');
    return
  end

elseif isequal(str,'var')
  if isstr(value)
    res = set(self,'variable',value);
    if isa(res,'slice'), self = res; else disp(':: error in set indice'); end
  else
    disp(':: bad value for variable name');
    return
  end

elseif isequal(str,'type')
  if ismember(type,{'slicei','slicej','slicek','slicelon','slicelat','slicez'})
    res = set(self,'type',value);
    if isa(res,'slice'), self = res; else disp(':: error in set indice'); end
  else
    disp(':: bad value for slice type');
    return
  end

elseif isequal(str,'dim')
  tagOnFig = get(self,'slice_tag');
  dimOnFig = getfromtag(self,tagOnFig,'dim');
  is2d = isequal(dimOnFig,'2d');
  is3d = isequal(dimOnFig,'3d');
  if (isequal(value,2) & is2d) |...
     (isequal(value,3) & is3d)
    run = 0;
  end
  if ismember(value,[2 3])
    value = [num2str(value),'d'];
    res = set(self,'dim',value);
    if isa(res,'slice'), self = res; else disp(':: error in set dim'); end
  else
    disp(':: non valid dim for output chart');
    return
  end
  % but run = 1 if no figure or axes are empty:
  fig = figfind(self);
  if isempty(fig); run = 1;
  elseif isempty(get(gca,'children')), run = 1;
  end


elseif isequal(str,'g2')
    if ismember(value,{'pcolor','contour'})
      self.slice_2dtype = value;
    else
      disp(':: non valid 2-D graph');
      return
    end

elseif isequal(str,'g3')
    if ismember(value,{'surf','contourz'})
      self.slice_3dtype = value;
    else
      disp(':: non valid 3-D graph');
     return
    end

elseif isequal(str,'caxis')
  if isnumber(value,2) | isempty(value)
    self = add(self,'caxis',value);
    self = add(self,'colorbar');
  else
    disp(':: bad value for caxis');
    return
  end
  run = 0;

elseif isequal(str,'shading')
  self = add(self,'shading',value);
  run = 0;

elseif isequal(str,'clabel')
  [cs_,ch_] = get(self,'slice_cs_ch');
  if isempty(ch_)
    disp(':: no contours to label');
    return
  elseif ~ishandle(ch_)
    disp(':: no contours to label');
    return
  end

  if isequal(value,'man')
    m_clabel(ch_);
  elseif  isequal(value,'manual')
    clabel(cs_,'manual');
  elseif isnumber(value,1,'Z+') & ~isempty(cs_)
    clabel(cs_,ch_,'labelspacing',value)
  else
    contourz('clabel');
  end
  run = 0;

elseif isequal(str,'cvals')
  % contour values:
  if ~isnumber(value)
    disp(':: bad contour values');
    return
  end
  % store:
  res = set(self,'cvals',value);
  if isa(res,'slice'), self = res; else disp(':: error in set cvals'); end

elseif isequal(str,'clabelh')
  [cs_,ch_] = get(self,'bathy_cs_ch');
  if isempty(ch_) | isempty(cs_)
    disp(':: no bathy contours to label');
    return
  elseif ~ishandle(ch_)
    disp(':: no bathy contours to label');
    return
  end

  if isequal(value,'man')
    m_clabel(ch_);
  elseif isequal(value,'manual')
    clabel(cs_,'manual');
  elseif isnumber(value,1,'Z+')
    clabel(cs_,ch_,'labelspacing',value)
  end
  run=0;

elseif isequal(str,'hold')
  if ismember(value,[0 1])
    res = set(self,'axes_ishold',value);
    if isa(res,'slice'), self = res; else disp(':: error in set axes_ishold'); end
  else
    disp(':: bad value for hold');
    return
  end
  run = 0;

% --------------------------------------------------------------------
% s coordinates parameters:
% --------------------------------------------------------------------
elseif isequal(str,'scoord')
  if isempty(value)
    % set the values in file:
    [tts, ttb, hc, n] = s_params(file);
    % store:
    res = set(self,'scoord',tts,ttb,hc,n);
    if isa(res,'slice'), self = res; else disp(':: error in set scoord'); end
  elseif isnumber(value,3,'R0+')
    tts = value(1);
    ttb = value(2);
    hc  = value(3);
    %n   = value(4);
    if ~(tts>=0 & tts <=20)
      disp([':: bad value for THETA_S (',num2str(tts),')  [0... 20]']);
      return
    end
    if ~(ttb>=0 & ttb <=1)
      disp([':: bad value for THETA_B (',num2str(ttb),')  [0... 1]']);
      return
    end
    if hc < 0
      disp([':: bad value for HC (',num2str(hc),')  [>0]']);
      return
    end
    % store:
    res = set(self,'scoord',tts,ttb,hc);
    if isa(res,'slice'), self = res; else disp(':: error in set scoord'); end
  else
    disp(':: bad value for [THETA_S THETA_B HC <N>]');
    return
  end


% --------------------------------------------------------------------
% current view:
% --------------------------------------------------------------------
elseif isequal(str,'limits')
  ax = gca;
  self=limits(self,value,ax);
  run = 0;

% --------------------------------------------------------------------
% coastline:
% --------------------------------------------------------------------
elseif isequal(str,'coastline')
  if isequal(value,'load')
    self = loadcoastline(self);
  else
    self = loadcoastline(self,value);
  end
  run = 0;

elseif isequal(str,'show_coastline')
  label  = get(self,'coastline_label');
  tag    = gentag(self,label);
  handle = getbytag(self,tag);
  if isequal(value,1)
    self = showcoastline(self);
  elseif isequal(value,0)
    evalc('delete(handle);','');
  end
  if ismember(value,[0 1])
    res = set(self,'coastline_show',value);
    if isa(res,'slice'), self = res; else disp(':: error in set coastline_show'); end
  else
    disp(':: invalid value for show_coastline')
  end
  run = 0;

elseif isequal(str,'set_coastline')
  label  = get(self,'coastline_label');
  tag    = gentag(self,label);
  handle = getbytag(self,tag);
  % set coastline properties:
  if mod(length(value),2) ~= 0
    disp(':: invalid parameter/value pair arguments');
  else
    for i=1:2:length(value)-1
      evalc('set(handle,value{i},value{i+1})','');

      % store some attributes, even if is not handle.
      val = lower(value{i});
      theval = value{i+1};
      if isequal(val,'color')
        res = set(self,'coastline_color',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set coastline_color'); end
      elseif isequal(val,'linestyle')
        res = set(self,'coastline_linestyle',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set coastline_linestyle'); end
      elseif isequal(val,'linewidth')
        res = set(self,'coastline_linewidth',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set coastline_linewidth'); end
      end

    end
  end
  run = 0;

% --------------------------------------------------------------------
% mask:
% --------------------------------------------------------------------
elseif isequal(str,'show_mask')
  label  = get(self,'mask_label');
  %handle = getbytag(self,label,'search');
  tag = gentag(self,label);
  handle = getbytag(self,tag);
  current = get(self,'mask_show');

  if ismember(value,[0 1])
    res = set(self,'mask_show',value);
    if isa(res,'slice'), self = res; else disp(':: error in set mask_show'); end
  end

  if isequal(value,1)
    if ~isequal(current,1), self = showmask(self); else, run = 0; end
  elseif isequal(value,0)
    evalc('delete(handle);',''); run=0;
  else
    disp(':: invalid value for show_mask')
    return
  end

elseif isequal(str,'set_mask')
  label  = get(self,'mask_label');
  %handle = getbytag(self,label,'search'); % instead, use only the last:
  tag = gentag(self,label);
  handle = getbytag(self,tag);

  % set mask properties:
  if mod(length(value),2) ~= 0
    disp(':: invalid parameter/value pair arguments');
  else
    for i=1:2:length(value)-1
      evalc('set(handle,value{i},value{i+1})','');

      % store some attributes, even if is not handle.
      val = lower(value{i});
      theval = value{i+1};
      if isequal(val,'color')
        res = set(self,'mask_color',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set mask_color'); end
      elseif isequal(val,'linestyle')
        res = set(self,'mask_linestyle',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set mask_linestyle'); end
      elseif isequal(val,'linewidth')
        res = set(self,'mask_linewidth',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set mask_linewidth'); end
      elseif isequal(val,'marker')
        res = set(self,'mask_marker',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set mask_marker'); end
      elseif isequal(val,'markersize')
        res = set(self,'mask_markersize',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set mask_markersize'); end
      elseif isequal(val,'markeredgecolor')
        res = set(self,'mask_markeredgecolor',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set mask_markeredgecolor'); end
      elseif isequal(val,'markerfacecolor')
        res = set(self,'mask_markerfacecolor',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set mask_markerfacecolor'); end
      end

    end
  end
  run = 0;

% --------------------------------------------------------------------
% region border:
% --------------------------------------------------------------------
elseif isequal(str,'show_border')
  label   = get(self,'border_label');
  tag     = gentag(self,label);
  handle  = getbytag(self,tag);
  current = get(self,'border_show');

  if ismember(value,[0 1])
    res = set(self,'border_show',value);
    if isa(res,'slice'), self = res; else disp(':: error in set border_show'); end
  end

  if isequal(value,1)
    if ~isequal(current,1), self = showborder(self); else, run = 0; end
  elseif isequal(value,0)
    evalc('delete(handle);',''); run=0;
  else
    disp(':: invalid value for show_border')
    return
  end

  run = 0;


elseif isequal(str,'set_border')
  label   = get(self,'border_label');
  tag     = gentag(self,label);
  handle  = getbytag(self,tag);
  % store some attributes, even if is not handle.
  if mod(length(value),2) ~= 0
    disp(':: invalid parameter/value pair arguments');
  else
    for i=1:2:length(value)-1
      evalc('set(handle,value{i},value{i+1})','');

      % store some attributes, even if is not handle.
      val = lower(value{i});
      theval = value{i+1};
      if isequal(val,'color')
        res = set(self,'border_color',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set border_color'); end
      elseif isequal(val,'linestyle')
        res = set(self,'border_linestyle',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set border_linestyle'); end
      elseif isequal(val,'linewidth')
        res = set(self,'border_linewidth',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set border_linewidth'); end
      elseif isequal(val,'marker')
        res = set(self,'border_marker',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set border_marker'); end
      elseif isequal(val,'markersize')
        res = set(self,'border_markersize',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set border_markersize'); end
      elseif isequal(val,'markeredgecolor')
        res = set(self,'border_markeredgecolor',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set border_markeredgecolor'); end
      elseif isequal(val,'markerfacecolor')
        res = set(self,'border_markerfacecolor',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set border_markerfacecolor'); end
      end

    end
  end
  run = 0;

% --------------------------------------------------------------------
% zeta:
% --------------------------------------------------------------------
elseif isequal(str,'show_zeta')
  label   = get(self,'zeta_label');
  tag     = gentag(self,label);
  handle  = getbytag(self,tag);
  current = get(self,'zeta_show');

  if ismember(value,[0 1])
    res = set(self,'zeta_show',value);
    if isa(res,'slice'), self = res; else disp(':: error in set zeta_show'); end
  end

  if isequal(value,1)
    if ~isequal(current,1), self = showzeta(self); else, run = 0; end
  elseif isequal(value,0)
    evalc('delete(handle);',''); run=0;
  else
    disp(':: invalid value for show_zeta')
    return
  end

elseif isequal(str,'set_zeta')
  label   = get(self,'zeta_label');
  tag     = gentag(self,label);
  handle  = getbytag(self,tag);
  % set zeta properties:
  if mod(length(value),2) ~= 0
    disp(':: invalid parameter/value pair arguments');
  else
    for i=1:2:length(value)-1
      evalc('set(handle,value{i},value{i+1})','');

      % store some attributes, even if is not handle.
      val = lower(value{i});
      theval = value{i+1};
      if isequal(val,'color')
        res = set(self,'zeta_color',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set zeta_color'); end
      elseif isequal(val,'linestyle')
        res = set(self,'zeta_linestyle',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set zeta_linestyle'); end
      elseif isequal(val,'linewidth')
        res = set(self,'zeta_linewidth',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set zeta_linewidth'); end
      end

    end
  end
  run = 0;

% --------------------------------------------------------------------
% bottom:
% --------------------------------------------------------------------
elseif isequal(str,'show_bottom')
  label   = get(self,'bottom_label');
  tag     = gentag(self,label);
  handle  = getbytag(self,tag);
  current = get(self,'bottom_show');

  if ismember(value,[0 1])
    res = set(self,'bottom_show',value);
    if isa(res,'slice'), self = res; else disp(':: error in set bottom_show'); end
  end

  if isequal(value,1)
    if ~isequal(current,1), self = showbottom(self); else, run = 0; end
  elseif isequal(value,0)
    evalc('delete(handle);',''); run=0;
  else
    disp(':: invalid value for show_bottom')
    return
  end

elseif isequal(str,'set_bottom')
  label   = get(self,'bottom_label');
  tag     = gentag(self,label);
  handle  = getbytag(self,tag);
  % set bottom properties:
  if mod(length(value),2) ~= 0
    disp(':: invalid parameter/value pair arguments');
  else
    for i=1:2:length(value)-1
      evalc('set(handle,value{i},value{i+1});','');

      % store some attributes, even if is not handle.
      val = lower(value{i});
      theval = value{i+1};
      if isequal(val,'color')
        res = set(self,'bottom_color',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bottom_color'); end
      elseif isequal(val,'linestyle')
        res = set(self,'bottom_linestyle',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bottom_linestyle'); end
      elseif isequal(val,'linewidth')
        res = set(self,'bottom_linewidth',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bottom_linewidth'); end
      end

    end
  end
  run = 0;

% --------------------------------------------------------------------
% bathy:
% --------------------------------------------------------------------
elseif isequal(str,'show_bathy')
  label   = get(self,'bathy_label');
  tag     = gentag(self,label);
  handle  = getbytag(self,tag);
  current = get(self,'bathy_show');

  if ismember(value,[0 1])
    res = set(self,'bathy_show',value);
    if isa(res,'slice'), self = res; else disp(':: error in set bathy_show'); end
  end

  if isequal(value,1)
    if ~isequal(current,1), self = showbathy(self); else, run = 0; end
  elseif isequal(value,0)
    evalc('delete(handle);',''); run=0;
  else
    disp(':: invalid value for show_bathy')
    return
  end

elseif isequal(str,'bathy_vals')
  label   = get(self,'bathy_labelc');
  tag     = gentag(self,label);
  handle  = getbytag(self,tag);

  if isnumber(value) | isempty(value)
    res = set(self,'bathy_cvals',value);
    if isa(res,'slice'), self = res; else disp(':: error in set bathy_cvals'); end
    % delete previous contours:
    evalc('delete(handle);','');
    self = showbathy(self,'contours');
    run = 0;
  else
    disp(':: bad bathy contour values')
    return
  end

elseif isequal(str,'set_bathy')
  label   = get(self,'bathy_label');
  labelc  = get(self,'bathy_labelc');
  tag     = gentag(self,label);
  tagc    = gentag(self,labelc);
  handle  = getbytag(self,tag);
  handlec = getbytag(self,tagc);
  % set bathy properties:
  if mod(length(value),2) ~= 0
    disp(':: invalid parameter/value pair arguments');
  else
    for i=1:2:length(value)-1
      % take into account the 2 handles with diff properties:
      if ismember(lower(value{i}),lower({'Color','LineStyle','LineWidth'}))
        % than leading with the contours:
        evalc('set(handlec,value{i},value{i+1})','');
      elseif ismember(lower(value{i}),lower({'FaceColor','FaceAlpha','EdgeColor','EdgeAlpha'}))
        % than leading with the bathy surf:
        evalc('set(handle,value{i},value{i+1})','');
      elseif isequal(value{i},'material')
        eval('material(value{i+1});','disp('':: The material vector must be of size 1x3, 1x4, or 1x5'');');
      end

      % store some attributes, even if is not handle.
      val = lower(value{i});
      theval = value{i+1};
      if isequal(val,'color')
        res = set(self,'bathy_color',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bathy_color'); end
      elseif isequal(val,'linestyle')
        res = set(self,'bathy_linestyle',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bathy_linestyle'); end
      elseif isequal(val,'linewidth')
        res = set(self,'bathy_linewidth',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bathy_linewidth'); end
      elseif isequal(val,'facecolor')
        res = set(self,'bathy_facecolor',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bathy_facecolor'); end
      elseif isequal(val,'facealpha')
        res = set(self,'bathy_facealpha',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bathy_facealpha'); end
      elseif isequal(val,'edgecolor')
        res = set(self,'bathy_edgecolor',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bathy_edgecolor'); end
      elseif isequal(val,'edgealpha')
        res = set(self,'bathy_edgealpha',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bathy_edgealpha'); end
      elseif isequal(val,'material')
        res = set(self,'bathy_material',theval);
        if isa(res,'slice'), self = res; else disp(':: error in set bathy_material'); end
      end

    end
  end
  run = 0;

% --------------------------------------------------------------------
else
  disp([':: unknown option ',str]);
  run = 0;
end

if run
  self = runslice(self);
end
