function R_dispflt

global H

% --------------------------------------------------------------------
% get fname:
% --------------------------------------------------------------------
% first try to get his file:
evalc('fname=H.ROMS.flt.fname','fname=[]');

if isempty(fname);
  return
end

% --------------------------------------------------------------------
% get his or grid:
% --------------------------------------------------------------------
% first try to get his file:
evalc('fname2=H.ROMS.his.fname','fname2=[]');
% now try from grid file:
if isempty(fname2)
  evalc('fname2=H.ROMS.grid.fname','fname2=[]');
end

% --------------------------------------------------------------------
% get type of slice:
% --------------------------------------------------------------------
isi   = get(H.ROMS.grid.icb,   'value');  I   = str2num(get(H.ROMS.grid.i,   'string'));
isj   = get(H.ROMS.grid.jcb,   'value');  J   = str2num(get(H.ROMS.grid.j,   'string'));
isk   = get(H.ROMS.grid.kcb,   'value');  K   = str2num(get(H.ROMS.grid.k,   'string'));
islon = get(H.ROMS.grid.loncb, 'value');  LON = str2num(get(H.ROMS.grid.lon, 'string'));
islat = get(H.ROMS.grid.latcb, 'value');  LAT = str2num(get(H.ROMS.grid.lat, 'string'));
isz   = get(H.ROMS.grid.zcb,   'value');  Z   = str2num(get(H.ROMS.grid.z,   'string'));

if isi,   type = 'I';   ind=I;   funcID='i';   end
if isj,   type = 'J';   ind=J;   funcID='j';   end
if isk,   type = 'K';   ind=K;   funcID='k';   end
if islon, type = 'LON'; ind=LON; funcID='lon'; end
if islat, type = 'LAT'; ind=LAT; funcID='lat'; end
if isz,   type = 'Z';   ind=Z;   funcID='z';   end

% --------------------------------------------------------------------
% get time:
% --------------------------------------------------------------------
itime = str2num(get(H.ROMS.flt.tindex,'string'));
[time_name, time_scale, time_offset] = R_vars(fname,'time');
nc=netcdf(fname);
ot = nc{time_name}(itime);
ot = ot * time_scale + time_offset;
ot = ot/86400;
nc=close(nc);

% --------------------------------------------------------------------
% check if need to  open new fig:
% --------------------------------------------------------------------
% - open if none exist yet or if new fig checkbox is selected:
% find last output fig:
figs    = get(0,'children');
outputs = findobj(figs,'tag','rcdv_output');
% get new fig checkbox value:
new = get(H.ROMS.his.newfig,'value');
if new | isempty(outputs)
  figure('tag','rcdv_output');
elseif ~isempty(outputs)
  last = outputs(1);
  figure(last);
end

% --------------------------------------------------------------------
% check  if 2-d or 3-d:
% --------------------------------------------------------------------
is2d = get(H.ROMS.his.d2,'value');
is3d = get(H.ROMS.his.d3,'value');

% --------------------------------------------------------------------
% check if hold on:
% --------------------------------------------------------------------
theHold = H.ROMS.his.hold;
is_hold=get(theHold,'value');
if ~is_hold
  clf
  set(gcf,'userdata',[]);
else
  % if hold and in case the bathy and several lines are plotted
  % with plot_border3d, beter just remove what would be repeated:
  eval('d3 = H.ROMS.plot3d;','');
  eval('delete(d3.bottom);',  '');
  eval('delete(d3.top);',     '');
  eval('delete(d3.corners);', '');
  eval('delete(d3.mask);',    '');
  eval('delete(d3.contour);', '');
  eval('delete(d3.surfh);',   '');

  % turns off previous possible lighting
  delete(findobj(gca,'type','light'))

  % verify that previous plot has same dim, 2-d or 3-d:
  info = get(gca,'userdata');
  eval('old_dim = info.dim;','old_dim = [];');
  if (isequal(old_dim,'2d') & is3d) | (isequal(old_dim,'3d') & is2d)
    clf 
    set(gcf,'userdata',[]);
  end

  % verify than if 2d, the old plot has same type:
  eval('old_type = info.type;','old_type = type;');
  if is2d & ~isequal(old_type,type)
    clf
    set(gcf,'userdata',[]);
  end

  % get also the rate and keep old objetcs to avoid them to be scaled later again by rate:
   eval('rate = info.rate;','rate = 1;');
  old_objs = findobj(gca);
end
hold on

% »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% get DATA:
% »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% start some stuff:
set(H.fig,'pointer','watch');

% -----------  get floats  range:
dimi    = H.ROMS.flt.dimi;
dimstep = H.ROMS.flt.dimstep;
dime    = H.ROMS.flt.dime;

dimi    = get(dimi,    'string');
dimstep = get(dimstep, 'string');
dime    = get(dime,    'string');

range_floats = [dimi,':',dimstep,':',dime];

% ------------ get floats time range:
ti = num2str(1);
dt = get(H.ROMS.flt.tstep,'string'); dt =strrep(dt,'+','');
te = num2str(itime);

