function self = loadcoastline(Obj,file)
%   LOADCOASTLINE method for class slice
%   Loads coastline mat file with variables .lon and .lat

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

if nargin == 1
  [filename, pathname] = uigetfile('*', 'select the coasltine file');
  if isequal(filename,0) | isequal(pathname,0)
    return
  else
    file=fullfile(pathname, filename);
  end
end

% check good file:
if  ~isstr(file)
  disp(':: coastline file not found')
  return
end
if  ~exist(file,'file')
  disp(':: coastline file not found')
  return
end

% check for lon and lat:
evalc('data = load(file);','data=[];');
if isempty(data)
  disp(':: coastline file not found');
  return
end
x = [];
y = [];
evalc('x = data.lon;','');
evalc('y = data.lat;','');
if isempty(x) | isempty(y)
  disp(':: bad coastline file')
  return
end

res = set(self,'coastline_show',1);
if isa(res,'slice'), self = res; else disp(':: error in set coastline_show'); end
res = set(self,'coastline_file',file);
if isa(res,'slice'), self = res; else disp(':: error in set coastline_file'); end
res = set(self,'coastline_data',x,y);
if isa(res,'slice'), self = res; else disp(':: error in set coastline_data'); end
label = get(self,'coastline_label');
tag   = gentag(self,label);
res = set(self,'coastline_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set coastline_tag'); end

self = showcoastline(self);

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
