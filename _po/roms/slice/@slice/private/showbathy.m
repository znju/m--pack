function self=showbathy(Obj,what)
%   SHOWBATHY method of class slice
%   Plots bathy of current slice

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

label    = get(self,'bathy_label');
labelc   = get(self,'bathy_labelc');
dataTag  = get(self,'bathy_tag');
dataTagc = get(self,'bathy_tagc');
tag      = gentag(self,label);
tagc     = gentag(self,labelc);
% check if is already plotted:
handle  = getbytag(self,tag);
handlec = getbytag(self,tagc);
dosurf = 1;
docont = 1;
if ~isempty(handle);  dosurf = 0; end
if ~isempty(handlec); docont = 0; end

if nargin > 1
  if isequal(what,'contours'), dosurf = 0; end
  if isequal(what,'surface'),  docont = 0; end
end

if ~(dosurf | docont)
  return
end

out = get(self,'slice_info');
file    = out.file;
type    = out.type;
dim     = out.dim;
is2d    = out.is2d;
is3d    = out.is3d;
ishoriz = out.ishoriz;

cvals = get(self,'bathy_cvals');

% show bathy if dim is 3d or if 2d and slicek or z
if ~( is3d | (is2d & ishoriz) )
  return
end

% extract h if empty:
if ~isequal(tag,dataTag)
  if echoload(self)
    disp([' :-]  loading bathy']);
  end
  [x,y,h] = roms_grid(file);
  res = set(self,'bathy_data',x,y,h);
  if isa(res,'slice'), self = res; else disp(':: error in set bathy_data'); end
else
  [x,y,h] = get(self,'bathy_data');
end

ish = ishold; hold on

% show bathy contours:
if docont
  if ~isempty(cvals)
    if is2d
      [cs_,ch_] = contour(x,y,h,cvals,'k');
    elseif is3d
      if length(cvals) > 1, cvals = -cvals; end
      [cs_,ch_] = contour3(x,y,-h,cvals,'k');
    end

    % store contours handles:
    res = set(self,'bathy_cs_ch',cs_,ch_);
    if isa(res,'slice'), self = res; else disp(':: error in set bathy_cs_ch'); end

    style = get(self,'bathy_style_contours');
    evalc('set(ch_,style);','');

    set(ch_,'tag',tagc);
    res = set(self,'bathy_tagc',tagc);
    if isa(res,'slice'), self = res; else disp(':: error in set bathy_tagc'); end
  end
end

if dosurf
  % show h surf if 3d:
  if is3d
    hhandle=surf(x,y,-h);

    style = get(self,'bathy_style_surface');
    mat   = get(self,'bathy_style_material');
    evalc('set(hhandle,style);','');
    evalc('material(mat)','');

    set(hhandle,'tag',tag);
    res = set(self,'bathy_tag',tag);
    if isa(res,'slice'), self = res; else disp(':: error in set bathy_tag'); end

    % turns off previous possible lighting
    % delete(findobj(gca,'type','light'))
    % camlight;
    % this is being done in runslice
  end
end

if ~ish, hold off; end

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
