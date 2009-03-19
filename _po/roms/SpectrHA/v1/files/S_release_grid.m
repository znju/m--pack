function S_release_grid
%function S_release_grid
%Open grid in a new figure
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

figure
invert=1; %cos of current selected color!!
copy_axes(HANDLES.grid_axes,axes,'GRID',invert);
