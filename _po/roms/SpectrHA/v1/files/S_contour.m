function S_contour
%function S_contour
%Add contours to current grid 
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FGRID HANDLES LOOK ETC

S_pointer
axes(HANDLES.grid_axes);

str_values=get(HANDLES.contours,'string');
values=str2num(str_values);
tmp_contour_values=[];
for i=1:length(values) % remove already contoured values:
    if  ~ ismember(values(i),FGRID.contour_values)
        tmp_contour_values=[tmp_contour_values values(i)];
    end
end
if isempty(FGRID.name)
    errordlg('No grid loaded','missing...','modal');
else
    if isempty(values) | ~isempty(findstr('nan',str_values)) |  ~isempty(findstr('NaN',str_values))
        errordlg('Wrong contours','wrong...','modal');
    elseif ~ isempty(tmp_contour_values)
        lon=S_get_ncvar(FGRID.name,'longitude');
        lat=S_get_ncvar(FGRID.name,'latitude');
        h=S_get_ncvar(FGRID.name,'bathymetry');
        for i=1:length(tmp_contour_values)
            [cs,line]=contour(lon,lat,h,[tmp_contour_values(i) tmp_contour_values(i)],'b-');
            for li=1:length(line)
              set(line(li),'color',LOOK.color.contours);
              ETC.handles.contours(end+1)=line(li);
            end
            if ~ isempty(cs) % dont include empty contours:  
                cs(:,3:end+1)=cs(:,2:end);cs(:,2)=NaN; % to know the start
                FGRID.contours=[FGRID.contours cs];
                FGRID.contour_values=[FGRID.contour_values tmp_contour_values(i)];
                FGRID.contour_values=sort(FGRID.contour_values);
            end
        end
    end
end
set(HANDLES.contours,'string','contours');

if exist('h')
  FGRID.hmin=min(min(h));
end

return
