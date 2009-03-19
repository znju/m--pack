function N_guisize(in,func)
%N_guisize
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% enables change size of GUI

global H

if nargin == 0
  return
end

if nargin < 2
  func = 'N_positions';
end

% uncheck all:
set(H.menu_gs_def,    'checked','off');
set(H.menu_gs_h25,    'checked','off');
set(H.menu_gs_v25 ,   'checked','off');
set(H.menu_gs_cust,   'checked','off');
set(H.menu_gs_fill,   'checked','off');

if isequal(in,'default')
   eval([func,'([0 0]);']);
   set(H.menu_gs_def,   'checked','on');
end

if isequal(in,'H+25%')
  eval([func,'([0 25]);']);
  set(H.menu_gs_h25,   'checked','on');
end

if isequal(in,'V+25%')
  eval([func,'([25 0]);']);
  set(H.menu_gs_v25 ,  'checked','on');
end

if isequal(in,'custom')
  dlgTitle='increase gui size';
  prompt={'horizontal (%)','vertical (%)'};
  evalc('x=H.guisize_h;','x=''0'';');
  evalc('y=H.guisize_v;','y=''0'';');
  %x='0';
  %y='0';
  def={x,y};
  lineNo=1;
  AddOpts.Resize='on';
  AddOpts.WindowStyle='normal';
  AddOpts.Interpreter='tex';
  answer=inputdlg(prompt,dlgTitle,lineNo,def,AddOpts);
  if ~isempty(answer)
    x=answer{1};
    y=answer{2};
    x=str2num(x);
    y=str2num(y);
    if isnumber(x,1) & isnumber(y,1)
      eval([func,'([y x]);']);
      H.guisize_h = num2str(x);
      H.guisize_v = num2str(y);
      set(H.menu_gs_cust,   'checked','on');
    end
  end
end


padd_top = 0.06;
padd_bot = 0.04;
padd_left= 0.005;
padd_right=0.005;

if isequal(in,'fill')
  sw=1-padd_left-padd_right; % screen width
  sh=1-padd_top-padd_bot;
  % check percentage to increase:
  fp=get(gcf,'position');
  l=fp(3);
  x=(sw-l)/l*100;
  h=fp(4);
  y=(sh-h)/h*100;
  eval([func,'([y x],''fill'');']);

  %place fig in the bottom left corner:
  fp=get(gcf,'position');
  set(gcf,'position',[0+padd_left 0+padd_bot fp(3) fp(4)]);

  % check this:
  set(H.menu_gs_fill,   'checked','on');
end

% check if menus are not reachable:
fp=get(gcf,'position');
if fp(2)+fp(4) > 1
  fp(2)=1-fp(4)-padd_top;
  set(gcf,'position',fp);
end

% restore axis and colorbar position (also colors, but not needed here);
% (sets their position accordind to colorbar labels extent)
% this called after each plot
N_axProp
