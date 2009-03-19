function S2_legend(leg,font)

color='w';
if nargin <= 1
  font='arial';
end

warning off
if nargin >=1
  if isstr(leg)
    legend(leg)
  else
    color=leg; % used by S2_release
  end
else
  legend
end

lc=get(legend,'children');
if ~isempty(lc)
  set(lc(end),'interpreter','none','color',color,'fontname',font);
end
warning on
