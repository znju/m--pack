function self=showzeta(Obj)
%   SHOWZETA method of class slice
%   Plots zeta of current slice

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

label   = get(self,'zeta_label');
dataTag = get(self,'zeta_tag');
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
isiso   = out.isiso;
ishoriz = out.ishoriz;

if ishoriz | isiso
  return
end

if ~isequal(tag,dataTag)
  if echoload(self)
    disp([' :-]  loading zeta']);
  end
  zeta = 'zeta';
  [x,y,z,v]=roms_slice(file,'slice',type,'variable',zeta,'ind',i,'time',t);

  res = set(self,'zeta_data',x,y,v);
  if isa(res,'slice'), self = res; else disp(':: error in set zeta_data'); end
else
  [x,y,v] = get(self,'zeta_data');
end

if isempty(v)
  return
end

ish = ishold; hold on
% plot:
if is2d
  if isi
    x=y;
  end
  zhandle  = plot(x,v,'k');
elseif is3d
  zhandle = plot3(x,y,v,'k');
end

set(zhandle,'tag',tag);
res = set(self,'zeta_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set zeta_tag'); end

style = get(self,'zeta_style');
evalc('set(zhandle,style)','');

if ~ish, hold off; end

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
