function c=S2_ch_color(obj,uicontmenu)

if nargin == 1
 uicontmenu=0;
end

button=get(gcf,'selectiontype');

% normal = left mouse button
% alt    = rigth mouse button
% extend = third (wheel) mouse button

if ~isequal(button,'extend') % only continues if third button is pressed, cos of zoom...
  if uicontmenu==0
    return
  end
end

c=uisetcolor;
if ~isequal(c,0)
  set(obj,'color',c);
end

