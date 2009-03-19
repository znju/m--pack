function [x,y,z,v,labels]=roms_slicez_clim(file,grd,varname,depth,t,varargin)
%ROMS_SLICEZ_CLIM   Make ROMS climatology slice at z=const
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICEZ_CLIM(FILE,GRID,VARNAME,Z,T,VARARGIN)
%      V = ROMS_SLICEZ(FILE,VARNAME,Z,T,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
%      GRID      ROMS grid file
%      VARNAME   Variable to extract (array or dimension > 2)
%      Z         Depth (negative below zero)
%      T         Time indice
%      VARARGIN:
%         's_params': structure with fields: .tts, .ttb, .hc and .N
%            These are required to calc z and so, are not always needed
%            They will be used by the function S_LEVELS when needed.
%            If this structure is not entered or any of its fields is
%            missing then the function S_PARAMS will look for this data
%            in the file
%
%   Outputs:
%      X         Longitude
%      Y         Latitude
%      Z         Depth
%      V         Variable at slice
%      LABELS    Names of variables X, Y and Z
%
%   Example:
%      file = 'roms_clm.nc';
%      grid = 'roms_grd.nc';
%      varname = 'temp';      % 4-d array
%      z = -200;
%      t = 10;
%      params.tts = 5;
%      params.ttb = .3;
%      params.hc  = 10;
%      params.N   = 20;
%      [x,y,z,v,labels]=roms_slicez_clim(file,grd,varname,z,t,'s_params',params);
%      figure
%      surf(x,y,z,v);
%      figure
%      pcolor(x,y,v)
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See also ROMS_SLICE, S_LEVELS

%   Department of Physics
%   University of Aveiro, Portugal

%   ??-02-2005 - Improved + bug fix
%   05-07-2005 - Changed to allow roms2.2
%   23-06-2008 - Created from roms_slicez to be used with climatologies

sparams = [];
vin = varargin;
for ii=1:length(vin)
  if isequal(vin{ii},'s_params')
    sparams = vin{ii+1};
    if isfield(sparams,'tts') & isfield(sparams,'ttb') & isfield(sparams,'hc')  & isfield(sparams,'N')
      tts    = sparams.tts;
      ttb    = sparams.ttb;
      hc     = sparams.hc;
      N      = sparams.N;
    end
  end
end

% get the s parameters from the file:
% Notice that the s-parameters of the file will not be used if
% they are given as input
%if isempty(sparams)
  [tts,ttb,hc,N] = s_params(file);
%end
disp('HEREEEEEEEEE')

x        = [];
y        = [];
z        = [];
v        = [];
labels.x = [];
labels.y = [];
labels.z = [];

if nargin < 3
  disp('» bad number of arguments');
  return
end

if ~isnumber(depth,1)
  disp('» bad depth input argument');
  return
end

% --------------------------------------------------------------------
% open file to read:
% --------------------------------------------------------------------
ncquiet;
nc=netcdf(file);

% --------------------------------------------------------------------
% check if variable exists:
% --------------------------------------------------------------------
if ~n_varexist(file,varname)
  fprintf(1,'» variable %s not found\n',varname);
  close(nc);
  return
end

% --------------------------------------------------------------------
% extract var:
% --------------------------------------------------------------------
isS_rho  = n_vardimexist(file,varname,'s_rho');
isS_w    = n_vardimexist(file,varname,'s_w');
isXi_u   = n_vardimexist(file,varname,'xi_u');
isXi_psi = n_vardimexist(file,varname,'xi_psi');
isEta_v  = n_vardimexist(file,varname,'eta_v');
isEta_psi= n_vardimexist(file,varname,'eta_psi');

LenS_rho = n_filedim(file,'s_rho');
LenS_w   = n_filedim(file,'s_w');

% best way to test z comp.:
if ~(isS_rho | isS_w)
  fprintf(1,'» variable %s has no z dependence\n',varname);
  close(nc)
  return
end

if     strcmpi(varname,'temp'), dimTime='tclm_time';
elseif strcmpi(varname,'salt'), dimTime='sclm_time';
elseif strcmpi(varname,'u'),    dimTime='uclm_time';
elseif strcmpi(varname,'v'),    dimTime='vclm_time';
elseif strcmpi(varname,'ubar'), dimTime='uclm_time';
elseif strcmpi(varname,'vbar'), dimTime='vclm_time';
%elseif strcmpi(varname,'zeta'), dimTime=''; %  no z dependence, return already happened
end

if ~n_vardimexist(file,varname,dimTime)
  dimTime='time';
end

nTimes   = n_vardim(file,varname,dimTime);
if nTimes>1
  if nargin < 4, disp('» bad number of arguments, t is required');
    close(nc);
    return
  elseif ~isnumber(t,1,'Z+') %t < 1
    disp('» t must be > 1');
    close(nc);
    return
  elseif t > nTimes
    fprintf(1,'» t = %g exceeds time dimension (%g)\n',t,LenTime);
    close(nc);
    return
  end
end

% extract v:
v=use(file,varname,dimTime,t);
v=squeeze(v);

% --------------------------------------------------- extract x and y:
if n_varexist(grd,'lon_rho'),    x = use(grd,'lon_rho');  labels.x='longitude';
elseif n_varexist(grd,'x_rho'),  x = use(grd,'x_rho');    labels.x='distance x';
else  fprintf(1,'» lon_rho or x_rho do not exist\n'); close(nc), return, end

if n_varexist(grd,'lat_rho'),    y = use(grd,'lat_rho');  labels.y='latitude';
elseif n_varexist(grd,'y_rho'),  y = use(grd,'y_rho');    labels.y='distance y';
else  fprintf(1,'» lat_rho or y_rho do not exist\n'); close(nc), return, end

if isXi_u | isXi_psi
  x = (x(:,2:end)+x(:,1:end-1))/2;
  y = (y(:,2:end)+y(:,1:end-1))/2;
end
if isEta_v | isEta_psi
  x = (x(2:end,:)+x(1:end-1,:))/2;
  y = (y(2:end,:)+y(1:end-1,:))/2;
end

% ----------------------------------------------------- extract z: (depth)
% get h:
if n_varexist(grd,'h'),  h = use(grd,'h');
else, fprintf(1,'» h is not present\n');    close(nc), return, end
if isXi_u | isXi_psi,   h = (h(:,2:end)+h(:,1:end-1))/2; end
if isEta_v | isEta_psi, h = (h(2:end,:)+h(1:end-1,:))/2; end

% get zeta:
if n_varexist(file,'zeta'),  zeta = nc{'zeta'}(t,:,:); % t, j, i
else, fprintf(1,'» zeta is not present\n'); close(nc), return, end
if isXi_u | isXi_psi,   zeta = (zeta(:,2:end)+zeta(:,1:end-1))/2; end
if isEta_v | isEta_psi, zeta = (zeta(2:end,:)+zeta(1:end-1,:))/2; end

if isstr(sparams)
   [z_,zw_]=pom_s_levels(sparams,h,zeta,1);
   N=pom_s_levels(sparams);
else
  [z_,zw_] = s_levels(h,tts,ttb,hc,N,zeta,0);
end

if isS_rho
  z = repmat(nan,[LenS_rho+2 size(h)]);
  z(2:end-1,:,:) = permute(z_, [3 1 2]);
elseif isS_w
  z = repmat(nan,[LenS_w+2 size(h)]);
  z(2:end-1,:,:) = permute(zw_,[3 1 2]);
end

labels.z = 'depth';

% ------------------------------------------------------- extract v:
z(1,:,:) = -inf;
z(end,:,:) = inf;

% find z indices with depth above z:
i=z > depth;
iM = i(2:end,:,:) - i(1:end-1,:,:);
iM(2:end+1,:,:) = iM;
iM(1,:,:) = zeros(size(iM(1,:,:)));
iM = logical(iM);

% find z indices with depth under z:
i=z < depth;
im = i(1:end-1,:,:) - i(2:end,:,:);
im(end+1,:,:) = zeros(size(iM(1,:,:)));
im = logical(im);

% get interpolation coefficients:
size(z)
size(iM)
size(z(iM))
zUp   = reshape(z(iM),size(z,2),size(z,3));
zDown = reshape(z(im),size(z,2),size(z,3));
coefUp   = (zUp-depth)./(zUp-zDown);
coefDown = (depth-zDown)./(zUp-zDown);

% z not needed anymore:
z=repmat(depth,size(z,2),size(z,3));

v(2:end+1,:,:) = v;
v(1,:,:)       = repmat(nan,size(v,2),size(v,3));
v(end+1,:,:)   = repmat(nan,size(v,2),size(v,3));

vUp   = reshape(v(iM),size(z,1),size(z,2));
vDown = reshape(v(im),size(z,1),size(z,2));
v = coefUp.*vDown + coefDown.*vUp;

close(nc)

if nargout == 1
  x = v;
end
