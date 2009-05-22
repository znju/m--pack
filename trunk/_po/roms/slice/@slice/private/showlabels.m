function self=showlabels(Obj)
%   SHOWLABELS method of class slice
%   Sets the labels of current slice
%   (x, y, zlabel, title and colorbar ylabel)

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

label   = get(self,'labels_label');
dataTag = get(self,'labels_tag');
tag     = gentag(self,label);
% check if is already plotted:
handle  = getbytag(self,tag);
if ~isempty(handle)
  return
end

out = get(self,'slice_info');
file    = out.file;
varname = out.var;
type    = out.type;
i       = out.ind;
t       = out.time;
dim     = out.dim;
dimv    = out.dimv;
is2d    = out.is2d;
is3d    = out.is3d;
isi     = out.isi;
isj     = out.isj;
ishoriz = out.ishoriz;
isvel   = out.isvel;
isiso   = out.isiso;
vel_color = out.vel_color;

% find axes:
ax = figfind(self,'axes');
if isempty(ax)
  %return
  ax=axes;
  % just to show the result !
end

% find colorbar:
cbar = figfind(self,'colorbar');
if isempty(cbar)
  if isequal(dimv,2) & (~isvel | (isvel & isempty(vel_color))) & ~isiso
    cbar = colorbar; % there is no colorbar if 1d
  end
  % just to show the result !
end

if ~isequal(tag,dataTag)
  
  % xlabel, ylabel, zlabel do not change: only load when is empty
  % colorbar label changes with varname
  % title changes with i, t, varname and type
  
  % check for varname changes:
  prev_varname = getfromtag(self,dataTag,'variable');
  isSameVar = isequal(varname,prev_varname);
  
  % check for i changes:
  prev_i    = getfromtag(self,dataTag,'ind');
  isSameInd = isequal(i,prev_i);
  
  % check for t changes:
  prev_t     = getfromtag(self,dataTag,'time');
  isSameTime = isequal(t,prev_t);  
  
  % check for type changes:
  prev_type  = getfromtag(self,dataTag,'type');
  isSameType = isequal(type,prev_type); 
  
  if ~isSameVar
    % colorbar:
    if echoload(self)
      disp([' :-]  finding colorbar label']);
    end
    if isvel
      str_colorbar = varname;
    else
      lname        = n_varatt(file,varname,'long_name');
      units        = n_varatt(file,varname,'units');
      str_colorbar = [varname,' -- ',lname,' (',units,')'];
    end
    % store:
    res = set(self,'cblabel',str_colorbar);
    if isa(res,'slice'), self = res; else disp(':: error in set cblabel'); end
  else
    str_colorbar = get(self,'cblabel');
  end

  if ~isSameVar | ~all([isSameInd isSameTime isSameType])
    % title:
    if echoload(self)
      disp([' :-]  finding title']);
    end
    evalc('str_type = type(6:end);','str_type=''??''');
    tdays = octime(self);
    tdays = sprintf('%4.2f days',tdays);
    strt = sprintf('%3d',t);
    str_title    = [varname ,' -- time = ',strt,' = ',tdays,' -- ',str_type,' = ',num2str(i)];
    if n_attexist(file,'title')
      tit = n_att(file,'title');
      str_title = [tit,' -- ',str_title];
    end
    % store:
    res = set(self,'title',str_title);
    if isa(res,'slice'), self = res; else disp(':: error in set title'); end
  else
    str_title = get(self,'title');
  end

else
  str_colorbar = get(self,'cblabel'); 
  str_title    = get(self,'title');
end

[labelx,labely,labelz] = get(self,'xyzlabel');
if isempty(labelx) | isempty(labely) | isempty(labelz)
  if echoload(self)
    disp([' :-]  finding xlabel and ylabel']);
  end

  % find the var:
  vx = [];
  if n_varexist(file,'lon_rho'), vx='lon_rho'; elseif n_varexist(file,'x_rho'), vx='x_rho'; end
  if n_varexist(file,'lat_rho'), vy='lat_rho'; elseif n_varexist(file,'y_rho'), vy='y_rho'; end

  if ~isempty(vx) & ~isempty(vy)
    xlname = n_varatt(file,vx,'long_name');
    xunits = n_varatt(file,vx,'units');
    %labelx = [vx,' -- ',xlname,' (',xunits,')'];
    labelx = [vx,'  (',xunits,')'];

    ylname = n_varatt(file,vy,'long_name');
    yunits = n_varatt(file,vy,'units');
    %labely = [vy,' -- ',ylname,' (',yunits,')'];
    labely = [vy,'  (',yunits,')'];
  else
    labelx = 'xi ??';
    labely = 'eta ??';
  end
  labelz = 'depth (m)';  

  % store:
  res = set(self,'xyzlabel',labelx,labely,labelz);
  if isa(res,'slice'), self = res; else disp(':: error in set xyzlabel'); end
end

if 0 % lets forget this for now!
  % look for slice in axes:
  label   = get(self,'slice_label');
  handles = getbytag(self,label);
  if isempty(handles)
    return
  end
end

if is2d
  if isi
    labelx = labely;
    labely = labelz;
  elseif isj
    labely = labelz;
  end
  labz = '';
end

% if dimv is 1d, use colorbar label as ylabel:
if isequal(dimv,1)
  labely = str_colorbar;
end

axes(ax);
xlabel(labelx,  'interpreter','none');
ylabel(labely,  'interpreter','none');
zlabel(labelz,  'interpreter','none');
title(str_title,'interpreter','none');
if ~isempty(cbar)
  % here, must be careful about hold on:
  if ~isvel | (isvel & isempty(vel_color))
    axes(cbar);
    ylabel(str_colorbar,'interpreter','none');
  end
end
axes(ax);

res = set(self,'labels_tag',tag);
if isa(res,'slice'), self = res; else disp(':: error in set labels_tag'); end

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
