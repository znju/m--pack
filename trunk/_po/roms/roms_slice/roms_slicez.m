function [x,y,z,v,labels]=roms_slicez(file,varname,depth,t,varargin)
%ROMS_SLICEZ   Make ROMS slice at z=const
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICEZ(FILE,VARNAME,Z,T,VARARGIN)
%      V = ROMS_SLICEZ(FILE,VARNAME,Z,T,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
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
%      file = 'ocean_his.nc';
%      varname = 'temp';      % 4-d array
%      z = -200;
%      t = 10;
%      params.tts = 5;
%      params.ttb = .3;
%      params.hc  = 10;
%      params.N   = 20;
%      [x,y,z,v,labels]=roms_slicez(file,varname,z,t,'s_params',params);
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
if isempty(sparams)
  [tts,ttb,hc,N] = s_params(file);
end

x        = [];
y        = [];
z        = [];
v        = [];
labels.x = [];
labels.y = [];
labels.z = [];

if nargin < 2
  disp('» bad number of arguments');
  return
end

if ~isnumber(depth,1)
  disp('» bad depth input arguments');
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
% get dimensions/check input data/set variable extraction (dimsvSTR):
% --------------------------------------------------------------------
dims = n_vardims(file,varname);
if isempty(dims)
  fprintf(1,'» variable %s has unknown dimension',varname);
  close(nc);
  return
end
dimNames = dims.name;
dimLen   = dims.length;

dim_time    = 'time';      isTime    = 0;
dim_oc_time = 'ocean_time'; % added for roms 2.2
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

for d = 1:length(dimNames)
  dim = dimNames{d};
  len = dimLen{d};
  if     isequal(dim,dim_time) | ...
         isequal(dim,dim_oc_time), isTime    = 1; LenTime    = len; iTime    = d;
  elseif isequal(dim,dim_eta_rho), isEta_rho = 1; LenEta_rho = len; iEta_rho = d;
  elseif isequal(dim,dim_eta_u),   isEta_u   = 1; LenEta_u   = len; iEta_u   = d;
  elseif isequal(dim,dim_eta_v),   isEta_v   = 1; LenEta_v   = len; iEta_v   = d;
  elseif isequal(dim,dim_eta_psi), isEta_psi = 1; LenEta_psi = len; iEta_psi = d;
  elseif isequal(dim,dim_xi_rho),  isXi_rho  = 1; LenXi_rho  = len; iXi_rho  = d;
  elseif isequal(dim,dim_xi_u),    isXi_u    = 1; LenXi_u    = len; iXi_u    = d;
  elseif isequal(dim,dim_xi_v),    isXi_v    = 1; LenXi_v    = len; iXi_v    = d;
  elseif isequal(dim,dim_xi_psi),  isXi_psi  = 1; LenXi_psi  = len; iXi_psi  = d;
  elseif isequal(dim,dim_s_rho),   isS_rho   = 1; LenS_rho   = len; iS_rho   = d;
  elseif isequal(dim,dim_s_w),     isS_w     = 1; LenS_w     = len; iS_w     = d;
  end
end

% check input data:
% time:
if isTime
  if nargin < 4, disp('» bad number of arguments, t is required');
    close(nc);
    return
  elseif ~isnumber(t,1,'Z+') %t < 1
    disp('» t must be > 1');
    close(nc);
    return
  elseif t > LenTime
    fprintf(1,'» t = %g exceeds time dimension (%g)\n',t,LenTime);
    close(nc);
    return
  end
end

if nargin < 3
  disp('» bad number of arguments, z is required');
  close(nc);
  return
end

%set v extraction dimensions:
if isTime,     dimsv{iTime}    = num2str(t);                  end % dimsv2{iTime}    = dimsv{iTime};    end
if isEta_rho,  dimsv{iEta_rho} = ['1:',num2str(LenEta_rho) ]; end % dimsv2{iEta_rho} = dimsv{iEta_rho}; end
if isEta_u,    dimsv{iEta_u}   = ['1:',num2str(LenEta_u)   ]; end % dimsv2{iEta_u}   = dimsv{iEta_u};   end
if isEta_v,    dimsv{iEta_v}   = ['1:',num2str(LenEta_v)   ]; end % dimsv2{iEta_v}   = dimsv{iEta_v};   end
if isEta_psi,  dimsv{iEta_psi} = ['1:',num2str(LenEta_psi) ]; end % dimsv2{iEta_psi} = dimsv{iEta_psi}; end
if isXi_rho,   dimsv{iXi_rho}  = ['1:',num2str(LenXi_rho) ];  end % dimsv2{iXi_rho}  = dimsv{iXi_rho};  end
if isXi_u,     dimsv{iXi_u}    = ['1:',num2str(LenXi_u)   ];  end % dimsv2{iXi_u}    = dimsv{iXi_u};    end
if isXi_v,     dimsv{iXi_v}    = ['1:',num2str(LenXi_v)   ];  end % dimsv2{iXi_v}    = dimsv{iXi_v};    end
if isXi_psi,   dimsv{iXi_psi}  = ['1:',num2str(LenXi_psi) ];  end % dimsv2{iXi_psi}  = dimsv{iXi_psi};  end
if isS_rho,    dimsv{iS_rho}   = ['1:',num2str(LenS_rho)   ]; end % dimsv2{iS_rho}   = 'k';             end
if isS_w,      dimsv{iS_w}     = ['1:',num2str(LenS_w)     ]; end % dimsv2{iS_w}     = 'k';             end

dimsvSTR  = '(';
dimsvSTR2 = '(';
for d = 1:length(dimsv)
  dimsvSTR  = [dimsvSTR, dimsv{d}, ','];
%  dimsvSTR2 = [dimsvSTR2,dimsv2{d},','];
end
dimsvSTR  = [dimsvSTR(1:end-1), ')'];
%dimsvSTR2 = [dimsvSTR2(1:end-1),')'];

[n,tmp]=range_dims(dimsvSTR(2:end-1));
if ~n == 3 % horizontal z slice makes sense only for n = 3 !!
  fprintf(1,'» variable may have wrong dimensions, z slice is not possible, n = %g',n);
  close(nc)
  return
end

% best way to test z comp.:
if ~(isS_rho | isS_w)
  fprintf(1,'» variable %s has no z dependence\n',varname);
  close(nc)
  return
end

% --------------------------------------------------- extract x and y:
if n_varexist(file,'lon_rho'),    x = nc{'lon_rho'}(:,:);  labels.x='longitude';
elseif n_varexist(file,'x_rho'),  x = nc{'x_rho'}(:,:);    labels.x='distance x';
else  fprintf(1,'» lon_rho or x_rho do not exist\n'); close(nc), return, end

if n_varexist(file,'lat_rho'),    y = nc{'lat_rho'}(:,:);  labels.y='latitude';
elseif n_varexist(file,'y_rho'),  y = nc{'y_rho'}(:,:);    labels.y='distance y';
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
if n_varexist(file,'h'),  h = nc{'h'}(:,:);
else, fprintf(1,'» h is not present\n');    close(nc), return, end
if isXi_u | isXi_psi,   h = (h(:,2:end)+h(:,1:end-1))/2; end
if isEta_v | isEta_psi, h = (h(2:end,:)+h(1:end-1,:))/2; end

% get zeta:
if n_varexist(file,'zeta'),  zeta = nc{'zeta'}(t,:,:); % t, j, i
else, fprintf(1,'» zeta is not present\n'); close(nc), return, end
if isXi_u | isXi_psi,   zeta = (zeta(:,2:end)+zeta(:,1:end-1))/2; end
if isEta_v | isEta_psi, zeta = (zeta(2:end,:)+zeta(1:end-1,:))/2; end

[z_,zw_] = s_levels(h,tts,ttb,hc,N,zeta,0);
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
zUp   = reshape(z(iM),size(z,2),size(z,3));
zDown = reshape(z(im),size(z,2),size(z,3));
coefUp   = (zUp-depth)./(zUp-zDown);
coefDown = (depth-zDown)./(zUp-zDown);

% z not needed anymore:
z=repmat(depth,size(z,2),size(z,3));

% get variable:
str = ['v = nc{''',varname,'''}',dimsvSTR];
evalc(str,'');
v=squeeze(v);

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