% check if track (plot float track):
dotrack = get(H.ROMS.flt.trackcb,'value');
if ~dotrack
  ti=te;
end
range_time = [ti,':',dt,':',te];

range = ['(',range_time,',',range_floats,')'];
s   = n_varsize(range(2:end-1));

if prod(s) > 100 * 1000
  question = 'var size is quite big! wanna procced?';
  size_str = sprintf('[  %g  x  %g  ] = %g',s,prod(s));
  current  = 'max var size in use = 100 x 1000';
  question={question,size_str,current};
  title='';
  answer=questdlg(question,title,'yes','no','no');
  if isequal(answer,'no')
    return
  end
end

if n_varexist(fname,'lon')
  X = 'lon';
  Y = 'lat';
  Z = 'depth';
else
  X = 'Xgrid';
  Y = 'Ygrid';
  Z = 'depth';
end

nc=netcdf(fname);
evalc(['x = nc{X}',range,';'],'x=[];');
evalc(['y = nc{Y}',range,';'],'y=[];');
evalc(['z = nc{Z}',range,';'],'z=[];');
nc=close(nc);

% get missing_value:
missing_value = 'missing_value';
evalc(['missx = n_varatt(fname,X,missing_value);'],'missx='';');
evalc(['missy = n_varatt(fname,Y,missing_value);'],'missy='';');
evalc(['missz = n_varatt(fname,Z,missing_value);'],'missz='';');

% convert missing_value to nan:
x(x==missx)=nan;
y(y==missy)=nan;
z(z==missz)=nan;

% looks like first value is zero, convert it also to nan:
if (itime == 1 | dotrack) & x(1,:) == 0 & y(1,:) == 0
  x(1,:) = nan;
  y(1,:) = nan;
end

if isempty(x) | isempty(y) | isempty(z)
  return
end

% get additional: depth, zeta and mask:
% from his or grid:
if ~isempty(fname2)
  eval(['[xh,yh,zh,h,names]=roms_slice',funcID,'(fname2,''h'',ind,itime);']);
  eval(['[xm,ym,zh,m,names]=roms_slice',funcID,'(fname2,''mask_rho'',ind,itime);']);
else
  xh = nan;  xm = nan;
  yh = nan;  ym = nan;
  h  = nan;  m  = nan;
end

% »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% get DATA.......   DONE:
% »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

% --------------------------------------------------------------------
% plot additional data: depth, zeta and mask:
% --------------------------------------------------------------------

% ------------------ 3d:
if is3d

  if dotrack
    plot3(x,y,z);
  else
    plot3(x,y,z,'bo')
  end

  if ~isempty(fname2)
    bathyvals  = H.ROMS.grid.contours_values;
    if length(bathyvals) == 1
      bathyvals = [bathyvals bathyvals];
    end % otherwise would be the number of contours
    cont_color = get(H.ROMS.his.morebathyc,'backgroundcolor');
    p3d = plot_border3d(fname2,'bathy',bathyvals);
    set(p3d.contour,'color',cont_color);
    set(p3d.surfh,'edgecolor','g')
    set(p3d.surfh,'facecolor',[.5 .5 .5])
    set(p3d.surfh,'facealpha',.2)
  end
end

if is2d
  if isi | islon
    % depth:
    plot(yh,-h);
    % mask:
    i = m==0;
    plot(ym(i),m(i),'r+');
    if dotrack
      plot(y,z);
    else
      plot(y,z,'bo')
    end
  end

  if isj | islat
    % depth:
    plot(xh,-h);
    % mask:
    i = m==0;
    plot(xm(i),m(i),'r+');
    if dotrack
      plot(x,z);
    else
      plot(x,z,'bo')
    end
  end

  if isk | isz
    % bathy:

    % coaats:

  end

end

% --------------------------------------------------------------------
% pre-defined limits:
% --------------------------------------------------------------------
% for 2-d, use:
%   - xlim
%   - ylim
%
% for 3-d, use:
%   - CameraPosition
%   - CameraTarget
%   - CameraViewAngle
%
% the objective is to froze what we see changing itime
% to get this values, press [current] ( R_outputsett  is called )

if is2d
  % do  axis equal if togglebutton is activated:
  if get(H.ROMS.his.axequal,'value')
    axis equal
  end

  xl   = str2num(get(H.ROMS.his.xlim,'string'));
  yl   = str2num(get(H.ROMS.his.ylim,'string'));
  zl   = str2num(get(H.ROMS.his.zlim,'string'));

  if length(xl) ~= 2 & length(yl) ~= 2 length(zl) ~= 2
    % means are values for 3-d, so uncheck them.
    set(H.ROMS.his.xlimcb,'value',0);
    set(H.ROMS.his.ylimcb,'value',0);
    set(H.ROMS.his.zlimcb,'value',0);
  end

  % check  if apply xlim or ylim:
  isxl = get(H.ROMS.his.xlimcb,'value');
  isyl = get(H.ROMS.his.ylimcb,'value');
  iszl = get(H.ROMS.his.zlimcb,'value');

  xl   = str2num(get(H.ROMS.his.xlim,'string'));
  yl   = str2num(get(H.ROMS.his.ylim,'string'));
  zl   = str2num(get(H.ROMS.his.zlim,'string'));

  if isxl,  xlim(xl);
  else set(H.ROMS.his.xlim,'string',[num2str(xl(1)),'  ', num2str(xl(2))]);
  end

  if isyl,  ylim(yl);
  else set(H.ROMS.his.ylim,'string',[num2str(yl(1)),'  ', num2str(yl(2))]);
  end

  % nothing to do with zl; zl is indeed CameraViewAngle, not zlim.

