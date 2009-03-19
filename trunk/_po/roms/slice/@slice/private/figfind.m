function handle = figfind(self,what)
%   FINDFIG method for class slice
%   Fings handle of slice figure, axes or colorbar

% MMA, martinho@fis.ua.pt
% 21-07-2005

handle = [];

if nargin == 1
  % find last slice figure:
  label = get(self,'figure_label');
  tag   = gentag(self,label);
  figs  = findobj(0,'tag',tag,'type','figure');
  if ~isempty(figs)
    % use current if is a slice figure
    handle = figs(1);
    figure(handle);
  end
  return
end

if isequal(what,'colorbar')
  % find colorbar:
  label  = get(self,'slice_colorbar_label');
  cbtag  = gentag(self,label);
  cbar   = getbytag(self,cbtag);
  handle = cbar;
  return
end

if isequal(what,'axes')
  % find slice axes, but first find figure:
  fig = figfind(self);
  if ~isempty(fig)
    label  = get(self,'axes_label');
    tag    = gentag(self,label);
    ax     = getbytag(self,tag);
    handle = ax;
  end
  return
end
