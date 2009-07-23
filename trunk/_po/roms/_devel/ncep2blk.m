function ncep2blk(Y,yref,grd,path,blk_tag,gen_blk)

if nargin < 6
  gen_blk=1
end
if nargin < 5
  blk_tag='roms_blk_rot';
end

% yref time to remove:
trm=julian(yref,1,1)-julian(1800,1,1);

fair = 'air.2m.gauss.'   ;
fskt = 'skt.sfc.gauss.'  ;
frh  = 'shum.2m.gauss.'  ;
fpr  = 'prate.sfc.gauss.';
fdsw = 'dswrf.sfc.gauss.';
fusw = 'uswrf.sfc.gauss.';
flw  = 'dlwrf.sfc.gauss.';
fu10 = 'uwnd.10m.gauss.' ;
fv10 = 'vwnd.10m.gauss.' ;
fprs = 'pres.sfc.gauss.' ;

Fgrid=[path 'land.sfc.gauss.nc'];

% process interp coefs:
lon1=use(Fgrid,'lon'); lon1(lon1>180)=lon1(lon1>180)-360;
lat1=use(Fgrid,'lat');
[lon1,lat1]=meshgrid(lon1,lat1);
[lon2r,lat2r]=roms_grid(grd,'r'); S=size(lon2r);

[I,J,W] = interp_coefs(lon1,lat1,lon2r,lat2r);

I1=I(1,:,:); I2=I(2,:,:); I3=I(3,:,:); I4=I(4,:,:);
J1=J(1,:,:); J2=J(2,:,:); J3=J(3,:,:); J4=J(4,:,:);
W1=W(1,:,:); W2=W(2,:,:); W3=W(3,:,:); W4=W(4,:,:);

I1=I1(:); I2=I2(:); I3=I3(:); I4=I4(:);
J1=J1(:); J2=J2(:); J3=J3(:); J4=J4(:);
W1=W1(:); W2=W2(:); W3=W3(:); W4=W4(:);

IJ1=sub2ind(size(lon1),I1,J1);
IJ2=sub2ind(size(lon1),I2,J2);
IJ3=sub2ind(size(lon1),I3,J3);
IJ4=sub2ind(size(lon1),I4,J4);

w=squeeze(sum(W)); w=w(:); % = W1+W2+W3+W4

% load grid angle, to rotate wind currents and stress:
angle=use(grd,'angle');

