function R_outputsett(in)

global H

% set xlim, ylim, ax eq, ax auto
% in last output new figure

% find last output figure:
figs    = get(0,'children');
outputs = findobj(figs,'tag','rcdv_output');
if isempty(outputs)
  return
end
last    = outputs(1);

figure(last);

axes(gca);  % shold test  if colorbar!

% --------------------------------------------------------------------
% check  if 2-d or 3-d:
% --------------------------------------------------------------------
is2d = get(H.ROMS.his.d2,'value');
is3d = get(H.ROMS.his.d3,'value');


% --------------------------------------------------------------------
% 2-d
% --------------------------------------------------------------------
if is2d

  if isequal(in,'xlim')
    % first check vals:
    xl=xlim;
    def=[num2str(xl(1)),'  ', num2str(xl(2))];
    N_checkeditvals('H.ROMS.his.xlim',2,def);
    % now, apply xlim:
    xl=str2num(get(H.ROMS.his.xlim,'string'));
    xlim(xl);
  end

  if isequal(in,'ylim')
    % first check vals:
    yl=ylim;
    def=[num2str(yl(1)),'  ', num2str(yl(2))];
    N_checkeditvals('H.ROMS.his.ylim',2,def);
    % now, apply ylim:
    yl=str2num(get(H.ROMS.his.ylim,'string'));
    ylim(yl);
  end

  if isequal(in,'ylim')
    % first check vals:
    zl=zlim;
    def=[num2str(zl(1)),'  ', num2str(zl(2))];
    N_checkeditvals('H.ROMS.his.zlim',2,def);
    % now, apply ylim:
    zl=str2num(get(H.ROMS.his.zlim,'string'));
    zlim(zl);
  end


  if isequal(in,'current')
    % get xlim, ylim and check checkboxes:
    xl=xlim;
    xl=[num2str(xl(1)),'  ', num2str(xl(2))];
    set(H.ROMS.his.xlim,'string',xl);
    set(H.ROMS.his.xlimcb,'value',1);

    yl=ylim;
    yl=[num2str(yl(1)),'  ', num2str(yl(2))];
    set(H.ROMS.his.ylim,'string',yl);
    set(H.ROMS.his.ylimcb,'value',1);

    zl=zlim;
    zl=[num2str(zl(1)),'  ', num2str(zl(2))];
    set(H.ROMS.his.zlim,'string',zl);
    set(H.ROMS.his.zlimcb,'value',1);
  end

end

% --------------------------------------------------------------------
% 3-d
% --------------------------------------------------------------------
if is3d
  if isequal(in,'xlim')
    % first check vals:
    xl = get(gca,'CameraPosition');
    def = [num2str(xl(1)),'  ', num2str(xl(2)),'  ', num2str(xl(3))];
    N_checkeditvals('H.ROMS.his.xlim',3,def)
    % now, apply CameraPosition:
    xl=str2num(get(H.ROMS.his.xlim,'string'));
    set(gca,'CameraPosition',xl);
  end

  if isequal(in,'ylim')
    % first check vals:
    yl = get(gca,'CameraTarget');
    def = [num2str(yl(1)),'  ', num2str(yl(2)),'  ', num2str(yl(3))];
    N_checkeditvals('H.ROMS.his.ylim',3,def)
    % now, apply CameraTarget:
    yl=str2num(get(H.ROMS.his.ylim,'string'));
    set(gca,'CameraTarget',yl);
  end

  if isequal(in,'zlim')
    % first check vals:
    zl = get(gca,'CameraViewAngle');
    def = num2str(zl);
    N_checkeditvals('H.ROMS.his.zlim',1,def)
    % now, apply CameraViewAngle:
    zl=str2num(get(H.ROMS.his.zlim,'string'));
    set(gca,'CameraViewAngle',zl);
  end

  if isequal(in,'current')
    xl = get(gca,'CameraPosition');
    xl = [num2str(xl(1)),'  ', num2str(xl(2)),'  ', num2str(xl(3))];
    set(H.ROMS.his.xlim,'string',xl);
    set(H.ROMS.his.xlimcb,'value',1);

    yl = get(gca,'CameraTarget');
    yl = [num2str(yl(1)),'  ', num2str(yl(2)),'  ', num2str(yl(3))];
    set(H.ROMS.his.ylim,'string',yl);
    set(H.ROMS.his.ylimcb,'value',1);

    zl = get(gca,'CameraViewAngle');
    set(H.ROMS.his.zlim,'string',zl);
    set(H.ROMS.his.zlimcb,'value',1);
  end

end

% --------------------------------------------------------------------
% ax equal, auto, close all  outputs
% --------------------------------------------------------------------
if isequal(in,'ax equal')
  % this is a togglebutton, so let it work only if value 0 --> 1
  % this is cos I wanna use it to set axis eq at display when value =1
  % anyway, value shall remain 1 ater ax auto
  thehandle = H.ROMS.his.axequal;
  if get(thehandle,'value')
    axis equal
  end
end

if isequal(in,'ax auto')
  axis auto
  axis normal
end

if isequal(in,'close all')
  for i=1:length(outputs)
    close(outputs(i));
  end
end
