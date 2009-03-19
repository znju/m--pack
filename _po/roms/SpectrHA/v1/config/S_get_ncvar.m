function var=S_get_ncvar(fname,label,IJK)
%function var=S_get_ncvar(fname,label,IJK)
%Reads variables from NetCDF files
%Input: fname, NetCDF filename
%       label, variabel to read, view S_set_data
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global FSTA % used to find if history or stations based on size of u

% check for netcdf
if ~S_exists_netcdf
  var=[];
  return
end

if nargin == 3
  I=IJK(1);
  J=IJK(2);
  K=IJK(3);
else
  I=':';
  J=':';
  K=':';
  IJK=[];
end

if length(IJK) == 4
  T=IJK(4);
else
  T=':'; % get series for all times
end

% zero will be all dimention:
if isequal(I,0), I=':' ; end
if isequal(J,0), J=':' ; end
if isequal(K,0), K=':' ; end


% defauly index positions
i1=I;
i2=J;
i3=K;
i4=T;

%=========================================================================
% grid variables:                                            

% case ROMS hystory file or SEAGRID file                     
%----------------------------------------------------------|--------------
bathymetry = 'h';         % bathymetry at rho points;      |         J x I
longitude  = 'lon_rho';   % longitude at rho points;       |         J x I
latitude   = 'lat_rho';   % latitude at rho points;        |         J x I
longitude2 = 'x_rho';
latitude2  = 'y_rho';
mask =       'mask_rho';  % mask at rho points;            |         J x I

switch label
  case 'bathymetry'
    varname=bathymetry;
    i1=J; i2=I; i3=1; i4=1;
  case 'longitude'
    if find_ncvar(fname,longitude)
      varname=longitude;
    else
      varname=longitude2;
    end
    i1=J; i2=I; i3=1; i4=1;
  case 'latitude'
    if find_ncvar(fname,latitude)
      varname=latitude;
    else
      varname=latitude2;
    end
    i1=J; i2=I; i3=1; i4=1;
  case 'mask'
    varname=mask;
    i1=J; i2=I; i3=1; i4=1;
end

%=========================================================================
% stations variables:                                        

% case ROMS stations file or [ROMS hystory file]                                   
%----------------------------------------------------------|--------------
bathy_sta = 'h';            % stations bathymetry at rho;  |             J    [J x I]      
lon_sta   = 'lon_rho';      % stations longitude at rho;   |             J    [J x I]
lat_sta   = 'lat_rho';      % stations latitude at rho;    |             J    [J x I]
lon_sta2  = 'x_rho';
lat_sta2  = 'y_rho';
lon_sta3  = 'Xgrid';
lat_sta3  = 'Ygrid';
time      = 'ocean_time';   % time since initialization;   |             T
time2     = 'scrum_time';
ssh       = 'zeta';         % free-surface                 |         T x J    [T x J   x I  ] 
vel_u     = 'u';            % u-momentum component         |     T x J x K    [T x K   x J   x I-1]
vel_v     = 'v';            % v-momentum component         |     T x J x K    [T x K   x J-1 x I  ]
vel_uBar  = 'ubar';         % barotropic u                 |         T x J    [T x J   x I-1]
vel_vBar  = 'vbar';         % barotropic v                 |         T x J    [T x J-1 x I  ]
var_nlevels = 'u';          % variable used to know the
                             % number of vertical levels
theta_s   = 'theta_s';      % surface control parameter    |             1    
theta_b   = 'theta_b';      % bottom control parameter     |             1             
Tcline    = 'Tcline';       % surface/bottom layer width   |             1

if isequal(length(size_ncvar(fname,vel_u)),4)
  FSTA.type='his';
  his=1;
else
  FSTA.type='sta';
  his=0;
end

switch label
  case 'bathy_sta'
    varname=bathy_sta;
    i1=J; i2=I; i3=1; i4=1;
  case 'lon_sta'
    if find_ncvar(fname,lon_sta)
      varname=lon_sta;
    elseif find_ncvar(fname,lon_sta3)
      varname=lon_sta3;
    else
      varname=lon_sta2;
    end
  case 'lat_sta'
    if find_ncvar(fname,lat_sta)
      varname=lat_sta;
    elseif find_ncvar(fname,lat_sta3)
      varname=lat_sta3;
    else
      varname=lat_sta2;
    end
  case 'time'
    if find_ncvar(fname,time)
      varname=time;
    else
      varname=time2;
    end
  case 'ssh'
    varname=ssh;
    if his, i1=T; i2=J; i3=I; i4=1; else,
            i1=T; i2=J; i3=1; i4=1; end
  case 'vel_u'
    varname=vel_u;
    if his, i1=T; i2=K; i3=J; i4=I; else,
            i1=T; i2=J; i3=K; i4=1; end
  case 'vel_v'
    varname=vel_v;
    if his, i1=T; i2=K; i3=J; i4=I; else,
            i1=T; i2=J; i3=K; i4=1; end
  case 'vel_uBar'
    varname=vel_uBar;
    if his, i1=T; i2=J; i3=I; i4=1; else,
            i1=T; i2=J; i3=1; i4=1; end
  case 'vel_vBar'
    varname=vel_vBar;
    if his, i1=T; i2=J; i3=I; i4=1; else,
            i1=T; i2=J; i3=1; i4=1; end
  case 'nlevels'
    varname=var_nlevels;
    s=size_ncvar(fname,varname);
    if length(s) >=2,
      if his,  var=s(2); else var=s(3); end
     else, var=[]; end
    varname='';  
  case 'theta_s' 
    varname=theta_s;
  case 'theta_b'
    varname=theta_b;
  case 'Tcline'
    varname=Tcline;
end

if ~isempty(varname)
  warning off
  nc=netcdf(fname,'nowrite');
    var=nc{varname}(i1,i2,i3,i4);
  nc=close(nc);
  warning on

  % for agrif:
  var(var==1e+15) = 0;
end

if his
  sz=size_ncvar(fname,varname);
  bad=0;
  if isequal(varname,vel_u)
    if i4 > sz(4);
      bad=1;
    end
  end
  if isequal(varname,vel_v)
    if i3 > sz(3);
      bad=1;
    end
  end
  if  isequal(varname,vel_uBar)
    if i3 > sz(3);
      bad=1;
    end
  end
  if isequal(varname,vel_vBar)
    if i2 > sz(2)
      bad=1;
    end
  end
  if bad
    var=[];
    msgbox('? out of range ?','wrong','modal');
    return
  end
end

%---------------------------------------------------------------------

function result=find_ncvar(fname,varname)
nc=netcdf(fname,'nowrite');
vv=var(nc);
nvars=length(vv);
result=0;
for i=1:nvars
  Name=name(vv{i});
  if isequal(Name,varname)
    result=1;
    nc=close(nc);
    return
  end
end 
nc=close(nc);


function result=size_ncvar(fname,varname)
nc=netcdf(fname,'nowrite');
vv=var(nc);
nvars=length(vv);
result=[];
for i=1:nvars
  Name=name(vv{i});
  if isequal(Name,varname)
    result=size(vv{i});
    nc=close(nc);
    return
  end
end
nc=close(nc);

