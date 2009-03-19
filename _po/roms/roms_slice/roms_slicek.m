function [x,y,z,v,labels]=roms_slicek(file,varname,k,t,varargin)
%ROMS_SLICEK   Make ROMS slice at s-level (k=const)
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICEK(FILE,VARNAME,K,T,VARARGIN)
%      V = ROMS_SLICEK(FILE,VARNAME,K,T,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
%      VARNAME   Variable to extract (array or dimension >= 2)
%      K         S-level indice
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
%      X         Position x (lon_rho or x_rho, at rho, u, v or psi points)
%      Y         Position y (lat_rho or y_rho, at rho, u, v or psi points)
%      Z         Depth (at rho or w points)
%      V         Variable at slice
%      LABELS    Names of variables X, Y and Z
%
%   Examples:
%      file = 'ocean_his.nc';
%      varname = 'temp';      % 4-d array (I and T are required)
%      k = 15;
%      t = 10;
%      params.tts = 5;
%      params.ttb = .3;
%      params.hc  = 10;
%      params.N   = 20;
%      [x,y,z,v,labels]=roms_slicek(file,varname,k,t,'s_params',params);
%      figure
%      surf(x,y,z,v);
%      figure
%      pcolor(x,y,v)
%
%      varname = 'ubar';    % 3-d array (T is required)
%      [x,y,z,v,labels]=roms_slicek(file,varname,'whatever...',t);
%      figure
%      pcolor(x,y,v)
%
%      varname = 'h';       % 2-d array (no t or k required)
%      [x,y,z,v,labels]=roms_slicek(file,varname);
%      figure
%      pcolor(x,y,-v)
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See also ROMS_SLICE, S_LEVELS

%   Department of Physics
%   University of Aveiro, Portuga

%   ??-02-2005 - Improved
%   05-07-2005 - Changed to allow roms2.2

sparams = [];
vin = varargin;
for ii=1:length(vin)
  if isequal(vin{ii},'s_params')
    sparams = vin{ii+1};
    if    isfield(sparams,'tts') & isfield(sparams,'ttb') & isfield(sparams,'hc')  & isfield(sparams,'N')
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
dims = n_vardim(file,varname);
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
  elseif ~isnumber(t,1,'Z+')% < 1
    disp('» t must be > 1');
    close(nc);
    return
  elseif t > LenTime
    fprintf(1,'» t = %g exceeds time dimension (%g)\n',t,LenTime);
    close(nc);
    return
  end
end
 
% k:
if isS_rho | isS_w
  if nargin < 3
    disp('» bad number of arguments, k is required');
    close(nc);
    return
  elseif ~isnumber(k,1,'Z+') %k < 1
    disp('» k must be > 1');
    close(nc);
    return
  elseif (isS_rho & k > LenS_rho) | (isS_w & k > LenS_w)
    if     isS_rho, kmax = LenS_rho;
    elseif isS_w,   kmax = LenS_w;
    end
    fprintf(1,'» k = %g exceeds S dimension (%g)\n',k,kmax);
    close(nc);
    return
  end
end

%set v extraction dimensions:
if isTime,     dimsv{iTime}    = num2str(t);                   end
if isEta_rho,  dimsv{iEta_rho} = ['1:',num2str(LenEta_rho) ];  end
if isEta_u,    dimsv{iEta_u}   = ['1:',num2str(LenEta_u)   ];  end
if isEta_v,    dimsv{iEta_v}   = ['1:',num2str(LenEta_v)   ];  end
if isEta_psi,  dimsv{iEta_psi} = ['1:',num2str(LenEta_psi) ];  end
if isXi_rho,   dimsv{iXi_rho}  = ['1:',num2str(LenXi_rho)  ];  end
if isXi_u,     dimsv{iXi_u}    = ['1:',num2str(LenXi_u)    ];  end
if isXi_v,     dimsv{iXi_v}    = ['1:',num2str(LenXi_v)    ];  end
if isXi_psi,   dimsv{iXi_psi}  = ['1:',num2str(LenXi_psi)  ];  end
if isS_rho,    dimsv{iS_rho}   = num2str(k);                   end
if isS_w,      dimsv{iS_w}     = num2str(k);                   end

dimsvSTR = '(';
for d = 1:length(dimsv)
  dimsvSTR = [dimsvSTR,dimsv{d},','];
end
dimsvSTR = [dimsvSTR(1:end-1),')'];

n=n_vararraydim(dimsvSTR(2:end-1));
if n ~= 2
  fprintf(1,'» variable extracted is not a 2-d array, n = %g',n);
  close(nc)
  return
end

% --------------------------------------------------- extract x:
if n_varexist(file,'lon_rho'),    x = nc{'lon_rho'}(:); labels.x='lon_rho';
elseif n_varexist(file,'x_rho'),  x = nc{'x_rho'}(:);   labels.x='x_rho';
else  fprintf(1,'» lon_rho or x_rho do not exist\n'); close(nc), return, end

if isXi_u | isXi_psi
  x = (x(:,2:end)+x(:,1:end-1))/2;
end
if     isXi_u,   labels.x=[labels.x,' at u'];
elseif isXi_psi, labels.x=[labels.x,' at psi'];
end

if isEta_v | isEta_psi
  x = (x(2:end,:)+x(1:end-1,:))/2;
end
if     isEta_v,   labels.x=[labels.x,' at v'];
elseif isEta_psi, labels.x=[labels.x,' at psi'];
end

if isXi_psi & isEta_psi
  labels.x = strrep(labels.x,' at psi','');
  labels.x=[labels.x,' at psi'];
end

% --------------------------------------------------- extract y:
if n_varexist(file,'lat_rho'),    y = nc{'lat_rho'}(:); labels.y='lat_rho';
elseif n_varexist(file,'y_rho'),  y = nc{'y_rho'}(:);   labels.y='y_rho';
else  fprintf(1,'» lat_rho or y_rho do not exist\n'); close(nc), return, end

if isXi_u | isXi_psi
  y = (y(:,2:end)+y(:,1:end-1))/2;
end
if     isXi_u,   labels.y=[labels.y,' at u'];
elseif isXi_psi, labels.y=[labels.y,' at psi'];
end

if isEta_v | isEta_psi
  y = (y(2:end,:)+y(1:end-1,:))/2;
end
if     isEta_v,   labels.y=[labels.y,' at v'];
elseif isEta_psi, labels.y=[labels.y,' at psi'];
end

if isXi_psi & isEta_psi
  labels.y = strrep(labels.y,' at psi','');
  labels.y=[labels.y,' at psi'];
end

% --------------------------------------------------- extract z:

if isS_rho | isS_w
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

  [z,zw]=s_levels(h,tts,ttb,hc,N,zeta,0);
  if isS_w
    z = zw;
  end
  z = squeeze(z(:,:,k));
else
  % var has no vertical comp.
  z = zeros(size(x));
end

labels.z = 'depth';

% ------------------------------------------------------- extract v:
str=['v=nc{''',varname,'''}',dimsvSTR];
evalc(str,'');
v=squeeze(v);

close(nc)

if nargout == 1
  x = v;
end
