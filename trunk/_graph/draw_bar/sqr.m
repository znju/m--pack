function sqr(task,point)
%SQR   Add rectangle to current axis
%   When SQR is called click with left mouse button on axis and drag
%   it to construct the desired rectangle. To reshape it use the
%   marker  points. To drag object, use left or right on the line,
%   not on markers. Use third button to delete the object.
%
%   SQR is part of DRAW_BAR tool
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
  s     = plot(x,y,'r','erasemode','xor','tag','sqr'); 
  hold on
  s_aux = plot(x,y,'bs','erasemode','xor','tag','sqr_aux');

  set(s,'userdata',s_aux);
  set(s_aux,'userdata',s);

  motion=['sqr(''create'',[',num2str(point),'])'];
  set(gcf,'windowbuttonMotionfcn',motion);
  set(gcf,'windowbuttonUpfcn','sqr(''stop'')');
  set(gcf,'windowbuttonDownfcn','sqr(''get'')');

  handles=[s_aux,s];
  set(gca,'userdata',handles);

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


  cp=get(gca,'currentpoint');
  x=cp(1,1);
  y=cp(1,2);

  xi=point(1);
  yi=point(2);

  xx=[xi x x xi xi];
  yy=[yi yi y y yi];
  set(s,'xdata',xx,'ydata',yy);

  xm=(x+xi)/2;
  ym=(y+yi)/2;
  xx=[xi xm x x x xm xi xi];
  yy=[yi yi yi ym y  y y ym];
  set(s_aux,'xdata',xx,'ydata',yy);
end

if isequal(task,'get')
  cp=get(gca,'currentpoint');
  xi=cp(1,1);
  yi=cp(1,2);
  if isequal(get(gco,'tag'),'sqr_aux')
    x=get(gco,'xdata');
    y=get(gco,'ydata');
    dist=(x-xi).^2 + (y-yi).^2;
    i=find(dist==min(dist));
    point=i(1);
    motion=['sqr(''move'',[',num2str(point),'])'];
    set(gcf,'windowbuttonMotionfcn',motion);

  elseif isequal(get(gco,'tag'),'sqr')
    point=[xi,yi];
    motion=['sqr(''move'',[',num2str(point),'])'];
    set(gcf,'windowbuttonMotionfcn',motion);
  end

  if isequal(get(gco,'tag'),'sqr') & isequal(get(gcf,'SelectionType'),'extend')
    aux=get(gco,'userdata');
    delete(gco);
    delete(aux);
  end
end

% ========================================================= move
if isequal(task,'move');
  if isequal(get(gco,'tag'),'sqr_aux')
    x=get(gco,'xdata');
    y=get(gco,'ydata');
    cp=get(gca,'currentpoint');
    xi=cp(1,1);
    yi=cp(1,2);

    i= point;
    switch i
      case 1
        x([1 7 8])=xi;
        y([1 2 3])=yi;
      case 3
        x([3 4 5])=xi;
        y([1 2 3])=yi;
      case 5
        x([3 4 5])=xi;
        y([5 6 7])=yi;
      case 7
        x([1 7 8])=xi;
        y([5 6 7])=yi;
      case {2,6}
        y(i-1:i+1)=yi;
      case 4
        x(i-1:i+1)=xi;
      case 8
        x([1 7 8])=xi;
    end
    xm=(x(1)+x(3))/2;
    ym=(y(3)+y(5))/2;
    x([2 6])=xm;
    y([4 8])=ym;

    x_=[x(1) x(3) x(5) x(7) x(1)];
    y_=[y(1) y(3) y(5) y(7) y(1)];

    set(gco,'xdata',x,'ydata',y);
    s=get(gco,'userdata');
    set(s,'xdata',x_,'ydata',y_);

  end

  if isequal(get(gco,'tag'),'sqr') &  ~isequal(get(gcf,'SelectionType'),'extend')
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
    motion=['sqr(''move'',[',num2str(point),'])'];
    set(gcf,'windowbuttonMotionfcn',motion);
  end
end


if isequal(task,'stop')
  set(gcf,'windowbuttonMotionfcn','');

  % delete if there was no motion, ie, sqr is just one point: - at creation
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
  % delete after moving:
  if isequal(get(gco,'tag'),'sqr') | isequal(get(gco,'tag'),'sqr_aux')
    other=get(gco,'userdata');
    x=get(gco,'xdata');
    y=get(gco,'ydata');
    if length(unique(x))==1 & length(unique(y))==1
      delete(gco);
      delete(other);
    end
  end

end
