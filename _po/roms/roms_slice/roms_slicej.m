function [x,y,z,v,labels]=roms_slicej(file,varname,j,t,varargin)
%ROMS_SLICEJ   Make ROMS slice across xi direction (j=const)
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICEJ(FILE,VARNAME,J,T,VARARGIN)
%      V = ROMS_SLICEJ(FILE,VARNAME,J,T,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
%      VARNAME   Variable to extract (array or dimension >= 2)
%      J         Indice in eta direction
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
%      X         Position x (lon_rho or x_rho, at rho  or at u/psi points)
%      Y         Position y (lat_rho or y_rho, at rho  or at u/psi points)
%      Z         Depth (at rho or w points)
%      V         Variable at slice
%      LABELS    Names of variables X, Y and Z
%
%   Examples:
%      file = 'ocean_his.nc';
%      varname = 'temp';      % 4-d array (J and T are required)
%      j = 50;
%      t = 10;
%      params.tts = 5;
%      params.ttb = .3;
%      params.hc  = 10;
%      params.N   = 20;
%      [x,y,z,v,labels]=roms_slicej(file,varname,j,t,'s_params',params);
%      figure
%      surf(x,y,z,v);
%      figure
%      pcolor(y,z,v)
%
%      varname = 'ubar';    % 3-d array (J and T are required)
%      [x,y,z,v,labels]=roms_slicej(file,varname,j,t);
%      figure
%      plot3(x,y,v)
%
%      varname = 'h';       % 2-d array (J is required)
%      [x,y,z,v,labels]=roms_slicej(file,varname,j);
%      figure
%      plot3(x,y,-v)
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See also ROMS_SLICE, S_LEVELS

%   Department of Physics
%   University of Aveiro, Portugal

%   ??-02-2005 - Improved
%   05-07-2005 - Changed to allow roms2.2

sparams = [];
grd='';
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
  elseif isequal(vin{ii},'grid')
    grd= vin{ii+1};
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

% j:
if isEta_rho | isEta_u | isEta_v | isEta_psi
  if nargin < 3
    disp('» bad number of arguments, j is required');
    close(nc);
    return
  elseif ~isnumber(j,1,'Z+') %j < 1
   disp('» j must be > 1');
    close(nc);
    return
  elseif (isEta_rho & j > LenEta_rho) | (isEta_u & j > LenEta_u) | (isEta_v & j > LenEta_v+1) | (isEta_psi & j > LenEta_psi+1)
    % allow here exctract at rho points, means v an j = end+1
    if     isEta_rho, jmax = LenEta_rho;
    elseif isEta_u,   jmax = LenEta_u;
    elseif isEta_v,   jmax = LenEta_v+1;
    elseif isEta_psi, jmax = LenEta_psi+1;
    end
    fprintf(1,'» j = %g exceeds Eta dimension (%g)\n',j,jmax);
    close(nc);
    return
  end
end

%set v extraction dimensions:
if isTime,     dimsv{iTime}    = num2str(t);                   dimsv2{iTime}    = dimsv{iTime};    end
if isEta_rho,  dimsv{iEta_rho} = num2str(j);                   dimsv2{iEta_rho} = num2str(j-1);    end
if isEta_u,    dimsv{iEta_u}   = num2str(j);                   dimsv2{iEta_u}   = num2str(j-1);    end
if isEta_v,    dimsv{iEta_v}   = num2str(j);                   dimsv2{iEta_v}   = num2str(j-1);    end
if isEta_psi,  dimsv{iEta_psi} = num2str(j);                   dimsv2{iEta_psi} = num2str(j-1);    end
if isXi_rho,   dimsv{iXi_rho}  = ['1:',num2str(LenXi_rho) ];   dimsv2{iXi_rho}  = dimsv{iXi_rho};  end
if isXi_u,     dimsv{iXi_u}    = ['1:',num2str(LenXi_u)   ];   dimsv2{iXi_u}    = dimsv{iXi_u};    end
if isXi_v,     dimsv{iXi_v}    = ['1:',num2str(LenXi_v)   ];   dimsv2{iXi_v}    = dimsv{iXi_v};    end
if isXi_psi,   dimsv{iXi_psi}  = ['1:',num2str(LenXi_psi) ];   dimsv2{iXi_psi}  = dimsv{iXi_psi};  end
if isS_rho,    dimsv{iS_rho}   = ['1:',num2str(LenS_rho)   ];  dimsv2{iS_rho}   = dimsv{iS_rho};   end
if isS_w,      dimsv{iS_w}     = ['1:',num2str(LenS_w)     ];  dimsv2{iS_w}     = dimsv{iS_w};     end

dimsvSTR  = '(';
dimsvSTR2 = '(';
for d = 1:length(dimsv)
  dimsvSTR  = [dimsvSTR, dimsv{d}, ','];
  dimsvSTR2 = [dimsvSTR2,dimsv2{d},','];
end
dimsvSTR  = [dimsvSTR(1:end-1), ')'];
dimsvSTR2 = [dimsvSTR2(1:end-1),')'];

[n,tmp]=range_dims(dimsvSTR(2:end-1));
if ~(n == 2 | n == 1) % allow here 1-d arrays, to make slices in bathy, for instance
  fprintf(1,'» variable extracted is not a 2-d or 1-d array, n = %g',n);
  close(nc)
  return
end

% --------------------------------------------------- extract x:
ncg=netcdf(grd);

if n_varexist(grd,'lon_rho'),    x = ncg{'lon_rho'}(j,:);  labels.x='lon_rho';
elseif n_varexist(grd,'x_rho'),  x = ncg{'x_rho'}(j,:);    labels.x='x_rho';
else  fprintf(1,'» lon_rho or x_rho do not exist\n'); close(nc), close(ncg), return, end

if isXi_u | isXi_psi
  x = (x(2:end)+x(1:end-1))/2;
end
if     isXi_u,   labels.x=[labels.x,' at u'];
elseif isXi_psi, labels.x=[labels.x,' at psi'];
end

% --------------------------------------------------- extract y:
if n_varexist(grd,'lat_rho'),    y = ncg{'lat_rho'}(j,:);  labels.y='lat_rho';
elseif n_varexist(grd,'y_rho'),  y = ncg{'y_rho'}(j,:);    labels.y='y_rho';
else  fprintf(1,'» lat_rho or y_rho do not exist\n'); close(nc), close(ncg), return, end

if isXi_u | isXi_psi
  y = (y(2:end)+y(1:end-1))/2;
end

if     isXi_u,   labels.y=[labels.y,' at u'];
elseif isXi_psi, labels.y=[labels.y,' at psi'];
end

% ----------------------------------------------------- extract z: (depth)

if isS_rho | isS_w
  % get h:
  if n_varexist(grd,'h'),  h = ncg{'h'}(j,:);
  else, fprintf(1,'» h is not present\n');    close(nc), close(ncg), return, end
  if isXi_u | isXi_psi, h = (h(2:end) + h(1:end-1))/2; end

  % get zeta:
  if n_varexist(file,'zeta'),  zeta = nc{'zeta'}(t,j,:);
  else, fprintf(1,'» zeta is not present\n'); close(nc), return, end
  if isXi_u | isXi_psi, zeta=(zeta(2:end) + zeta(1:end-1))/2; end

  [z,zw]=s_levels(h,tts,ttb,hc,N,zeta,0);
  if isS_w
    z = zw;
  end
else
  % var has no vertical comp.
  z = zeros(size(x));
end

labels.z = 'depth';

close(ncg);
% ------------------------------------------------------- extract v:
if isEta_rho | isEta_u
  str = ['v = nc{''',varname,'''}',dimsvSTR];
  evalc(str,'');
  v=squeeze(v);
elseif isEta_v | isEta_psi
  if j == 1  % first indice (at rho)
    str = ['v = nc{''',varname,'''}',dimsvSTR];
    evalc(str,'');
    v=squeeze(v);
  elseif (isEta_v & j == LenEta_v+1) | (isEta_psi & j == LenEta_psi+1) % last indice at rho, use previous at v
    str = ['v = nc{''',varname,'''}',dimsvSTR2];
    evalc(str,'');
    v=squeeze(v);
  else
   str  = ['v  = nc{''',varname,'''}',dimsvSTR];
    str2 = ['v2 = nc{''',varname,'''}',dimsvSTR2];
    evalc(str,'');
    evalc(str2,'');
    v=squeeze(v);
    v2=squeeze(v2);
    v=(v+v2)/2;
  end
end

close(nc);

if n==2
  v=v';
  x=repmat(x',1,size(v,2));
  y=repmat(y',1,size(v,2));
end

if nargout == 1
  x = v;
end
