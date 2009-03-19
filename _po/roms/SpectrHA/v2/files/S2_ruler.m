function S2_ruler(what)

global HANDLES ETC

new_v=0;
new_h=0;
move=0;
stop=0;
del=0;
if isequal(what,'newV')
  new_v=1;
elseif isequal(what,'newH')
  new_h=1;
elseif isequal(what,'move')
  move=1;
elseif isequal(what,'stop')
  stop=1;
elseif isequal(what,'del')
  del=1;
end

%---------------------------------------------------------------------

if new_h | new_v
  S_pointer('crosshair');
  [xi,yi]=m_input(1);
  S_pointer('arrow');

  yl=ylim;
  xl=xlim;

  color=[0 1 0];
  selected=0;

  info.color=color;
  info.selected=selected;
end

if gca~=HANDLES.grid_axes
  new_v=0;
  new_h=0;
end

%---------------------------------------------------------------------

if new_v
  ETC.ruler_v=plot([xi xi],yl,'color',color,'Erasemode','xor');
  set(ETC.ruler_v,'tag','ruler_v');
  set(ETC.ruler_v,'userdata',info);
  set(gcf,'WindowButtonMotionFcn','S2_ruler(''move'')');
  S_axes_prop;
end

if new_h
  ETC.ruler_h=plot(xl,[yi yi],'color',color,'Erasemode','xor');
  set(ETC.ruler_h,'tag','ruler_h');
  set(ETC.ruler_h,'userdata',info);
  set(gcf,'WindowButtonMotionFcn','S2_ruler(''move'')');
  S_axes_prop;
end

%---------------------------------------------------------------------
if move  
  set(gcf,'WindowButtonMotionFcn','S2_ruler(''move'')');
  S2_disp_pos
  cp=get(gca,'currentpoint');
  cp=cp(1,1:2);
  
  obj=gco; %obj=ETC.ruler_v;

  tag=get(obj,'tag');
  info=get(obj,'userdata');

  if isequal(tag,'ruler_v')
    set(gcf,'Pointer','right');
    set(obj,'XData',[cp(1) cp(1)])
    set(obj,'Marker','square');
%    set(obj,'MarkerFaceColor','r','MarkerSize',12);
    if ishandle(ETC.new.txt)
      set(ETC.new.txt,'position',cp,'string',[' (',num2str(cp(1)),')'])
    else
      ETC.new.txt=text(cp(1),cp(2),[' (',num2str(cp(2)),')'],'color','w','erasemode','xor',...
                'HorizontalAlignment','left','VerticalAlignment','middle');
    end

    xl=xlim;
    if cp(1) > xl(2) | cp(1) < xl(1)
      S_pointer
      delete(obj);
      delete(ETC.new.txt);
      ETC.new.txt=[];
    end

  end

  if isequal(tag,'ruler_h')
    set(gcf,'Pointer','top');
    set(obj,'YData',[cp(2) cp(2)])
    set(obj,'Marker','square');
%    set(obj,'MarkerFaceColor','r','MarkerSize',12);
    if ishandle(ETC.new.txt)
      set(ETC.new.txt,'position',cp,'string',['(',num2str(cp(2)),')'])
    else
      ETC.new.txt=text(cp(1),cp(2),['(',num2str(cp(2)),')'],'color','w','erasemode','xor',...
                'HorizontalAlignment','center','VerticalAlignment','bottom');
    end
    
    yl=ylim;
    if cp(2) > yl(2) | cp(2) < yl(1)
      S_pointer
      delete(obj);
      delete(ETC.new.txt);
      ETC.new.txt=[];
    end
  end
  set(gcf,'WindowButtonUpFcn','S2_ruler(''stop'')'); 
  
end

%---------------------------------------------------------------------
if stop
  set(gcf,'WindowButtonMotionFcn','S2_disp_pos');
  set(gcf,'WindowButtonDownFcn','S2_ruler(''move'')');
  p=get(gcf,'pointer');
%  if ~isequal(p,'circle') & ~isequal(p,'crosshair') % when selecting or clabel, keep pointer!!
    set(gcf,'pointer','arrow');
%  end

  obj=gco;
  if isruler(obj)
    set(obj,'marker','none');
  end

  delete(ETC.new.txt);
  ETC.new.txt=[];
  
end

%---------------------------------------------------------------------
function result=isruler(obj)
result=0;
tag=get(obj,'tag');
if findstr('ruler',tag)
  result=1;
end


