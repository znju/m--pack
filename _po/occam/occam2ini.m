function occam2ini(fname,grd,ini,s_params,varargin)
%OCCAM2INI   Create and fill ROMS ini file from OCCAM file
%
%   Syntax:
%      OCCAM2INI(FNAME,GRID,INI,SPARAMS,VARARGIN)
%
%   Inputs:
%      FNAME   OCCAM file
%      GRID    ROMS/POM NetCDF grid file
%      INI     Name of the ini file to create (or just fill)
%      SPARAMS   S-coordinates parameters, [theta_s,theta_b,hc,n] for
%                ROMS and z,zz text file for POM
%      VARARGIN:
%         title, title for the ini file ('Roms ini file')
%         clobber, ini creation clobber option ('clobber')
%         time, time for the ini file (0)
%         newini, if 1, the ini file is created (1)
%         quiet, if 0 some messagens may be printed (default=0)
%         any other VARARGIN options of OCCAM2INI_VARS
%
%   Outputs:
%      None
%
%   Example:
%      occam   = 'jan.nc'
%      grd     = 'roms_grd.nc';
%      ini     = 'rom_ini.nc'
%      sparams = [4 0 10 50];
%      occam2ini(occam,grd,ini,sparams,'time',70);
%
%   See also OCCAM2INI_VARS, SHELF_BREAK_DIFF, OCCAM2CLM
%
%   MMA 20-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

title   = 'Roms ini file';
clobber = 'clobber';
time    = 0;
newini  = 1;
quiet   = 0;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'title'),    title   = vin{i+1};
  elseif isequal(vin{i},'clobber'),  clobber = vin{i+1};
  elseif isequal(vin{i},'time'),     time    = vin{i+1};
  elseif isequal(vin{i},'newini'),   newini  = vin{i+1};
  elseif isequal(vin{i},'quiet'),    quiet   = vin{i+1};
  end
end

if isstr(s_params)
  N=pom_s_levels(s_params);
  theta_s=0;
  theta_b=0;
  hc=0;
else
  [theta_s,theta_b,hc,N]=unpack(s_params);
end

% create ini file:
if newini
  create_inifile(ini,grd,title,theta_s,theta_b,hc,N,time,clobber)
end

% extract data from occam:
[temp,salt,velu,velv,ssh] = occam2ini_vars(fname,grd,s_params,varargin{:});

% calc ubar and vbar:
if ~quiet
  fprintf(1,'  > calc ubar and vbar\n');
end
[ubar,vbar]=roms_uvbar(velu,velv,ssh,grd,s_params);

% fill ini file:
if ~quiet
  fprintf(1,'  > filling ini file\n');
end
nc=netcdf(ini,'w');
nc{'temp'}(:) = temp;
nc{'salt'}(:) = salt;
nc{'u'}(:)    = velu;
nc{'v'}(:)    = velv;
nc{'ubar'}(:) = ubar;
nc{'vbar'}(:) = vbar;
nc{'zeta'}(:) = ssh;
close(nc)
