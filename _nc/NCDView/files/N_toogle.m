function N_toogle(what)
%N_toogle
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% controls tooglebuttons : grid, zoom, rotate, axis_eq

global H

%axes(H.axes);
figure(H.fig);
axes(gca);

switch what
  case 'grid'
    if get(H.grid,'value')
      grid on
      evalc('set(gca,''XMinorTick'',''on'',''YMinorTick'',''on'')','');
    else
      grid off
      evalc('set(gca,''XMinorTick'',''off'',''YMinorTick'',''off'')','');
    end

  case 'zoom'
    if get(H.zoom,'value')
      zoom on
    else
      zoom off
    end

  case 'rotate'
    if get(H.rotate,'value')
      rotate3d on
    else
      rotate3d off
    end

  case 'axis_eq'
    if get(H.axis_eq,'value')
      axis equal
    else
      axis normal
    end

end

%%%%%%
% ps: zoom and rotation are not compatible, so when one is on, the other
% must be off, so:
if isequal(what,'zoom') & get(H.zoom,'value')
  set(H.rotate,'value',0)
end
if isequal(what,'rotate') & get(H.rotate,'value')
  set(H.zoom,'value',0)
end
