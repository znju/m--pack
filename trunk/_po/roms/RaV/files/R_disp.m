function R_disp

global H

% --------------------------------------------------------------------
% get fname:
% --------------------------------------------------------------------
% first try to get his file:
evalc('fname=H.ROMS.his.fname','fname=[]');

% now try from grid file:
if isempty(fname)
  evalc('fname=H.ROMS.grid.fname','fname=[]');
end

if isempty(fname);
  return
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
itime = str2num(get(H.ROMS.his.tindex,'string'));
[time_name, time_scale, time_offset] = R_vars(fname,'time');
nc=netcdf(fname);
ot = nc{time_name}(itime);
ot = ot * time_scale + time_offset;
ot = ot/86400;
nc=close(nc);

% --------------------------------------------------------------------
% get varnames (main and overlay)
% --------------------------------------------------------------------
% get varname:
vars  = get(H.ROMS.his.var1,'string');
varsi = get(H.ROMS.his.var1,'value');
varname = vars{varsi};
main = 1;
if isequal(varname,'none')
  main  = 0;
end

% check if varname exists in file:
if main
  if ~n_varexist(fname,varname)
    errordlg(['Variable ',varname,' not found in file'],'missing variable','modal');
    return
  end
end

% get overlay varname:
vars  = get(H.ROMS.his.var2,'string');
varsi = get(H.ROMS.his.var2,'value');
varname2 = vars{varsi};
overlay = 1;
if isequal(varname2,'none')
  overlay  = 0;
end

% now, the velocity field:
% check if overlay uv or uvbar:
arrows  = 0;
isuvbar = 0;
if isequal(varname2,'currents')
  arrows = 1;
end
if isequal(varname2,'uv-bar')
  arrows   = 1;
  isuvbar  = 1;
  % look for variables ubar and vbar:
  if ~n_varexist(fname,'ubar') | ~n_varexist(fname,'vbar')
    errordlg('Variables ubar or vbar not found in file','missing variable','modal')
    return
  end
end

% check if varname exists in file:
if overlay & ~arrows
  if ~n_varexist(fname,varname2)
     errordlg(['Variable ',varname2,' not found in file'],'missing variable','modal');
     return
  end
end


% --------------------------------------------------------------------
% get scales (main and overlay):
% --------------------------------------------------------------------
scale1s = get(H.ROMS.his.morescale1,'string');
scale2s = get(H.ROMS.his.morescale2,'string');
scale1  = str2num(scale1s);
scale2  = str2num(scale2s);

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
if is2d, new_dim = '2d'; end
if is3d, new_dim = '3d'; end

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
  
  % verify that previous plot has same dim, 1-d, 2-d, 3-d:
  info = get(gca,'userdata');
  eval('old_dim = info.dim;','old_dim = [];');
  if ~isequal(old_dim,new_dim)
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


% --------------------------------------------------------------------
% deal with variables without depth dependence:
% --------------------------------------------------------------------
% warning, cannot do pcolor or contours of variables like zeta, ubar or vbar at slicei,...
isbar_main    = 0;
isbar_overlay = 0;
bar_vars = {'zeta','ubar','vbar','uv-bar'};
if ismember(varname, bar_vars), isbar_main    = 1; end
if ismember(varname2,bar_vars), isbar_overlay = 1; end

if is2d & isbar_main
  if isk | isz,  funcID_main = 'k';
  else,          main = 0; % do not plot main
  end
elseif is3d & isbar_main
  funcID_main = 'k';
end

if is2d & isbar_overlay
  if isk | isz,  funcID_overlay = 'k';
  else,          overlay = 0; % do not plot main
  end
elseif is3d & isbar_overlay
  funcID_overlay = 'k';
end

if main == 0 & overlay == 0
  set(H.fig,'pointer','arrow');
  return
end

% --------------------------------------------------------------------
%  deal with files without info about s-coordinates.
%  In this case, values from the grid tab shall be used if the force
%   checkbox is activated
% --------------------------------------------------------------------
[tts,ttb,hc,N] = s_params(fname);

% check force edited s-paraameters:
forceEdited = get(H.ROMS.grid.sparams,'value');

