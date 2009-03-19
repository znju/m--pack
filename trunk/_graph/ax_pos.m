function ax_pos(exec,ax)
%AX_POS   Show mouse position
%   Adds to current figure a text uicontrol where current mouse
%   position is shown. To stop the motion display, click with right
%   mouse button  and to start again use the left button
%   There is no need for input variables. To add or remove ax_pos
%   you just need to type ax_pos. However in can be called with the
%   inputs bellow.
%
%   Syntax:
%      AX_POS(EXEC,AX)
%
%   Inputs:
%      EXEC   Execution options: 'init','show','stop','remove',
%             to start, start display, stop display and to remove
%             ax_pos handles
%      AX     The axis you want to know the mouse position [ gca ]
%
%   Example:
%      figure
%      ax_pos % start
%      ax_pos % end
%
%   MMA 14-12-2004, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

if nargin == 0
  % check if gonna init or remove;
  ui = findobj(gcf,'tag','ax_pos_uicontrol');
  if isempty(ui)
    exec = 'init';
  else
    exec = 'remove';
  end
end

if nargin < 2
  ax = gca;
end

if isequal(exec,'init')
  set(ax,'units','normalized');
  ap = get(ax,'position');

  y0  = 0.02;
  add = 0.05;
  uih = add+y0;

  pos = [ap(1) y0  ap(3) uih];
  uicontrol('style','text','units','normalized','position',pos,'backgroundcolor','k','foregroundcolor','g','tag','ax_pos_uicontrol','userdata',ap);
  % show some cross:
  show_cross

  set(ax,'position',[ap(1) ap(2)+add ap(3) ap(4)-add]);

  set(gcf,'WindowButtonMotionFcn','ax_pos(''show'');');
  %set(gcf,'pointer','crosshair');
  set(gcf,'WindowButtonDownFcn','ax_pos(''stop'');');
end

ui = findobj(gcf,'tag','ax_pos_uicontrol');
cross = findobj(gcf,'tag','ax_pos_cross');

if isequal(exec,'show')
  cpos = get(ax,'CurrentPoint');
  cpos = cpos(1,1:2);
  if ishandle(ui)
    str = sprintf('%10f X %10f',cpos(1),cpos(2));
    set(ui,'string',str);
  end
  if ishandle(cross)
    set(cross,'xdata',cpos(1),'ydata',cpos(2));
  else
    show_cross; % plot it again
  end
end

if isequal(exec,'stop')
  % chek if using right mouse button:
  button = get(gcf, 'SelectionType');
  if isequal(button,'alt')
    set(gcf,'WindowButtonMotionFcn','');
    %set(gcf,'pointer','arrow');
  else
    set(gcf,'WindowButtonMotionFcn','ax_pos(''show'');');
    %set(gcf,'pointer','crosshair');
  end
end

if isequal(exec,'remove')
  if ishandle(ui)
    ap = get(ui,'userdata');
  end
  eval('delete(ui)','');
  eval('delete(cross)','');
  set(gcf,'WindowButtonMotionFcn','');
  set(gcf,'WindowButtonDownFcn','');
  % restore ax position:
  set(ax,'position',ap);
  disp('## AX_POS removed')
end

function show_cross
xl = xlim;
yl = ylim;
h = ishold;
hold on
plot((xl(1)+xl(2))/2,(yl(1)+yl(2))/2,'r+','markersize',16,'tag','ax_pos_cross','erasemode','xor');
if ~h, hold off, end
