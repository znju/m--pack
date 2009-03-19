function [ncep,ftp] = ncep_settings(Y,type)
%NCEP_SETTINGS   Information about NCEP bulk fluxes files
%   This information is used be NCEP_GEN in the creation of ROMS
%   bulk fluxes forcing file.
%
%   Syntax:
%      [NCEP,FTP] = NCEP_SETTINGS(YEAR,TYPE)
%
%   Inputs:
%      YEAR   Each file contains data for one year
%      TYPE   File type:
%        wind
%          wind-u         4xDaily u-wind at 10 m                       (m/s)      --> m/s
%          wind-v         4xDaily v-wind at 10 m                       (m/s)      --> m/s
%        radiation
%          radiation-sw   4xDaily Net Shortwave Radiation              (W/m^2)    --> - W/m^2
%          radiation-lw   4xDaily Net Longwave Radiation               (W/m^2)    --> - W/m^2
%          radiation-lh   4xDaily Latent Heat Net Flux at surface      (W/m^2)    --> - W/m^2
%          radiation-sh   4xDaily Sensible Heat Net Flux at surface    (W/m^2)    --> - W/m^2
%        temperature      4xDaily Air temperature at 2 m               (degK)     --> K
%        pressure         4xDaily Surface Pressure                     (Pascals)  --> hP (mb)
%        cloud            Total cloud cover                            (%)        --> [0, ... 1]
%        precipitation    4xDaily Precipitation Rate at surface        (Kg/m^2/s) --> Kg/m^2/s
%        humidity         4xDaily relative humidity at sigma level 995 (%)        --> %
%
%   Outputs:
%      NCEP   Structure with .file, .path, .var, .str, .roms_scale
%             and .roms_offset
%      FTP    Structure with .site (ncep ftp site) and .run (unix
%             command to download file)
%
%   Examples:
%      [ncep,ftp] = ncep_settings(2004);
%      [ncep,ftp] = ncep_settings(2004,'wind');
%      [ncep,ftp] = ncep_settings(2004,'wind-v')
%
%   MMA 10-2004, martinho@fis.ua.pt
%
%   See also NCEP_GEN

%   Department of Physics
%   University of Aveiro, Portugal

ftpSite = 'ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis/';
command = 'wget ';

if ~isstr(Y)
  Y = num2str(Y);
end

% --------------------------------------------------------------------
% wind:

% ncep info:

file_u = 'uwnd.10m.gauss'; file_u = [file_u,'.',Y,'.nc'];
file_v = 'vwnd.10m.gauss'; file_v = [file_v,'.',Y,'.nc'];
var_u  = 'uwnd';
var_v  = 'vwnd';
path_u = 'surface_gauss/';
path_v = 'surface_gauss/';
str_u  = ' 4xDaily u-wind at 10 m   ';
str_v  = ' 4xDaily v-wind at 10 m   ';

ncep.wind(1).file = file_u;
ncep.wind(2).file = file_v;
ncep.wind(1).var  = var_u;
ncep.wind(2).var  = var_v;
ncep.wind(1).path = path_u;
ncep.wind(2).path = path_v;
ncep.wind(1).str  = str_u;
ncep.wind(2).str  = str_v;

% roms info: conversion scale and offset

roms_scale   = 1; % units remain m/s
roms_offset  = 0;

ncep.wind(1).roms_scale    = roms_scale;
ncep.wind(1).roms_offset   = roms_offset;

% --------------------------------------------------------------------

% radiation:

% ncep info:

file_sw = 'nswrs.sfc.gauss'; file_sw = [file_sw,'.',Y,'.nc'];
file_lw = 'nlwrs.sfc.gauss'; file_lw = [file_lw,'.',Y,'.nc'];
file_lh = 'lhtfl.sfc.gauss'; file_lh = [file_lh,'.',Y,'.nc'];
file_sh = 'shtfl.sfc.gauss'; file_sh = [file_sh,'.',Y,'.nc'];
var_sw  = 'nswrs';
var_lw  = 'nlwrs';
var_lh  = 'lhtfl';
var_sh  = 'shtfl';
path_sw = 'surface_gauss/';
path_lw = 'surface_gauss/';
path_lh = 'surface_gauss/';
path_sh = 'surface_gauss/';
str_sw  = ' 4xDaily Net Shortwave Radiation   ';
str_lw  = ' 4xDaily Net Longwave Radiation   ';
str_lh  = ' 4xDaily Latent Heat Net Flux at surface   ';
str_sh  = ' 4xDaily Sensible Heat Net Flux at surface ';

