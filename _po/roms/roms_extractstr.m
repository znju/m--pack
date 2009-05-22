function [str,errorstr,n] = roms_extractstr(file,varname,varargin)
%ROMS_EXTRACTSTR   Get range of ROMS NetCDF variables
%   Returns the string with the range of a ROMS variable to use
%   inside the NetCDF/Matlab interface: var=nc{varname}(range).
%
%   Syntax:
%      [STR,ERR,N] = ROMS_EXTRACTSTR(FILE,VARNAME,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
%      VARNAME   ROMS variable
%      VARARGIN:
%         dimension then value:
%            'time'/'ocean time', time indice
%            'station', station indice
%            'eta',     eta_rho[u, v, psi] indice
%            'xi',      xi_rho[u, v, psi] indice
%            's',       s_rho or s_w indice
%
%   Outputs:
%      STR   The extraction string
%      ERR   In case of an error, like indice too big, an error string
%            is created
%      N     Range (STR) dimension, obtained by RANGE_DIMS(STR)
%
%   Examples:
%      file = 'ocean_sta.nc'
%      var  = 'temp';
%      % range str for a time series at a station:
%      [str,errorstr,n] = roms_extractstr(file,var,'station',50,'s',25');
%      % slice in depth:
%      [str,errorstr,n] = roms_extractstr(file,'h','eta',50);
%
%   MMA 3-2-2005, martinho@fis.ua.pt
%
%   See also RUSE, USE, RANGE_DIMS

%   Department of Physics
%   University of Aveiro, Portugal

%   24-07-2005 - Changed to allow roms2.2 (ocean_time or time)

str      = [];
errorstr = [];
n        = [];

setTime    = 0;
setStation = 0;
setEta     = 0;
setXi      = 0;
setS       = 0;
vin = varargin;
for ii=1:length(vin)
  if isequal(vin{ii},'time'),    itime = vin{ii+1};    setTime    = 1; end
  if isequal(vin{ii},'station'), istation = vin{ii+1}; setStation = 1; end
  if isequal(vin{ii},'eta'),     ieta = vin{ii+1};     setEta     = 1; end
  if isequal(vin{ii},'xi'),      ixi = vin{ii+1};      setXi      = 1; end
  if isequal(vin{ii},'s'),       is = vin{ii+1};       setS       = 1; end
end

% --------------------------------------------------------------------
% check if variable exists:
% --------------------------------------------------------------------
if ~n_varexist(file,varname)
  errorstr=sprintf('» variable %s not found\n',varname);
  return
end

% --------------------------------------------------------------------
% get dimensions and set extraction string:
% --------------------------------------------------------------------
dims = n_vardims(file,varname);
if isempty(dims)
  errorstr=sprintf('» variable %s has unknown dimension',varname);
  return
end
dimNames = dims.name;
dimLen   = dims.length;

dim_time    = {'time','ocean_time','ftime'};      isTime    = 0;
%dim_oc_time = 'ocean_time'; % added for roms 2.2
%dim_sc_time = 'ftime';      % added for roms-agrif
dim_eta_rho = 'eta_rho';   isEta_rho = 0;
dim_eta_u   = 'eta_u';     isEta_u   = 0;
dim_eta_v   = 'eta_v';     isEta_v   = 0;
dim_eta_psi = 'eta_psi';   isEta_psi = 0;
dim_xi_rho  = 'xi_rho';    isXi_rho  = 0;
dim_xi_u    = 'xi_u';      isXi_u    = 0;
dim_xi_v    = 'xi_v';      isXi_v    = 0;
dim_xi_psi  = 'xi_psi';    isXi_psi  = 0;
dim_s_rho   = 's_rho';     isS_rho   = 0;
dim_s_w     = 's_w';       isS_w     = 0;
dim_station = {'station','stanum'};   isStation = 0;

for d = 1:length(dimNames)
  dim = dimNames{d};
  len = dimLen{d};
  if ismember(dim,dim_time),        isTime    = 1; LenTime    = len; iTime    = d;
  elseif isequal(dim,dim_eta_rho),  isEta_rho = 1; LenEta_rho = len; iEta_rho = d;
  elseif isequal(dim,dim_eta_u),    isEta_u   = 1; LenEta_u   = len; iEta_u   = d;
  elseif isequal(dim,dim_eta_v),    isEta_v   = 1; LenEta_v   = len; iEta_v   = d;
  elseif isequal(dim,dim_eta_psi),  isEta_psi = 1; LenEta_psi = len; iEta_psi = d;
  elseif isequal(dim,dim_xi_rho),   isXi_rho  = 1; LenXi_rho  = len; iXi_rho  = d;
  elseif isequal(dim,dim_xi_u),     isXi_u    = 1; LenXi_u    = len; iXi_u    = d;
  elseif isequal(dim,dim_xi_v),     isXi_v    = 1; LenXi_v    = len; iXi_v    = d;
  elseif isequal(dim,dim_xi_psi),   isXi_psi  = 1; LenXi_psi  = len; iXi_psi  = d;
  elseif isequal(dim,dim_s_rho),    isS_rho   = 1; LenS_rho   = len; iS_rho   = d;
  elseif isequal(dim,dim_s_w),      isS_w     = 1; LenS_w     = len; iS_w     = d;
  elseif ismember(dim,dim_station), isStation = 1; LenStation = len; iStation = d;
  end
end

% set v extraction dimensions:
if isTime,     dimsv{iTime}    = ['1:',num2str(LenTime)    ]; end
if isStation,  dimsv{iStation} = ['1:',num2str(LenStation) ]; end
if isEta_rho,  dimsv{iEta_rho} = ['1:',num2str(LenEta_rho) ]; end
if isEta_u,    dimsv{iEta_u}   = ['1:',num2str(LenEta_u)   ]; end
if isEta_v,    dimsv{iEta_v}   = ['1:',num2str(LenEta_v)   ]; end
if isEta_psi,  dimsv{iEta_psi} = ['1:',num2str(LenEta_psi) ]; end
if isXi_rho,   dimsv{iXi_rho}  = ['1:',num2str(LenXi_rho)  ]; end
if isXi_u,     dimsv{iXi_u}    = ['1:',num2str(LenXi_u)    ]; end
if isXi_v,     dimsv{iXi_v}    = ['1:',num2str(LenXi_v)    ]; end
if isXi_psi,   dimsv{iXi_psi}  = ['1:',num2str(LenXi_psi)  ]; end
if isS_rho,    dimsv{iS_rho}   = ['1:',num2str(LenS_rho)   ]; end
if isS_w,      dimsv{iS_w}     = ['1:',num2str(LenS_w)     ]; end

if setTime    & isTime,    dimsv{iTime}     = num2str(itime);    end
if setStation & isStation, dimsv{iStation}  = num2str(istation); end
if setEta
  if isEta_rho, dimsv{iEta_rho} = num2str(ieta); end
  if isEta_u,   dimsv{iEta_u}   = num2str(ieta); end
  if isEta_v,   dimsv{iEta_v}   = num2str(ieta); end
  if isEta_psi, dimsv{iEta_psi} = num2str(ieta); end
end
if setXi
  if isXi_rho,  dimsv{iXi_rho}  = num2str(ixi); end
  if isXi_u,    dimsv{iXi_u}    = num2str(ixi); end
  if isXi_v,    dimsv{iXi_v}    = num2str(ixi); end
  if isXi_psi,  dimsv{iXi_psi}  = num2str(ixi); end
end
if setS
  if isS_rho,   dimsv{iS_rho}   = num2str(is); end
  if isS_w,     dimsv{iS_w}     = num2str(is); end
end

% --------------------------------------------------------------------
% get max indice:
% --------------------------------------------------------------------
% in order to allow selection as a:b, the i<...> variable will be string, so check the max of it,
% also check for positive values:
if setTime
  mitime = itime;
  if isstr(itime),  mitime = max(str2num(itime));
  elseif ~isnumber(itime,1,'Z+'),    str = ['» bad itime = ',   num2str(itime)   ]; errorstr = strvcat(errorstr,str);
  end
end
if setStation
  mistation = istation;
  if isstr(istation), mistation = max(str2num(istation));
  elseif ~isnumber(istation,1,'Z+'), str = ['» bad istation = ',num2str(istation)]; errorstr = strvcat(errorstr,str);
  end
end
if setEta
  mieta = ieta;
  if isstr(ieta), mieta = max(str2num(ieta));
  elseif ~isnumber(ieta,1,'Z+'),     str = ['» bad ieta = ',    num2str(ieta)    ]; errorstr = strvcat(errorstr,str);
  end
end
if setXi
  mixi = ixi;
  if isstr(ixi), mixi = max(str2num(ixi));
  elseif ~isnumber(ixi,1,'Z+'),      str = ['» bad ixi = ',     num2str(ixi)     ]; errorstr = strvcat(errorstr,str);
  end
end
if setS
  mis = is;
  if isstr(is), mis = max(str2num(is));
  elseif ~isnumber(is,1,'Z+'),       str = ['» bad is = ',      num2str(is)      ]; errorstr = strvcat(errorstr,str);
  end
end
% well, I could also check here forgood strings, like 'a:b', check a and b... but that would be too much...

% --------------------------------------------------------------------
% check if valid extraction indices:
% --------------------------------------------------------------------
if setTime    & isTime    & mitime    > LenTime
  str = ['» itime = ',   num2str(mitime),   ' exceeds Time dimension (',   num2str(LenTime),   ')']; errorstr = strvcat(errorstr,str);
end
if setStation & isStation & mistation > LenStation,
  str = ['» istation = ',num2str(mistation),' exceeds Station dimension (',num2str(LenStation),')']; errorstr = strvcat(errorstr,str);
end
if setEta
  if isEta_rho & mieta > LenEta_rho
    str = ['» ieta = ',num2str(mieta),' exceeds Eta_rho dimension (',num2str(LenEta_rho),')']; errorstr = strvcat(errorstr,str);
  end
  if isEta_u & mieta > LenEta_u
    str = ['» ieta = ',num2str(mieta),' exceeds Eta_u dimension (',  num2str(LenEta_u),  ')']; errorstr = strvcat(errorstr,str);
  end
  if isEta_v & mieta > LenEta_v
    str = ['» ieta = ',num2str(mieta),' exceeds Eta_v dimension (',  num2str(LenEta_v),  ')']; errorstr = strvcat(errorstr,str);
  end
  if isEta_psi & mieta > LenEta_psi
    str = ['» ieta = ',num2str(mieta),' exceeds Eta_psi dimension (',num2str(LenEta_psi),')']; errorstr = strvcat(errorstr,str);
  end
end
if setXi
  if isXi_rho & mixi > LenXi_rho
    str = ['» ixi = ',num2str(mixi),  ' exceeds Xi_rho dimension (', num2str(LenXi_rho),')' ]; errorstr = strvcat(errorstr,str);
  end
  if isXi_u & mixi > LenXi_u
    str = ['» ixi = ',num2str(mixi),  ' exceeds Xi_u dimension (',   num2str(LenXi_u),  ')' ]; errorstr = strvcat(errorstr,str);
  end
  if isXi_v & mixi > LenXi_v
    str = ['» ixi = ',num2str(mixi),  ' exceeds Xi_v dimension (',   num2str(LenXi_v),  ')' ]; errorstr = strvcat(errorstr,str);
  end
  if isXi_psi & mixi > LenXi_psi
    str = ['» ixi = ',num2str(mixi),  ' exceeds Xi_psi dimension (', num2str(LenXi_psi),')' ]; errorstr = strvcat(errorstr,str);
  end
end
if setS
  if isS_rho & mis > LenS_rho
    str = ['» is = ',num2str(mis),    ' exceeds S_rho dimension (', num2str(LenS_rho),')'   ]; errorstr = strvcat(errorstr,str);
  end
  if isS_w & mis > LenS_w
    str = ['» is = ',num2str(mis),    ' exceeds S_w dimension (',   num2str(LenS_w),')'     ]; errorstr = strvcat(errorstr,str);
  end
end

% --------------------------------------------------------------------
% build extraction string:
% --------------------------------------------------------------------
dimsvSTR  = '(';
for d = 1:length(dimsv)
  dimsvSTR  = [dimsvSTR, dimsv{d}, ','];
end
dimsvSTR  = [dimsvSTR(1:end-1), ')'];

if ~isempty(errorstr)
  dimsvSTR = [];
end
[n,tmp]    = range_dims(dimsvSTR);
str  = dimsvSTR;
