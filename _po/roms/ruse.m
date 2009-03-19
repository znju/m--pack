function [v] = ruse(file,varname,varargin)
%RUSE   Extract ROMS NetCDF variables
%   Returns a ROMS variable at the desired range.
%
%   Syntax:
%      V = RUSE(FILE,VARNAME,VARARGIN)
%
%   Input:
%      FILE      ROMS output file
%      VARNAME   ROMS variable
%      VARARGIN:
%         dimension then value (integer, or string to define some
%         range, like '[1 3 8]' or '1:10':
%            'time',    time indice
%            'station', station indice
%            'eta',     eta_rho[u, v, psi] indice
%            'xi',      xi_rho[u, v, psi] indice
%            's',       s_rho or s_w indice
%
%   Output:
%      V   the variable
%
%   Examples:
%      file = 'ocean_sta.nc'
%      var  = 'temp';
%      % time series at a station:
%      temp = ruse(file,var,'station',50,'s',25');
%      % in more than one station:
%      temp = ruse(file,var,'station','[50 100]','s',25');
%      % or more:
%      temp = ruse(file,var,'station','50:600','s',25');
%      % slice in depth:
%      h = ruse(file,'h','eta',50');
%
%   MMA 3-2-2005, martinho@fis.ua.pt
%
%   See also ROMS_EXTRACTSTR, USE

%   Department of Physics
%   University of Aveiro, Portugal

v = [];

% get extraction string:
[str,err,n] = roms_extractstr(file,varname,varargin{:});

if ~isempty(err)
  disp(err);
  return
end

nc = netcdf(file);
  eval(['v=nc{varname}',str,';']);
close(nc);
v = squeeze(v);