if isempty(tts) | isempty(ttb) | isempty(hc) | isempty(N) | forceEdited
  % get from the grid tab:
  tts    = get(H.ROMS.grid.thetas, 'string'); tts    = str2num(tts);
  ttb    = get(H.ROMS.grid.thetab, 'string'); ttb    = str2num(ttb);
  hmin   = get(H.ROMS.grid.hmin,   'string'); hmin   = str2num(hmin);
  tcline = get(H.ROMS.grid.tcline, 'string'); tcline = str2num(tcline);
  N      = get(H.ROMS.grid.N,      'string'); N      = str2num(N);

  is1 = isnumber(tts);
  is2 = isnumber(ttb);
  is3 = isnumber(hmin);
  is4 = isnumber(tcline);
  is5 = isnumber(N);

  if ~all([is1 is2 is3 is4 is5])
    warndlg({'Some bad values were found for the s-coord parameters',...
             'Go to the grid tab and insert proper values of:',...
             'theta-s, theta-b, hmin, tcline and N'},'s-coord params not found','modal');

    set(H.fig,'pointer','arrow');
    return
  end

  sparams.tts    = tts;
  sparams.ttb    = ttb;
  sparams.hc     = min(hmin,tcline);
  sparams.N      = N;

  sparams_str = [',''s_params'',sparams'];
else
  sparams_str='';
end

% »»»»»»»»»»»»»»»»»»»»»»»»»»»»»Â»»»»»»»»»»»»Â»»»»»»Â»»»»»»»»»»»»»»»»»»»»»
% get DATA:
% »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% start some stuff:
set(H.fig,'pointer','watch');

% get main:
if main
  if exist('funcID_main'), funcID=funcID_main; end
  eval([' [x,y,z,v,labels]=roms_slice',funcID,'(fname,varname,ind,itime',sparams_str,');']);
  %size(v), size(x), size(y), size(z)
  v=zero2nan(v) * scale1(1); % notice that for arrows, scale(2) is used for v.
end

