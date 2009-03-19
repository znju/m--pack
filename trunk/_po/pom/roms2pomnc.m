function roms2pomnc(rclm,rfrc,den,grdtxt,ztxt)
%ROMS2POMNC   Create POM clm and frc files from ROMS
%
%   Syntax:
%      ROMS2POMNC(RCLM,RFRC,DEN,GRD,ZFILE)
%
%   Inputs:
%      RCLM   ROMS clm file
%      RFRC   ROMS frc file
%      DEN    POM RMEAN NetCDF file (eg see OCCAM2POM_DENS)
%      GRD    POM grid file (netcdf of text)
%      ZFILE  POM vertical coordinates text file
%
%   Comment:
%      Creates pom_clm_XXX.nc and pom_frc_XXX.nc, for XXX=001,...
%      to length of time dimension inside RCLM and RFRC
%
%   See also POM_NCCLM, POM_NCFRC, ROMS2POMBIN
%
%   MMA 02-09-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

quiet=0;
clm_tag='pom_clm_';
frc_tag='pom_frc_';

% --------------------------------------------------------------------
% Clm files:
% --------------------------------------------------------------------
time=use(rclm,'tclm_time');
for i=1:length(time)

  clm=sprintf('%s%03d.nc',clm_tag,i);

  % Create clm file:
  if ~quiet
    fprintf(1,'  -> Creating pom clm file %s\n',clm);
  end
  pom_ncclm(clm,grdtxt,ztxt,time(i));

  % Fill clm file:
  nc=netcdf(clm,'w');

  if ~quiet, disp('   adding temp...'); end
  v=use(rclm,'temp','tclm_time',i);  v(end+1,:,:)=v(end,:,:);
  nc{'temp'}(:)=v;

  if ~quiet, disp('   adding sal...'); end
  v=use(rclm,'salt','sclm_time',i);  v(end+1,:,:)=v(end,:,:);
  nc{'sal'}(:)=v;

  if ~quiet, disp('   adding ssh...'); end
  v=use(rclm,'zeta','zeta_time',i);
  nc{'ssh'}(:)=v;

  if ~quiet, disp('   adding u...'); end
  v=use(rclm,'u','uclm_time',i);  v(end+1,:,:)=v(end,:,:); v(:,:,2:end+1)=v;
  nc{'u'}(:)=v;

  if ~quiet, disp('   adding v...'); end
  v=use(rclm,'v','vclm_time',i);  v(end+1,:,:)=v(end,:,:); v(:,2:end+1,:)=v;
  nc{'v'}(:)=v;

  if ~quiet, disp('   adding rmean...'); end
  v=use(den,'dens'); v(end+1,:,:)=v(end,:,:);
  nc{'rmean'}(:)=(v-1000)/1000;

  close(nc);
end

% --------------------------------------------------------------------
% Clm mean:
% --------------------------------------------------------------------
clm='pom_clm_mean.nc';
if ~quiet
  fprintf(1,'  -> Creating pom clm mean file %s\n',clm);
end
pom_ncclm(clm,grdtxt,ztxt,0);
nc=netcdf(clm,'w');

if ~quiet, disp('   adding temp...'); end
v=use(rclm,'temp'); v=squeeze(mean(v)); v(end+1,:,:)=v(end,:,:);
 nc{'temp'}(:)=v;

if ~quiet, disp('   adding salt...'); end
v=use(rclm,'salt'); v=squeeze(mean(v)); v(end+1,:,:)=v(end,:,:);
nc{'sal'}(:)=v;

if ~quiet, disp('   adding ssh...'); end
v=use(rclm,'zeta'); v=squeeze(mean(v));
nc{'ssh'}(:)=v;

if ~quiet, disp('   adding u...'); end
v=use(rclm,'u'); v=squeeze(mean(v)); v(end+1,:,:)=v(end,:,:); v(:,:,2:end+1)=v;
nc{'u'}(:)=v;

if ~quiet, disp('   adding v...'); end
v=use(rclm,'v'); v=squeeze(mean(v)); v(end+1,:,:)=v(end,:,:); v(:,2:end+1,:)=v;
nc{'v'}(:)=v;

if ~quiet, disp('   adding rmean...'); end
v=use(den,'dens'); v(end+1,:,:)=v(end,:,:);
nc{'rmean'}(:)=(v-1000)/1000;


% --------------------------------------------------------------------
% Frc files:
% --------------------------------------------------------------------
time=use(rfrc,'sms_time');
for i=1:length(time)

  frc=sprintf('%s%03d.nc',frc_tag,i);

  % Create frc file:
  if ~quiet
    fprintf(1,'  -> Creating pom frc file %s\n',frc);
  end
  pom_ncfrc(frc,grdtxt,time(i));

  % Fill frc file:
  nc=netcdf(frc,'w');

  v=use(rfrc,'sustr','sms_time',i); v(:,2:end+1)=v;
  nc{'uwindstr'}(:)=-v/1025;

  v=use(rfrc,'svstr','sms_time',i); v(2:end+1,:)=v;
  nc{'vwindstr'}(:)=-v/1025;

  close(nc);
end
