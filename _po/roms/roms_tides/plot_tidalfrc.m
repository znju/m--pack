function plot_tidalfrc(action)
%PLOT_TIDALFRC   Plot ROMS NetCDF tidal forcing files
%   Very simple GUI for quick visualization of tidal forcings.
%
%   MMA 10-5-2005, martinho@fis.ua.pt
%
%   See Also READ_TPXO, GEN_TPXOFRC

%   Department of Physics
%   University of Aveiro, Portugal

global TFP

if nargin == 0
  action = 'init';
end

if isequal(action,'init')

  TFP.fig = figure('MenuBar','none','NumberTitle','off','name','Tidal Forcing Plotter');
  set(gcf,'position',[210   203   650   650]);

  TFP.menu.tfp = uimenu('label','< tfp >');
  TFP.menu.tfpload = uimenu('label','load','parent',TFP.menu.tfp,'callback','plot_tidalfrc(''load'')');
  TFP.menu.tfpexit = uimenu('label','exit','parent',TFP.menu.tfp,'callback','closereq');

  TFP.menu.tfabout = uimenu('label','about','parent',TFP.menu.tfp,'callback','plot_tidalfrc(''about'')');

  dx = 0.01;
  dy = 0.01;
  ddy = dy/3;
  ddx = dx/3;
  dh = 0.025;
  dw = 0.07;
  dwl = 0.37;

  W = .5;
  H = .8;
  TFP.axt =  uicontrol('style','text','units','normalized','position',[1-W-dx 1-dy-2*dh W 2*dh]);
  TFP.ax  = axes('units','normalized','position',[1-W-dx 1-dy-H-2*dh-ddy W H]); box on

  x = dx; y = 1-dh-dy; w = dw; h = dh;
  TFP.file    = uicontrol('style','text','string','file','units','normalized',                                'position',[x y w h]); x = x+dw+ddx; w = dwl;
  TFP.filestr = uicontrol('style','text','string','','units','normalized',     'HorizontalAlignment','left',  'position',[x y w h]); x = dx; y = y-ddy-dh; w = dw;
  TFP.type    = uicontrol('style','text','string','type','units','normalized',                                'position',[x y w h]); x = x+dw+ddx; w = dwl;
  TFP.typestr = uicontrol('style','text','string','','units','normalized',     'HorizontalAlignment','left',  'position',[x y w h]); x = dx; y = y-ddy-dh; w = dw;
  TFP.title   = uicontrol('style','text','string','title','units','normalized',                               'position',[x y w h]); x = x+dw+ddx; w = dwl;
  TFP.titlestr= uicontrol('style','text','string','','units','normalized',     'HorizontalAlignment','left',  'position',[x y w h]); x = dx; y = y-ddy-dh; w = dw;
  TFP.grid    = uicontrol(                'string','grid','units','normalized', 'callback','plot_tidalfrc(''loadgrd'')',    'position',[x y w h]); x = x+dw+ddx; w = dwl;
  TFP.gridstr = uicontrol('style','text','string','','units','normalized',     'HorizontalAlignment','left',  'position',[x y w h]); x = dx; y = y-ddy-dh; w = dw;
  TFP.comp    = uicontrol('style','text','string','compon','units','normalized',                              'position',[x y w h]); x = x+dw+ddx; w = dwl;
  TFP.compstr = uicontrol('style','text','string','','units','normalized',     'HorizontalAlignment','left',  'position',[x y w h]); x = dx; y = y-ddy-dh; w = dw;
  TFP.hist    = uicontrol('style','text','string','hist','units','normalized',                                'position',[x y w h]); x = x+dw+ddx; w = dwl;
  TFP.histstr = uicontrol('style','text','string','','units','normalized',     'HorizontalAlignment','left',  'position',[x y w h]);

  % grid:
  h = 0.025;
  x = dx; y = y-ddy-dh - dy; w = dw; y1=y;
  TFP.grd      = uicontrol('style','text','string','grid',   'units','normalized',                                         'position',[x y 3*w h]); y = y-ddy-dh;
  TFP.grdplot  = uicontrol(               'string','plot',   'units','normalized', 'callback','plot_tidalfrc(''grd'')',    'position',[x y w h]); x = x+dw;
  TFP.grdplot3 = uicontrol(               'string','plot3d', 'units','normalized', 'callback','plot_tidalfrc(''grd3'')',   'position',[x y w h]); x = x+dw;
  TFP.grdcoast = uicontrol(               'string','coast',  'units','normalized', 'callback','plot_tidalfrc(''grdcl'')',  'position',[x y w h]); x = x+dw;

  % z:
  x = dx; y = y-ddy-dh - dy; w = dw;
  TFP.zuv    = uicontrol('style','text',      'string','z -:- uv',    'units','normalized',                                         'position',[x y 3*w h]); y = y-ddy-dh;
  TFP.zuv_   = uicontrol('style','popupmenu', 'string',{'amp+pha','amp','pha','-------','ellipses','major','minor','ecc','inc','phase'}, 'units','normalized',                        'position',[x y 2*w h]);

  % ellipses:
  x = dx; y = y-ddy-dh - dy; w = dw;
  TFP.ell       = uicontrol('style','text',      'string','ellipses',    'units','normalized',  'position',[x y 3*w h]); y = y-ddy-dh;
  TFP.elldx     = uicontrol('style','text',      'string','dx', 'units','normalized',           'position',[x y w/2 h]); x = x+w/2;
  TFP.elldx_    = uicontrol('style','edit',      'string','5',  'units','normalized',           'position',[x y w   h]); y=y-h;x=dx;
  TFP.elldy     = uicontrol('style','text',      'string','dy', 'units','normalized',           'position',[x y w/2 h]); x = x+w/2;
  TFP.elldy_    = uicontrol('style','edit',      'string','5',  'units','normalized',           'position',[x y w   h]); y=y-h;x=dx;
  TFP.ellsc     = uicontrol('style','text',      'string','scale', 'units','normalized',        'position',[x y w h]); x = x+w;
  TFP.ellsc_    = uicontrol('style','edit',      'string','1',  'units','normalized',           'position',[x y w   h]); y=y-h;x=dx;

  % t, zoom,...
  x=2*dx+dw*3; y=y1; ws = w/2;
  TFP.tlt  = uicontrol(               'string','<',    'units','normalized', 'callback','plot_tidalfrc(''lt'')',    'position',[x y ws h]); x = x+ws;
  TFP.t    = uicontrol('style','text','string','',     'units','normalized',                                        'position',[x y 1.5*w  h]); x = x+1.5*w;
  TFP.tgt  = uicontrol(               'string','>',    'units','normalized', 'callback','plot_tidalfrc(''gt'')',    'position',[x y ws h]); x = x+ws + 0*ddx;
  TFP.disp = uicontrol(               'string','disp', 'units','normalized', 'callback','plot_tidalfrc(''disp'')',  'position',[x y .75*w  h]);

  x=2*dx+dw*3; y = y -2*h;
  TFP.zoom   =  uicontrol('style','togglebutton','string','zoom',     'units','normalized',  'callback','zoom',       'position',[x y w  h]); x = x+w;
  TFP.axauto =  uicontrol(                       'string','ax nor',   'units','normalized',  'callback','axis normal', 'position',[x y w  h]); y = y-h;
  TFP.axequal=  uicontrol(                       'string','ax eql',   'units','normalized',  'callback','axis equal', 'position',[x y w  h]); x = x+w;

