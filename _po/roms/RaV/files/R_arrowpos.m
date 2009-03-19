function R_arrowpos
global H

% get position for scale arrow using ginput

% try to finf new output figure, if none, then use ROMS.axes
figs    = get(0,'children');
outputs = findobj(figs,'tag','rcdv_output');
if ~isempty(outputs)
  last = outputs(1);
  figure(last);
end

[x,y]=ginput(1);

str=[num2str(x),' ',num2str(y)];
set(H.ROMS.his.morearrsc,'string',str);