for i=1:length(Y)
  year=Y(i);
  syear=num2str(year);

  nydays=julianmd(year,12,31,24)-julian(year,1,1,0);
  bulkc=nydays;

  % input ncep2 filenames:
  Fair = [path syear filesep fair syear,'.nc']; % T air 2m [C]
  Fskt = [path syear filesep fskt syear,'.nc']; % skt for Lw calculation
  Frh  = [path syear filesep frh  syear,'.nc']; % R humidity 2m [%]
  Fpr  = [path syear filesep fpr  syear,'.nc']; % P rate [kg/m^2/s]
  Fdsw = [path syear filesep fdsw syear,'.nc']; % Downward shortwave flux  [W/m^2]
  Fusw = [path syear filesep fusw syear,'.nc']; % Upward shortwave flux  [W/m^2]
  Flw  = [path syear filesep flw  syear,'.nc']; % Net outgoing Longwave flux  [W/m^2]
  Fu10 = [path syear filesep fu10 syear,'.nc']; % U wind speed 10m
  Fv10 = [path syear filesep fv10 syear,'.nc']; % V wind speed 10m
  Fprs = [path syear filesep fprs syear,'.nc']; % surface pressure

  % get bulk time:
  bulkt=use(Fair,'time')/24 -trm;

  blkname = [blk_tag '_' syear '.nc'];
  if gen_blk
    title   = ['NCEP blk file year' syear];
    if gen_blk==1 || (gen_blk==2 && ~exist(blkname))
      create_bulk(blkname,grd,title,bulkt,bulkc)
    elseif gen_blk==2 && exist(blkname)
      fprintf(1,'file exists, not creating new, %s\n',blkname);
    end
  end

  % load full vars:
  fprintf(1,'loading vars (10) year %d\n',year);
  fprintf(1,' air'   ); AIR   = use(Fair,'air'  );
  fprintf(1,' skt'   ); SKT   = use(Fskt,'skt'  );
  fprintf(1,' shum'  ); SHUM  = use(Frh, 'shum' );
  fprintf(1,' prate' ); PRATE = use(Fpr, 'prate');
  fprintf(1,' dswrf' ); DSWRF = use(Fdsw,'dswrf');
  fprintf(1,' uswrf' ); USWRF = use(Fusw,'uswrf');
  fprintf(1,' dlwrf' ); DLWRF = use(Flw, 'dlwrf');
  fprintf(1,' uwnd'  ); UWND  = use(Fu10,'uwnd' );
  fprintf(1,' vwnd'  ); VWND  = use(Fv10,'vwnd' );
  fprintf(1,' pres\n'); PRES  = use(Fprs,'pres' );

  for t=1:length(bulkt)
    fprintf(1,'time %6.2f  %d of %d ',bulkt(t),t,length(bulkt));
    % T air 2m [C]
    %v=use(Fair,'air','time',t)-273.15; % convert to celcius
    v=squeeze(AIR(t,:,:))-273.15;
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    tair=reshape(v,S);

    % skt for Lw calculation
    %v=use(Fskt,'skt','time',t)-273.15; % convert to celcius
    v=squeeze(SKT(t,:,:))-273.15;
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    skt=reshape(v,S);

    % R humidity 2m [%]
    %v=use(Frh,'shum','time',t);
    v=squeeze(SHUM(t,:,:));
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    shum=reshape(v,S);
    rhum = shum./qsat(tair);
    rhum(rhum>1.)=1.;

    % P rate [kg/m^2/s]
    %v=use(Fpr,'prate','time',t) * 0.1 * (24*60*60.0);  %convert [kg/m^2/s] to cm/day
    v=squeeze(PRATE(t,:,:)) * 0.1 * (24*60*60.0);
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    prate=reshape(v,S);
    prate(abs(prate)<1.e-4)=0;

    % Shortwave flux [W/m^2]
    % Downward:
    %dswrf=use(Fdsw,'dswrf','time',t);
    dswrf=squeeze(DSWRF(t,:,:));
    dswrf(dswrf<1.e-10)=0;
    % Upward:
    %uswrf=use(Fusw,'uswrf','time',t);
    uswrf=squeeze(USWRF(t,:,:));
    uswrf(uswrf<1.e-10)=0;
    % Net:
    v=dswrf-uswrf;
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    nswrs=reshape(v,S);

    % Longwave flux  [W/m^2]
    % Downward:
    %v=use(Flw,'dlwrf','time',t);
    v=squeeze(DLWRF(t,:,:));
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    dlwrf=-reshape(v,S);
    % Net:
    nlwf  = -lwhf(skt,-dlwrf);
    nlwf(nlwf<1.e-10)=0;

    % U wind speed 10 m
    %v=use(Fu10,'uwnd','time',t);
    v=squeeze(UWND(t,:,:));
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    uwnd=reshape(v,S);

    % V wind speed 10 m
    %v=use(Fv10,'vwnd','time',t);
    v=squeeze(VWND(t,:,:));
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    vwnd=reshape(v,S);

    % Surface stress
    speed = sqrt(uwnd.^2+vwnd.^2);
    [Cd, u10m]=cdnlp(speed, 10.);
    rhoa=air_dens(tair,rhum*100.0);
    taux = Cd.*rhoa.*uwnd.*speed;
    tauy = Cd.*rhoa.*vwnd.*speed;

    % Rotate with grid angle:
    uwnd =  uwnd.*cos(angle) + vwnd.*sin(angle);
    vwnd = -uwnd.*sin(angle) + vwnd.*cos(angle);
    taux =  taux.*cos(angle) + tauy.*sin(angle);
    tauy = -taux.*sin(angle) + tauy.*cos(angle);

    % uv stress to uv points:
    taux=rho2u_2d(taux);
    tauy=rho2v_2d(tauy);

    % Surface pressure
    %v=use(Fprs,'pres','time',t);
    v=squeeze(PRES(t,:,:));
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    pres=reshape(v,S);


    % Fill BLK:
    fprintf(1,'   -- filling nc\n');
    nc=netcdf(blkname,'w');
      nc{'tair' }(t,:,:) = tair;
      nc{'rhum' }(t,:,:) = rhum;
      nc{'prate'}(t,:,:) = prate;
      nc{'radsw'}(t,:,:) = nswrs;
      nc{'radlw'}(t,:,:) = nlwf;
      nc{'dlwrf'}(t,:,:) = dlwrf;
      nc{'uwnd' }(t,:,:) = uwnd;
      nc{'vwnd' }(t,:,:) = vwnd;
      nc{'wspd' }(t,:,:) = speed;
      nc{'sustr'}(t,:,:) = taux;
      nc{'svstr'}(t,:,:) = tauy;
      nc{'pres' }(t,:,:) = pres;
    close(nc)
  end
  fprintf(1,'   -- file %s done\n',blkname);
end
