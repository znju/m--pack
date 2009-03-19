function dens = occam2pom_dens(files,grd,s_params,varargin)
%OCCAM2POM_DENS   Compute density for POM from OCCAM files
%
%   Syntax:
%      DENS = OCCAM2POM_DENS(FILES,GRID,SPARAMS,VARARGIN)
%
%   Inputs:
%      FILES   OCCAM files
%      GRID    ROMS/POM NetCDF grid file
%      SPARAMS   S-coordinates parameters, [theta_s,theta_b,hc,n] for
%                ROMS and z,zz text file for POM
%      VARARGIN:
%         ddx, if not 0, shelf break diff is calculated and used, see
%              SHELF_BREAK_DIFF, default=1
%         dmax,  maximum distance considered, values higher are not
%                used, default=20000 (20 km)
%         depths, shelf break depths range, default=[200 1000]
%         ij, distance along j, 2, or along i, 1 (default=2)
%         quiet, if 0 some messagens may be printed (default=0)
%         save, NetCDF filename where DENS will be saved, or 0, not
%               to save (default=0)
%
%   Outputs:
%      DENS   Density for POM
%
%   Example:
%      ocfiles = {'jan.nc','feb.nc','mar.nc'};
%      grd     = 'roms_grd.nc';
%      sparams = 'zz.dat'
%      dens = occam2pom_dens(ocfiles,grd,sparams);
%
%   See also OCCAM2INI_VARS, SHELF_BREAK_DIFF
%
%   MMA 26-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if ~iscell(files)
  files={files};
end

ddxMax   = 15000;      % higher values not used by shelf_break_diff
sbDepths = [200 1000]; % shelf break depths, used by shelf_break_diff
sbDir    = 0;          % shelf break axis, if xi use 0, used by shelf_break_diff
calcDDX  = 1;
quiet    = 0;
savename = 0

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'ddx'),    calcDDX   = vin{i+1};
  elseif isequal(vin{i},'dmax'),   ddxMax    = vin{i+1};
  elseif isequal(vin{i},'depths'), sbDepths  = vin{i+1};
  elseif isequal(vin{i},'ij'),     sbDir     = vin{i+1};
  elseif isequal(vin{i},'quiet'),  quiet     = vin{i+1};
  elseif isequal(vin{i},'save'),   savename  = vin{i+1};
  end
end

% get grid vars:
[xg,yg,hg] = roms_grid(grd,'r');
[xu,yu,hu] = roms_grid(grd,'u');
[xv,yv,hv] = roms_grid(grd,'v');
ang=use(grd,'angle')*180/pi;
[eta,xi]=size(hg);

Noc=n_filedim(files{1},'DEPTH');
D=repmat(nan,[length(files) Noc eta xi]);
for n=1:length(files)
  fname=files{n};
  if ~quiet
     fprintf(1,'  - using file %s\n',fname);
  end

  [xoc,yoc,hocr,mr,Mr]   = occam_grid(fname,'r');
  [xocu,yocu,hocu,mu,Mu] = occam_grid(fname, 'uv');

  % calc s-levels:
  % zeta is needed, interpolate:
  vname='SEA_SURFACE_HEIGHT__MEAN_';
  SSH=use(fname,vname,'DEPTH',i,'miss',0)*0.01;
  ssh=interp2(xoc,yoc,SSH,xg,yg);
  ssh(isnan(ssh))=0;

  if ~quiet
    fprintf(1,'  > calc s-levels\n');
  end
  if isstr(s_params)
    datafile=s_params;
    [zr,zw]=pom_s_levels(s_params,hg,ssh);
    N=pom_s_levels(s_params);
  else
    [theta_s,theta_b,hc,N]=unpack(s_params);
    [zr,zw]=s_levels(hg,theta_s,theta_b,hc,N,ssh);
  end

  % get average grid width and depth:
  % used in extrap2
  if ~quiet
    fprintf(1,'  > getting grid width/grid depth range');
  end
  x_=xg(round(eta/2),:);
  y_=yg(round(eta/2),:);
  dx=spheric_dist(y_(2:end),y_(1:end-1),x_(2:end),x_(1:end-1));
  gw=sum(dx); % mean grid width
  gz=max(hg(:))-min(hg(:)); % grid depth
  rwd=gw/gz; % rate width depth
  if ~quiet
    fprintf(1,' = %6.2f\n',rwd);
  end

  % calc average x distance between depths at slope:
  if calcDDX
    if n==1
      if ~quiet
        fprintf(1,'  > getting distance between depths at slope');
      end
      [DDX,dmean,dmstd]=shelf_break_diff(xg,yg,hg,xoc,yoc,hocr,'ij',sbDir,'depths',sbDepths,'dmax',ddxMax);
      ddx=dmstd;
      if ~quiet
        fprintf(1,' = %6.2f km\n',ddx/1000);
      end
    else
      ddx=0;
    end
  end

  % interp occam data to new grid but same depths:
  Noc=n_filedim(fname,'DEPTH');

  TEMP = repmat(nan,[Noc eta xi]);
  SALT = repmat(nan,[Noc eta xi]);
  DENS=repmat(nan,[Noc eta xi]);

  % slice occam data; in case of extrapHoriz its faster if we slice only
  % the needed part of the occam grid
  if extrapHoriz
    if ~quiet
      fprintf(1,'  > slicing occam data\n');
    end
    [i1,j1]=find_nearest(xoc,yoc,min(min(xg)),min(min(yg)));
    [i2,j2]=find_nearest(xoc,yoc,max(max(xg)),max(max(yg)));
    i1=max(1,i1-3);
    j1=max(1,j1-3);
    i2=min(size(xoc,1),i2+3);
    j2=min(size(xoc,2),j2+3);
    ilat=[num2str(i1) ':' num2str(i2)];
    ilon=[num2str(j1) ':' num2str(j2)];
    xoc=xoc(i1:i2,j1:j2); xocu=xocu(i1:i2,j1:j2);
    yoc=yoc(i1:i2,j1:j2); yocu=yocu(i1:i2,j1:j2);
  end

  for i=1:Noc
    if ~quiet
      fprintf(1,'  - interp z level %d of %d\n',i,Noc);
    end

    vname='POTENTIAL_TEMPERATURE__MEAN_';
    voc=use(fname,vname,'DEPTH',i,'LONGITUDE_T',ilon,'LATITUDE_T',ilat,'miss',-2);
    voc=extrap2(xoc,yoc,voc,nan);
    TEMP(i,:,:)=interp2(xoc,yoc,voc,xg,yg);

    vname='SALINITY__MEAN_';
    voc=use(fname,vname,'DEPTH',i,'LONGITUDE_T',ilon,'LATITUDE_T',ilat);
    voc=voc*1000+35;
    miss=max(max(voc));
    voc(voc==miss)=nan;
    voc=extrap2(xoc,yoc,voc,nan);
    SALT(i,:,:)=interp2(xoc,yoc,voc,xg,yg);
  end

  % ocaam depth:
  doc=use(fname,'DEPTH')*0.01;

  % calc density:
  DENS=rho_eos(TEMP,SALT,-repmat(doc,[1 eta xi]));
  for i=1:size(DENS,1)
    DENS(i,:,:)=mean(mean(DENS(i,:,:)));
  end

  D(n,:,:,:)=DENS;
