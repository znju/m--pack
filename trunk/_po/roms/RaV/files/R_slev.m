function R_slev
% release s_levels

global H

% get fname:
fname = get(H.ROMS.axes_title,'string');
if isempty(fname)
  return
end


%get s-cooordinates parameters
thetas = H.ROMS.grid.thetas;
thetab = H.ROMS.grid.thetab;
tcline = H.ROMS.grid.tcline;
hmin   = H.ROMS.grid.hmin;
zeta   = H.ROMS.grid.zeta;
n      = H.ROMS.grid.N;

tts  = str2num(get(thetas, 'string'));
ttb  = str2num(get(thetab, 'string'));
tc   = str2num(get(tcline, 'string'));
hmin = str2num(get(hmin,   'string'));
zt   = str2num(get(zeta,   'string'));
N    = str2num(get(n,      'string'));

if ~(isnumber(tts,1) & isnumber(ttb,1) & isnumber(tc,1) & isnumber(hmin,1) & isnumber(zt,1) & isnumber(N,1))
  return
end

% get type of slice:
isi   = get(H.ROMS.grid.icb,   'value');  I   = str2num(get(H.ROMS.grid.i,   'string'));
isj   = get(H.ROMS.grid.jcb,   'value');  J   = str2num(get(H.ROMS.grid.j,   'string'));
isk   = get(H.ROMS.grid.kcb,   'value');  K   = str2num(get(H.ROMS.grid.k,   'string'));
islon = get(H.ROMS.grid.loncb, 'value');  LON = str2num(get(H.ROMS.grid.lon, 'string'));
islat = get(H.ROMS.grid.latcb, 'value');  LAT = str2num(get(H.ROMS.grid.lat, 'string'));
isz   = get(H.ROMS.grid.zcb,   'value');  Z   = str2num(get(H.ROMS.grid.z,   'string'));
if isi,   type = 'I';   ind=I;   funcID='i'; end
if isj,   type = 'J';   ind=J;   funcID='j'; end
if isk,   type = 'K';   ind=K;   funcID='k'; end
if islon, type = 'LON'; ind=LON; funcID='lon'; end
if islat, type = 'LAT'; ind=LAT; funcID='lat'; end
if isz,   type = 'Z';   ind=Z;   funcID='z'; end

if isz
  msgbox('choose othe slice (not z)','bad slice...','modal');
  return
end

set(gcf,'pointer','watch')

% get h:
varname = 'h';
eval([' [x,y,z,h,labels]=roms_slice',funcID,'(fname,varname,ind);']);

% get mask:
varname = 'mask_rho';
eval([' [xm,ym,zm,m]=roms_slice',funcID,'(fname,varname,ind);']);

% s-levels:
hc = min(hmin,tc);
[zr,zw] = s_levels(h,tts,ttb,hc,N,zt);

set(gcf,'pointer','arrow')

% plot:
% check if 2d or 3d:
is2d = get(H.ROMS.his.d2,'value');
is3d = get(H.ROMS.his.d3,'value');
figure
%----------- 2d:
if is2d & ~isk
  if isi | islon, x = y;         labx = labels.y; end
  if isj | islat, x = x; zr=zr'; labx = labels.y; end

  plot(x,zr,'k');
  hold on
  % bathy:
  plot(x,-h);
  plot(x,repmat(zt,size(h)));
  % mask:
  i = find(abs(m)<0.5);
  plot(x(i),0*m(i),'r+')

  % labels:
  xlabel(labx,     'interpreter','none');
  ylabel(labels.z, 'interpreter','none');
  title({['S-levels at RHO points, slice: ',type,' = ',num2str(ind)], fname},'interpreter','none');

  % legend:
  s1=['theta_s = ',num2str(tts)];
  s2=['theta_b = ',num2str(ttb)];
  s3=['Tcline  = ',num2str(tc)];
  s4=['hmin    = ',num2str(hmin)];
  s5=['N       = ',num2str(N)];
  str=strvcat(s1,s2,s3,s4,s5);
  n=plot(nan,'w');
  legend(n,str,4);
  lc=get(legend,'children');
  if ~isempty(lc)
    set(lc(end),'interpreter','none','fontname','courier');
  end

  % xlim, ylim:
  xamp=max(x)-min(x);   dx=xamp/20;
  zamp=max(h)+max(zt);  dz=zamp/20;
  xlim([min(x)-dx max(x)+dx]);
  ylim([min(-h)-dz max(zt)+dz]);
end

%----------- 3d:
if is3d | isk
  if isj | islat, zr=zr';  end

  if isk
    surf(x,y,zr(:,:,K),repmat(nan,size(z))); hold on
  else
    ind = find(size(x) == 1);
    for i = 1:size(zr,ind)

      if ind == 1
        plot3(x,y,zr(i,:),'k'); hold on
      else
        plot3(x,y,zr(:,i),'k'); hold on
      end

    end
  end

  % mask:
  i = find(abs(m)<0.5);
  plot3(xm(i),ym(i),0*m(i),'r+')

  % bathy to show:
  bathyvals  = H.ROMS.grid.contours_values;
  if ~isempty(bathyvals)
    if length(bathyvals) == 1
      bathyvals = [bathyvals bathyvals];
    end
    plot_border3d(fname,'bottom',0,'bathy',bathyvals,['slice',funcID],ind);
  else
    plot_border3d(fname,'bottom',0,['slice',funcID],ind);
  end
  grid on

  % labels:
  xlabel(labels.x,     'interpreter','none');
  ylabel(labels.y,     'interpreter','none');
  zlabel(labels.z,     'interpreter','none');
  title({['S-levels at RHO points, slice: ',type,' = ',num2str(ind)], fname},'interpreter','none');
end
