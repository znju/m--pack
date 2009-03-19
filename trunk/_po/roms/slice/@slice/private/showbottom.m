function self=showbottom(Obj)
%   SHOWBOTTOM method of class slice
%   Plots bottom of current slice

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

label   = get(self,'bottom_label');
dataTag = get(self,'bottom_tag');
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
  varh = 'h';
  if echoload(self)
    disp([' :-]  loading bottom']);
  end
  [xh,yh,zh,h]=roms_slice(file,'slice',type,'variable',varh,'ind',i,'time',t);
  res = set(self,'bottom_data',xh,yh,h);
  if isa(res,'slice'), self = res; else disp(':: error in set bottom_data'); end
else
  [xh,yh,h] = get(self,'bottom_data');
end

if isi & is2d
  xh = yh;
end

ish = ishold; hold on
if is2d
  bhandle = plot(xh,-h);
elseif is3d
  bhandle = plot3(xh,yh,-h);
end

set(bhandle,'tag',tag);
res = set(self,'bottom_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set bottom_tag'); end

style = get(self,'bottom_style');
evalc('set(bhandle,style)','');

if ~ish, hold off; end

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