end

DENS=squeeze(mean(D,1)); % n files mean

% repeat 1st level to z > ssh, like 1m.
% otherwise bad griddata may occur near surface!
% also need to add another level to X and Z.
DENS(2:end+1,:,:)=DENS; DENS(1,:,:)=DENS(2,:,:);

dens = repmat(nan,[N eta   xi]);

for i=1:eta
  if ~quiet
    fprintf(1,'  - interp to s-levels eta %d of %d\n',i,eta);
  end

  x_  = xg(i,:);
  xu_ = xu(i,:);
  if i< eta, xv_ = xv(i,:); end
  y_  = yg(i,:);
  yu_ = yu(i,:);
  if i<eta, yv_ = yv(i,:); end

  % convert X to distance:
  dx  = spheric_dist( y_(2:end), y_(1:end-1), x_(2:end), x_(1:end-1)); dx =[0; cumsum(dx(:))];
  dxu = spheric_dist(yu_(2:end),yu_(1:end-1),xu_(2:end),xu_(1:end-1)); dxu=[0; cumsum(dxu(:))];
  dxv = spheric_dist(yv_(2:end),yv_(1:end-1),xv_(2:end),xv_(1:end-1)); dxv=[0; cumsum(dxv(:))];
  X  = repmat(dx(:)', Noc,1);  X(2:end+1,:) =X;  X(1,:)= X(2,:);
  Xu = repmat(dxu(:)',Noc,1);  Xu(2:end+1,:)=Xu; Xu(1,:)=Xu(2,:);
  Xv = repmat(dxv(:)',Noc,1);  Xv(2:end+1,:)=Xv; Xv(1,:)=Xv(2,:);

  % 2d occam depth at new grid:
  Z  = repmat(doc,1,xi);   Z(2:end+1,:) =Z;  Z(1,:)=-10;
  Zu = repmat(doc,1,xi-1); Zu(2:end+1,:)=Zu; Zu(1,:)=-10;
  Zv = repmat(doc,1,xi);   Zv(2:end+1,:)=Zv; Zv(1,:)=-10;

  % interp to s-levels:
  xx  = repmat(dx(:)', N,1);
  xxu = repmat(dxu(:)',N,1);
  xxv = repmat(dxv(:)',N,1);
  zz  = squeeze(zr(i,:,:))';
  zzu = (zz(:,2:end)+zz(:,1:end-1))/2;
  zzv = zz;

  method='cubic';
  dens(:,i,:) = griddata(X-ddx, -Z, squeeze(DENS(:,i,:)),xx, zz,method);

  % extrap again due to nans near right margin, due to ddx:
  dens(:,i,:) = extrap2(xx,zz,  squeeze(dens(:,i,:)),nan,[10*rwd 1]);
end

if savename
  %save(savename,'dens')
  var2nc(savename,'dens',dens);
  if ~quiet
    fprintf(1,'  - dens saved in NetCDF file %s\n',savename);
  end
end
