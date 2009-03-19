function R_clabel
global H

evalc('vals=H.ROMS.grid.contours;','vals=[];');
if isempty(vals)
  return
end
axes(H.ROMS.axes);

is_hold=ishold;
hold on

uistate=uisuspend(gcf);
set(gcf,'pointer','crosshair'); 
button = 'normal';
while strcmp(button,'normal')
  keydown = waitforbuttonpress;
  button = get(gcf, 'SelectionType');
  if  strcmp(button,'normal')
    if gca==H.ROMS.axes
      cp=get(gca,'currentpoint');
      xi=cp(1,1);
      yi=cp(1,2);
      
      dist=(xi-H.ROMS.grid.contours(1,:)).^2+(yi-H.ROMS.grid.contours(2,:)).^2;
      [y,i]=min(dist);
      plot(H.ROMS.grid.contours(1,i),H.ROMS.grid.contours(2,i),'+');
      for k=i-1:-1:1 % find contour value
        ivalue=ismember(H.ROMS.grid.contours_values,H.ROMS.grid.contours(1,k));
        if  any(ivalue)
          [J,j]=find(ivalue == 1);
          val=H.ROMS.grid.contours_values(j);
          if isnan(H.ROMS.grid.contours(1,k+1))
            break
          end
        end
      end
      str=num2str(val);
      text(H.ROMS.grid.contours(1,i),H.ROMS.grid.contours(2,i),[' ',str],'FontSize',7,'VerticalAlignment','baseline');
    else
      button='not the desired axes';
    end % click correct axes
  end
end % while
set(gcf,'pointer','arrow');
uirestore(uistate);

if  ~is_hold
  hold off
end
