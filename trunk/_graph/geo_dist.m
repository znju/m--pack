function geo_dist(what)
%GEO_DIST   Display distances on axis
%   Adds the menu dist to current figure. When used you can draw
%   a line in current axis and the distance is shown. The line can
%   then be moved and the distance updated. To keep the distance
%   value, click on the line with the third mouse button.
%   To remove the dist menu call geo_dist again.
%   The earth radius 6370 km is used.
%
%   MMA 2004, martinho@fis.ua.pt
%
%   See also M_INPUT SPH_DIST

%   Department of physics
%   University of Aveiro

if nargin==0
  what=[];
  figure(gcf)
  a=findobj(gcf,'tag','DIST_MENU');
  if isempty(a)
    uimenu('label','»dist«','callback','geo_dist(''start'')','tag','DIST_MENU');
  else
    delete(a);
  end
end

if isequal(what,'start')
  h=ishold;
  hold on
  N=1;
  set(gcf,'pointer','crosshair');
  [x,y]=m_input(N);
  if ~isempty(x)
    obj=plot(x,y,'r+-','tag','DIST_OBJ_start','EraseMode','xor');
    set(gcf,'WindowButtonMotionFcn','geo_dist(''create'')');
  else
    set(gcf,'pointer','arrow');
  end
end

if isequal(what,'create')
  cp=get(gca,'currentpoint');
  cp=cp(1,1:2);
  obj=findobj(gcf,'tag','DIST_OBJ_start');
  x0=get(obj,'xdata');
  y0=get(obj,'ydata');
  set(obj,'xdata',[x0(1) cp(1)],'ydata',[y0(1) cp(2)]);
  set(gcf,'WindowButtonUpFcn','geo_dist(''stop'')');
  if x0(1)==cp(1) | y0(1)==cp(2)
    set(obj,'MarkerEdgeColor','k')
  else
    set(obj,'MarkerEdgeColor','r')
  end
  disp_dist(obj);
end

if isequal(what,'stop')
  set(gcf,'WindowButtonMotionFcn','');
  set(gcf,'pointer','arrow');
  obj=findobj(gcf,'tag','DIST_OBJ_start');
  set(obj,'tag','DIST_OBJ');
  set(gcf,'WindowButtonDownFcn','geo_dist(''select'')');
  if length(get(obj,'xdata')) == 1
    delete(obj)
  end
  button=get(gcf,'selectiontype');
% normal = left mouse button
% alt    = rigth mouse button
% extend = third (wheel) mouse button
  if ~isequal(button,'extend');
    stop_disp_dist;
  end
end

if isequal(what,'select')
  tag=get(gco,'tag');
  if isequal(tag,'DIST_OBJ')
    obj=gco;
    cp=get(gca,'currentpoint');
    cp=cp(1,1:2);
    set(obj,'userData',cp);
    x0=get(obj,'xdata');
    y0=get(obj,'ydata');
    d=sqrt((x0-cp(1)).^2+(y0-cp(2)).^2);
    len=sqrt((x0(2)-x0(1)).^2+(y0(2)-y0(1)).^2);
    [val,i]=min(d);
    if any(d < len/4)
      if i==1
        set(gcf,'WindowButtonMotionFcn','geo_dist(''move1'')');
      end
      if i==2
        set(gcf,'WindowButtonMotionFcn','geo_dist(''move2'')');
      end
    else
      set(gcf,'WindowButtonMotionFcn','geo_dist(''move'')');
    end
    disp_dist(obj);
  end
end

if isequal(what,'move1')
  obj=gco;
  cp=get(gca,'currentpoint');
  cp=cp(1,1:2);
  x0=get(obj,'xdata');
  y0=get(obj,'ydata');
  set(obj,'xdata',[cp(1) x0(2) ],'ydata',[cp(2) y0(2) ]);
  set(gcf,'WindowButtonUpFcn','geo_dist(''stop'')');
  if cp(1)==x0(2) | cp(2)==y0(2)
    set(obj,'MarkerEdgeColor','k')
  else
    set(obj,'MarkerEdgeColor','r')
  end
  disp_dist(obj);
end
if isequal(what,'move2')    
  obj=gco;
  cp=get(gca,'currentpoint');
  cp=cp(1,1:2);
  x0=get(obj,'xdata');
  y0=get(obj,'ydata');
  set(obj,'xdata',[x0(1) cp(1)],'ydata',[y0(1) cp(2)]);
  set(gcf,'WindowButtonUpFcn','geo_dist(''stop'')');
  if x0(1)==cp(1) | y0(1)==cp(2)
    set(obj,'MarkerEdgeColor','k')
  else
    set(obj,'MarkerEdgeColor','r')
  end
  disp_dist(obj);
end
if isequal(what,'move')
  obj=gco;
  cp=get(gca,'currentpoint');
  cp=cp(1,1:2);
  x0=get(obj,'xdata');
  y0=get(obj,'ydata');
  pt=get(obj,'userData');
  set(obj,'userData',cp);
  x_rel=cp(1)-pt(1);
  y_rel=cp(2)-pt(2);
  set(obj,'xdata',x0+x_rel,'ydata',y0+y_rel);
  set(gcf,'WindowButtonUpFcn','geo_dist(''stop'')');
  disp_dist(obj);
end

function disp_dist(obj)
x=get(obj,'xdata');
y=get(obj,'ydata');
dist=sph_dist(x(1),y(1),x(2),y(2),6370);
str=['( ',num2str(dist),' Km )'];
stop_disp_dist
txt=text(.5*(x(2)+x(1)),.5*(y(2)+y(1)),str);
set(txt,'tag','DIST_OBJ_LABEL','EraseMode','xor','fontsize',8,...
  'HorizontalAlignment','center','VerticalAlignment','bottom');
ang=atan2(y(2)-y(1),x(2)-x(1));
set(txt,'rotation',ang*180/pi);
button=get(gcf,'selectiontype');
if isequal(button,'extend');
  set(txt,'tag','DIST_OBJ_LABEL_locked');
end

function stop_disp_dist
label=findobj(gca,'tag','DIST_OBJ_LABEL');
delete(label);
