function R_contour(fname)

global H

if nargin ==  0
  % first look for his file:
  evalc('fname=H.ROMS.his.fname','fname=[]');

  % now try from grid file:
  if isempty(fname)
    evalc('fname=H.ROMS.grid.fname','fname=[]');
  end
end

if isempty(fname)
  return
end

[lonr,latr,h] = roms_grid(fname);

str_values=get(H.ROMS.grid.contour,'string');
values=str2num(str_values);
hold on

values=str2num(str_values);
tmp_contour_values=[];
for i=1:length(values) % remove already contoured values:
  if  ~ ismember(values(i),H.ROMS.grid.contours_values)
    tmp_contour_values=[tmp_contour_values values(i)];
  end
end

if isempty(values) | ~isempty(findstr('nan',str_values)) |  ~isempty(findstr('NaN',str_values))
  errordlg('Wrong contours');
elseif ~ isempty(tmp_contour_values)        
  for i=1:length(tmp_contour_values)
    [cs,line]=contour(lonr,latr,h,[tmp_contour_values(i) tmp_contour_values(i)],'b-');
    if ~ isempty(cs) % dont include empty contours:  
      cs(:,3:end+1)=cs(:,2:end);cs(:,2)=NaN; % to know the start
      H.ROMS.grid.contours=[H.ROMS.grid.contours cs];
      H.ROMS.grid.contours_values=[H.ROMS.grid.contours_values tmp_contour_values(i)];
      H.ROMS.grid.contours_values=sort(H.ROMS.grid.contours_values);
    end
  end
end