end % 2-d

if is3d
  % first, set view 3 and bring colorbar up:
  view(3)
  % colorbar exists if main:
  %if main
  %  ud_handles(color_bar,'top')
  %end

  xl   = str2num(get(H.ROMS.his.xlim,'string'));
  yl   = str2num(get(H.ROMS.his.ylim,'string'));
  zl   = str2num(get(H.ROMS.his.zlim,'string'));

  if length(xl) ~= 3 & length(yl) ~= 3 & length(zl) ~= 1
    % means are values for 2-d, so uncheck them.
    set(H.ROMS.his.xlimcb,'value',0);
    set(H.ROMS.his.ylimcb,'value',0);
    set(H.ROMS.his.zlimcb,'value',0);
  end

  % check  if apply camera settings:
  isxl = get(H.ROMS.his.xlimcb,'value');
  isyl = get(H.ROMS.his.ylimcb,'value');
  iszl = get(H.ROMS.his.zlimcb,'value');

  if isxl
    set(gca,'CameraPosition',xl);
  else
    xl = get(gca,'CameraPosition');
    set(H.ROMS.his.xlim,'string',[num2str(xl(1)),'  ', num2str(xl(2)),'  ', num2str(xl(3))]);
 end

  if isyl
    set(gca,'CameraTarget',yl);
  else
    yl = get(gca,'CameraTarget');
    set(H.ROMS.his.ylim,'string',[num2str(yl(1)),'  ', num2str(yl(2)),'  ', num2str(yl(3))])
  end

  if iszl
    set(gca,'CameraViewAngle',zl);
  else
    zl = get(gca,'CameraViewAngle');
    set(H.ROMS.his.zlim,'string',zl)
  end

end % 3-d

% --------------------------------------------------------------------
% labels:
% --------------------------------------------------------------------

% TODO

% --------------------------------------------------------------------
% the coastline overlay:
% --------------------------------------------------------------------
if (is2d & (isk | isz)) | is3d

  cl_overlay=0;
  if findobj(H.fig,'tag','cl_overlay');
    cl_overlay=1;
  end

  if cl_overlay
    evalc('xy=H.ROMS.overlay.data;','xy=[];');

    xcl = xy(:,1);
    ycl = xy(:,2);
    % plot only coastline inside region:
    [XB,YB]= roms_border(fname);
    i=inpolygon(xcl,ycl,XB,YB);
    xcl(i==0) = nan;
    ycl(i==0) = nan;

    p = plot(xcl,ycl);

    Type='cl_overlay';
    evalc(['LineStyle = H.overlay.LineStyle.',Type,';' ], 'LineStyle = ''default'';');
    evalc(['LineWidth = H.overlay.LineWidth.',Type,';' ], 'LineWidth = ''default'';');
    evalc(['Color     = H.overlay.Color.',Type,';'     ], 'Color     = ''b''      ;');
    set(p,'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',Color);
  end

end

% --------------------------------------------------------------------
% the bathymetry overlay (for z and k slices) and grid   on/off:
% --------------------------------------------------------------------
if (isk | isz) & is2d
  % ------------------------------------- bathy overlay:
  bathy      = H.ROMS.his.morebathy;
  incbathy = get(bathy,'value');

  if incbathy
    bathyColor = H.ROMS.his.morebathyc;
    bathyvals  = H.ROMS.grid.contours_values;
    if length(bathyvals) == 1
      bathyvals = [bathyvals bathyvals];
    end % otherwise would be the number of contours

    bcolor   = get(bathyColor,'backgroundcolor');
    if ~isempty(bathyvals)
      [tmp1,tmp2] = contour(xh,yh,h,bathyvals,'k');
      set(tmp2,'color',bcolor);
      end
  end

  % ------------------------------------- mask_rho overlay:
  mask      = H.ROMS.his.moremask;
  incmask = get(mask,'value');
  if incmask
    maskColor = H.ROMS.his.moremaskc;
    mcolor   = get(maskColor,'backgroundcolor');
    [tmp1,tmp2] = contour(xm,ym,m,[-5 .5],'k');
    set(tmp2,'color',mcolor);
  end

end % is k or z

% grid on/off
gridon   = H.ROMS.his.moregridon;
incgrid  = get(gridon,'value');
if incgrid
  grid on
else
  grid off
end


% --------------------------------------------------------------------
% done... final settings:
set(H.fig,'pointer','arrow');


