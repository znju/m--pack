function S_spaxis(a)
%function S_spaxis(a)
%Execute "axis a", a= equal, normal, ...
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

eval(['axis ',a]);

if isequal(gca,HANDLES.spectrum_axes)
  xlim=get(gca,'xlim');
  set(HANDLES.xlim_i,'string',xlim(1));
  set(HANDLES.xlim_e,'string',xlim(2));
end

