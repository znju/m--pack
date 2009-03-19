function S_2_clabel;
%function S_2_clabel
%Add labels to current contours
%
%this function is part of SpectrHA utility (v1 and modif at v2)
%MMA, Jul-2003
%martinho@fis.ua.pt

global FGRID HANDLES ETC LOOK

S_pointer

if ~ isempty(FGRID.contours)
    
    uistate=uisuspend(gcf);

    %»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»» Add new:
    %uirestore(uistate,'WindowButtonMotionFcn')
    set(gcf,'WindowButtonMotionFcn','S2_disp_pos'); % do not move rulers !!
    %«««««««««««««««««««««««««««««««««««««««««««««« done,

    S_pointer('crosshair'); 
    button = 'normal';
    while strcmp(button,'normal')
        keydown = waitforbuttonpress;
        button = get(gcf, 'SelectionType');
        parent=get(gco,'parent');
        if  strcmp(button,'normal')
            if gca==HANDLES.grid_axes%strcmp(get(parent,'tag'),'grid_axes')
                cp=get(gca,'currentpoint');
                xi=cp(1,1);
                yi=cp(1,2);

                dist=(xi-FGRID.contours(1,:)).^2+(yi-FGRID.contours(2,:)).^2;
                [y,i]=min(dist);
                ETC.handles.clabel_marker(end+1)=plot(FGRID.contours(1,i),FGRID.contours(2,i),'+');
		set(ETC.handles.clabel_marker(end),'color',LOOK.color.clabel_marker);
                for k=i-1:-1:1 % find contour value
                    ivalue=ismember(FGRID.contour_values,FGRID.contours(1,k));
                    if  any(ivalue)
                        [J,j]=find(ivalue == 1);
                        val=FGRID.contour_values(j);
                        if isnan(FGRID.contours(1,k+1))
                            break
                        end
                    end
                end
                str=num2str(val);
                ETC.handles.clabel_label(end+1)=text(FGRID.contours(1,i),FGRID.contours(2,i),[' ',str],'FontSize',7);
		set(ETC.handles.clabel_label(end),'color',LOOK.color.clabel_label);
            else
                button='not the desired axes';
            end % click correct axes
        end
    end % while
        S_pointer
        uirestore(uistate);
else 
    errordlg('No contours defined','missing...','modal');
end

return
