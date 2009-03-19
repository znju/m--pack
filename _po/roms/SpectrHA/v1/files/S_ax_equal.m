function S_ax_equal
%function S_ax_equal
%Executes axis equal or axis normal upon grid axis
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

axes(HANDLES.grid_axes);
if get(gca,'dataaspectratio') == [1 1 1]
    axis normal
    set(HANDLES.axes_equal,'string','axis equal');
else
    axis equal
    set(HANDLES.axes_equal,'string','axis normal');
end

return