ncep.radiation(1).file = file_sw;
ncep.radiation(2).file = file_lw;
ncep.radiation(3).file = file_lh;
ncep.radiation(4).file = file_sh;
ncep.radiation(1).var  = var_sw;
ncep.radiation(2).var  = var_lw;
ncep.radiation(3).var  = var_lh;
ncep.radiation(4).var  = var_sh;
ncep.radiation(1).path = path_sw;
ncep.radiation(2).path = path_lw;
ncep.radiation(3).path = path_lh;
ncep.radiation(4).path = path_sh;
ncep.radiation(1).str  = str_sw;
ncep.radiation(2).str  = str_lw;
ncep.radiation(3).str  = str_lh;
ncep.radiation(4).str  = str_sh;

% roms info: conversion scale and offset

roms_scale   = -1;  % units remain W/m^2, but whith opposite direction !!
roms_offset  = 0;

ncep.radiation(1).roms_scale    = roms_scale;
ncep.radiation(1).roms_offset   = roms_offset;


% --------------------------------------------------------------------

% temperature:

% ncep info:

file_t = 'air.2m.gauss';  file_t = [file_t,'.',Y,'.nc'];
var_t  = 'air';
path_t = 'surface_gauss/';
str_t  = ' 4xDaily Air temperature at 2 m   ';

ncep.temperature.file = file_t;
ncep.temperature.var  = var_t;
ncep.temperature.path = path_t;
ncep.temperature.str  = str_t;

% roms info: conversion scale and offset

roms_scale   = 1;
roms_offset  = -273.15; % units from Kelvin to Celssius

ncep.temperature(1).roms_scale    = roms_scale;
ncep.temperature(1).roms_offset   = roms_offset;


% --------------------------------------------------------------------

% pressure:

% ncep info:

file_p = 'pres.sfc.gauss';  file_p = [file_p,'.',Y,'.nc'];
var_p  = 'pres';
path_p = 'surface_gauss/';
str_p  = ' 4xDaily Surface Pressure   ';

ncep.pressure.file = file_p;
ncep.pressure.var  = var_p;
ncep.pressure.path = path_p;
ncep.pressure.str  = str_p;

% roms info: conversion scale and offset

roms_scale   = 1/100; % units from Pascal to mb (hPa)
roms_offset  = 0;

ncep.pressure(1).roms_scale    = roms_scale;
ncep.pressure(1).roms_offset   = roms_offset;

% --------------------------------------------------------------------

% cloud:

% ncep info:

file_c = 'tcdc.eatm.gauss'; file_c = [file_c,'.',Y,'.nc'];
var_c  = 'tcdc';
path_c = 'other_gauss/';
str_c  = ' Total cloud cover        ';

ncep.cloud.file = file_c;
ncep.cloud.var  = var_c;
ncep.cloud.path = path_c;
ncep.cloud.str  = str_c;

% roms info: conversion scale and offset

roms_scale   = 1/100; % units from % to 0-1
roms_offset  = 0;

ncep.cloud(1).roms_scale    = roms_scale;
ncep.cloud(1).roms_offset   = roms_offset;

% --------------------------------------------------------------------

% precipitation:

% ncep info:

file_r = 'prate.sfc.gauss'; file_r = [file_r,'.',Y,'.nc'];
var_r  = 'prate';
path_r = 'surface_gauss/';
str_r  = ' 4xDaily Precipitation Rate at surface   ';

ncep.precipitation.file = file_r;
ncep.precipitation.var  = var_r;
ncep.precipitation.path = path_r;
ncep.precipitation.str  = str_r;

% roms info: conversion scale and offset

roms_scale   = 1; % units remain Kg/m^2/s
roms_offset  = 0;

ncep.precipitation(1).roms_scale    = roms_scale;
ncep.precipitation(1).roms_offset   = roms_offset;

% --------------------------------------------------------------------

% humidity:

% ncep info:

file_h = 'rhum.sig995'; file_h = [file_h,'.',Y,'.nc'];
var_h  = 'rhum';
path_h = 'surface/';
str_h  = ' 4xDaily relative humidity at sigma level 995';

ncep.humidity.file = file_h;
ncep.humidity.var  = var_h;
ncep.humidity.path = path_h;
ncep.humidity.str  = str_h;

% roms info: conversion scale and offset

roms_scale   = 1; % units remain %
roms_offset  = 0;

ncep.humidity(1).roms_scale    = roms_scale;
ncep.humidity(1).roms_offset   = roms_offset;

% --------------------------------------------------------------------
if nargin > 1
  if     isequal(type,'wind-u'),       ncep = ncep.wind(1);
  elseif isequal(type,'wind-v'),       ncep = ncep.wind(2);
  elseif isequal(type,'radiation-sw'), ncep = ncep.radiation(1);
  elseif isequal(type,'radiation-lw'), ncep = ncep.radiation(2);
  elseif isequal(type,'radiation-lh'), ncep = ncep.radiation(3);
  elseif isequal(type,'radiation-sh'), ncep = ncep.radiation(4);
  else  eval(['ncep=ncep.',type,';']);
  end
end

ftp.site = ftpSite;
ftp.run  = command;
