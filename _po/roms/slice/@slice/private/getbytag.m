function handle = getbytag(self,tag,what)
%   GETBYTAG method for class slice
%   Gives the figure handle(s) with the desired tag/part of tag

% MMA, martinho@fis.ua.pt
% 21-07-2005

handle = [];

% serach for figure:
fig = figfind(self);
if isempty(fig)
  return
end

if nargin < 3
  handle = findobj(fig,'tag',tag);
  if isempty(handle), handle = findall(fig,'tag',tag); end
elseif isequal(what,'search')
  handles = findobj(fig);
  n = 0;
  for i=1:length(handles)
    if ~isempty(findstr(get(handles(i),'tag'),tag))
      n = n+1;
      handle(n) = handles(i);
    end
  end
end
