function gen_ini(src,ini,tinit)
%GEN_INI   Create ROMS ini file
%   The ini file is created from a source file, his or avg.
%
%   Syntax:
%      GEN_INI(SRC,INI,TINI)
%
%   Inputs:
%      SRC   Source file (his or avg)
%      INI   File to be created
%      TINI  Ini time [y m d h mm sec]
%
%   Example:
%      gen_ini('roms_his.nc','roms_ini.nc',[2005 11 1 0 0 0])
%
%   MMA 27-6-2006, martinho@fis.ua.pt
%
%   See also CREATE_NESTEDINITIAL

% Department of Physics
% University of Aveiro, Portugal

if nargin <3
  disp(':: Error : arguments required')
  return
end

% find time: ---------------------------------------------------------
dia = julianmd(tinit) - julianmd([tinit(1) 1 1 0 0 0]);
srctime = use(src,'scrum_time')/86400;
t1=find(srctime<dia); t1=t1(end);
time=srctime(t1);

% create ini NetCDF file: --------------------------------------------
gridfile   = src;
parentfile = src;
title=n_fileatt(src,'title');
[theta_s,theta_b,hc,N]=s_params(src);
Tcline=hc;
clobber='clobber';

create_nestedinitial(ini,gridfile,parentfile,title,theta_s,theta_b,Tcline,N,time,clobber);

% show time index to extract: ----------------------------------------
disp([':: tinit = ',datestr(tinit)])
y=tinit(1);
tnum=datenum(greg2(time,y));
mmm=datestr(tnum,'mmm');
dd=datestr(tnum,'dd');
mmdd=[dd,'-',mmm];
disp([':: created ini file ',ini,' at time ',num2str(t1),' = ',mmdd])

% fill ---------------------------------------------------------------
disp(':: filling vars...')
nc = netcdf(ini,'w');
  nc{'scrum_time'}(:) = time*86400;
  nc{'tstart'}(:)     = time;
  nc{'tend'}(:)       = time;
  nc{'u'}(:)      = use(src,'u','time',t1);
  nc{'v'}(:)      = use(src,'v','time',t1);
  nc{'ubar'}(:)   = use(src,'ubar','time',t1);
  nc{'vbar'}(:)   = use(src,'vbar','time',t1);
  nc{'zeta'}(:)   = use(src,'zeta','time',t1);
  nc{'temp'}(:)   = use(src,'temp','time',t1);
  nc{'salt'}(:)   = use(src,'salt','time',t1);
close(nc);
disp(':: done.')
