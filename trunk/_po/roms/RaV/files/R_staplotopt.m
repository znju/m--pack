function R_staplotopt(in)

global H

contourcb   = H.ROMS.sta.contourcb;     % handle
pcolorcb    = H.ROMS.sta.pcolorcb;      % handle
plotcb      = H.ROMS.sta.plotcb;        % handle
contourvals = H.ROMS.sta.contourvals;   % handle
pcolorcaxis = 'H.ROMS.sta.pcolorcaxis'; % handle name
evalc('Cs          = H.ROMS.sta.cs;','Cs=[];');            % contour cs vals (from [cs,ch]=contour...)

% --------------------------------------------------------------------
% change contour/pcolor checkboxes
% --------------------------------------------------------------------
if isequal(in,'contourcb') | isequal(in,'pcolorcb')  | isequal(in,'plotcb')
  set(contourcb, 'value',0);
  set(pcolorcb,  'value',0);
  set(plotcb,    'value',0);
  if isequal(in,'contourcb'), set(contourcb, 'value',1); end
  if isequal(in,'pcolorcb'),  set(pcolorcb,  'value',1);  end
  if isequal(in,'plotcb'),    set(plotcb,    'value',1);  end
end

% --------------------------------------------------------------------
% do contour
% --------------------------------------------------------------------
if isequal(in,'contour')
  % set checkbox:
  R_staplotopt('contourcb');
  % plot:
  R_stadisp;
end

% --------------------------------------------------------------------
% do pcolor
% --------------------------------------------------------------------
if isequal(in,'pcolor')
  % set checkbox:
  R_staplotopt('pcolorcb');
  % plot:
  R_stadisp;
end

% --------------------------------------------------------------------
% do plot
% --------------------------------------------------------------------
if isequal(in,'plot')
  % set checkbox:
  R_staplotopt('plotcb');
  % plot:
  R_stadisp;
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

  if ~isempty(Cs), clabel(Cs,'manual'),  end
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

  cax = str2num(get(H.ROMS.sta.pcolorcaxis,'string'));
  caxis(cax);
  colorbar

end


