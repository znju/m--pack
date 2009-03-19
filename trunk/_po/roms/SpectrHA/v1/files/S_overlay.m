function S_overlay
%function S_overlay
%Overlay coastline (lon and lat vectors) file on grid axis
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES ETC LOOK

fid=fopen(ETC.logname,'a');
[filename, pathname]=uigetfile('*.mat', 'Choose the Coastline file');
if (isequal(filename,0)|isequal(pathname,0))
  fname=[];
else
  fname=[pathname,filename];
  fprintf(fid,'%s\n',['# Loaded coastline: ',fname]);
end

load('-mat',fname);

if ~exist('lon') | ~exist('lat')
  errordlg('Lon and Lat not in loadded file','missing...','modal');
  return
end

axes(HANDLES.grid_axes);
hold on
ETC.handles.coastline=plot(lon,lat);
set(ETC.handles.coastline,'color',LOOK.color.coastline);
axis auto

S_axes_prop

return
