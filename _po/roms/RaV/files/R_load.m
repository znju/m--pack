function R_load(what,file);

global H

ncquiet
eval('warning off MATLAB:mir_warning_variable_used_as_function','');

if nargin >= 2
  grd= netcdf(file);
else
  grd = netcdf;
end

if isempty(grd)
  return;
else
  fname=name(grd);
  close(grd);
end
str=subname(fname,35);

% set attributes:
set_fatt(fname);

axes(H.ROMS.axes);
hold off;


if isequal(what,'grid')
    H.ROMS.grid.fname = fname;
    % show grid name:
    set(H.ROMS.grid.name,'string',str);
end

if isequal(what,'his')
    H.ROMS.his.fname = fname;
    % show his name:
    set(H.ROMS.his.name,'string',str);
    % show time info:
    R_histime;
end

if isequal(what,'flt')
  H.ROMS.flt.fname = fname;
  % show flt name:
  set(H.ROMS.flt.name,'string',str);
  % show time info:
  R_flttime

  % --------- set float indexes:
  dimi    = H.ROMS.flt.dimi;
  dimstep = H.ROMS.flt.dimstep;
  dime    = H.ROMS.flt.dime;
  dims    = H.ROMS.flt.dims;
  % n. flots:
  sizeX   = n_varsize(fname,'Xgrid');
  nfloats = sizeX(2);
  set(dimi,    'string',1);
  set(dimstep, 'string',1);
  set(dime,    'string',nfloats);
  set(dims,    'string',nfloats);

end

if isequal(what,'sta')
  if ~ishold
    hold on
  end

  H.ROMS.sta.fname = fname;
  % show sta name:
  set(H.ROMS.sta.name,'string',str);
  % show time info:
  R_statime

  % plot positions
  if n_varexist(fname,'lon_rho');
    xsta = use(fname,'lon_rho');
  elseif n_varexist(fname,'x_rho');
    xsta = use(fname,'x_rho');
  else
    xsta = use(fname,'lon');
  end

  if n_varexist(fname,'lat_rho');
    ysta = use(fname,'lat_rho');
  elseif n_varexist(fname,'y_rho');
    ysta = use(fname,'y_rho');
  else
    ysta = use(fname,'lat');
  end

  % it looks like roms2+ sets positions over mask as 1e35, so convert to nan:
  xsta(xsta == 1e35) = nan;
  ysta(ysta == 1e35) = nan;

  eval('is = ishandle(H.ROMS.sta.points);','is=0;');
  if ~is
    H.ROMS.sta.points = plot(xsta,ysta,'.');
  else
    set(H.ROMS.sta.points,'xdata',xsta,'ydata',ysta);
  end

  % show dt at filter:
  dsta_hours = H.ROMS.sta.dsta_hours; % stored at R_statime.m
  set(H.ROMS.sta.filterdt,'string',dsta_hours);

  % show number of s-lev at K:
  k   = H.ROMS.grid.k;
  kcb = H.ROMS.grid.kcb;
  if n_dimexist(fname,'s_rho');
    set(k,'string',n_dim(fname,'s_rho'));
    % also select it:
    R_slicecb('kcb')
  end

end


if isequal(what,'grid') | isequal(what,'his')
  % load vars
  [lonr,latr,h,m] = roms_grid(fname);
  nc=netcdf(fname);
  HMIN =  min(min(h));

  % pcolor of mask
  if ~isempty(m)
    % pcolor of mask
    m(find(m==1))=nan;
    pcolor(lonr,latr,m);
    colormap([1 1 1;.5 .5 .5])
    shading flat
    hold on
    contour(lonr,latr,m,[.5 .5],'r');
  end


  % contour of h:
  H.ROMS.grid.contours_values=[];
  H.ROMS.grid.contours=[];
  R_contour(fname);

  % show position cross:
  H.ROMS.lonr = lonr;
  H.ROMS.latr = latr;
  R_pointer('init');

  % show several vars, if they exist:
  TTS = [];
  TTB = [];
  N   = [];
  [TTS,TTB,HC,N] = s_params(fname);

  thetas = H.ROMS.grid.thetas;
  thetab = H.ROMS.grid.thetab;
  tcline = H.ROMS.grid.tcline;
  hmin   = H.ROMS.grid.hmin;
  n      = H.ROMS.grid.N;
  k      = H.ROMS.grid.k;

  % get tcline:
  if     n_varexist(fname,'Tcline'), TCLINE = use(fname,'Tcline');
  elseif n_attexist(fname,'Tcline'), TCLINE = n_att(fname,'Tcline');
  else                               TCLINE = [];
  end
                        set(hmin,   'string',HMIN);
  if ~isempty(TCLINE),  set(tcline, 'string',TCLINE); end
  if ~isempty(TTS),     set(thetas, 'string',TTS);    end
  if ~isempty(TTB),     set(thetab, 'string',TTB);    end
  if ~isempty(N),       set(n,      'string',N);
                        set(k,      'string',N);      end

  % plot region border:
  plot_border(lonr,latr,'border','b:');

  % show axis title:
  set(H.ROMS.axes_title,'string',fname);

  nc=close(nc);
end

% -------------------------------- set several stuff:
R_axprop

% lims:
set(H.xlim_cb,'value',0)
xl=xlim;
set(H.xlim,'string',[num2str(xl(1)),'  ',num2str(xl(2))]);
set(H.ylim_cb,'value',0)
yl=ylim;
set(H.ylim,'string',[num2str(yl(1)),'  ',num2str(yl(2))]);
set(H.zlim_cb,'value',0)
zl=zlim;
set(H.zlim,'string',[num2str(zl(1)),'  ',num2str(zl(2))]);
set(H.ar_cb,'value',0)
ar=get(gca,'DataAspectRatio');
set(H.ar,'string',[num2str(ar(1)),'  ',num2str(ar(2)),'  ',num2str(ar(3))]);



function set_fatt(file)
  global H
  % get atributes
  nc=netcdf(file);
    %var=nc{varname};
    %a=att(var);
    a=att(nc);
    M=['#  atributes of --» ',file,'  #'];
    for i=1:length(a)
      b=a{i};
      v_name=name(b);
      v_val=b(:);
      if isnumeric(v_val), v_val=num2str(v_val); end
      M=strvcat(M,[v_name,' --» ', v_val]);
    end
    set(H.varAtt,'string',M);
  nc=close(nc);
return

