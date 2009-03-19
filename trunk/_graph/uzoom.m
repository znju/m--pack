function uzoom(thefig,action)
%UZOOM   Unconstrained zoom
%   Add a new button to figure which allows zoom in and out without
%   restrictions. This tool is useful cos matlab vrsion > 7 doesn't
%   allow  zoom out with the zoom in button any more!
%
%   Syntax:
%      UZOOM(FIG)
%
%   Input:
%      FIG   Figure where the UZOOM button will be added (gcf)
%
%   MMA 11-9-2006, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

if nargin==0 | isempty(thefig)
  thefig=gcf;
end
if nargin < 2
  action='init';
end

cp = get(gca,'CurrentPoint');
cpx=cp(1,1);
cpy=cp(1,2);
cpz=cp(1,3);

b=findall(thefig,'tag','uzoom');
aux=findobj(thefig,'tag','uzoom_aux');

is2d=prod(diag(view))+1<eps*10;

if isequal(action,'end')
  state=getappdata(b,'state');
  uirestore(state);
end
if isequal(action,'init')
  t=findall(thefig,'type','uitoolbar');
  t=t(1);
  b=uitoggletool(t,'tag','uzoom','tooltipstring','uzoom','separator','on');

  c=ones([19 19 3]);
  c(7:13,10,:)=0;
  c(10,7:13,:)=0;
  set(b,'cdata',c);

  set(b,'OnCallback','uzoom([],''start'')');
  set(b,'OffCallback','uzoom([],''end'')');
end

if isequal(action,'start')
  state=uisuspend(thefig);
  setappdata(b,'state',state);
  v=view;
  ax=axis;
  setappdata(b,'view',v);
  setappdata(b,'axis',ax);

  set(thefig,'WindowButtonDownFcn','uzoom([],''get'')');
end


if isequal(action,'get')
  cp = get(gca,'CurrentPoint');
  cpx=cp(1,1);
  cpy=cp(1,2);
  set(b,'userdata',[cpx cpy]);

  mouse=get(gcf,'SelectionType');
  if isequal(mouse,'open')
    mouse=getappdata(b,'prev_SelectionType');
  end
  if ismember(mouse,{'normal','open'})
    if is2d
      set(thefig,'WindowButtonMotionFcn','uzoom([],''move'')');
    end
    set(thefig,'WindowButtonUpFcn','uzoom([],''on'')');
  elseif isequal(mouse,'extend')
    %axis auto
%    v=getappdata(b,'view');
%    view(v);
    ax=getappdata(b,'axis');
    axis(ax);
  else
    set(thefig,'WindowButtonUpFcn','uzoom([],''out'')');
  end
  setappdata(b,'prev_SelectionType',mouse)
end

if isequal(action,'move')
  cp0=get(b,'userdata');
  x0=cp0(1);
  y0=cp0(2);

  r=sqrt((cpx-x0)^2+(cpy-y0)^2);
  if r> sqrt(diff(xlim)^2+diff(ylim)^2)/50
    x=[x0 cpx cpx x0 x0];
    y=[y0 y0 cpy cpy y0];
    if ishandle(aux)
      set(aux,'xdata',x,'ydata',y);
    else
      h=ishold; hold on
      plot(x,y,'tag','uzoom_aux','erasemode','xor');
      if ~h, hold off; end
    end
    set(thefig,'WindowButtonUpFcn','uzoom([],''stop'')');
  end
end

if isequal(action,'stop')
  set(thefig,'WindowButtonMotionFcn','');
  set(thefig,'WindowButtonUpFcn','');

  try
    x=get(aux,'xdata');
    y=get(aux,'ydata');

    dx=max(x(:))-min(x(:));
    dy=max(y(:))-min(y(:));
    d=max(dx,dy);
    x=[mean(x(:))-d/2 mean(x(:))+d/2];
    y=[mean(y(:))-d/2 mean(y(:))+d/2];

    axis([min(min(x)) max(max(x)) min(min(y)) max(max(y))])
    delete(aux)
  end
end

if ismember(action,{'out','on'})
  set(thefig,'WindowButtonMotionFcn','');
  set(thefig,'WindowButtonUpFcn','');

  dx=diff(xlim); x0=cpx;
  dy=diff(ylim); y0=cpy;
  dz=diff(zlim); z0=cpz;
  if is2d
    if isequal(action,'out')
      xl=[x0-dx x0+dx];
      yl=[y0-dy y0+dy];
    elseif isequal(action,'on')
      xl=[x0-dx/4 x0+dx/4];
      yl=[y0-dy/4 y0+dy/4] ;
    end
    axis([xl yl]);
  else
    if isequal(action,'out')
       camzoom(1/2); % must also use campan !!!!!!!!
%      xl=[x0-dx x0+dx];
%      yl=[y0-dy y0+dy];
%      zl=[z0-dz z0+dz];
    elseif isequal(action,'on')
       camzoom(2);
%      xl=[x0-dx/4 x0+dx/4];
%      yl=[y0-dy/4 y0+dy/4] ;
%      zl=[z0-dz/4 z0+dz/4] ;        zl=zlim;
    end
%    axis([xl yl zl]);
  end

end
