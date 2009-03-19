function [self,dimv]=showisoslice(Obj)
%   SHOWISOSLICE method of class slice
%   Plots iso slice

% MMA, martinho@fis.ua.pt
% 8-2005

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

if is2d
  disp(':: changing to 3-D ...');
  self = set(self,'dim','3d');
  is2d = 0;
  is3d = 1;
end

if ~isequal(tag(1:end-2),dataTag(1:end-2))
  if echoload(self)
    disp([' :-]  loading slice']);
  end

  sparams = get(self,'scoord');
  [x,y,z,v] = roms_sliceiso(file,varname,i,t,'s_params',sparams);

  if isempty(v)
    disp([':: output is empty !?'])
    return
  end

   res = set(self,'slice_data',x,y,z,v);
  if isa(res,'slice'), self = res; else disp(':: error in set slice_data'); end
else
  [x,y,z,v] = get(self,'slice_data');
end

dimv = 2;
handle = patch(v);
[ec,ea,fc,fa,rp] = get(self,'slice_iso_data');
set(handle,'facecolor',fc,'edgecolor',ec);
eval('set(handle,''facealpha'',fa,''edgealpha'',ea)','');
if ~isempty(rp)
  reducepatch(p,rp);
end

set(handle,'tag',tag);
res = set(self,'slice_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set slice_tag'); end

% remove light from slice:
%evalc('set(handle,''facelight'',''none'');','');
% allow light in isosurface

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
