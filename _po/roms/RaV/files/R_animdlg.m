function R_animdlg(do)

global H

if nargin == 0
  do='show';
end


%if isequal(do,'show')

% find last output fig:
figs    = get(0,'children');
outputs = findobj(figs,'tag','rcdv_output');
if ~isempty(outputs)
  last = outputs(1);
  fp=get(figure(last),'paperposition');
  figpos=[num2str(fp(1)),' ',num2str(fp(2)),' ',num2str(fp(3)),' ',num2str(fp(4))];
  isfig=1;
else
  figpos='';
  isfig=0;
end

if isequal(do,'show')

  % about colors, get default:
  if isfig
    figure(last);
    cax = gca;
    xcolor = get(cax,'xcolor');
    ycolor = get(cax,'ycolor');
    acolor = get(cax,'color');
    fcolor = get(gcf,'color');
    tl = get(cax,'title');
    tcolor = get(tl,'color');
  else
    xcolor = 'default';
    ycolor = 'default';
    acolor = 'default';
    fcolor = 'default';
    tcolor = 'default';
  end

  % get old values:
  % colors:
  evalc('xcolor=H.ROMS.ANIM.xcolor;','');
  evalc('ycolor=H.ROMS.ANIM.ycolor;','');
  evalc('tcolor=H.ROMS.ANIM.tcolor;','');
  evalc('acolor=H.ROMS.ANIM.acolor;','');
  evalc('fcolor=H.ROMS.ANIM.fcolor;','');

  % axis off, caxis, fig pos:
  evalc('axoff=H.ROMS.ANIM.axoff;','axoff=0;');
  % get cax:
  cax=get(H.ROMS.his.pcolorcaxis,'string');
  evalc('cax=H.ROMS.ANIM.caxis;','cax = cax;');
  % get fig pos:
  evalc('figpos=H.ROMS.ANIM.figpos;','figpos = figpos;');

  % t1, t2, dt:
  t1='1';
  t2=get(H.ROMS.his.nhis,'string');
  dt=get(H.ROMS.his.tstep,'string');
  dt=strrep(dt,'+','');

  evalc('t1=H.ROMS.ANIM.t1;','t1=t1;');
  evalc('t2=H.ROMS.ANIM.t2;','t2=t2;');
  evalc('t1=H.ROMS.ANIM.dt;','dt=dt;');


  %                             % name, fps, size and resize:
  %                               H.ROMS.ANIM.fliname  = get(H.ROMS.anim.fliname, 'string');
  %                                 H.ROMS.ANIM.flifps   = get(H.ROMS.anim.flifps,  'string');
  %                                   H.ROMS.ANIM.flidim   = get(H.ROMS.anim.flidim,  'string');
  %                                     H.ROMS.ANIM.fligeom  = get(H.ROMS.anim.fligeom, 'string'):



bgc = 'r';
bgt = 'b';
bgf = [0.6930    0.9181    1.0000];

% create anim dialog

hh=.3;
L=.25;
h=dialog;%('WindowStyle','normal');
Name='ANIM DLG...';
set(h,'units','normalized');
set(h,'position',[.5-L/2 .5-hh/2 L hh]);
set(h,'Name',Name);

% colors:
H.ROMS.anim.cframe = uicontrol(h,'style','frame');
H.ROMS.anim.xcolor = uicontrol(h,'string','xcolor','callback','R_animdlg(''xcolor'')',  'backgroundcolor',xcolor,  'foregroundcolor',bgc); % xcolor
H.ROMS.anim.ycolor = uicontrol(h,'string','ycolor','callback','R_animdlg(''ycolor'')',  'backgroundcolor',ycolor,  'foregroundcolor',bgc); % ycolor
H.ROMS.anim.tcolor = uicontrol(h,'string','tcolor','callback','R_animdlg(''tcolor'')',  'backgroundcolor',tcolor,  'foregroundcolor',bgc); % title color
H.ROMS.anim.fcolor = uicontrol(h,'string','fcolor','callback','R_animdlg(''fcolor'')',  'backgroundcolor',fcolor,  'foregroundcolor',bgc); % figure color
H.ROMS.anim.acolor = uicontrol(h,'string','acolor','callback','R_animdlg(''acolor'')',  'backgroundcolor',acolor,  'foregroundcolor',bgc); % axis   color
% axis on/off
H.ROMS.anim.axoff  = uicontrol(h,'style','checkbox','string','ax off','callback','R_animdlg(''axonoff'')',    'foregroundcolor',bgc, 'value',axoff); % axis on/off
% caxis
H.ROMS.anim.caxis  = uicontrol(h,'style','edit','string',cax, 'callback','',        'foregroundcolor',bgc); % caxis
% fig pos
H.ROMS.anim.figpos = uicontrol(h,'style','edit','string',figpos,'callback','',      'foregroundcolor',bgc); % figure position