% get overlay:
if overlay
  if exist('funcID_overlay'), funcID=funcID_overlay; end
  %eval('funcID = funcID_overlay;', 'funcID = funcID;');
  if ~arrows
    eval(['[x2,y2,z2,v2,labels2]=roms_slice',funcID,'(fname,varname2,ind,itime',sparams_str,');']);
    v2=zero2nan(v2) * scale2(1);
  else
    if is3d, arr_type = '3'; else arr_type=''; end
    if ~isuvbar
      eval(['[x2,y2,z2,v2,labels2]=roms_sliceuvw',arr_type,'(fname,''slice',funcID,''',ind,itime',sparams_str,');']);
    else
      eval(['[x2,y2,z2,v2,labels2]=roms_sliceuvw',arr_type,'(fname,''slicekbar'',ind,itime',sparams_str,');']);
    end % isuvbar
  end
end

% get additional: depth, zeta and mask:
if isz, funcID_k = 'k'; else funcID_k = funcID; end % slice z do not
% allow not variables without depth dependence, so use slicek.
if is2d
  % get h:
  eval(['[xh,yh,zh,h]=roms_slice',funcID_k,'(fname,''h'',ind);']);
  
  % get zeta:
  eval(['[xz,yz,zz,zt]=roms_slice',funcID_k,'(fname,''zeta'',ind,itime);']);
end
% get mask:
eval(['[xm,ym,zm,m]=roms_slice',funcID_k,'(fname,''mask_rho'',ind,itime);']);

% »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
% get DATA.......   DONE:
% »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

% --------------------------------------------------------------------
% get type of plot and plot:
% --------------------------------------------------------------------

% first, set empty all cs of contours:
H.ROMS.his.cs   = [];
H.ROMS.his.cs21 = [];
H.ROMS.his.cs22 = [];

if main
  % ---------------------- 2-d:
  if is2d
    if isi | islon, x = y; y = z; labx = labels.y; laby = labels.z; end
    if isj | islat,        y = z; labx = labels.x; laby = labels.z; end
    if isk | isz,                 labx = labels.x; laby = labels.y; end
    
    % contour:
    ct=get(H.ROMS.his.contourcb,'value');
    if ct
      ctvals = str2num(get(H.ROMS.his.contourvals,'string'));
      if isnan(v)
        cs=[];
        ch=[];
      else
        [cs,ch]=contour(x,y,v,ctvals);
      end
      H.ROMS.his.cs  = cs; % used by R_plotopt
      
    % pcolor:
    else
      pc=pcolor(x,y,v);
      shading flat
      if length(unique(v))==1 | isnan(v)
        set(pc,'edgecolor','k','edgealpha',.1);  
      end
    end
    
  end % 2-d
  
  % ---------------------- 3-d:
  if is3d
    labx = labels.x;
    laby = labels.y;
    labz = labels.z;

    evalc('srf_main = surf(x,y,z,v); bad = 0;','bad = 1');
    if bad
      warndlg({'inconsistent size  of x, y,z and var, check N in grid tab',...
               ['x   : ',num2str(size(x))],...
               ['y   : ',num2str(size(y))],...
               ['z   : ',num2str(size(z))],...
               ['var : ',num2str(size(v))]},'error','modal');
      return
    else
      set(srf_main,'facecolor','interp','edgecolor','none');
    end
    if length(unique(v))==1 | isnan(v)
      set(srf_main,'edgecolor','k'); % just to show lines
      evalc('set(srf_main,''edgealpha'',.1);','');
    else
      caxis([min(min(v)) max(max(v))]);
    end
  end % main 3-d
  
  % ------------------------------------------------------------------
  % check if apply caxis: (also for contours)
  % ------------------------------------------------------------------
  if get(H.ROMS.his.pcolorcaxiscb,'value')
    cax = str2num(get(H.ROMS.his.pcolorcaxis,'string'));
    caxis(cax);
  else
    cax = caxis;
    set(H.ROMS.his.pcolorcaxis,'string',[num2str(cax(1)),'  ', num2str(cax(2))]);
  end
  
  % ------------------------------------------------------------------
  % colorbar
  % ------------------------------------------------------------------
  ax=gca;
  color_bar = colorbar;
  % store colorbar handle for future use (R_anim)
  H.ROMS.output_figure.colorbar = color_bar;
  axes(color_bar);
  % label: varname, long_name and units:
  long_name = n_varatt(fname,varname,'long_name');
  units     = n_varatt(fname,varname,'units');
  ylabel([varname,'  --  ',long_name,'    (',units,')']);
  axes(ax);
  hold on
  
end % if main

% --------------------------------------------------------------------
% generic for 2-d: plot additional data: depth, zeta and mask:
% --------------------------------------------------------------------
if ~isz & ~isk & is2d
  if isi | islon, xh = yh; xz = yz; xm = ym; end
  
  if is2d
    % bathym (depth):
    plot(xh,-h);
    
    % zeta:
    plot(xz,zt,'b');
    
    % mask:
    i = m <= 0.5;
    plot(xm(i),0*m(i),'r+')
  end

end

% --------------------------------------------------------------------
% generic for 3-d:
% --------------------------------------------------------------------
if is3d
  % plot the region border:
  bathyColor = H.ROMS.his.morebathyc;
  bathyvals  = H.ROMS.grid.contours_values;
  if length(bathyvals) == 1
    bathyvals = [bathyvals bathyvals];
  end % otherwise would be the number of contours
  if ~isempty(bathyvals)
    H.ROMS.plot3d=plot_border3d(fname,'bottom',1,'zeta',itime,['slice',funcID],ind,'bathy',bathyvals);
  else
    H.ROMS.plot3d=plot_border3d(fname,'bottom',1,'zeta',itime,['slice',funcID],ind);
  end
  camlight
  eval('set(srf_main,''FaceLighting'',''none'')','');

  % show mask:
  if n_vararraydim(size(m)) == 1 % means will plot onli in slice i, j, ...
    i = m <= 0.5;
    plot3(xm(i),ym(i),0*m(i),'r+')
  end
  
end


% --------------------------------------------------------------------
% now, the varname2 overlay:
% --------------------------------------------------------------------
if overlay
  
  % first, execute some common tasks:
  
  % 1 - get data used by both 2d and 3d:
  if ~arrows
    % contours
    % features:
    % - LineStyle
    % - LineWidth
    % - Color
    
    % the handles:
    h_cvals1 = H.ROMS.his.morecvals1;  % values
    h_cvals2 = H.ROMS.his.morecvals2;
    h_line1  = H.ROMS.his.moreline1;   % lineStyle
    h_line2  = H.ROMS.his.moreline2;
    h_linew1 = H.ROMS.his.morelinew1;  % lineWidth
    h_linew2 = H.ROMS.his.morelinew2;
    h_linec1 = H.ROMS.his.morelinec1;  % Color
    h_linec2 = H.ROMS.his.morelinec2;
    
    % the values:
    cvals1 = get(h_cvals1, 'string');
    cvals2 = get(h_cvals2, 'string');
    line1  = get(h_line1,  'string'); line1_   = get(h_line1,  'value'); line1  = line1{line1_};
    line2  = get(h_line2,  'string'); line2_   = get(h_line2,  'value'); line2  = line2{line2_};
    linew1 = get(h_linew1, 'string'); linew1_  = get(h_linew1, 'value'); linew1 = linew1{linew1_};
    linew2 = get(h_linew2, 'string'); linew2_  = get(h_linew2, 'value'); linew2 = linew2{linew2_};
    linew1 = str2num(linew1);
    linew2 = str2num(linew2);
    linec1 = get(h_linec1, 'backgroundcolor');
    linec2 = get(h_linec2, 'backgroundcolor');
  else
    % get du and dv:
    dudv = get(H.ROMS.his.moreduv,'string');
    dudv=str2num(dudv);
    du=dudv(1);
    evalc('dv=dudv(2);','dv=du;');
    
    % arrows color:
    arrColor = get(H.ROMS.his.morearrcolor,'backgroundcolor');
    
    % arrow scale position:
    arrpos = get(H.ROMS.his.morearrsc,'string');
    arrpos = str2num(arrpos);
    
    % arrow scale value:
    arrScale = get(H.ROMS.his.morearrscval,'string');
    arrScale = str2num(arrScale);
  end
  
  % 2 - set the variables and labels:
  if is2d
    if isi | islon, x2 = y2; y2 = z2; labx2 = labels2.y; laby2 = labels2.z; end
    if isj | islat,          y2 = z2; labx2 = labels2.x; laby2 = labels2.z; end
    if isk | isz,                     labx2 = labels2.x; laby2 = labels2.y; end
  elseif is3d
    labx2 = labels2.x;
    laby2 = labels2.y;
    labz2 = labels2.z;
  end
  
  % 3 - scale objects in case of orrows are in use or where used and hold on:
  % rate ~= 1 means hold is on and old arrows are plotted
  eval('rate = rate;','rate = 1;');
  if is2d
    if rate ~= 1 & ~(isk | isz)
      % scale new plot with previous rate, do not scale old objs:
      yxRate = rate;
      y2 = y2/yxRate;
      
      % but let me keep ytick:
      ytick = get(gca,'ytick');
      
      % scale new objects:
      objs=get(gca,'children');
      eval('old_objs = old_objs;','old_objs=[];');
      for i=1:length(objs)
        if ~ismember(objs(i),old_objs) % old objects shall not be scaled.
          eval('yd=get(objs(i),''ydata'');','');
          eval('set(objs(i),''ydata'',yd/yxRate);','');
        end
      end
    end
    
    if rate == 1 & ~(isk | isz) & arrows
      % find new scale and use it to scale all objs (old and new)
      dy=max(max(y2))-min(min(y2));
      dx=max(max(x2))-min(min(x2));
      yxRate=dy/dx;
      y2 = y2/yxRate;
      
      % but let me keep ytick:
      ytick = get(gca,'ytick');
      
      % scale all objects:
      objs=get(gca,'children');
      for i=1:length(objs)
        eval('yd=get(objs(i),''ydata'');','');
        eval('set(objs(i),''ydata'',yd/yxRate);','');
      end
    end
    
  end % end for 2-d
  
  if is3d
    if rate ~= 1
      % scale new plot with previous rate, do not scale old objs:
      zxRate = rate;
      z2 = z2/zxRate;
      
      % but let me keep ztick:
      ztick = get(gca,'ztick');
      
      % scale new objects:
      objs=get(gca,'children');
      eval('old_objs = old_objs;','old_objs=[];');
      objs=get(gca,'children');
      for i=1:length(objs)
        if ~ismember(objs(i),old_objs) % old objects shall not be scaled.
          eval('zd=get(objs(i),''zdata'');','');
          eval('set(objs(i),''zdata'',zd/zxRate);','');
        end
      end
    end
    
    if rate == 1 & arrows
      % find new scale and use it to scale all objs (old and new)
      % find aplitude of z and x:
      [xtmp,ytmp,ztmp] = roms_border(fname);
      % x:
      max_x = max(xtmp);
      min_x = min(xtmp);
      dx = max_x - min_x;
      % z:
      eval('max_z = max(get(H.ROMS.plot3d.zeta,''zdata''));','max_z=10;');
      %max_z = max(ztmp);
      min_z = min(ztmp);
      dz = max_z-min_z;

      zxRate=dz/dx;
      z2 = z2/zxRate;

      % but let me keep ztick:
      ztick = get(gca,'ztick');

      % scale all objects:
      objs=get(gca,'children');
      for i=1:length(objs)
        eval('zd=get(objs(i),''zdata'');','');
        eval('set(objs(i),''zdata'',zd/zxRate);','');
      end
    end
    
  end % end for 3-d


  % ---------------------- 2-d:
  if is2d
    
    if ~arrows
      % first conyour:
      str = ['[cs,ch] = contour(x2,y2,v2,',cvals1,',''k'');'];
      eval(str);
      set(ch,'lineStyle',line1,'lineWidth',linew1,'Color',linec1);
      H.ROMS.his.cs21  = cs; % used by R_more
      
      % second contour:
      if ~isempty(cvals2)
        str = ['[cs,ch] = contour(x2,y2,v2,',cvals2,',''k'');'];
        eval(str);
        set(ch,'lineStyle',line2,'lineWidth',linew2,'Color',linec2);
        H.ROMS.his.cs22  = cs;  % used by R_more
      end
      
    end % if ~arrows
    
    
    % »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»» 2-d arrows:
    if arrows
      for i=1:du:size(v2,1)
        for j=1:dv:size(v2,2)
          pos = [x2(i,j) y2(i,j)];
          V   = [real(v2(i,j)) imag(v2(i,j))] .* scale2;
          handles=vector(pos,V,.3,20,'k',0);
          eval('set(handles.plot,''color'',arrColor);','');
        end
      end
      
      axis equal
      
      % scale:
      pos = arrpos;
      V   = arrScale .* scale2;
      handles=vector(pos,V,.3,20,'k',0);
      set(handles.plot,'color',arrColor);
      ARR = num2str(norm(arrScale));
      tx = text(pos(1),pos(2),ARR,'HorizontalAlignment','center','VerticalAlignment','top');
      
    end % end if arrows
    
  end % 2-d
  
  % ---------------------- 3-d:
  if is3d
    
    if ~arrows
      linec1 = num2str(linec1);
      linec2 = num2str(linec2);
      
      % first contour:
      if ~all(isnan(v2)) & ~isempty(cvals1)
        cs21 = contourz(x2,y2,z2,v2,cvals1,linec1);
        set(cs21,'lineStyle',line1,'lineWidth',linew1);
        H.ROMS.his.cs21 = 'contourz(''clabel'');'; % string to be evaluated at clabel
      end
      
      % second contour:
      if ~all(isnan(v2)) & ~isempty(cvals2)
        cs22 = contourz(x2,y2,z2,v2,cvals2,linec2);
        set(cs22,'lineStyle',line2,'lineWidth',linew2);
        H.ROMS.his.cs22 = 'contourz(''clabel'');'; % string to be evaluated at clabel
      end
    end % if ~arrows
    
    % »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»» 3-d arrows:
    if arrows
      % here must have scale2 with length 1 or 3 !!
      % otherwise, use only first
      if length(scale2) == 2
        scale2 = [scale2(1) scale2(1) scale2(1)];
      end
      
      for i=1:du:size(v2.u,1)
        for j=1:dv:size(v2.u,2)
          pos = [x2(i,j) y2(i,j) z2(i,j)];
          V   = [v2.u(i,j) v2.v(i,j) v2.w(i,j)] .* scale2;
          handles=cone3d(pos,V,20,.3);
          eval('set(handles.line,''color'',arrColor);','');
        end
      end
      
      axis normal
      axis equal
      
      % arrow scale:
      pos = arrpos;
      V   = arrScale .* scale2;
      handles=vector(pos,V,.3,20,'k',0);
      set(handles.plot,'color',arrColor);
      ARR = num2str(norm(arrScale));
      tx = text(pos(1),pos(2),ARR,'HorizontalAlignment','center','VerticalAlignment','top');

      
    end % 3-d arrows
    
  end % 3-d
end % if overlay

% --------------------------------------------------------------------
% nice xlim and ylim:
% --------------------------------------------------------------------
if is2d
  if exist('x')==1, xx=x; else xx=x2; end
  if exist('y')==1, yy=y; else yy=y2; end
  %evalc('xx=x;','xx=x2;');
  %evalc('yy=y;','yy=y2;');
  
  if isi | islon |  isj |  islat
    xamp = max(max(xx))-min(min(xx));
    dx   = xamp/20;
    zamp = max(h)+max(zt);
    dz   = zamp/20;
    
    min_x = min(min(xx)) - dx;
    max_x = max(max(xx)) + dx;
    xlim([min_x max_x]);
    
    min_y = min(-h) - dz;
    max_y = max(zt) + dz;
    if exist('yxRate')==1
      min_y = min_y/yxRate;
      max_y = max_y/yxRate;
    end
    %eval('min_y = min_y/yxRate;','');
    %eval('max_y = max_y/yxRate;','');
    ylim([min_y max_y]);
  end
  
  if isk | isz
    xamp = max(max(xx))-min(min(xx));
    dx   = xamp/20;
    yamp = max(max(yy))-min(min(yy));
    dy   = xamp/20;
    
    min_x = min(min(xx))-dx;
    max_x = max(max(xx))+dx;
    xlim([min_x max_x]);
    
    min_y = min(min(yy))-dy;
    max_y = max(max(yy))+dy;
    ylim([min_y max_y]);
  end
  
end

if is3d & arrows
  axis tight
  zl = zlim;
  zamp = zl(2)-zl(1); dz = zamp/20;
  zlim([zl(1)-dz zl(2)+dz]);
  
  xl = xlim;
  xamp = xl(2)-xl(1); dx = xamp/20;
  xlim([xl(1)-dx xl(2)+dx]);
  
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
  if main
    ud_handles(color_bar,'top')
  end

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

% X and Y for main variable:
if exist('labx')==1, mainX = labx; else mainX = []; end
if exist('laby')==1, mainY = laby; else mainY = []; end
if exist('labz')==1, mainZ = labz; else mainZ = []; end

% next is not working in matlab 5.3 !!?? so use above.
%evalc('mainX = labx;','mainX = [];');
%evalc('mainY = laby;','mainY = [];');
%evalc('mainZ = labz;','mainZ = [];');

% X and Y for overlay variable:
if exist('labx2')==1, overlayX= labx2; else overlayX= []; end
if exist('laby2')==1, overlayY= laby2; else overlayY= []; end
if exist('labz2')==1, overlayZ= labz2; else overlayZ= []; end

% next is not working in matlab 5.3 !!?? so use above.
%evalc('overlayX = labx2;','overlayX = [];');
%evalc('overlayY = laby2;','overlayY = [];');
%evalc('overlayZ = labz2;','overlayZ = [];');

labelx = [mainX,'  [ ',overlayX,' ]'];
labely = [mainY,'  [ ',overlayY,' ]'];
labelz = [mainZ,'  [ ',overlayZ,' ]'];

% title:
days = sprintf('%6.2f days',ot);
if ~isequal(varname,'none')
  mainTit    = [varname,'*',scale1s];  else mainTit    = [];
end
if ~isequal(varname2,'none')
  overlayTit = [' [ ',varname2,'*',scale2s,' ] ']; else overlayTit = [];
end
titl = [mainTit,overlayTit,' -- ',type,' = ',num2str(ind),' -- time = ',days];

xlabel(labelx, 'interpreter','none');
ylabel(labely, 'interpreter','none');
zlabel(labelz, 'interpreter','none');
title(titl,    'interpreter','none');

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
    evalc(['clcolor     = H.overlay.Color.',Type,';'     ], 'clcolor     = ''b''      ;');
    set(p,'LineStyle',LineStyle,'LineWidth',LineWidth,'Color',clcolor);
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

% change xticklabels if using vertical slices with arrows:
% or zticklabels for 3d:
% but only if is a new figure:
if isempty(get(gca,'userdata'))
  if exist('yxRate')
    set(gca,'ytick',ytick/yxRate);
    ytl=get(gca,'ytick');
    set(gca,'yticklabel',ytl*yxRate,'YTickMode','manual');
  end
  
  if exist('zxRate')
    set(gca,'ztick',ztick/zxRate);
    ztl=get(gca,'ztick');
    set(gca,'zticklabel',ztl*zxRate,'ZTickMode','manual');
  end
end

% keep these rates cos of possible hold on,
% also keep 2d or 3d, to remove hold on if next plot will have diff dim:
% also keep type, cos in 2d, if hold on and diff type, then hold off

if is3d,     info.dim = '3d';
elseif is2d  info.dim = '2d';
elseif is1d  info.dim = '1d';
end

if     exist('yxRate'), info.rate = yxRate;
elseif exist('zxRate'), info.rate = zxRate;
else                    info.rate = 1;
end

info.type = type;

set(gca,'userdata', info);

%% if 2d, use box on:
if is2d, box on; end