end


if isequal(action,'about')

  Message={
  'Tidal Forcing Plotter',
  'plot of ROMS tidal forcing files',
  '10-5-2005',
  '',
  'Created by:'
  'Martinho Marta Almeida',
  'Physics Department',
  'Aveiro University'
  'Portugal',
  '',
  'http://neptuno.fis.ua.pt/~mma',
  'martinho@fis.ua.pt'
};
Title='NCDView, about';
mb=msgbox(Message,Title,'help','modal');



end

if isequal(action,'load')
  TFP.fname =name(netcdf);
  TFP.type       = n_att(TFP.fname,'type');
  TFP.title      = n_att(TFP.fname,'title');
  TFP.grd_file   = n_att(TFP.fname,'grd_file');
  TFP.components = n_att(TFP.fname,'components');
  TFP.history    = n_att(TFP.fname,'history');

  set(TFP.filestr,  'string',TFP.fname);
  set(TFP.typestr,  'string',TFP.type);
  set(TFP.titlestr, 'string',TFP.title);
  set(TFP.gridstr,  'string',TFP.grd_file);
  set(TFP.compstr,  'string',TFP.components);
  set(TFP.histstr,  'string',TFP.history);

  TFP.n_components = n_dim(TFP.fname,'tide_period');

  set(TFP.t,'string',['1 of ',num2str(TFP.n_components)]);
end

if isequal(action,'loadgrd')
  TFP.grd_file =name(netcdf);
  set(TFP.gridstr,'string',TFP.grd_file);
end



if isequal(action,'grd')
  axes(TFP.ax);
  hold off
  plot_border2d(TFP.grd_file);
end

