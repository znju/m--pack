function self = showcoastline(Obj)
%   SHOWCOASTLINE method of class slice
%   Plots coastline on current slice

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

label   = get(self,'coastline_label');
dataTag = get(self,'coastline_tag');
tag     = gentag(self,label);
handle  = getbytag(self,tag);
% check if is already plotted:
handle  = getbytag(self,tag);
if ~isempty(handle)
  return
end

out = get(self,'slice_info');
type    = out.type;
i       = out.ind;
t       = out.time;
dim     = out.dim;
is2d    = out.is2d;
is3d    = out.is3d;
isi     = out.isi;
isj     = out.isj;
ishoriz = out.ishoriz;

if ~ishoriz & is2d
  return
end

file = get(self,'coastline_file');
if isempty(file) | ~exist(file,'file')
  %disp(':: unable to plot coastline, please load a valid file first');
  return
end

if ~isequal(tag,dataTag)
  if echoload(self)
    disp([' :-]  loading coastline']);
  end

  data = load(file);
  x = data.lon;
  y = data.lat;

  res = set(self,'coastline_data',x,y);
  if isa(res,'slice'), self = res; else disp(':: error in set coastline_data'); end
else
  [x,y] = get(self,'coastline_data');
end

ish = ishold; hold on

clhandle = plot(x,y);

set(clhandle,'tag',tag);
res = set(self,'coastline_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set coastline_tag'); end

style = get(self,'coastline_style');
evalc('set(clhandle,style)','');

if ~ish, hold off; end

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
