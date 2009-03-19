function spl(task,point)
%SPL   Add spline line to current axis
%   When SPL is called click with left mouse button on axis to choose
%   points; to stop, click with right button. To create new points or
%   delete some, use right button. To drag object, use left button on
%   the line, not on markers. Use third button to delete the object.
%
%   SPL is part of DRAW_BAR tool
%
%   MMA 2004, martinho@fis.ua.pt
%
%   See also DRAW_BAR

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 1
 task='create';
end

% ========================================================= create
if isequal(task,'create');
  h=ishold;
  [x,y,button]=ginput(1);
  cont=0;
  while isequal(button,1)
    cont=cont+1;
    tmp(cont)=plot(x,y,'bo');
    hold on
    X(cont)=x;
    Y(cont)=y;
    [x,y,button]=ginput(1);
  end
  n=cont;
  if n>1
    delete(tmp);
    % rebuild spline:
    xy=[X;Y];
    xys=re_spline(xy);
    s=plot(xys(1,:),xys(2,:),'color','r','erasemode','xor');
    aux=plot(X,Y,'bs','erasemode','xor');
    set(s,  'userdata',aux);
    set(s,'tag','spline');
    set(aux,'userdata',s);
    set(aux,'tag','spl_aux');
    set(gcf,'windowbuttondownfcn','spl(''get'')');

    % settings:
    evalc('setgs=draw_bar(''setgs'');','setgs=[]');
    if ~isempty(setgs)
      set(s,'color',     setgs.LineColor);
      set(s,'LineWidth', setgs.LineWidth);
      set(aux,'color',       setgs.MarkerColor);
      set(aux,'MarkerSize', setgs.MarkerSize);
    end

  end
end

% ========================================================= get
if isequal(task,'get');
  %  if isequal(get(gco,'tag'),'spl_aux') 
  %    set(gco,'marker','square');
  %  elseif isequal(get(gco,'tag'),'spline')
  %    aux=get(gco,'userdata');
  %    set(aux,'marker','square');
  %  end

  cp=get(gca,'currentpoint');
  xi=cp(1,1);
  yi=cp(1,2);

  % find point to move:
  if isequal(get(gco,'tag'),'spl_aux')
    x=get(gco,'xdata');
    y=get(gco,'ydata');
    % find aux point selected:
    dist=(x-xi).^2 + (y-yi).^2 ;
    i=find(dist == min(dist));

    % -------------------------------------------- set motion;
    if isequal(get(gcf,'SelectionType'),'normal')
      motion=['spl(''move'',',num2str(i),')'];
      set(gcf,'windowbuttonMotionfcn',motion);
      set(gcf,'windowbuttonUpfcn','spl(''stop'')');

    % --------------------------------------------- remove point:
    elseif isequal(get(gcf,'SelectionType'),'alt')
      i=i(1);
      if i==1
        X=x(2:end);
        Y=y(2:end);
      elseif i==length(x)
        X=x(1:end-1);
        Y=y(1:end-1);
      else
        X=[x(1:i-1) x(i+1:end)];
        Y=[y(1:i-1) y(i+1:end)];
      end

      % rebuild aux:
      xy=[X;Y];
      set(gco,'xdata',xy(1,:),'ydata',xy(2,:));
      % rebuild or delete spline:
      s=get(gco,'userdata');
      n=size(xy,2);
      if n<=1
        delete(s);
        delete(gco);
      else
        % rebuild spline:
        xys=re_spline(xy);
        set(s,'xdata',xys(1,:),'ydata',xys(2,:));
      end
    end

  % ---------------------------------------------------- add new point:
  elseif isequal(get(gco,'tag'),'spline')
    if isequal(get(gcf,'SelectionType'),'alt')
      % add new point:
      % find position of it:
      x=get(gco,'xdata');
      y=get(gco,'ydata');
      N=length(x);
      % find spline point selected:
      dist=(x-xi).^2 + (y-yi).^2 ;
      i=find(dist == min(dist));
      % get aux points:
      aux=get(gco,'userdata');
      xx=get(aux,'xdata');
      yy=get(aux,'ydata');
      for  n=i:N
        if ismember(x(n),xx) & ismember(y(n),yy)
          break
        end
      end
      dist=(xx-x(n)).^2 + (yy-y(n)).^2 ;
      i=find(dist == min(dist));
      i_=i-1;
      % rebuilt aux
      X=[xx(1:i_) xi xx(i:end)];
      Y=[yy(1:i_) yi yy(i:end)];
      xy=[X;Y];
      set(aux,'xdata',xy(1,:),'ydata',xy(2,:));
      % rebuild spline:
      xys=re_spline(xy);
      set(gco,'xdata',xys(1,:),'ydata',xys(2,:));

    elseif isequal(get(gcf,'SelectionType'),'normal')
      % move all
      cp=get(gca,'currentpoint');
      xi=cp(1,1);
      yi=cp(1,2);
      point=[xi,yi];
       motion=['spl(''move'',[',num2str(point),'])'];
      set(gcf,'windowbuttonMotionfcn',motion);
      set(gcf,'windowbuttonUpfcn','spl(''stop'')');

    elseif isequal(get(gcf,'SelectionType'),'extend')
      % delete it:
      aux=get(gco,'userdata');
      delete(gco);
      delete(aux);
    end
  end
end % get

% ========================================================= move
if isequal(task,'move');
  if isequal(get(gco,'tag'),'spl_aux')
    x=get(gco,'xdata');
    y=get(gco,'ydata');
    cp=get(gca,'currentpoint');
    xi=cp(1,1);
    yi=cp(1,2);
    xy=[x;y];
    xy(:,point)=[xi;yi];
    % rebuild spline:
    xys=re_spline(xy);
    set(gco,'xdata',xy(1,:),'ydata',xy(2,:));
    s=get(gco,'userdata');
    set(s,'xdata',xys(1,:),'ydata',xys(2,:));
  end
  if isequal(get(gco,'tag'),'spline') & isequal(get(gcf,'SelectionType'),'normal')
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
    motion=['spl(''move'',[',num2str(point),'])'];
    set(gcf,'windowbuttonMotionfcn',motion);
  end
end

% ========================================================= stop
if isequal(task,'stop');
  set(gcf,'windowbuttonMotionfcn','');
  set(gcf,'windowbuttondownfcn','spl(''get'')');
  set(gcf,'windowbuttonUpfcn','');

  %    % remove markers:
  %    if isequal(get(gco,'tag'),'spl_aux')
  %      set(gco,'marker','none');
  %    elseif isequal(get(gco,'tag'),'spline')
  %      aux=get(gco,'userdata');
  %      set(aux,'marker','none');
  %    end
end

function xys=re_spline(xy)
dt=.01;
n=size(xy,2);
t=1:n;
ts=1:dt:n;
evalc('xys=spline(t,xy,ts);','xys=[]');
