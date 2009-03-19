function R_colorbutton(handle)
global H

% callback for colorbutons

eval(['clr = get(',handle,',''backgroundcolor'');']);

clr = uisetcolor(clr);

eval(['set(',handle,',''backgroundcolor'',clr)']);
