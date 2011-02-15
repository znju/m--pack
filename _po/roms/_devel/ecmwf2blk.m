function ecmwf2blk(Y,yref,grd,path,blk_tag,gen_blk)

if nargin < 6
  gen_blk=1
end
if nargin < 5
  blk_tag='roms_ecmwf_blk';
end

% yref time to remove:
trm=julian(yref,1,1)-julian(1900,1,1);


fair = 't2m'     ;
fprs = 'msl'     ;
fu10 = 'u10_v10' ;
fv10 = 'u10_v10' ;
fnsr = 'ssr'     ;
fnlw = 'lwnet'   ;
fpr  = 'tp'      ;
fdew = 'd2m';

Fgrid=[path num2str(Y(1)) filesep fair '.nc'];

% process interp coefs:
lon1=use(Fgrid,'longitude'); lon1(lon1>180)=lon1(lon1>180)-360;
lat1=use(Fgrid,'latitude');
[lon1,lat1]=meshgrid(lon1,lat1);
[lon2r,lat2r]=roms_grid(grd,'r'); S=size(lon2r);

if ~exist('tmpInterpCoef.mat','file')
[I,J,W] = interp_coefs(lon1,lat1,lon2r,lat2r);
  save tmpInterpCoef I J W
  return
else
  load tmpInterpCoef
end

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
  Fair = [path syear filesep fair,'.nc']; % T air 2m [K]
  Fprs = [path syear filesep fprs,'.nc']; % surface pressure [Pa]
  Fu10 = [path syear filesep fu10,'.nc']; % U wind speed 10m
  Fv10 = [path syear filesep fv10,'.nc']; % V wind speed 10m
  Fnsr = [path syear filesep fnsr,'.nc']; % Net solar radiation [W/(m^2 s)]
  Fnlw = [path syear filesep fnlw,'.nc']; % Net lonng wave [W/(m^2 s)]
  Fpr  = [path syear filesep fpr ,'.nc']; % Total precipitation [m]
  Fdew = [path syear filesep fdew,'.nc']; % dewpoint for relative humidity [K]


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
  fprintf(1,' air'   ); AIR   = use(Fair,'t2m'  );
  fprintf(1,' pres'); PRES  = use(Fprs,'msl' );
  fprintf(1,' uwnd'  ); UWND  = use(Fu10,'u10' );
  fprintf(1,' vwnd'  ); VWND  = use(Fv10,'v10' );
  fprintf(1,' radsw' ); SWRF  = use(Fnsr,'ssr');
    fprintf(1,'dt radsw' ); SW_DTHOURS=diff(use(Fnsr,'time','time','1:2'));
    fprintf(1,'=%d',SW_DTHOURS );
  fprintf(1,' dlwrf' ); DLWRF = use(Fnlw,'str');;
    fprintf(1,'dt radlw' ); LW_DTHOURS=diff(use(Fnlw,'time','time','1:2'));
    fprintf(1,'=%d',LW_DTHOURS );
  fprintf(1,' prate' ); PRATE = use(Fpr, 'tp');
    fprintf(1,'dt prate' ); PR_DTHOURS=diff(use(Fpr,'time','time','1:2'));
    fprintf(1,'=%d',PR_DTHOURS );
  fprintf(1,' dew (rhum)'   ); DEW   = use(Fdew,'d2m'  );


  for t=1:length(bulkt)
    fprintf(1,'time %6.2f  %d of %d ',bulkt(t),t,length(bulkt));

    % T air 2m [C]
    v=squeeze(AIR(t,:,:))-273.15;
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    tair=reshape(v,S);

    % Surface pressure [Pa]
    v=squeeze(PRES(t,:,:));
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    pres=reshape(v,S);


    % Net shortwave flux [W/m^2]
    v=squeeze(SWRF(t,:,:))*3600*SW_DTHOURS;
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    nswrs=reshape(v,S);

    % Longwave flux  ... not using
    v=squeeze(DLWRF(t,:,:))*3600*LW_DTHOURS;
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    nlwf=reshape(v,S);
    % downward: not used by model
    dlwrf=-99999*nlwf;

    % P rate [cm/day][kg/m^2/s]
    v=squeeze(PRATE(t,:,:))*100*24/PR_DTHOURS; % m --> cm/day
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    prate=reshape(v,S);
    prate(abs(prate)<1.e-4)=0;

    % R humidity 2m [%]
    % [(112-0.1T+Td)/(112+0.9T)]^8, T, Td in Celsius
    v=squeeze(DEW(t,:,:))-273.15;
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    Td=reshape(v,S);
    T=tair;
    rhum=((112-0.1*T+Td)./(112+0.9*T)).^8;

    % U wind speed 10 m
    v=squeeze(UWND(t,:,:));
    v=( v(IJ1).*W1 + v(IJ2).*W2 + v(IJ3).*W3 + v(IJ4).*W4)./w;
    uwnd=reshape(v,S);

    % V wind speed 10 m
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
    Uwnd =  uwnd.*cos(angle) + vwnd.*sin(angle);
    Vwnd = -uwnd.*sin(angle) + vwnd.*cos(angle);
    Taux =  taux.*cos(angle) + tauy.*sin(angle);
    Tauy = -taux.*sin(angle) + tauy.*cos(angle);

    % uv stress to uv points:
    Taux=rho2u_2d(Taux);
    Tauy=rho2v_2d(Tauy);


    % Fill BLK:
    fprintf(1,'   -- filling nc\n');
    nc=netcdf(blkname,'w');
      nc{'tair' }(t,:,:) = tair;
      nc{'rhum' }(t,:,:) = rhum;
      nc{'prate'}(t,:,:) = prate;
      nc{'radsw'}(t,:,:) = nswrs;
      nc{'radlw'}(t,:,:) = nlwf;
      nc{'dlwrf'}(t,:,:) = dlwrf;
      nc{'uwnd' }(t,:,:) = Uwnd;
      nc{'vwnd' }(t,:,:) = Vwnd;
      nc{'wspd' }(t,:,:) = speed;
      nc{'sustr'}(t,:,:) = Taux;
      nc{'svstr'}(t,:,:) = Tauy;
      nc{'pres' }(t,:,:) = pres;
    close(nc)
  end
  fprintf(1,'   -- file %s done\n',blkname);
end
