function N_arrows(x,y,varu,varv,filenumberu,filenumberv);
%N_arrows
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% allows visualization of velocity fields

global H


fileu=H.files{filenumberu};
filev=H.files{filenumberv};

u = N_getVar(fileu,varu);
v = N_getVar(filev,varv);

scale   = str2num(get(H.varMult,   'string'));
offset  = str2num(get(H.varOffset, 'string'));

%--------------------- apply scale and offset:
u=squeeze(u);
u=u*scale+offset;

v=squeeze(v);
v=v*scale+offset;


n=n_vararraydim(size(u));
[x,y]=N_setxy(fileu,varu,n,size(u));
if n == 1
  if isempty(x),  x = zeros(size(u)); end
  if isempty(y),  y = zeros(size(u)); end
  x = reshape(x,length(x),1);
  y = reshape(y,length(y),1);
  u = reshape(u,length(u),1);
  v = reshape(v,length(v),1);
elseif n == 2
  if n_vararraydim(size(x)) == 1
    [x,y]=meshgrid(x,y);
  end
end
[m,n]=size(u);

%-------------------- dealing with big vars:
% let me not plot arrows bigger then... 30x30, or at least ask the user:
evalc('sizeMax=H.maxarrowssize;','sizeMax=30*30;');
if m*n > sizeMax
  question = 'lots of arrows will be plotted... ! wanna procced?';
  size_str = sprintf('[  %g  x  %g ] = %g',m,n,m*n);
  current  = ['current size max = ',num2str(sizeMax)];
  change   = 'change this in menu MISC --> MAX VAR SIZE (for arrows)';
  question={question,size_str,current,change};
  title='';
  answer=questdlg(question,title,'yes','no','no');
  if isequal(answer,'no')
    return
  end
end

set(gcf,'pointer','watch')
% check hold on:
is_hold = get(H.hold,'value');
if ~is_hold
  hold off
  N_cla
end

if 0
for i=1:m
  for j=1:n
    pos=[x(i,j) y(i,j)];
    V=[u(i,j) v(i,j)]; %V
    handles=vector(pos,V,.3,20,'r',1); hold on
  end
end
else
  speed = sqrt(u.^2+v.^2);
  handles = vfield(x,y,u,v,speed);  
end

if 0 % use colorbar instead !!
  % put scale arrow:
  vmean = mean(mean(sqrt(u.^2 + v.^2)));
  V = [0 abs(vmean)];
  pos = [x(1,1) y(1,1)];
  vector(pos,V*2,.3,20,'k',1);
  text(pos(1),pos(2),[' ',num2str(vmean*2)])
end

set(gcf,'pointer','arrow')

% axis equal:
axis normal
axis equal
set(H.axis_eq,'value',1)

%-----------------
% check  if grid on:
if get(H.grid,'value')
  grid on
  evalc('set(gca,''XMinorTick'',''on'',''YMinorTick'',''on'')','');
end

%--------------------

% DataAspectRatio:
if get(H.ar_cb,'value')
  dar = str2num(get(H.ar,'string'));
  set(gca,'DataAspectRatio',dar);
  set(gca,'DataAspectRatio',H.limits.dar);
else
  dar=get(gca,'DataAspectRatio');
  set(H.ar,'string',[num2str(dar(1)),'  ',num2str(dar(2)),'  ',num2str(dar(3))]);
  H.limits.dar = dar;
end

% xlim
if get(H.xlim_cb,'value')
  xl = str2num(get(H.xlim,'string'));
  xlim(xl);
  xlim(H.limits.xlim);
else
  xl=xlim;
  set(H.xlim,'string',[num2str(xl(1)),'  ',num2str(xl(2))]);
  H.limits.xlim = xl;
end

% ylim
if get(H.ylim_cb,'value')
  yl = str2num(get(H.ylim,'string'));
  ylim(yl);
  ylim(H.limits.ylim);
else
  yl=ylim;
  set(H.ylim,'string',[num2str(yl(1)),'  ',num2str(yl(2))]);
  H.limits.ylim = yl;
end

% zlim
if get(H.zlim_cb,'value')
  zl = str2num(get(H.zlim,'string'));
  zlim(zl);
  zlim(H.limits.zlim);
else
  zl=zlim;
  set(H.zlim,'string',[num2str(zl(1)),'  ',num2str(zl(2))]);
  H.limits.zlim = zl;
end



%%%%%%%%%%%%%%%%%%%%%
% overlay data: if always or 2d and n==2
% check if data is to overlay always:
is=get(H.menu_overlay_always,'checked');
is2d = get(H.menu_overlay_2d,     'checked');
if isequal(is,'on') | (isequal(is2d,'on') & 2==2) % here n always 2
  evalc('xy=H.overlay.data;','xy=[]');
  if ~isempty(xy)
    hold on
    cmenu = uicontextmenu;
    p=plot(xy(:,1),xy(:,2),'UiContextMenu',cmenu);
    N_setcontextmenu(cmenu,'overlay');

    Type='overlay';
    evalc(['LineStyle = H.overlay.LineStyle.',Type,';' ], 'LineStyle = ''default'';');
    evalc(['LineWidth = H.overlay.LineWidth.',Type,';' ], 'LineWidth = ''default'';');
    evalc(['Color     = H.overlay.Color.',Type,';'     ], 'Color     = ''b''      ;');
    set(p,'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',Color);

  end
end

% restore axis and colorbar colors;
% also sets their position according to colorbar labels extent
% % also changes axes_title width, witch should always be = axes width
N_axProp


if ~is_hold
  hold off
end

% check if zoom:
 if get(H.zoom,'value')
  zoom on
end

