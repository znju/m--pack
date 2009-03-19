function wind_ncep2pom(fu,fv,frc,grd,varargin)
%WIND_NCEP2POM   Interp ncep wind to pom grid
%
%   Syntax:
%      WIND_NCEP2POM(FU,FV,FRC,GRD,VARARGIN)
%
%   Inputs:
%      FU,FV   NCEP wind files (with vars uwnd and vwnd)
%      FRC     NetCDF file to create (with POM_NCWINDFRC)
%      GRD     POM grid file
%      VARARGIN:
%         times, time dim to use from NCEP, default=':'
%         stress, if 1 wind is converted to stress, default=0
%         rot, if 1 wind is rotated with grid angle, default=0
%         rho, if 1 wind is at center of cells, else u and v are at
%            grid u and v points, default=0
%
%   See also POM_NCWINDFRC
%
%   MMA 08-10-2008, mma@odyle.net

ncep_times=':';
useStress=0; % converter ou nao m/s para wind stress
rotWind = 0; % rodar para grelha
uvAtRho = 0;  % if 1, as variaveis u e v serao interpoladas para o centro da celula
             % e n para os pontos u e v.

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'times'),      ncep_times = vin{i+1};
  elseif isequal(vin{i},'stress'), useStress  = vin{i+1};
  elseif isequal(vin{i},'rot'),    rotWind    = vin{i+1};
  elseif isequal(vin{i},'rho'),    uvAtRho    = vin{i+1};
  end
end


if n_varexist(grd,'lon') & n_varexist(grd,'lat')
  x=use(grd,'lon');
  y=use(grd,'lat');
else
  [x,y,h] = pom_grid(grd,'r');
end
[eta,xi]=size(x);

lonu=use(fu,'lon'); lonu(lonu>180)=lonu(lonu>180)-360;
latu=use(fu,'lat');
[lonu,latu]=meshgrid(lonu,latu);
uwnd=use(fu,'uwnd','time',ncep_times);

lonv=use(fv,'lon'); lonv(lonv>180)=lonv(lonv>180)-360;
latv=use(fv,'lat');
[lonv,latv]=meshgrid(lonv,latv);
vwnd=use(fv,'vwnd','time',ncep_times);

if isequal(ncep_times,':')
  times=n_filedim(fu,'time');
else
  times=length(eval(ncep_times));
end

U=zeros([times eta xi]);
V=zeros([times eta xi]);

% interp:
for i=1:times
  if mod(i,100)==0
    fprintf(1,'griddata u,v %d of %d\n',i,times);
  end
  U(i,:,:)=griddata(lonu,latu,squeeze(uwnd(i,:,:)),x,y);
  V(i,:,:)=griddata(lonv,latv,squeeze(vwnd(i,:,:)),x,y);
end

% rot to grid ang:
if rotWind
  ang=use(grd,'angle')*180/pi;
  for i=1:times
    if mod(i,100)==0
      fprintf(1,'rot u,v %d of %d\n',i,size(vwnd,1));
    end
    [U(i,:,:),V(i,:,:)] = rot2d(squeeze(U(i,:,:)),squeeze(V(i,:,:)),-ang);
  end
end

% convert to stress:
if useStress
  [U,V]=wind_stress(U,V);
end

if ~uvAtRho
  % from rho points to u,v:
  U=(U(:,:,1:end-1)+U(:,:,2:end))/2;
  V=(V(:,1:end-1,:)+V(:,2:end,:))/2;

  % add u,v ij mask for pom:
  U(:,:,2:end+1)=U;
  V(:,2:end+1,:)=V;
end

% create forcing file:
time=use(fu,'time','time',ncep_times);
pom_ncwindfrc(frc,grd,time);

% fill frc:
nc=netcdf(frc,'w');
nc{'UVENTO'}(:)=U;
nc{'VVENTO'}(:)=V;
close(nc);

