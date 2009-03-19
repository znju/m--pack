function edit_mask(file,action)
%EDIT_MASK   Edit land mask of ROMS NetCDF grid file
%
%   Syntax:
%      EDIT_MASK(FILE)
%      EDIT_MASK(BATHY_COUNTOURS)
%
%   Inputs:
%      FILE              ROMS NetCDF grid file [ <none> ]
%      BATHY_COUNTOURS   Depth contour to be added
%
%   Comments:
%      Without input argument FILE, the user is asked to choose one.
%      If a file coastline.mat with variables lon and lat is present
%      in path, the coast line is plotted; the user can however select
%      a new one using the menu <coast>.
%      The final file will be the same as input so, better copy the
%      original if you wanna keep it.
%
%   Usage:
%      edit_mask
%      % then you will prompted to select grid file
%      % click on menu <mask> to select points with mouse (right button)
%      % use left button to stop selection and start zoom on
%
%   MMA 1-10-2004, martinho@fis.ua.pt
%   11-1-2005, new version not based on pcolor
%    8-4-2005, added BATHY_COUNTOURS option

%   Department of Physics
%   University of Aveiro, Portugal

%   08-04-2005 - Added BATHY_COUNTOURS option
%   11-01-2005 - New version not based on pcolor
%     -06-2007 - Show ij

if length(get(0,'children'))>0
  DATA=getappdata(gcf,'data');
  set(gcf,'WindowButtonMotionFcn','edit_mask(''action'',''show_ij'');');
end

% ----------- add bathy contours:
bathy_contours = [];
if nargin ==1
  if isnumeric(file)
    bathy_contours = file;
  end
end
% -------------------------------

if nargin == 0 | isnumeric(file)
  file = netcdf('*.nc');
  file = name(file);
end
if isempty(file) & nargin == 1
  return
end
if nargin < 2
  action = 'init';
end

if isequal(action,'init')

  DATA.fig = figure;
  set(gcf,'menubar','none','NumberTitle','off','name','edit_mask')

  DATA.file    = file;
  DATA.changed = 0;
  DATA.saved   = 0;

  DATA.menu.mask = uimenu('label','<mask>',   'callback',  'edit_mask(''action'',''mask'');'       );
  DATA.menu.coas = uimenu('label','.coast.',  'callback',  'edit_mask(''action'',''coastline'');'  );
  DATA.menu.save = uimenu('label','<save>',   'callback',  'edit_mask(''action'',''save'');'       );
  DATA.menu.zoom = uimenu('label','[zoom]',   'callback',  'edit_mask(''action'',''zoom'');'       );
%  DATA.menu.fill = uimenu('label','-fill-',   'callback',  'edit_mask(''action'',''fill'');'       );
  DATA.menu.uv   = uimenu('label','-u-v-',    'callback',  'edit_mask(''action'',''uvr'');'         );
  DATA.menu.quit = uimenu('label','-quit-',   'callback',  'edit_mask(''action'',''quit'');'       );


  % laod variables:
  isxy = 0;
  % ------------------------------ rho
  if n_varexist(file,'lon_rho')
    lonr = use(file,'lon_rho');
    isxy = 0;
  elseif n_varexist(file,'x_rho')
    lonr = use(file,'x_rho');
    isxy = 1;
  end

  if ~isxy
    if ~n_varexist(file,'lat_rho');
      disp('## missing variables...');
      return
    end
    latr = use(file,'lat_rho');
  else
    if ~n_varexist(file,'y_rho');
      disp('## missing variables...');
      return
    end
    latr = use(file,'y_rho');
  end

  % ------------------------------ u, v
  isuv = 1;
  if ~isxy
    if  n_varexist(file,'lon_u') & n_varexist(file,'lat_u') & n_varexist(file,'lon_v') & n_varexist(file,'lat_v')
      lonu = use(file,'lon_u');
      latu = use(file,'lat_u');
      lonv = use(file,'lon_v');
      latv = use(file,'lat_v');
    else
      isuv = 0;
    end
  else
    if  n_varexist(file,'x_u') & n_varexist(file,'y_u') & n_varexist(file,'x_v') & n_varexist(file,'y_v')
      lonu = use(file,'x_u');
      latu = use(file,'y_u');
      lonv = use(file,'x_v');
      latv = use(file,'y_v');
    else
      isuv = 0;
    end
  end

  if ~isuv
    lonu = ( lonr(:,1:end-1) + lonr(:,2:end) )/2;
    latu = ( latr(:,1:end-1) + latr(:,2:end) )/2;

    lonv = ( lonr(1:end-1,:) + lonr(2:end,:) )/2;
    latv = ( latr(1:end-1,:) + latr(2:end,:) )/2;
  end


  % ------------------------------ masks
  if  n_varexist(file,'mask_rho')
    maskr = use(file,'mask_rho');
  else
    maskr = ones(size(lonr));
  end

  if  n_varexist(file,'mask_u') &   n_varexist(file,'mask_v')
    masku = use(file,'mask_u');
    maskv = use(file,'mask_v');
  else
    [masku,maskv,pmask]=uvp_masks(maskr);
  end

  % ------------------------------ bathy contour:
  if ~isempty(bathy_contours) &  n_varexist(file,'h')
    h = use(file,'h');
  end

  % --------------------------------------------------------------------

  [lon,lat] = gen_grid(lonr,latr);

  m_axis(lon,lat,.2,.2);
  hold on

  % rho, u, v
  set_points(lonr,latr,maskr,'rho');
  set_points(lonu,latu,masku,'u');
  set_points(lonv,latv,maskv,'v');
  set_fill(maskr,lon,lat);

  % bathy contours:
  if ~isempty(bathy_contours) &  n_varexist(file,'h')
    contour(lonr,latr,h,[bathy_contours]);
  end

  eval('load coastline, cl = 1;','cl = 0;');
  if cl
    pcl=plot(lon,lat,'r'); set(pcl,'tag','coastline','color',[0 0.65 0]);
  end

  lh = .8;
  lw = .5;
  set(gcf,'units','normalized');
  fp = get(gcf,'position');
  set(gcf,'position',[0.5-lw/2 0.5-lh/2 lw lh]);
  set(gca,'position',[0.0738    0.0535    0.8989    0.9092]);


  % zomm on:
  zm = DATA.menu.zoom;
  zoom on
  set(zm,'foregroundcolor',[1 0 0]);

  DATA.xr = lonr;
  DATA.yr = latr;
  DATA.mr = maskr;
  DATA.mr0 = maskr;

  DATA.xu = lonu;
  DATA.yu = latu;
  DATA.mu = masku;

  DATA.xv = lonv;
  DATA.yv = latv;
  DATA.mv = maskv;

  % show xi, eta at title:
  set(gcf,'WindowButtonMotionFcn','edit_mask(''action'',''show_ij'');');