if isequal(action,'grd3')
  figure
  plot_border3d(TFP.grd_file);
end

if isequal(action,'grdcl')
  [filename, pathname]=uigetfile('*.mat', 'Choose the lon x lat file');
  if (isequal(filename,0)|isequal(pathname,0))
    fname=[];
    return
  else
    fname=[pathname,filename];
  end

  load('-mat',fname);

  if ~exist('lon') | ~exist('lat')
    return
  end

  err = 0;
  evalc(['p=plot(lon,lat,''k'');'],'err=1;');
  if ~err
    lon=get(p,'xdata');
    lat=get(p,'ydata');
    TFP.cl.lon = lon;
    TFP.cl.lat = lat;
  end

end

if isequal(action,'gt')
  str = get(TFP.t,'string');
  str = explode(str,' ',1); n = str2num(str);
  if n < TFP.n_components
    new = n+1;
  else
    new = 1;
  end
  set(TFP.t,'string',[num2str(new),' of ',num2str(TFP.n_components)]);
  plot_tidalfrc('disp');
end

if isequal(action,'lt')
  str = get(TFP.t,'string');
  str = explode(str,' ',1); n = str2num(str);
  if n > 1
    new = n-1;
  else
    new = TFP.n_components;
  end
  set(TFP.t,'string',[num2str(new),' of ',num2str(TFP.n_components)]);
  plot_tidalfrc('disp');
end

if isequal(action,'disp')
  grd = TFP.grd_file;
  [x,y,h,m] = roms_grid(grd);

  str = get(TFP.zuv_,'string');
  n   =  get(TFP.zuv_,'value');
  str = str{n};
  s   = get(TFP.t,'string');
  s   = explode(s,' ',1); n = str2num(s);

  nc = netcdf(TFP.fname);
  if isequal(str,'amp+pha')
    amp = nc{'tide_Eamp'}(n,:);
    pha = nc{'tide_Ephase'}(n,:);

    hold off
    pcolor(x,y,zero2nan(amp)); hold on, shading flat
    [cs,ch]=contour(x,y,zero2nan(pha),'w'); clabel(cs);
    box on
    colorbar('horiz');
  end

  if  ismember(str,{'amp','pha','phase','inc','major','minor','ecc'})
    if isequal(str,'amp'),   varname = 'tide_Eamp';   end
    if isequal(str,'pha'),   varname = 'tide_Ephase'; end
    if isequal(str,'phase'), varname = 'tide_Cphase'; end
    if isequal(str,'inc'),   varname = 'tide_Cangle'; end
    if isequal(str,'major'), varname = 'tide_Cmax';   end
    if isequal(str,'minor'), varname = 'tide_Cmin';   end

    if isequal(str,'ecc')
      major = nc{'tide_Cmax'}(n,:);
      minor = nc{'tide_Cmin'}(n,:);
      val = minor./major;
    else
      val = nc{varname}(n,:);
    end

    hold off
    pcolor(x,y,zero2nan(val));
    shading flat
    box on
    colorbar('horiz');
  end

  if isequal(str,'ellipses')
    major = nc{'tide_Cmax'}(n,:);
    minor = nc{'tide_Cmin'}(n,:);
    inc   = nc{'tide_Cangle'}(n,:);
    phase = nc{'tide_Cphase'}(n,:);

    dx    = str2num(get(TFP.elldx_,'string'));
    dy    = str2num(get(TFP.elldy_,'string'));
    scale = str2num(get(TFP.ellsc_,'string'));

    cla
    hold on
    for i=1:dx:size(major,2)
      for j=1:dy:size(minor,1)
        if major(j,i) ~=0 & ~isnan(major(j,i))
          if minor(j,i)/major(j,i) > 0, cor = 'b'; else, cor = 'r'; end
          pos = [x(j,i) y(j,i)];
          plot_ellipse(major(j,i)*scale,minor(j,i)*scale,inc(j,i),phase(j,i),pos,cor);
        end
      end
    end
    delete(colorbar)

  end

  axis equal
  hold on
  contour(x,y,m,[.5 .5],'r')
  plot_border(x,y,'border','r');
  m_axis(x,y,.2,.2)
  % coatline:
  evalc('plot(TFP.cl.lon,TFP.cl.lat,''k'');','');


  period = nc{'tide_period'}(n);
  component = freq2name(1/period);
  set(TFP.axt,'string',[component,' - T = ',num2str(period),' h']);

  close(nc);
end


% colors:
if isequal(action,'init')
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

  obj = findobj(gcf,'style','popupmenu');
  set(obj,'backgroundcolor',textbg,'foregroundcolor',textfg);
end