% time options:
H.ROMS.anim.tframe = uicontrol(h,'style','frame');
H.ROMS.anim.t1 = uicontrol(h,'style','edit','string',t1,                               'foregroundcolor',bgt);
H.ROMS.anim.t2 = uicontrol(h,'style','edit','string',t2,                                'foregroundcolor',bgt);
H.ROMS.anim.dt = uicontrol(h,'style','edit','string',dt,                                'foregroundcolor',bgt);
H.ROMS.anim.prev = uicontrol(h,'string','preview','callback','R_animdlg(''preview'')',  'foregroundcolor',bgt);
% current pos and cax
H.ROMS.anim.current = uicontrol(h,              'string','curr','callback','R_animdlg(''currpos'')',      'foregroundcolor',bgc);

% ppm2fli options:
H.ROMS.anim.fliframe = uicontrol(h,'style','frame');
H.ROMS.anim.fliname_ = uicontrol(h,'style','text','string','name',      'foregroundcolor',bgf);
H.ROMS.anim.fliname  = uicontrol(h,'style','edit','string','anim.flc',  'foregroundcolor',bgf);
H.ROMS.anim.flifps_  = uicontrol(h,'style','text','string','fps',       'foregroundcolor',bgf);
H.ROMS.anim.flifps   = uicontrol(h,'style','edit','string','5',         'foregroundcolor',bgf);
H.ROMS.anim.flidim_  = uicontrol(h,'style','text','string','size',      'foregroundcolor',bgf);
H.ROMS.anim.flidim   = uicontrol(h,'style','edit','string','300x500',   'foregroundcolor',bgf);
H.ROMS.anim.fligeom_ = uicontrol(h,'style','text','string','resize %',  'foregroundcolor',bgf);
H.ROMS.anim.fligeom  = uicontrol(h,'style','edit','string','70%',       'foregroundcolor',bgf);

% ok, cancel
tmp1 = uicontrol(h,'string','START',  'callback','R_animdlg(''ok'')');
tmp2 = uicontrol(h,'string','cancel', 'callback','close(gcbf);');

children=get(h,'children');
for i=1:length(children)
  evalc(['set(children(',num2str(i),'),''units'',''normalized'');'],'');
%  evalc(['set(children(',num2str(i),'),''foregroundcolor'',''r'');'],'');
end

end % do == show


% »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% callbacks
% ««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
% ax on/off:
if isequal(do,'axonoff')
  if isfig
    figure(last);
    cax = gca;
    if get(H.ROMS.anim.axoff,'value');
      axis off
    else
      axis on
    end
  end
end

% change colors:
chandles = {'xcolor','ycolor','tcolor','acolor','fcolor'};
if ismember(do,chandles)
  eval(['thehandle = H.ROMS.anim.',do,';']);
  color = get(thehandle,'backgroundcolor');
  color = uisetcolor(color);
  set(thehandle,'backgroundcolor',color);

  % set colors now:
  if isfig
    figure(last);
    cax = gca;
    color_bar = H.ROMS.output_figure.colorbar;
    if isequal(do,'xcolor')
      set(cax,'xcolor',color)
      set(color_bar,'xcolor',color);
    end
    if isequal(do,'ycolor')
      set(cax,'ycolor',color)
      set(color_bar,'ycolor',color);
    end
    if isequal(do,'tcolor')
      tl = get(cax,'title');
      set(tl,'color',color)
    end
    if isequal(do,'acolor')
      set(cax,'color',color)
    end
    if isequal(do,'fcolor')
      set(gcf,'color',color)
    end
  end

end

% preview / start:  set properties        -------------           STORE DATA
if isequal(do,'preview') | isequal(do,'ok')
  % colors:
  H.ROMS.ANIM.xcolor = get(H.ROMS.anim.xcolor,'backgroundcolor');
  H.ROMS.ANIM.ycolor = get(H.ROMS.anim.ycolor,'backgroundcolor');
  H.ROMS.ANIM.tcolor = get(H.ROMS.anim.tcolor,'backgroundcolor');
  H.ROMS.ANIM.acolor = get(H.ROMS.anim.acolor,'backgroundcolor');
  H.ROMS.ANIM.fcolor = get(H.ROMS.anim.fcolor,'backgroundcolor');

  % axis off, caxis and fig  pos:
  H.ROMS.ANIM.axoff  = get(H.ROMS.anim.axoff,'value');
  H.ROMS.ANIM.caxis  = get(H.ROMS.anim.caxis,'string');
  H.ROMS.ANIM.figpos = get(H.ROMS.anim.figpos,'string');

  % t1, t2, dt:
  H.ROMS.ANIM.t1 = str2num(get(H.ROMS.anim.t1,'string'));
  H.ROMS.ANIM.t2 = str2num(get(H.ROMS.anim.t2,'string'));
  H.ROMS.ANIM.dt = str2num(get(H.ROMS.anim.dt,'string'));

  % name, fps, size and resize:
  H.ROMS.ANIM.fliname  = get(H.ROMS.anim.fliname, 'string');
  H.ROMS.ANIM.flifps   = get(H.ROMS.anim.flifps,  'string');
  H.ROMS.ANIM.flidim   = get(H.ROMS.anim.flidim,  'string');
  H.ROMS.ANIM.fligeom  = get(H.ROMS.anim.fligeom, 'string');

