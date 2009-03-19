function S2_zellipse(var,num)

global HANDLES ETC LOOK FSTA

if nargin == 1
  num='';
end

if isempty(ETC.new.many_depth_tidestruc)
  return
end

staN=get(HANDLES.z_many,'value');
tide=get(HANDLES.tides,'value');

ismajor = 0;
isminor = 0;
isinc   = 0;
isphase = 0;
%-------------------- MMA, 29-4-2004: add ECC
isecc   = 0;
%---------------------------------------------- end
isamp  = 0;
ispha  = 0;
if isequal(var,'major')
  x=ETC.new.many_depth_tidestruc(staN,:,tide,1);
  ismajor=1;
elseif isequal(var,'minor')
  x=ETC.new.many_depth_tidestruc(staN,:,tide,3);
  isminor=1;
elseif isequal(var,'inc')
  x=ETC.new.many_depth_tidestruc(staN,:,tide,5);
  isinc=1;
elseif isequal(var,'phase')
  x=ETC.new.many_depth_tidestruc(staN,:,tide,7);
  isphase=1;
%-------------------- MMA, 29-4-2004: add ECC
elseif isequal(var,'ecc')
  xM=ETC.new.many_depth_tidestruc(staN,:,tide,1); % major
  xm=ETC.new.many_depth_tidestruc(staN,:,tide,3); % minor
  x=xm./xM; % ecc
  isecc=1;
%---------------------------------------------- end
elseif isequal(var,'amp')
  x=ETC.new.many_depth_tidestruc(staN,:,tide,1);
  isamp=1;
elseif isequal(var,'pha')
  x=ETC.new.many_depth_tidestruc(staN,:,tide,3);
  ispha=1;
end

S2_hide_ax('on'); % hide spectrum axes

h=ishold;


% take care of diff: (to avoid angles like 5 and next 358)
if get(HANDLES.diff,'value') & (isinc | isphase | ispha)
  x=x*pi/180;
  x=atan(sin(x)./cos(x));
  x=x*180/pi;
end

% depths: 
val=get(HANDLES.depths,'string');
z=str2num(val);
IJK=[FSTA.i nan nan];
h_sta=S_get_ncvar(FSTA.name,'bathymetry',IJK);

no_depth=0;
if isequal(get(HANDLES.no_depth,'value'),1)
  z=z./h_sta;
  no_depth=1;
end

M=mean(x);
if isequal(get(HANDLES.no_mean,'value'),1)
  x=x-M;
  ETC.new.line=plot(x,-z,'-+','color',LOOK.color.z_fg);
else
%=====================================================================
  ETC.new.line=plot(x,-z,'-+','color',LOOK.color.z_fg);

  if ~no_depth
  % plot y axis at central depth:
  % central depth:
  hh=h_sta/2;
  % x value at central depth: interp
    % z cant have equal values to be used by interp1 so:
    for i=1:length(z)-1
      if z(i+1)==z(i)
        z(i)=z(i)+min(z)*.00000001;
      end
    end
    xhh=interp1(z,x,hh);
    hold on
    marker1=plot(xhh,-hh,'+','color',LOOK.color.z_ax);
    marker2=plot([min(x) max(x) nan xhh xhh],[-h_sta -h_sta nan -h_sta 0],'+-','color',LOOK.color.z_ax); 
    marker3=plot(xhh,-z,'+','color',LOOK.color.z_fg,'markersize',4); 
  end
%=====================================================================
end

%label num:
text(x(end),-z(end),num,'horizontal','center','vertical','top','fontsize',5);
text(x(1),-z(1),num,'horizontal','center','vertical','bottom','fontsize',5);
set(ETC.new.line,'tag','myline');

ylabel('depth');
xlabel(var)
S2_axes_prop;

set(ETC.new.line,'ButtonDownFcn','S2_ch_color(gco);');
cmenu=create_menu;
set(ETC.new.line,'UIContextMenu', cmenu);

%---------------------------------------------------------------------
% legend:

comp=get(HANDLES.tides,'string');
current=sprintf('%2s %5.5s %3s %2d x %4d mean= %8.4f h= %8.2f',num,var,comp(tide,:),FSTA.i,M,h_sta);
if ~h
  ETC.new.leg=[];
end
ETC.new.leg=strvcat(ETC.new.leg,current);
S2_legend(ETC.new.leg);
 

%---------------------------------------------------------------------
if ~h
  hold off
end

%=====================================================================
function cmenu=create_menu
% Define the context menu
cmenu = uicontextmenu;
% Define callbacks for context menu items
cb1 = ['set(gco, ''LineStyle'', ''--'')'];
cb2 = ['set(gco, ''LineStyle'', '':'')'];
cb3 = ['set(gco, ''LineStyle'', ''-'')'];
% Define the context menu items
item1 = uimenu(cmenu, 'Label', 'dashed', 'Callback', cb1);
item2 = uimenu(cmenu, 'Label', 'dotted', 'Callback', cb2);
item3 = uimenu(cmenu, 'Label', 'solid', 'Callback', cb3);
item4 = uimenu(cmenu, 'Label', 'color', 'Callback', 'S2_ch_color(gco,1);');
item5 = uimenu(cmenu, 'Label', 'delete', 'Callback', 'delete(gco);');
item6 = uimenu(cmenu, 'Label', 'data', 'Callback', 'S2_data;');

