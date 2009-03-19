function R_plotopt(in)

global H

contourcb   = H.ROMS.his.contourcb;       % handle
pcolorcb    = H.ROMS.his.pcolorcb;        % handle
contourvals = H.ROMS.his.contourvals;     % handle
pcolorcaxis = 'H.ROMS.his.pcolorcaxis';   % handle name
evalc('Cs_  = H.ROMS.his.cs;','Cs_=[];'); % contour cs vals (from [cs,ch]=contour...)

% --------------------------------------------------------------------
% change contour/pcolor checkboxes
% --------------------------------------------------------------------
if isequal(in,'contourcb') | isequal(in,'pcolorcb')
  set(contourcb, 'value',0);
  set(pcolorcb,  'value',0);
  if isequal(in,'contourcb'), set(contourcb, 'value',1); end
  if isequal(in,'pcolorcb'),  set(pcolorcb, 'value',1);  end
end

% --------------------------------------------------------------------
% do contour
% --------------------------------------------------------------------
if isequal(in,'contour')
  % set checkbox:
  R_plotopt('contourcb');
  % plot:
  R_disp;
end

% --------------------------------------------------------------------
% do pcolor
% --------------------------------------------------------------------
if isequal(in,'pcolor')
  % set checkbox:
  R_plotopt('pcolorcb');
  % plot:
  R_disp;
end

% --------------------------------------------------------------------
% check contour vals
% --------------------------------------------------------------------
if isequal(in,'contourvals')
  vals=get(contourvals,'string');
  v=str2num(vals);
  if isnumber(v,-1)
    if length(v) > 1
      % first remove old ] and [:
      vals=strrep(vals,']','');
      vals=strrep(vals,'[',''); 
      set(contourvals,'string',['[',vals,']']);
    end
  else
    set(contourvals,'string','5');
  end
end


% from here output figure is needed:
% find it (last one)

figs    = get(0,'children');
outputs = findobj(figs,'tag','rcdv_output');
if isempty(outputs)
  last = [];
else
  last = outputs(1);
end

% --------------------------------------------------------------------
% do clabel
% --------------------------------------------------------------------
if isequal(in,'clabel')
  if ~isempty(last)
    figure(last)
  else
    return
  end
  if ~isempty(Cs_), clabel(Cs_,'manual'),  end
end

% --------------------------------------------------------------------
% do caxis
% --------------------------------------------------------------------
if isequal(in,'pcolorcaxis');
  N_checkeditvals(pcolorcaxis,2,'0 1');

  if ~isempty(last)
    figure(last)
  else
    return
  end

  cax = str2num(get(H.ROMS.his.pcolorcaxis,'string'));
  caxis(cax);
  colorbar

end


