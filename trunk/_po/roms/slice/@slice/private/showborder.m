function self=showborder(Obj)
%   SHOWBORDER method of class slice
%   Plots region border of current slice

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

label   = get(self,'border_label');
dataTag = get(self,'border_tag');
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
isiso   = out.isiso;
ishoriz = out.ishoriz;

if ~( (is2d & ishoriz) | is3d )
  return
end

% extract only when empty
if ~isequal(tag,dataTag)
  if echoload(self)
    disp([' :-]  loading border']);
  end
%  [x,y,h,xc,yc,hc] = roms_border(file);
%  z = zeros(size(x));
%  x = [x' nan x' nan xc(1) xc(1) nan xc(2) xc(2) nan xc(3) xc(3) nan xc(4) xc(4)];
%  y = [y' nan y' nan yc(1) yc(1) nan yc(2) yc(2) nan yc(3) yc(3) nan yc(4) yc(4)];
%  z = [z' nan h' nan hc(1) 0     nan hc(2) 0     nan hc(3) 0     nan hc(4) 0    ];
  [x,y,z]=roms_border(file,'3d');

  res = set(self,'border_data',x,y,z);
  if isa(res,'slice'), self = res; else disp(':: error in set border_data'); end
else
  [x,y,z] = get(self,'border_data');
end

ish = ishold; hold on

if is2d & ishoriz
  i = find(isnan(x)); i = i(1)-1;
  x = x(1:i);
  y = y(1:i);
  rbhandle = plot(x,y);
  isplotted = 1;
elseif is3d
  rbhandle = plot3(x,y,z);
end

set(rbhandle,'tag',tag);
res = set(self,'border_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set border_tag'); end

line_style   = get(self,'border_style_line');
marker_style = get(self,'border_style_marker');
evalc('set(rbhandle,line_style);',   '');
evalc('set(rbhandle,marker_style);', '');

if ~ish, hold off; end

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
