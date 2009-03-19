function varargout=draw_bar(setgs,toggle_obj)
%DRAW_BAR   Add drawing utilities to current figure
%   This very simple tool allow the creation and manipulation
%   of lines, splines, rectangles and circles.
%   Usage:
%      - click in the button of the object you wanna create;
%      - change shape by clicking and dragging the markers with left
%        mouse button;
%      - the creation of rectangles and circles stops after release
%        the mouse button; the creation of lines and splines is done
%        by selecting points, to stop click with the right mouse
%        button;
%      - use left button to add extra points to lines and splines,
%        or to remove desired markers;
%      - use right mouse button to drag all object; to drag you must
%        click on the line, not on the markers; rectangles and
%        circles can also be moves with left button;
%      - use third button to clear the object.
%
%   Syntax:
%      DRAW_BAR(POS)   Creates draw bar
%      DRAW_BAR(FCN)   Removes draw bar
%
%   Inputs:
%      POS   Position for the draw_bar frame
%            [ <x y w h> {0 0.95 0.25 0.05} ]
%      FCN   Cell array with the WindowButton callbacks:
%            WindowButtonDownFcn, WindowButtonMotionFcn and
%            WindowButtonUpFcn, to be restored   [ <empty> ]
%
%   Example:
%      figure
%      draw_bar([.8 .9 .2 .1]); % creates
%      fcn = {'ls','',''};
%      %draw_bar(fcn);
%      draw_bar; % removes
%
%   MMA 2004, martinho@fis.ua.pt
%
%   See also BLIN, CIRC, SPL, SQR

%   Department of Physics
%   University of Aveiro, Portugal

create=1;
down   = '';
motion = '';
up     = '';

if nargin == 0
  setgs=[];
  pos=[0 .95];
  l=0.25;
  h=0.05;
elseif nargin == 1
  if isnumeric(setgs)   % add draw bar.
    pos=setgs(1:2);
    l=setgs(3);
    h=setgs(4);
    create=1;
  elseif isstr(setgs)               % just get settings.
    create=0;
  elseif iscell(setgs) % WindowButton callbacks
    down   = setgs{1};
    motion = setgs{2};
    up     = setgs{3};
  end
elseif nargin==2
  % toggle objects
  toggle_objs(toggle_obj);
  return
end

% if already exists, remove  it:
fr=findobj(gcf,'tag','draw_bar_frame');
if ~isempty(fr) & create
  spl      = findobj(gcf,'tag','toggle_spl' );
  spl_new  = findobj(gcf,'tag','new_spl'    );
  sqr      = findobj(gcf,'tag','toggle_sqr' );
  sqr_new  = findobj(gcf,'tag','new_sqr'    );
  circ     = findobj(gcf,'tag','toggle_circ');
  circ_new = findobj(gcf,'tag','new_circ'   );
  blin     = findobj(gcf,'tag','toggle_blin');
  blin_new = findobj(gcf,'tag','new_blin'   );

  evalc('delete(fr)','');
  evalc('delete(spl)','');
  evalc('delete(spl_new)','');
  evalc('delete(sqr)','');
  evalc('delete(sqr_new)','');
  evalc('delete(circ)','');
  evalc('delete(circ_new)','');
  evalc('delete(blin)','');
  evalc('delete(blin_new)','');

  draw_bar('toggle_objs',[]); % to hide aux points of last obj drawn

  set(gcf,'WindowButtonDownFcn',   down);
  set(gcf,'WindowButtonMotionFcn', motion);
  set(gcf,'WindowButtonUpFcn',     up);

  create=0;
end

if create & exist('pos')==1
  units=get(gcf,'units');
  set(gcf,'units','normalized');

  fr      = uicontrol('style','frame','units','normalized','position',[pos l h],'tag','draw_bar_frame');
  spl     = uicontrol('style','togglebutton','units','normalized','string','spl', 'callback','draw_bar(''toggle_objs'',''spl'')','position',[pos(1) pos(2)+h/2 l/4 h/2],'tag','toggle_spl');
  spl_new = uicontrol('units','normalized','string','new', 'callback','spl','position',[pos(1) pos(2) l/4 h/2],'visible','off','tag','new_spl');

  sqr     = uicontrol('style','togglebutton','units','normalized','string','rec', 'callback','draw_bar(''toggle_objs'',''sqr'')','position',[pos(1)+l/4 pos(2)+h/2 l/4 h/2],'tag','toggle_sqr');
  sqr_new = uicontrol('units','normalized','string','new', 'callback','sqr','position',[pos(1)+l/4 pos(2) l/4 h/2],'visible','off','tag','new_sqr');

  circ     = uicontrol('style','togglebutton','units','normalized','string','cir', 'callback','draw_bar(''toggle_objs'',''circ'')','position',[pos(1)+2*l/4 pos(2)+h/2 l/4 h/2],'tag','toggle_circ');
  circ_new = uicontrol('units','normalized','string','new', 'callback','circ','position',[pos(1)+2*l/4 pos(2) l/4 h/2],'visible','off','tag','new_circ');

  blin     = uicontrol('style','togglebutton','units','normalized','string','lin', 'callback','draw_bar(''toggle_objs'',''blin'')','position',[pos(1)+3*l/4 pos(2)+h/2 l/4 h/2],'tag','toggle_blin');
  blin_new = uicontrol('units','normalized','string','new', 'callback','blin','position',[pos(1)+3*l/4 pos(2) l/4 h/2],'visible','off','tag','new_blin');

  set(gcf,'units',units);

  setgs=[];
elseif isstr(setgs)
  % settings:
  setgs.LineColor=[.38 .576 .851];
  setgs.LineWidth=0.5;

  setgs.MarkerColor='r';
  setgs.MarkerSize=4;
end

if nargout==1
  varargout{1} = setgs;
end

function toggle_objs(obj)
%TOGGLE_OBJS   Toggle DRAW_BAR objects
%   Works only in the context of the DRAW_BAR tool.
%
%   MMA 2004, martinho@fis.ua.pt
%
%   See also DRAW_BAR

%   Department of Physics
%   University of Aveiro, Portugal

if nargin == 0
  return
end

set(findobj(gcf,'tag','toggle_spl'),'value',0);
set(findobj(gcf,'tag','toggle_sqr'),'value',0);
set(findobj(gcf,'tag','toggle_circ'),'value',0);
set(findobj(gcf,'tag','toggle_blin'),'value',0);
eval(['set(findobj(gcf,''tag'',''toggle_',obj,'''),''value'',1);']);

eval(['set(gcf,''WindowButtonDownFcn'',''',obj,'(''''get'''')'')']);

set(findobj(gcf,'tag','spl_aux'),'visible','off');
set(findobj(gcf,'tag','circ_aux'),'visible','off');
set(findobj(gcf,'tag','sqr_aux'),'visible','off');
set(findobj(gcf,'tag','blin_aux'),'visible','off');
eval(['set(findobj(gcf,''tag'',''',obj,'_aux''),''visible'',''on'');']);

set(findobj(gcf,'tag','new_spl'),'visible','off');
set(findobj(gcf,'tag','new_sqr'),'visible','off');
set(findobj(gcf,'tag','new_circ'),'visible','off');
set(findobj(gcf,'tag','new_blin'),'visible','off');
eval(['set(findobj(gcf,''tag'',''new_',obj,'''),''visible'',''on'');']);