% -------------------------------------------------------------------- show_ij
elseif isequal(action,'show_ij')
  cp=get(gca,'CurrentPoint');
  cpx=cp(1,1);
  cpy=cp(1,2);
  dist = (DATA.xr-cpx).^2 + (DATA.yr-cpy).^2;
  [j,i]=find(dist == min(min(dist)));
  xi=i-1;
  eta=j-1;
  title(sprintf('%4d %4d',xi,eta))
  
% -------------------------------------------------------------------- mask
elseif isequal(action,'mask')

  xr = DATA.xr;
  yr = DATA.yr;
  mr = DATA.mr;

  xu = DATA.xu;
  yu = DATA.yu;
  mu = DATA.mu;

  xv = DATA.xv;
  yv = DATA.yv;
  mv = DATA.mv;


  % zomm off:
  zm = DATA.menu.zoom;
  mm = DATA.menu.mask;
  zoom off
  set(zm,'foregroundcolor',[0 0 0]);
  set(mm,'foregroundcolor',[1 0 0]);

  xi=0;
  while ~isempty(xi)
    [xi,yi] = m_input(1,'pointer','crosshair');
    if ~isempty(xi)
      dist = (xr-xi).^2 + (yr-yi).^2;
      [i,j] = find(dist == min(min(dist)));

      if mr(i,j) == 0, mr(i,j) =1; else, mr(i,j) = 0; end
      [mu,mv,mp]=uvp_mask(mr);

      DATA.mr = mr;
      DATA.mu = mu;
      DATA.mv = mv;
      set_points(xr,yr,mr,'rho')
      set_points(xu,yu,mu,'u')
      set_points(xv,yv,mv,'v')
      set_fill(mr)
    end
  end

  set(mm,'foregroundcolor',[0 0 0]);
  edit_mask('action','zoom');

  % check if changed:
  if ~isequal(mr,DATA.mr0)
    DATA.changed = 1;
  else
    DATA.changed = 0;
  end

% -------------------------------------------------------------------- zoom
elseif isequal(action,'zoom')
  zm = DATA.menu.zoom;
  color = get(zm,'foregroundcolor');
  if color==[0 0 0]
    zoom on
    set(zm,'foregroundcolor',[1 0 0]);
  else
    zoom off
    set(zm,'foregroundcolor',[0 0 0]);
  end

% -------------------------------------------------------------------- quit
elseif isequal(action,'quit')
  changed = DATA.changed;
  saved   = DATA.saved;
  file    = DATA.file;
  fig     = DATA.fig;

 if changed
    s = {'mask was changed', 'wanna quit without save it first ?' };
    answer = questdlg(s,'Edit_Mask', 'yes','no','no');
  elseif ~saved
    s = {'no changes done in grid: ',file};
    msgbox(s,'Edit_Mask','help','modal');
    answer = 'yes';
  else % saved
    s = {'mask successfully changed on file: ',file};
    msgbox(s,'Edit_Mask','help','modal');
    answer = 'yes';
  end
  if isequal(answer,'yes'), close(fig); end

