function N_disp(type)
%N_disp
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% plots everything except arrows
% is called always button display is pressed

global H

evalc('fname=H.fname','fname=[]');
if isempty(fname)
  return
end

if nargin == 0
  type=[];
end

%---------------------------------------------------------------------
% load variable:
%---------------------------------------------------------------------

%--------------------- get varname, scale and offset:
[varname,filenumber] = N_getvarname(H.varInfo);
if length(varname) > 1
  type='arrows';
  varu=varname{1};
  varv=varname{2};
  filenumberu=filenumber{1};
  filenumberv=filenumber{2};
end
varname    = varname{1};
filenumber = filenumber{1};
evalc('fname = H.files{filenumber};','fname=[];');

if isempty(fname)
  disp(['## error loading file number ',num2str(filenumber),' : nfiles= ',num2str(length(H.files))]);
  return
end

scale   = str2num(get(H.varMult,   'string'));
offset  = str2num(get(H.varOffset, 'string'));


%---------------------- load var:
v=N_getVar(fname,varname);
% get missing value and turn it into NaN:
missv=[];
if n_varattexist(fname,varname,'missing_value')
  missv = n_varatt(fname,varname,'missing_value');
end
if ~isempty(missv) & ~isempty(v)
  v(find(v==missv))=NaN;
end

%--------------------- apply scale and offset:
v=squeeze(v);
v=v*scale+offset;

%---------------------------------------------------------------------
% set X and Y:
%---------------------------------------------------------------------
n=n_vararraydim(size(v));
% n = 0 --> single value
% n = 1 --> vector, 1-D case
% n = 2 --> matrix, 2-D case
% n > 2 --> do nothing
% n < 0 --> empty variable, do nothing

[x,y,X,Y,xfilenumber,yfilenumber,do_xyLabels]=N_setxy(fname,varname,n,size(v));

%================================================================ plotting:
% load many stuff:

%contour values:
vals = str2num(get(H.contourvals,'string'));

% caxis:
cax  = str2num(get(H.pcolorcaxis,'string'));

% colormap:
cmobj = findobj('checked','on','tag','menu_colormap');
cm=get(cmobj,'label');
%cm=strrep(cm,' ','');
cmud=get(cmobj,'userData');

% view angle:
va   = str2num(get(H.surfview,'string'));

% shading:
obj=findobj('tag','menu_shading','checked','on');
str_sh = get(obj,'label');
shud = get(obj,'UserData');

% material:
obj=findobj('tag','menu_material','checked','on');
str_ma =  get(obj,'label');
str_ma=strrep(str_ma,'.',''); %cos default has a point: .default

% lighting:
obj=findobj('tag','menu_light','checked','on');
str_li =  get(obj,'label');

% axis:
obj=findobj('tag','menu_axis','checked','on');
str_ax =  get(obj,'label');

% xlim
xl = get(H.xlim,'string');
xl=str2num(xl);

% ylim
yl = get(H.ylim,'string');
yl=str2num(yl);

% zlim
zl = get(H.zlim,'string');
zl=str2num(zl);

% DataAspectRatio:
dar = get(H.ar,'string');
dar=str2num(dar);

%------------------------------------------------------ plot var:
axes(H.axes);

% get type of plot:

if isempty(type)
  % get type of plot:
  if get(H.contourcb,'value') % contour
    type = 'contour';
  elseif  get(H.pcolorcb,'value') % pcolor
    type = 'pcolor';
  elseif  get(H.surfcb,'value') % surf
    type = 'surf';
  end
  % else type comes as first input argument.
  % but check boxes must be changed.
elseif ~isequal(type,'arrows') % if arrows just let checkboxes as they are
  % change check box:
  N_2dcb(type);
end

%------------------------------------------------------- 2-D or 1-D arrows:
if isequal(type,'arrows') & (n == 2 | n==1)

  N_arrows(x,y,varu,varv,filenumberu,filenumberv);

  H.is.plotted=type;

  % set title and labels:
  vars        = {varu,varv};
  filenumbers = {filenumberu,filenumberv};
  N_axLabel(vars,filenumbers,'title');
  if  do_xyLabels & n==2
    N_axLabel(X,xfilenumber,'xlabel');
    N_axLabel(Y,yfilenumber,'ylabel');
  end
  if  do_xyLabels & n==1
    if isempty(x), N_axLabel(Y,yfilenumber,'ylabel'); end
    if isempty(y), N_axLabel(X,xfilenumber,'xlabel'); end
  end

  if 0 % use colorbar !!
    % delete colorbar if not hold:
    if ~ishold
      delete(colorbar)
      N_axProp % to  place title in right place
    end
  else
    % create colorbar:
    H.colorbar=colorbar; set(H.colorbar,'tag','Colorbar');
  end

  return
end

%------------------------------------------------------- 2-D
if n == 2 % 2-D
  if isequal(type,'contour') % use vals:
    str = ['[H.cs,H.ch]=',type,'(x,y,v,vals);'];
  else
    str = ['[H.pc]=',type,'(x,y,v);'];
  end
  %size(x), size(y), size(v)
  sizes_str = 'disp([''# error: check sizes: x--> '',num2str(size(x)),'' y--> '',num2str(size(y)),'' v--> '',num2str(size(v))]);';
  ok=1;
  evalc(str,'ok=0;');
  if  ~ok
    eval(sizes_str)
    return  
  end
  H.is.plotted=type;
  
  % set contours color:
  %if isequal(type,'contour'), N_contourcolor, end
  % -- do it only in the end, cos colormap is applied bellow
  
  % set title and labels:
  N_axLabel(varname,filenumber,'title');
  if  do_xyLabels
    N_axLabel(X,xfilenumber,'xlabel');
    N_axLabel(Y,yfilenumber,'ylabel');
  end
