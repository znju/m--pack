function roms2pombin(grd,ini,clm,frc,den,varargin)
%ROMS2POM_BIN   Create POM input binary files from ROMS input files
%
%   Syntax:
%      ROMS2POMBIN(GRID,INI,CLM,FRC,DENS,VARARGIN)
%
%   Inputs:
%      GRID   ROMS NetCDF grid file
%      INI    ROMS initial file
%      CLM    ROMS climatology file
%      FRC    ROMS forcing file (only wind stress needed)
%      DEN    NetCDF file with POM density (in variable dens)
%      VARARGIN:
%         precision, fwrite precision, default=float32
%         base, base folder where files will be saved (base is
%               created if needed), default='pom_in'
%         ts, folder for temp and salt files, default='ints'
%         uv, folder for u and v files, default='inuv'
%         ssh, folder for ssh files, default='inssh'
%         wind, folder for wind stress files, default='inwind'
%         rho, folder for mean desnsity file, default='inrho'
%
%   Example:
%      grd  = 'roms_grid.nc';
%      ini  = 'roms_ini.nc';
%      clm  = 'roms_clm.nc';
%      frc  = 'roms_frc.nc';
%      dens = 'pom_density.nc';
%      basefolder = 'my_pom_inputs'
%      roms2pombin(grd,ini,clm,frc,dens,'base',basefolder)
%
%   MMA 27-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

precision='float32';

baseFolder  = 'pom_in';
folder_ts   = 'ints';
folder_uv   = 'inuv';
folder_ssh  = 'inssh';
folder_wind = 'inwind';
folder_rho  = 'inrho';
%quiet = 0;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'precision'),    precision   = vin{i+1};
  elseif isequal(vin{i},'base'),         baseFolder  = vin{i+1};
  elseif isequal(vin{i},'ts'),           folder_ts   = vin{i+1};
  elseif isequal(vin{i},'uv'),           folder_uv   = vin{i+1};
  elseif isequal(vin{i},'ssh'),          folder_ssh  = vin{i+1};
  elseif isequal(vin{i},'wind'),         folder_wind = vin{i+1};
  elseif isequal(vin{i},'rho'),          folder_rho  = vin{i+1};
%  elseif isequal(vin{i},'quiet'),        quiet       = vin{i+1};
end

% create folders:
fprintf(1,'Putting contents inside %s\n',fname,baseFolder);
folders={folder_ts,folder_uv,folder_ssh,folder_wind,folder_rho}
if exist(baseFolder)~=7
  [success,msg]=mkdir(baseFolder);
  if ~success
    disp(msg)
    return
  end
  for i=1:length(folders)
    folder=[baseFolder filesep folders{i}];
    if exist(folder)~=7
      mkdir(folder)
    end
  end
end

% TEMP SALT ----------------------------------------------------------
% 1st temp, 2nd salt
% dims: xi eta zz
% zz(end)=bottom mask
% names: TANDS_01.bin, TANDS_02.bin, ...

T = n_dim(clm,'tclm_time');
L = n_dim(clm,'xi_rho');
M = n_dim(clm,'eta_rho');
K = n_dim(clm,'s_rho');

for i=1:T
  folder=[baseFolder filesep folder_ts filesep];
  fname=sprintf('%sTANDS_%02g.bin',folder,i);
  fid=fopen(fname,'w');

  v=use(clm,'temp','tclm_time',i);  v(end+1,:,:)=v(end,:,:); v=permute(v,[3 2 1]);
  fwrite(fid,v,precision);

  v=use(clm,'salt','sclm_time',i);  v(end+1,:,:)=v(end,:,:); v=permute(v,[3 2 1]);
  fwrite(fid,v,precision);

  fprintf(1,'Created %s as %s\n',fname,precision);
  fclose(fid);
end


% U V ----------------------------------------------------------------
% 1st u, 2nd v
% dims: xi eta zz
% zz(end)=bottom mask
% u(i=1)=u(i=2)
% v(j=1)=v(j=2)
% names: UANDV_01.bin, UANDV_02.bin, ...

for i=1:T
  folder=[baseFolder filesep folder_uv filesep];
  fname=sprintf('%sUANDV_%02g.bin',folder,i);
  fid=fopen(fname,'w');

  v=use(clm,'u','uclm_time',i);  v(end+1,:,:)=v(end,:,:); v=permute(v,[3 2 1]);
  v(2:end+1,:,:)=v;
  fwrite(fid,v,precision);

  v=use(clm,'v','vclm_time',i);  v(end+1,:,:)=v(end,:,:); v=permute(v,[3 2 1]);
  v(:,2:end+1,:)=v;
  fwrite(fid,v,precision);

  fprintf(1,'Created %s as %s\n',fname,precision);
  fclose(fid);
end


% SSH ----------------------------------------------------------------
% dims: xi eta
% names: ETA2D_01.bin,  ETA2D_02.bin, ...

for i=1:T
  folder=[baseFolder filesep folder_ssh filesep];
  fname=sprintf('%sETA2D_%02g.bin',folder,i);
  fid=fopen(fname,'w');

  v=use(clm,'zeta','zeta_time',i);  v=permute(v,[2 1]);
  fwrite(fid,v,precision);

  fprintf(1,'Created %s as %s\n',fname,precision);
  fclose(fid);
end


% Wind stress/rho ----------------------------------------------------
% dims: xi eta
% u(i=1)=u(i=2)
% v(j=1)=v(j=2)
% names: WUV_01.bin, WUV_02.bin, ...
% units: m2/s2, ie, WUSURF=-TAUX/1025; WVSURF=-TAUY/1025

for i=1:T
  folder=[baseFolder filesep folder_wind filesep];
  fname=sprintf('%sWUV_%02g.bin',folder,i);
  fid=fopen(fname,'w');

  v=use(frc,'sustr','sms_time',i);  v=permute(v,[2 1]);
  v(2:end+1,:)=v; v(1,:)=v(2,:);
  v=-v/1025;
  fwrite(fid,v,precision);

  v=use(frc,'svstr','sms_time',i);  v=permute(v,[2 1]);
  v(:,2:end+1)=v; v(:,1)=v(:,2);
  v=-v/1025;
  fwrite(fid,v,precision);

  fprintf(1,'Created %s as %s\n',fname,precision);
  fclose(fid);
end

% Density: -----------------------------------------------------------
% dims: xi eta zz
dens=use(den,'dens');
dens(end+1,:,:)=dens(end,:,:);

folder=[baseFolder filesep folder_rho filesep];
fname=sprintf('%srmean.bin',folder);
fname='rmean.bin';
fid=fopen(fname,'w');
fwrite(fid,dens,precision);
fclose(fid);
fprintf(1,'Created %s as %s\n',fname,precision);
