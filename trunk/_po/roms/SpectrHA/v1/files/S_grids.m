function S_grids
%function S_grids
%Add gridlines to grid or spectrum axis
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

S_pointer

if gco == HANDLES.add_grids_grid
  axes(HANDLES.grid_axes);
elseif gco == HANDLES.add_grids_spect
  axes(HANDLES.spectrum_axes);
end

grid;
%set(gca,'gridlinestyle','--');

S_upd_legend; % refresh legend

