function R_release_llmask
%function S_release_llmask
%Draw pcolor of lon_rho,lat_rho,mask_rho from grid NetCDF file
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FGRID

if ~isempty(FGRID.name)
  lon=S_get_ncvar(FGRID.name,'longitude');
  lat=S_get_ncvar(FGRID.name,'latitude');
  mask=S_get_ncvar(FGRID.name,'mask');

  figure;
  set(gcf,'numbertitle','off','name','MASK_RHO');
  
  pcolor(lon,lat,mask); colormap([.5 .5 .5;1 1 1]);
  title(FGRID.name,'interpreter','none')
  xlabel('lon\_rho');
  ylabel('lat\_rho');

else
  errordlg('No grid loaded','missing...','modal');
end

return

