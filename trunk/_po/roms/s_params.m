function [theta_s,theta_b,hc,n] = s_params(file)
%S_PARAMS   Get s-coordinates parameters from ROMS file
%   Gets from ROMS output files the data needed to calculate vertical
%   s-coordinate levels.
%   This function looks for the required values among variables, file
%   dimensions and file attributes. To see the result and where the
%   values were found use this function without output arguments.
%
%   Syntax:
%      [THETA_S,THETA_B,HC,N] = S_PARAMS(FILE)
%
%   Input:
%      FILE   ROMS output file
%
%   Outputs:
%      THETA_S   S-coordinate surface control parameter
%      THETA_B   S-coordinate bottom control parameter
%      HC        S-coordinate critical depth, minimum between Tcline
%                (s-coordinate surface/bottom layer width) and hmin
%                (minimum grid depth)
%      N         Number of vertical levels
%
%   MMA 3-2-2005, martinho@fis.ua.pt
%
%   See also S_LEVELS

%   Department of Physics
%   University of Aveiro, Portugal

theta_s = [];
theta_b = [];
hc      = [];
n       = [];
if nargin == 0
  disp([':: ',mfilename,' : input file is required']);
  return
end

% check file:
nc=netcdf(file);
if isempty(nc)
  return
end
close(nc)

% theta_s, theta_b:
% as variables or as file global attributes:
v = 'theta_s';
if n_varexist(file,v)
  theta_s = use(file,v);
  theta_s_source = 'variable';
elseif  n_attexist(file,v)
  theta_s = n_att(file,v);
  theta_s_source = 'file attribute';
else
  theta_s = [];
  theta_s_source = 'not found';
end

v = 'theta_b';
if n_varexist(file,v)
  theta_b = use(file,v);
  theta_b_source = 'variable';
elseif  n_attexist(file,v)
  theta_b = n_att(file,v);
  theta_b_source = 'file attribute';
else
  theta_b = [];
  theta_b_source = 'not found';
end

% get hc or minimum between hmin and Tcline:
% 1- get hc as variable or as file global attribute:
v = 'hc';
hc = [];
hc_source = 'not found';
if n_varexist(file,v)
  hc = use(file,v);
  hc_source = 'variable';
elseif  n_attexist(file,v)
  hc = n_att(file,v);
  hc_source = 'file attribute';
else

  % 2-  get hc as minimum between hmin and Tcline
  hmin   = [];
  Tcline = [];
  % get hmin and Tcline:
  if  n_varexist(file,'h')
    hmin = min(min(use(file,'h'))); % this may not be correct with stations file !!
  end
  v = 'Tcline';
  if n_varexist(file,v)
    Tcline = use(file,v);
  elseif  n_attexist(file,v)
    Tcline = n_att(file,v);
  end

  if ~isempty(hmin) & ~isempty(Tcline)
    hc = min(hmin,Tcline);
    hc_source = 'min of hmin and Tcline';
  end

end

% n:
% as value of file dimension N or s_rho;
% as length of variable sc_r or as file global attribute sc_r
if n_dimexist(file,'N')
  n = n_dim(file,'N');
  n_source = 'file dimension N';
elseif n_dimexist(file,'s_rho')
  n = n_dim(file,'s_rho');
  n_source = 'file dimension s_rho';
elseif n_varexist(file,'sc_r')
  n = length(use(file,'sc_r'));
  n_source = 'length of variable sc_r';
elseif n_attexist(file,'sc_r')
  n = n_att(file,'sc_r');
  n_source = 'file attribute sc_r';
else
  n = [];
  n_source = 'not found';
end

% --------------------------------------------------------------------
% show values and sources:
% --------------------------------------------------------------------
if nargout == 0
  fprintf(1,'\n');
  fprintf(1,'## s-levels parameters of file\n');
  fprintf(1,'%s\n',file);
  fprintf(1,'\n');

  if isempty(theta_s), fprintf(1,'  --> theta_s          %s\n',theta_s_source);
  else                 fprintf(1,'  --> theta_s  %6.2f  %s\n',theta_s,theta_s_source);
  end
  if isempty(theta_b), fprintf(1,'  --> theta_b          %s\n',theta_b_source);
  else                 fprintf(1,'  --> theta_b  %6.2f  %s\n',theta_b,theta_b_source);
  end
  if isempty(hc),      fprintf(1,'  --> hc               %s\n',hc_source);
  else                 fprintf(1,'  --> hc       %6.2f  %s\n',hc,hc_source);
  end
  if isempty(n),       fprintf(1,'  --> N                %s\n',n_source);
  else                 fprintf(1,'  --> N        %6.2f  %s\n',n,n_source);
  end

  fprintf(1,'\n');
end
