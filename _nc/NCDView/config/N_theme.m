function N_theme(type)
%N_theme
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% controls GUI theme (objects colors)

global H

evalc('is=ishandle(H.fig)','is=0');
if ~is
  return
end
figure(H.fig);

% uncheck all:
set(findobj(gcf,'Type','uimenu','tag','menu_theme'),'checked','off');

% --------------------------------------------------------------------
% theme1:
% --------------------------------------------------------------------
if isequal(type,'theme 1')
  % figure backgound:
  figbg   = [0.6706   0.6902   0.8039];
  % axes:
  axbg    = [0.929    0.933    0.953 ];
  axfg    = [0.2039   0.2235   0.3451];
  % frames:
  framebg = [206      209      225   ]/256;
  framefg = axfg;
  % editable areas
  editbg  = [231      233      241   ]/256;
  editfg  = [0.4353   0        0     ];
  % checkboxes:
  checbbg = framebg;
  checkfg = axfg;
  % listboxes:
  listbg  = framebg;
  listfg  = axfg;
  % text areas:
  textbg  = framebg;
  textfg  = axfg;
  % pushbuttons:
  pushbg  = figbg;
  pushfg  = [0.2784   0.3098   0.4706];
  inctfg  = [0.6902   0        0     ]; % to use in >  and <
  % tooglebuttons:
  tooglebg = pushbg;
  tooglefg = pushfg;

  set(H.menu_theme1,'checked','on');
  H.theme.name='theme 1';
end

% --------------------------------------------------------------------
% theme2:
% --------------------------------------------------------------------
if isequal(type,'theme 2')
  % figure backgound:
  figbg   = [0.35     0.35     0.35  ];
  % axes:
  axbg    = [.97      .97      0.93  ];
  axfg    = [0        0.8      0     ];
  % frames:
  framebg = [.45      .45      .45   ];
  framefg = axfg;
  % editable areas
  editbg  = [.55      .55      .55  ];
  editfg  = [0.6513   0.7921   0.904 ];
  % checkboxes:
  checbbg = framebg;
  checkfg = axfg;
  % listboxes:
  listbg  = framebg;
  listfg  = axfg;
  % text areas:
  textbg  = framebg;
  textfg  = axfg;
  % pushbuttons:
  pushbg  = figbg;
  pushfg  = axfg;
  inctfg  = [0        1        0     ]; % to use in >  and <
  % tooglebuttons:
  tooglebg = pushbg;
  tooglefg = pushfg;

  set(H.menu_theme2,'checked','on');
  H.theme.name='theme 2';
end


% --------------------------------------------------------------------
% theme3:
% --------------------------------------------------------------------
if isequal(type,'theme 3')
  % figure backgound:
  figbg   = [0.6722    0.7890    0.6722];
  % axes:
  axbg    = [0.929    0.933    0.953 ];
  axfg    = [0.2039   0.2235   0.3451];
  % frames:
  framebg = [192 223 189   ]/256;
  framefg = axfg;
  % editable areas
  editbg  = [231      233      241   ]/256;
  editfg  = [0.4353   0        0     ];
  % checkboxes:
  checbbg = framebg;
  checkfg = axfg;
  % listboxes:
  listbg  = framebg;
  listfg  = axfg;
  % text areas:
  textbg  = framebg;
  textfg  = axfg;
  % pushbuttons:
  pushbg  = figbg;
  pushfg  = [0.2784   0.3098   0.4706];
  inctfg  = [0.6902   0        0     ]; % to use in >  and <
  % tooglebuttons:
  tooglebg = pushbg;
  tooglefg = pushfg;

  set(H.menu_theme3,'checked','on');
  H.theme.name='theme 3';
end


% --------------------------------------------------------------------
% default theme:
% --------------------------------------------------------------------
if isequal(type,'default')
  figbg    = 'default';
  axbg     = 'default';
  axfg     = 'default';
  framebg  = 'default';
  framefg  = 'default';
  editbg   = 'default';
  editfg   = 'default';
  checbbg  = 'default';
  checkfg  = 'default';
  listbg   = 'default';
  listfg   = 'default';
  textbg   = 'default';
  textfg   = 'default';
  pushbg   = 'default';
  pushfg   = 'default';
  inctfg   = 'default';
  tooglebg = 'default';
  tooglefg = 'default';

  set(H.menu_themedef,'checked','on');
  H.theme.name='default';
end

% --------------------------------------------------------------------
% apply:
% --------------------------------------------------------------------
set(gcf,'color',figbg);
ax=findobj(gcf,'Type','axes');
set(ax,'color',axbg,'xcolor',axfg,'ycolor',axfg,'zcolor',axfg);

obj = findobj(gcf,'style','edit');
set(obj,'backgroundcolor',editbg,'foregroundcolor',editfg);

obj = findobj(gcf,'style','frame');
set(obj,'backgroundcolor',framebg,'foregroundcolor',framefg);

obj = findobj(gcf,'style','checkbox');
set(obj,'backgroundcolor',checbbg,'foregroundcolor',checkfg);

obj = findobj(gcf,'style','checkbox','tag','onFig');
set(obj,'backgroundcolor',figbg);

obj = findobj(gcf,'style','listbox');
set(obj,'backgroundcolor',listbg,'foregroundcolor',listfg);

obj = findobj(gcf,'style','text');
set(obj,'backgroundcolor',textbg,'foregroundcolor',textfg);

obj = findobj(gcf,'style','pushbutton');
set(obj,'backgroundcolor',pushbg,'foregroundcolor',pushfg);

obj = findobj(gcf,'style','togglebutton');
set(obj,'backgroundcolor',tooglebg,'foregroundcolor',tooglefg);

obj = findobj(gcf,'string','>');
set(obj,'foregroundcolor',inctfg);
obj = findobj(gcf,'string','<');
set(obj,'foregroundcolor',inctfg);


% keep values  in global var:
H.theme.figbg    = figbg;
H.theme.axbg     = axbg;
H.theme.axfg     = axfg;
H.theme.framebg  = framebg;
H.theme.framefg  = framefg;
H.theme.editbg   = editbg;
H.theme.editfg   = editfg;
H.theme.checbbg  = checbbg;
H.theme.checkfg  = checkfg;
H.theme.listbg   = listbg;
H.theme.listfg   = listfg;
H.theme.textbg   = textbg;
H.theme.textfg   = textfg;
H.theme.pushbg   = pushbg;
H.theme.pushfg   = pushfg;
H.theme.inctfg   = inctfg;
H.theme.tooglebg = tooglebg;
H.theme.tooglefg = tooglefg;
