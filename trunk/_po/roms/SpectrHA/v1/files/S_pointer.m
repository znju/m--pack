function S_pointer(type);
%function S_pointer(type);
%Change mouse pointer
%type: 'arrow', 'watch', 'crosshair', ...
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

if nargin == 0
  type='arrow';
end

set(HANDLES.fig,'pointer',type); 
