function occam2clm(files,grd,clm,s_params,time,varargin)
%OCCAM2CLM   Create and fill ROMS clm file from OCCAM files
%
%   Syntax:
%      OCCAM2CLM(FILES,GRID,CLM,SPARAMS,TIME,VARARGIN)
%
%   Inputs:
%      FNAME   OCCAM files (cell array)
%      GRID    ROMS/POM NetCDF grid file
%      CLM     Name of the clm file to create (or just fill)
%      SPARAMS   S-coordinates parameters, [theta_s,theta_b,hc,n] for
%                ROMS and z,zz text file for POM
%      TIME    Climatology time
%
%      VARARGIN:
%         title, title for the clm file ('Roms clm file')
%         clobber, clm creation clobber option ('clobber')
%         cycle, clm time cycle (365)
%         newclm, if 1, the clm file is created (1)
%         quiet, if 0 some messagens may be printed (default=0)
%         i1, start index of clm file (1)
%         any other VARARGIN options of OCCAM2INI_VARS
%
%   Outputs:
%      None
%
%   Example:
%      ocfiles = {'jan.nc','feb.nc','mar.nc'};
%      grd     = 'roms_grd.nc';
%      clm     = 'rom_clm.nc'
%      sparams = [4 0 10 50];
%      occam2clm(ocfiles,grd,clm,sparams,[15 45 60]);
%
%   See also OCCAM2INI_VARS, SHELF_BREAK_DIFF, OCCAM2INI
%
%   MMA 20-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

title   = 'Roms clm file';
clobber = 'clobber';
cycle   = 365;
newclm  = 1;
i1      = 1;
quiet   = 0;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'title'),    tit     = vin{i+1};
  elseif isequal(vin{i},'clobber'),  clobber = vin{i+1};
  elseif isequal(vin{i},'cycle'),    cycle   = vin{i+1};
  elseif isequal(vin{i},'quiet'),    quiet   = vin{i+1};
  elseif isequal(vin{i},'newclm'),   newclm  = vin{i+1};
  elseif isequal(vin{i},'i1'),       i1      = vin{i+1};
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

% create clm file:
if newclm
  if ~quiet
    fprintf(1,'  > creating clm file %s\n',clm)
  end
  create_climfile(clm,grd,title,theta_s,theta_b,hc,N,time,cycle,clobber);
end

% extract data from occam:
for i=1:length(files)
  j=i1+i-1;

  fname=files{i};
  if ~quiet
    fprintf(1,'  > extracting data from occam, file %d of %d - %s\n',i,length(files),basename(fname))
  end
  [temp,salt,velu,velv,ssh] = occam2ini_vars(fname,grd,s_params,varargin{:});

  % calc ubar and vbar:
  [ubar,vbar]=roms_uvbar(velu,velv,ssh,grd,s_params);

  % fill clm file:
  if ~quiet
    fprintf(1,'  > filling clm file t=%d\n',j);
  end
  nc=netcdf(clm,'w');
  nc{'temp'}(j,:,:,:) = temp;
  nc{'salt'}(j,:,:,:) = salt;
  nc{'u'}(j,:,:,:)    = velu;
  nc{'v'}(j,:,:,:)    = velv;
  nc{'ubar'}(j,:,:)   = ubar;
  nc{'vbar'}(j,:,:)   = vbar;
  nc{'zeta'}(j,:,:)    = ssh;
  close(nc)
end
