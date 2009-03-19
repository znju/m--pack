function roms_clm2ini(clm,ini,time,varargin)
%ROMS_CLM2INI   Create ROMS ini file from clm file
%
%   Syntax:
%      ROMS_CLM2INI(CLM,INI,TIME,VARARGIN)
%
%   Inputs:
%      CLM   Climatology file
%      INI   Name of the ini file to create (or just fill)
%      TIME  Initial time
%      VARARGIN:
%         title, title for the ini file ('Roms ini file')
%         clobber, ini creation clobber option ('clobber')
%         newini, if 1, the ini file is created (1)
%         quiet, if 0 some messagens may be printed (default=0)
%         grid, Name of the ROMS grid
%
%   See also CYCLIC_INDEX
%
%   MMA 30-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

title   = 'Roms ini file';
clobber = 'clobber';
newini  = 1;
quiet   = 0;
grd     = n_fileatt(clm,'grd_file');

vin=varargin;
for i=1:length(vin)
 if     isequal(vin{i},'title'),    title    = vin{i+1};
  elseif isequal(vin{i},'clobber'),  clobber = vin{i+1};
  elseif isequal(vin{i},'newini'),   newini  = vin{i+1};
  elseif isequal(vin{i},'grid'),     grd     = vin{i+1};
  elseif isequal(vin{i},'quiet'),    quiet   = vin{i+1};
  end
end

% create ini file:
if newini
  if ~quiet
    fprintf(1,' -- creating ini file %s\n',ini);
  end
  [theta_s,theta_b,hc,N]=s_params(clm);
  create_inifile(ini,grd,title,theta_s,theta_b,hc,N,time,clobber)
end

vars={'temp',     'salt',     'u',        'v',        'ubar',     'vbar',     'zeta'     };
ts  ={'tclm_time','sclm_time','uclm_time','vclm_time','uclm_time','vclm_time','zeta_time'};

for i =1:length(vars)
  varname = vars{i};
  tname  = ts{i};

  t=use(clm,tname);
  cycle=n_varatt(clm,tname,'cycle_length');
  [id,d] = cyclic_index(t,time,cycle);
  [i1,i2]=unpack(id);
  [d1,d2]=unpack(d);

  if ~quiet
    fprintf(1,' - using %7s t1,t2= %6.2f %6.2f  d1,d2= %6.2f %6.2f\n',varname,t(i1),t(i2),d1,d2);
  end

  v1=use(clm,varname,tname,i1);
  v2=use(clm,varname,tname,i2);

  v=(v1*d2+v2*d1)/(d1+d2);

  if ~quiet
    fprintf(1,'   ... filling ini file with var %s\n',varname);
  end

  nc=netcdf(ini,'w');
  nc{varname}(:)=v;
  close(nc)
end