end

% preview:
if isequal(do,'preview')
  R_anim('preview');
end

% START:
if isequal(do,'ok')
  R_anim('ok')
end

if isequal(do,'currpos')
  % set current paperposition and caxis:
  if isfig
    pp = get(gcf,'paperposition');
    pp=[num2str(pp(1)),'  ',num2str(pp(2)),'  ',num2str(pp(3)),'  ',num2str(pp(4))];
    set(H.ROMS.anim.figpos,'string',pp);
  end
  cax=get(H.ROMS.his.pcolorcaxis,'string');
  set(H.ROMS.anim.caxis,'string',cax);
end

% »»»»»»»»»»»»»»»»»»»»»»»»»»»»Â»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% positions:
% ««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
if isequal(do,'show')
hcb=.08;
ls=.15;
l=.2;
dx=.02;
dy=.02;
cfx = dx;
cfy = 1-dy-2*dy-5*hcb;
cfl = 2*dx+l*2;
cfh = 2*dy+5*hcb;
set(H.ROMS.anim.cframe,'position',[cfx cfy cfl cfh]);
x=2*dx;
y=1-2*dy-hcb;
set(H.ROMS.anim.xcolor,'position',[x y l hcb]); x=x+l;
set(H.ROMS.anim.ycolor,'position',[x y l hcb]); x=x-l; y=y-hcb;
set(H.ROMS.anim.tcolor,'position',[x y l hcb]); x=x+l;
set(H.ROMS.anim.acolor,'position',[x y l hcb]); x=x-l; y=y-hcb;
set(H.ROMS.anim.fcolor,'position',[x y l hcb]); x=x+l;
set(H.ROMS.anim.axoff, 'position',[x y l hcb]); x=x-l; y=y-hcb;
set(H.ROMS.anim.caxis, 'position',[x y 2*l hcb]); y=y-hcb;
set(H.ROMS.anim.figpos,'position',[x y 2*l hcb]); y=y-hcb;

% time, preview
tfx = cfx+cfl+dx;
tfy = cfy;
tfl = 1-dx-tfx;
tfh = cfh;
set(H.ROMS.anim.tframe,   'position',[tfx tfy tfl tfh]);
x=tfx+dx;
y=tfy+tfh-dy-hcb;
l=(tfl-2*dx)/3;
set(H.ROMS.anim.t1,       'position',[x y l hcb]); x=x+l;
set(H.ROMS.anim.dt,       'position',[x y l hcb]); x=x+l;
set(H.ROMS.anim.t2,       'position',[x y l hcb]);
l=(tfl-2*dx)/2;
x=tfx+tfl-dx-l;
y=tfy+dy;
set(H.ROMS.anim.prev,     'position',[x y l hcb]);
% curr caxis and paperposition:
x=tfx+dx;
set(H.ROMS.anim.current,  'position',[x y l/2 2*hcb]);

% fli
ffx = cfx;
ffy = 2*dy+hcb;
ffl = 1-2*dx;
ffh = cfy-ffy-2*dy;
set(H.ROMS.anim.fliframe, 'position',[ffx ffy ffl ffh]);
x=ffx+dx;
y=ffy+ffh-dy-hcb;
l=l;
set(H.ROMS.anim.fliname_,  'position',[x y l hcb]); x=x+l;
set(H.ROMS.anim.fliname,   'position',[x y l hcb]); x=x-l; y=y-hcb;
set(H.ROMS.anim.flifps_,   'position',[x y l hcb]); x=x+l;
set(H.ROMS.anim.flifps,    'position',[x y l hcb]); x=x-l; y=y-hcb;
set(H.ROMS.anim.flidim_,   'position',[x y l hcb]); x=x+l;
set(H.ROMS.anim.flidim,    'position',[x y l hcb]); x=x-l; y=y-hcb;
set(H.ROMS.anim.fligeom_,  'position',[x y l hcb]); x=x+l;
set(H.ROMS.anim.fligeom,   'position',[x y l hcb]);

% ok, cancel
l=l*.7;
set(tmp1,'position',[.5-2.5*l dy l*2 hcb]); % ok
set(tmp2,'position',[.5+l/2   dy l*2 hcb]); % cancel

end % positions
