function [self,dimv]=showslice(Obj)
%   SHOWSLICE method of class slice
%   Plots current slice

% MMA, martinho@fis.ua.pt
% 21-07-2005

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
varname = out.var;
dim     = out.dim;
graph2d = out.graph2d;
graph3d = out.graph3d;
is2d    = out.is2d;
is3d    = out.is3d;
cvals   = out.cvals;
isi     = out.isi;
isj     = out.isj;

% tag includes the dim which is not needed here:
if ~isequal(tag(1:end-2),dataTag(1:end-2))
  if echoload(self)
    disp([' :-]  loading slice']);
  end

%  if isempty(i), i=1; end
%  if isempty(t), t=1; end

  sparams = get(self,'scoord');
  [x,y,z,v] = roms_slice(file,'slice',type,'variable',varname,'ind',i,'time',t,'s_params',sparams);

  % zero2nan (in mask!)
  % but do not do this if 1d:
  if ~isempty(v)
    if ~any(size(v) == 1)
      v(v==0) = nan;
    end
  end

  if isempty(v)
    disp([':: output is empty !?'])
    return
  end

  res = set(self,'slice_data',x,y,z,v);
  if isa(res,'slice'), self = res; else disp(':: error in set slice_data'); end
else
  [x,y,z,v] = get(self,'slice_data');
end

if ndims(squeeze(v)) > 2
  return
end

if any(size(v) == 1)
  % find x:
  if isi
    x=y;
  end
  shandle = plot(x,v);
  dimv = 1;
else
  dimv = 2;

  if is2d
    if isi
      x=y;
      y=z;
    elseif isj
      y=z;
    end
    % graph type:
    if isequal(graph2d,'contour')
      eval(['[c_s,shandle]=',graph2d,'(x,y,v,cvals);']);
      % store handles:
      res = set(self,'slice_cs_ch',c_s,shandle);
      if isa(res,'slice'), self = res; else disp(':: error in set slice_cs_ch'); end
    else
      eval(['shandle=',graph2d,'(x,y,v);'])
    end

  elseif is3d
    if isequal(graph3d,'contourz')
      eval(['shandle=',graph3d,'(x,y,z,v,cvals);']);
      % store handles:
      res = set(self,'slice_cs_ch',[],shandle);
      if isa(res,'slice'), self = res; else disp(':: error in set slice_cs_ch'); end
    else
      eval(['shandle=',graph3d,'(x,y,z,v);'])
    end

  end
end

set(shandle,'tag',tag);
res = set(self,'slice_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set slice_tag'); end

% remove light from slice:
evalc('set(shandle,''facelight'',''none'');','');

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end

