function R_free3d

global H

% get fname:
fname = get(H.ROMS.axes_title,'string');
if isempty(fname)
  return
end

figure

% use defined contour values:
str_values=get(H.ROMS.grid.contour,'string');
values=str2num(str_values);
if length(values)==1, values=[values values]; end

plot_border3d(fname,'bathy',values);
view(3)
camlight
