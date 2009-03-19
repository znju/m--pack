function N_setfontsize(where,fontsize)
%N_setfontsize
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% sets selected fontsize (in menus) for the GUI objects

global H

switch where
  case 'ax'       % axes:
    obj = findobj(gcf,'type','axes');
    set(obj,'fontSize',fontsize);

    % restore positions of axes and colorbar:
    N_axProp;

    % set checked menu:
    set(findobj(gcf,'tag','menu_fontsize_ax'),'checked','off');
    set(H.menu_fontsize_ax_(fontsize),'checked','on');

  case 'edit'   % edit uicontrols
    obj = findobj(gcf,'type','uicontrol','style','edit');
    set(obj,'fontSize',fontsize);

    % set checked menu:
    set(findobj(gcf,'tag','menu_fontsize_edit'),'checked','off');
    set(H.menu_fontsize_edit_(fontsize),'checked','on');

  case 'push'   % pushbuttons, toggle, radio, checkbox
    obj = findobj(gcf,'type','uicontrol','style','pushbutton');
    set(obj,'fontSize',fontsize);

    obj = findobj(gcf,'type','uicontrol','style','togglebutton');
    set(obj,'fontSize',fontsize);

    obj = findobj(gcf,'type','uicontrol','style','radiobutton');
    set(obj,'fontSize',fontsize);

    obj = findobj(gcf,'type','uicontrol','style','checkbox');
    set(obj,'fontSize',fontsize);

     % set checked menu:
     set(findobj(gcf,'tag','menu_fontsize_push'),'checked','off');
     set(H.menu_fontsize_push_(fontsize),'checked','on');

  case 'text'  % text, listbox.
    obj = findobj(gcf,'type','uicontrol','style','text');
    set(obj,'fontSize',fontsize);

    obj = findobj(gcf,'type','uicontrol','style','listbox');
    set(obj,'fontSize',fontsize);

    % set checked menu:
    set(findobj(gcf,'tag','menu_fontsize_text'),'checked','off');
    set(H.menu_fontsize_text_(fontsize),'checked','on');
end
