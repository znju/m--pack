function flux_ncep2pom(files,frc,grd,varargin)
%FLUX_NCEP2POM   Interp ncep flux data to pom grid
%
%   Syntax:
%      FLUX_NCEP2POM(FILES,FRC,GRD,VARARGIN)
%
%   Inputs:
%      FILES   NCEP flux files {SW,LW,LA,SE}, ie, cell with the
%              files for short wave, long wave, latent and sensible
%              net fluxes
%      FRC     NetCDF file to create (with POM_NFLUX)
%      GRD     POM grid file
%      VARARGIN:
%         times, time dim to use from NCEP, default=':'
%
%   See also POM_NCFLUX
%
%   MMA 23-10-2008, mma@odyle.net

ncep_times=':';

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'times'),      ncep_times = vin{i+1};
  end
end

if n_varexist(grd,'lon') & n_varexist(grd,'lat')
  x=use(grd,'lon');
  y=use(grd,'lat');
else
  [x,y,h] = pom_grid(grd,'r');
end
[eta,xi]=size(x);

fSW=files{1};
fLW=files{2};
fLA=files{3};
fSE=files{4};

% short wave:
lon=use(fSW,'lon'); lon(lon>180)=lon(lon>180)-360;
lat=use(fSW,'lat');
[lon_sw,lat_sw]=meshgrid(lon,lat);
sw=use(fSW,'nswrs','time',ncep_times);

% long wave:
lon=use(fLW,'lon'); lon(lon>180)=lon(lon>180)-360;
lat=use(fLW,'lat');
[lon_lw,lat_lw]=meshgrid(lon,lat);
lw=use(fLW,'nlwrs','time',ncep_times);

% latent:
lon=use(fLA,'lon'); lon(lon>180)=lon(lon>180)-360;
lat=use(fLA,'lat');
[lon_la,lat_la]=meshgrid(lon,lat);
la=use(fLA,'lhtfl','time',ncep_times);

% sensible:
lon=use(fSE,'lon'); lon(lon>180)=lon(lon>180)-360;
lat=use(fSE,'lat');
[lon_se,lat_se]=meshgrid(lon,lat);
se=use(fSE,'shtfl','time',ncep_times);

if isequal(ncep_times,':')
  times=n_filedim(fSW,'time');
else
  times=length(eval(ncep_times));
end

SW=zeros([times eta xi]);
LW=zeros([times eta xi]);
LA=zeros([times eta xi]);
SE=zeros([times eta xi]);

% interp:
for i=1:times
  if mod(i,100)==0
    fprintf(1,'griddata fluxes %d of %d\n',i,times);
  end
  SW(i,:,:)=griddata(lon_sw,lat_sw,squeeze(sw(i,:,:)),x,y);
  LW(i,:,:)=griddata(lon_lw,lat_lw,squeeze(lw(i,:,:)),x,y);
  LA(i,:,:)=griddata(lon_la,lat_la,squeeze(la(i,:,:)),x,y);
  SE(i,:,:)=griddata(lon_se,lat_se,squeeze(se(i,:,:)),x,y);
end

% create forcing file:
time=use(fSW,'time','time',ncep_times);
time=(time-time(1))/24;

pom_ncflux(frc,grd,time);

% fill frc:
nc=netcdf(frc,'w');
nc{'shortwave'}(:)=SW;
nc{'longwave'}(:) = LW;
nc{'latente'}(:)  = LA;
nc{'sensivel'}(:) = SE;
close(nc);