end

%------------------------------------------------------- 1-D
if n == 1 % 1-D
  cmenu = uicontextmenu;
  evalc('p=plot(x,v,''UiContextMenu'',cmenu)','p=plot(v,''UiContextMenu'',cmenu)');
  N_setcontextmenu(cmenu,'plot1d');

  Type='plot1d';
  evalc(['LineStyle = H.overlay.LineStyle.',Type,';' ], 'LineStyle = ''default'';');
  evalc(['LineWidth = H.overlay.LineWidth.',Type,';' ], 'LineWidth = ''default'';');
  evalc(['Color     = H.overlay.Color.',Type,';'     ], 'Color     = ''b''      ;');
  set(p,'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',Color);

  H.is.plotted='line';

  % set title and labels:
  N_axLabel(varname,filenumber,'title');
  if  do_xyLabels
    N_axLabel(X,xfilenumber,'xlabel');
  end
end

%------------------------------------------------------- 0-D
if n==0 % unit
  % show value:
  i=get(H.dim1e,'string');
  j=get(H.dim2e,'string');
  k=get(H.dim3e,'string');
  l=get(H.dim4e,'string');
  str=sprintf('%s [ %g ] (%s , %s , %s ,%s ) =  %f',varname,filenumber,i,j,k,l,v);
  set(H.varInfo1,'string',str);

  return
end


%-------------------------------------------------------- apply many stuff:

% caxis:
if get(H.pcolorcaxiscb,'value')
  caxis(cax);
  H.pcolorcaxis_current=[num2str(cax(1)),'  ',num2str(cax(2))]; % to  be used in N_checkeditvals
else
  caxnew=caxis;
  set(H.pcolorcaxis,'string',[num2str(caxnew(1)),'  ',num2str(caxnew(2))]);
  H.pcolorcaxis_current=[num2str(caxnew(1)),'  ',num2str(caxnew(2))]; % to  be used in N_checkeditvals
end
if n == 2
  % create colorbar:
  H.colorbar=colorbar; set(H.colorbar,'tag','Colorbar'); % not done in Unix Matlab 6!?
end

% colormap
if isequal(cm,'2 colors')
  colormap(cmud);
else
  colormap(cm);
end

% view angle:
if get(H.surfviewcb,'value')
  view(va);
  H.surfview_current=[num2str(va(1)),'  ',num2str(va(2))]; % to  be used in N_checkeditvals
else
  [az,el]=view;
  set(H.surfview,'string',[num2str(az),'  ',num2str(el)]);
  H.surfview_current=[num2str(az),'  ',num2str(el)]; % to  be used in N_checkeditvals
end

% shading:
if isequal(str_sh,'color...')
  evalc('set(get(gca,''children''),''FaceColor'',shud);','');
else
  shading(str_sh);
end

% material:
material(str_ma);

% lighting:
lighting none; %remove previous lights and ad new one:
light;
lighting(str_li);

% axis:
axis(str_ax);

%--------------------
% check if axis equal:
if get(H.axis_eq,'value')
  axis equal
  %set(gca,'dataaspectratio',[1 1 1]);
end

% check if grid on:
if get(H.grid,'value')
  grid on
  evalc('set(gca,''XMinorTick'',''on'',''YMinorTick'',''on'')','');
end
%--------------------

% DataAspectRatio:
if get(H.ar_cb,'value')
  set(gca,'DataAspectRatio',dar);
  set(gca,'DataAspectRatio',H.limits.dar);
else
  ar=get(gca,'DataAspectRatio');
  set(H.ar,'string',[num2str(ar(1)),'  ',num2str(ar(2)),'  ',num2str(ar(3))]);
  H.limits.dar = ar;
end


% xlim
if get(H.xlim_cb,'value')
  xlim(xl);
  xlim(H.limits.xlim);
else
  xl=xlim;
  set(H.xlim,'string',[num2str(xl(1)),'  ',num2str(xl(2))]);
  H.limits.xlim = xl;
end

% ylim
if get(H.ylim_cb,'value')
  ylim(yl);
  ylim(H.limits.ylim);
else
  yl=ylim;
  set(H.ylim,'string',[num2str(yl(1)),'  ',num2str(yl(2))]);
  H.limits.ylim = yl;
end

% zlim
if get(H.zlim_cb,'value')
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
is   = get(H.menu_overlay_always, 'checked');
is2d = get(H.menu_overlay_2d,     'checked');
if isequal(is,'on') | (isequal(is2d,'on') & n==2)
  evalc('xy=H.overlay.data;','xy=[]');
  if ~isempty(xy)
    h=ishold;
    hold on

    cmenu = uicontextmenu;
    p=plot(xy(:,1),xy(:,2),'UiContextMenu',cmenu);
    N_setcontextmenu(cmenu,'overlay');

    Type='overlay';
    evalc(['LineStyle = H.overlay.LineStyle.',Type,';' ], 'LineStyle = ''default'';');
    evalc(['LineWidth = H.overlay.LineWidth.',Type,';' ], 'LineWidth = ''default'';');
    evalc(['Color     = H.overlay.Color.',Type,';'     ], 'Color     = ''b''      ;');
    set(p,'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',Color);

    if ~h
      hold off
    end
  end
end

% restore axis and colorbar colors;
% also sets their position accordind to colorbar labels extent
% also changes axes_title width, witch should always be = axes width
N_axProp

% set contours color:
if isequal(type,'contour'), N_contourcolor, end

% check if zoom:
if get(H.zoom,'value')
  zoom on
end
