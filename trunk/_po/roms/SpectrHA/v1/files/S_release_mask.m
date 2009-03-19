function S_release_mask
%function S_release_mask
%Draw pcolor of mask_rho from grid NetCDF file
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FGRID

if ~isempty(FGRID.name)
  mask=S_get_ncvar(FGRID.name,'mask');

  figure;
  set(gcf,'numbertitle','off','name','MASK_RHO');
  
  pcolor(mask); colormap([.5 .5 .5;1 1 1]);
  title(FGRID.name,'interpreter','none')

else
  errordlg('No grid loaded','missing...','modal');
end

return