% -------------------------------------------------------------------- save
elseif isequal(action,'save')
  changed = DATA.changed;
  if ~changed
    msgbox('nothing to save','Edit_Mask','help','modal');
    return
  end

  file = DATA.file;
  nc = netcdf(file,'write');
    rmask = DATA.mr;
    [umask,vmask,pmask]=uvp_mask(rmask);

    nc{'mask_rho'}(:) = rmask;
    nc{'mask_u'}(:)   = umask;
    nc{'mask_v'}(:)   = vmask;
    nc{'mask_psi'}(:) = pmask;

    msgbox(['file ',file,' saved'],'Edit_Mask','help','modal');
  nc = close(nc);

  DATA.changed = 0;
  DATA.saved   = 1;
  DATA.mr0     = DATA.mr;

%  zm = DATA.menu.zoom;
%  set(zm,'foregroundcolor',[0 0 0]);
%  edit_mask('action','zoom');

% -------------------------------------------------------------------- fill
elseif isequal(action,'fill')

  obj = findobj(gca,'tag','land');
  if ~isempty(obj)
    vis=get(obj,'visible');
    if isequal(vis,'on')
      set(obj,'visible','off');
    else
      set(obj,'visible','on');
    end
  end

  zm = DATA.menu.zoom;
  set(zm,'foregroundcolor',[0 0 0]);
  edit_mask('action','zoom');

% -------------------------------------------------------------------- uvr
elseif isequal(action,'uvr')
  u=findobj(gca,'tag','u');
  v=findobj(gca,'tag','v');
  r=findobj(gca,'tag','rho');
  vis = get(u,'visible');

  if isequal(vis,'on')
    set(u,'visible','off');
    set(v,'visible','off');
    set(r,'visible','off');
  else
    set(u,'visible','on');
    set(v,'visible','on');
    set(r,'visible','on');
  end

  zm = DATA.menu.zoom;
  set(zm,'foregroundcolor',[0 0 0]);
  edit_mask('action','zoom');

% -------------------------------------------------------------------- coastline
elseif isequal(action,'coastline')
  cl = getf;
  if isempty(cl), return, end
  ll=load(cl);

  % check if coast is plotted:
  obj = findobj(gca,'tag','coastline');
  if isempty(obj)
    pcl=plot(ll.lon,ll.lat,'r');
    set(pcl,'tag','coastline');
  else
    set(obj,'xdata',ll.lon,'ydata',ll.lat);
  end

  zm = DATA.menu.zoom;
  set(zm,'foregroundcolor',[0 0 0]);
  edit_mask('action','zoom');

end

% store data:
setappdata(gcf,'data',DATA);

function set_points(x,y,m,type)
global DATA
switch type
  case 'rho'
    opt = 'ko';
  case 'u'
    opt = 'b>';
  case 'v'
    opt = 'r^';
end

i  = m~=0;
obj = findobj(gca,'tag',type);
if isempty(obj)
  pl =plot(x(i),y(i),opt); set(pl,'Markersize',4,'tag',type,'visible','off');
else
  set(obj,'xdata',x(i),'ydata',y(i));
end


function set_fill(mr,lon,lat)
if nargin==3
  mr(:,end+1)=mr(:,end);
  mr(end+1,:)=mr(end,:);
  p=pcolor(lon,lat,mr);
  %colormap([1 1 0.781; 1 1 1]);
  colormap([1 .8 0; 1 1 1]);
  set(p,'edgecolor',[.8 .8 .8],'tag','land');
else
  obj=findobj(gca,'tag','land');
  if ~isempty(obj)
    mr(:,end+1)=mr(:,end);
    mr(end+1,:)=mr(end,:);
    set(obj,'cdata',mr);
  end
end


function [lon,lat] = gen_grid(lonr,latr)

lon = (lonr(:,2:end)+lonr(:,1:end-1))/2;
lat = (latr(:,2:end)+latr(:,1:end-1))/2;

lon = (lon(2:end,:)+lon(1:end-1,:))/2;
lat = (lat(2:end,:)+lat(1:end-1,:))/2;


lon(2:end+1,2:end+1) = lon;
lon(1,:) = lon(2,:) - (lon(3,:) - lon(2,:));
lon(end+1,:) = lon(end,:) + (lon(end,:) - lon(end-1,:));

lon(:,1) = lon(:,2) - (lon(:,3) - lon(:,2));
lon(:,end+1) = lon(:,end) + (lon(:,end) - lon(:,end-1));


lat(2:end+1,2:end+1) = lat;
lat(1,:) = lat(2,:) - (lat(3,:) - lat(2,:));
lat(end+1,:) = lat(end,:) + (lat(end,:) - lat(end-1,:));

lat(:,1) = lat(:,2) - (lat(:,3) - lat(:,2));
lat(:,end+1) = lat(:,end) + (lat(:,end) - lat(:,end-1));
