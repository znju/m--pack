function S_2_hold
%function S_2_hold
%hold on/off
%
%this function is part of SpectrHA utility  (v2)
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»» Add
S2_hide_ax('off')
%««««««««««««««««««««««««««««««««««««««««««««««
axes(HANDLES.spectrum_axes);

if get(HANDLES.hold_spect,'value') == 1
  hold on
else
  hold off
end

% refresh legend
S_upd_legend

