function S_release_bathy
%function S_release_bathy
%Draw 3D bathymetry from grid NetCDF file
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt


global FGRID  

if ~isempty(FGRID.name)
  lon=S_get_ncvar(FGRID.name,'longitude');
  lat=S_get_ncvar(FGRID.name,'latitude');
  mask=S_get_ncvar(FGRID.name,'mask');
  h=S_get_ncvar(FGRID.name,'bathymetry');
  
  figure;
  set(gcf,'numbertitle','off','name','BATHY');
  
  %---------------------------------------------------------------------
  % h:
  %---------------------------------------------------------------------
  sh=surfl(lon,lat,-h);
  set(sh,'facecolor',[0 .737 1],'edgecolor','none','AmbientStrength',0.5);
  set(sh,'AmbientStrength',[0.3],'DiffuseStrength',[0.8]);
  set(sh,'SpecularStrength',[0],'SpecularExponent',[25]);
  set(sh,'SpecularColorReflectance',[1]); % material == dull
  hold on 
  [c3 h3]=contour3(lon,lat,-h);
  set(h3(:),'edgecolor',[.92 .92 .92]);
  
  %---------------------------------------------------------------------
  % mask:
  %---------------------------------------------------------------------
  sm=surf(lon,lat,zero2nan(mask,1)-min(min(h)));
  set(sm,'facecolor','yellow','edgecolor','none');
  %set(sm,'FaceAlpha', [1]);
  %line:
  [cs,c]=contour(lon,lat,mask,[.5 .5],'r');
  set(c,'linewidth',3,'visible','off');
  i=find(cs(1,:) > max(max(lon)) | cs(2,:) < min(min(lon))) ;
  for j=1:length(i)
    cs(1,i(j))=nan;
    cs(2,i(j))=nan;
  end
  c=plot3(cs(1,2:end),cs(2,2:end),zeros(size(cs(1,2:end))));
  set(c,'linewidth',1,'color',[.711 .337 0]);
  
  camlight
  %---------------------------------------------------------------------
  
  title(FGRID.name,'interpreter','none')
  xlabel('lon\_rho');
  ylabel('lat\_rho');
  zlabel('depth')
  
  %ar=get(gca,'DataAspectRatio');
  %set(gca,'DataAspectRatio',[1 1 ar(3)]);
  
else
  errordlg('No grid loaded','misssing...','modal');
end

return

