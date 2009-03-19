function self=showmask(Obj)
%   SHOWMASK method of class slice
%   Plots mask of current slice

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

label   = get(self,'mask_label');
dataTag = get(self,'mask_tag');
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
is2d    = out.is2d;
is3d    = out.is3d;
isi     = out.isi;
isj     = out.isj;
ishoriz = out.ishoriz;

if ~isequal(tag,dataTag)
  mask = 'mask_rho';
  if echoload(self)
    disp([' :-]  loading mask']);
  end
  if isequal(type,'slicez') | ~is2d, type = 'slicek'; end
  [x,y,z,m]=roms_slice(file,'slice',type,'variable',mask,'ind',i,'time',t);

  res = set(self,'mask_data',x,y,m);
  if isa(res,'slice'), self = res; else disp(':: error in set mask_data'); end
else
  [x,y,m] = get(self,'mask_data');
end

if isempty(m)
  return
end

ish = ishold; hold on

if (is2d & ishoriz) | ~is2d
  [cs_,mhandle]=contour(x,y,m,[.5 .5],'k');

  style = get(self,'mask_style_line');
  evalc('set(mhandle,style)','');
else
  if isi, x = y; end
  m0 = m==0;
  z = zeros(size(m(m0)));
  mhandle = plot(x(m0),z);

  style = get(self,'mask_style_marker');
  evalc('set(mhandle,style)','');
end
set(mhandle,'tag',tag);
res = set(self,'mask_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set mask_tag'); end

if ~ish, hold off; end

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
