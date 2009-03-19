function rivers_gen(Isrc,Jsrc,Dsrc,Vshape,flag,time,q,temp,salt,frcname)
%RIVERS_GEN   Generate ROMS rivers forcing files
%
%   Syntax:
%      RIVERS_GEN(ISRC,JSRC,DSRC,VSHAPE,FLAG,,TIME,Q,TEMP,SALT,FRCNAME)
%
%   Example:
%    ns = 25;
%    f = rivers_vshape(ns);
%
%    datafile = 'data.txt';
%    tstart = '18-feb-2001';
%    tend   = '1-Apr-2001';
%    dt     = 1/4;
%    [t,q] = rivers_runoff(datafile,3,'dt',dt,'ts',tstart,'te',tend,'Qconst',[1000 1000]);
%
%    frcname = 'rivers_frc.nc'
%    gridname = '/home/user/grd/ocean_grd.nc';
%    rivers.nrivers = 3;
%    rivers.names   = {'Douro','Vouga','Minho'};
%    nt = length(t);
%    rivers_gennc(gridname,ns,nt,frcname,rivers);
%
%    Isrc = [117 113 107];
%    Jsrc = [116  99 141];
%    Dsrc = {'i-','i-','i-','i-'};
%    Vshape = f;
%    flag = [3 3 3];
%    time = t;
%    temp = 13;
%    salt = 0;
%
%    r = 0.5+0.5*tanh((time-0.5)/0.5);
%    q(:,1) = q(:,1).*r';
%    q(:,2) = q(:,2).*r';
%    q(:,3) = q(:,3).*r';
%
%    rivers_gen(Isrc,Jsrc,Dsrc,Vshape,flag,time,q,temp,salt,frcname)
%
%    MMA 2005, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

nrivers = length(Isrc);

% --------------------------------------------------------------------
% set river runoff direction and sign:
% --------------------------------------------------------------------
for i=1:nrivers
  d = Dsrc{i};
  evalc(['val = ',d(2),'1;'],'val=1;');
  thesign(i) = val;
  if isequal(d(1),'i')
    thedir(i)  = 0; % direction xi
  else
    thedir(i)  = 1; % direction eta
  end
end

% --------------------------------------------------------------------
% fill the forcing file:
% --------------------------------------------------------------------
nc = netcdf(frcname,'write')
%  % update dimension time:
%  tdim = nc('time');
%  tdim(:) = length(time);

  nc{'river'}(:)           = 1:nrivers;
  nc{'river_Xposition'}(:) = Isrc;
  nc{'river_Eposition'}(:) = Jsrc;
  nc{'river_direction'}(:) = thedir;
  nc{'river_flag'}(:)      = flag;
  nc{'river_time'}(:)      = time;
  nc{'river_temp'}(:)      = temp;
  nc{'river_salt'}(:)      = salt;

  for i=1:nrivers
    nc{'river_Vshape'}(:,i)  = Vshape;
    nc{'river_transport'}(:,i) = thesign(i)*q(:,i);
  end
close(nc)
