function self = add(Obj,prop,value)
%   ADD method for class slice
%   Adds additional stuff to the slice figure:
%   - caxis, colorbar and shading

% MMA, martinho@fis.ua.pt
% 21-07-2005

self = Obj;

% find figure:
fig = figfind(self);
if isempty(fig)
  return
end

% find colorbar:
cbar = figfind(self,'colorbar');

% find axes:
ax = figfind(self,'axes');

% find slice on axes:
label    = get(self,'slice_label');
theSlice = getbytag(self,label,'search');

% --------------------------------------------------------------------
% caxis:
% --------------------------------------------------------------------
if isequal(prop,'caxis')
  cax = [];
  if nargin >= 3
    % set caxis:
    if isnumber(value,2)
      if value(2) > value(1), cax = value;  else disp(':: bad caxis'); return,  end
    elseif ~isempty(value)
      disp(':: bad caxis');
      return
    end

    % set caxis:
    res = set(self,'slice_caxis',value);
    if isa(res,'slice'), self = res; else disp(':: error in set slice_caxis'); end
  else
    % get caxis:
    cax = get(self,'slice_caxis');
  end

  if ~isempty(cax)
    caxis(cax);
  else
    if ~isempty(theSlice)
      handle = theSlice(1); % use the last slice
      % this gives bad results when using contours !
      % so, better use directly from data:
      %if isprop(handle,'CData')
        %evalc('cmin = min(min(get(handle,''CData'')));','cmin = min(cell2mat(get(handle,''CData'')));');
        %evalc('cmax = max(max(get(handle,''CData'')));','cmax = max(cell2mat(get(handle,''CData'')));');
        v = get(self,'slice_data');
        if isstruct(v)
          % just in case !
          cmin = 0;
          cmax = 0;
        else
          cmin = min(reshape(v,prod(size(v)),1));
          cmax = max(reshape(v,prod(size(v)),1));
        end
        if cmin == cmax;
          cmin = cmin-1;
          cmax = cmax+1;
        end
        eval('caxis([cmin cmax]);','');
      %end

    end
  end

% --------------------------------------------------------------------
% colorbar:
% --------------------------------------------------------------------
elseif isequal(prop,'colorbar')
  if ~isempty(cbar)
    delete(cbar);
  end
  cbar = colorbar;

  % set tag:
  label  = get(self,'slice_colorbar_label');
  cbtag  = gentag(self,label);
  set(cbar,'tag',cbtag);

  % set a nice position:
  cbpos = get(cbar,'position');
  set(cbar,'position',[cbpos(1:2) min(cbpos(3),0.025) cbpos(4)]);

% --------------------------------------------------------------------
% shading:
% --------------------------------------------------------------------
elseif isequal(prop,'shading') % should be used with pcolor and surf !
  if nargin >= 3
    if ~ismember(value,{'interp','flat','faceted'})
      disp([':: bad value for shading: ',value]);
      return
    end
  end

  handles = theSlice;

  % find all surfaces:
  surfaces = [];
  n = 0;
  if ~isempty(handles)
    for i=1:length(handles)
      % get type of plot:
      thetype=get(handles(i),'type');
      if isequal(thetype,'surface')
        n = n+1;
        surfaces(n) = handles(i);
      end
    end
  else
    return
  end

  % aplly to all surfaces:
  if ~isempty(surfaces)
    if nargin >= 3
      % set the shading:
      res = set(self,'slice_shading',value);
      if isa(res,'slice'), self = res; else disp(':: error in set slice_shading'); end
    end
    % get the shading:
    value = get(self,'slice_shading');

    for i=1:length(surfaces)
      if ismember(value,{'interp','flat'})
        evalc(['set(surfaces(i),''facecolor'',''',value,''',''edgecolor'',''none'');'],'');
      elseif isequal(value,'faceted')
        evalc(['set(surfaces(i),''facecolor'',''flat'',''edgecolor'',''default'');'],'');
      end
    end
  end

end

if ~isa(self,class(Obj))
  disp([':: false object in file : ',mfilename])
  self = Obj;
end
