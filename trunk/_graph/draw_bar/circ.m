function circ(task,point)
%CIRC   Add circumference to current axis
%   When CIRC is called click with left mouse button on axis and drag
%   it to construct the desired circumference. To reshape it use the
%   marker  points. To drag object, use left or right on the line,
%   not on markers. Use third button to delete the object.
%
%   CIRC is part of DRAW_BAR tool
%
%   MMA 2004, martinho@fis.ua.pt
%
%   See also DRAW_BAR

%   Department of Physics
%   University of Aveiro, Portugal

if nargin == 0
  task='create';
end

% ========================================================= create
if isequal(task,'create') & nargin<2
  h=ishold;
  [x,y,button]=ginput(1);

  point=[x,y];
  s     = plot(x,y,'r','erasemode','xor','tag','circ'); 
  hold on
  s_aux = plot(x,y,'bs','erasemode','xor','tag','circ_aux');

  set(s,'userdata',s_aux);
  set(s_aux,'userdata',s);

  motion=['circ(''create'',[',num2str(point),'])'];
  set(gcf,'windowbuttonMotionfcn',motion);
  set(gcf,'windowbuttonUpfcn','circ(''stop'')');
  set(gcf,'windowbuttonDownfcn','circ(''get'')');

  handles=[s_aux,s];
  set(gca,'userdata',handles);

  % settings:
  evalc('setgs=draw_bar(''setgs'');','setgs=[]');
  if ~isempty(setgs)
    set(s,'color',     setgs.LineColor);
    set(s,'LineWidth', setgs.LineWidth);
    set(s_aux,'color',       setgs.MarkerColor);
    set(s_aux,'MarkerSize', setgs.MarkerSize);
  end

elseif isequal(task,'create') & nargin == 2
  handles=get(gca,'userdata');
  s_aux=handles(1);
  s=handles(2);

  x1=point(1);
  y1=point(2);

  cp=get(gca,'currentpoint');
  x=cp(1,1);
  y=cp(1,2);

  [xx,yy]=re_circ(x1,y1,x,y);
  set(s,'xdata',xx,'ydata',yy);
  set(s_aux,'xdata',[x1 x],'ydata',[y1 y]);
end

if isequal(task,'get')
  cp=get(gca,'currentpoint');
  xi=cp(1,1);
  yi=cp(1,2);
  if isequal(get(gco,'tag'),'circ_aux')
     x=get(gco,'xdata');
     y=get(gco,'ydata');
     dist=(x-xi).^2 + (y-yi).^2;
     i=find(dist==min(dist));
     point=i(1);
    motion=['circ(''move'',[',num2str(point),'])'];
    set(gcf,'windowbuttonMotionfcn',motion);

  elseif isequal(get(gco,'tag'),'circ')
    point=[xi yi];
    motion=['circ(''move'',[',num2str(point),'])'];
    set(gcf,'windowbuttonMotionfcn',motion);
  end

  if isequal(get(gco,'tag'),'circ') & isequal(get(gcf,'SelectionType'),'extend')
    aux=get(gco,'userdata');
    delete(gco);
    delete(aux);
  end
end

if isequal(task,'move');
  if isequal(get(gco,'tag'),'circ_aux')
    x=get(gco,'xdata');
    y=get(gco,'ydata');
    if isequal(point,1)
      x1=x(2);
      y1=y(2);
    elseif isequal(point,2)
      x1=x(1);
      y1=y(1);
    end
    cp=get(gca,'currentpoint');
    x=cp(1,1);
    y=cp(1,2);

    [xx,yy]=re_circ(x1,y1,x,y);
    s=get(gco,'userdata');
    set(s,'xdata',xx,'ydata',yy);
    if isequal(point,1)
      set(gco,'xdata',[x x1],'ydata',[y y1]);
    else
      set(gco,'xdata',[x1 x],'ydata',[y1 y]);
    end
  end

  if isequal(get(gco,'tag'),'circ') & ~isequal(get(gcf,'SelectionType'),'extend')
    % move all
    x=get(gco,'xdata');
    y=get(gco,'ydata');
    aux=get(gco,'userdata');
    xx=get(aux,'xdata');
    yy=get(aux,'ydata');
    xi_=point(1);
    yi_=point(2);
    cp=get(gca,'currentpoint');
    xi=cp(1,1);
    yi=cp(1,2);
    dx=xi-xi_;
    dy=yi-yi_;

    set(gco,'xdata',x+dx,'ydata',y+dy);
    set(aux,'xdata',xx+dx,'ydata',yy+dy);
    point=[xi,yi];
    motion=['circ(''move'',[',num2str(point),'])'];
    set(gcf,'windowbuttonMotionfcn',motion);

  end
end

if isequal(task,'stop')
  set(gcf,'windowbuttonMotionfcn','');

  % delete if there was no motion, ie, circ is just one point: - at creation
  handles=get(gca,'userdata');
  s_aux=handles(1);
  s=handles(2);
  if ishandle(s)
    x=get(s_aux,'xdata');
    if length(x) == 1
      delete(s_aux);
      delete(s);
    end
  end
end

function [xx,yy]=re_circ(x1,y1,x,y)
xc=(x+x1)/2;
yc=(y+y1)/2;
r=sqrt((x1-xc)^2 + (y1-yc)^2);
tt=0:10:360; tt=tt*pi/180;
xx=r*cos(tt)+xc;
yy=r*sin(tt)+yc;
