function [x,y,z,v,labels]=roms_slicelat(file,varname,lat,t,varargin)
%ROMS_SLICELAT   Make ROMS slice across meridional direction (lat=const)
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICELAT(FILE,VARNAME,LAT,T,VARARGIN)
%      V = ROMS_SLICELAT(FILE,VARNAME,LAT,T,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
%      VARNAME   Variable to extract (array or dimension >= 2)
%      LAT       Latitude [ lat [npts] ] (npts = number of points to
%                Use in interpolation [ 100 ]
%      T         Time indice
%      VARARGIN:
%         'zero2nan',[0 {1}]   if 1, zeros are converted to nan before
%            griddata interpolation (it is done by default)
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
%      Z         Depth (at rho or w points)
%      V         Variable at slice
%      LABELS    Names of variables X, Y and Z
%
%   Examples:
%      file = 'ocean_his.nc';
%      varname = 'temp';      % 4-d array
%      lat = [40 30]; % use interpolation at 30 points
%      t = 10;
%      params.tts = 5;
%      params.ttb = .3;
%      params.hc  = 10;
%      params.N   = 20;
%      [x,y,z,v,labels]=roms_slicelat(file,varname,lat,t,'s_params',params);
%      figure
%      surf(x,y,z,v);
%      figure
%      pcolor(x,z,v)
%
%      varname = 'ubar';    % 3-d array
%      [x,y,z,v,labels]=roms_slicelat(file,varname,lat,t);
%      figure
%      plot3(x,y,v)
%
%      varname = 'h';       % 2-d array
%      [x,y,z,v,labels]=roms_slicelat(file,varname,lat);
%      figure
%      plot3(x,y,-v)
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See also ROMS_SLICE, S_LEVELS

%   Department of Physics
%   University of Aveiro, Portugal

%   ??-02-2005 - Improved
%   24-07-2005 - Changed to allow roms2.2

x        = [];
y        = [];
z        = [];
v        = [];
labels.x = [];
labels.y = [];
labels.z = [];

if ~isnumber(lat,1) & ~isnumber(lat,2)
  disp('» bad lat input arguments');
  return
end

nLAT= 100;
if nargin >= 3
  evalc('nLAT = lat(2);','');
  lat=lat(1);
end

griddataMethod = 'cubic';

sparams    = [];
dozero2nan = 1;
vin = varargin;
for ii=1:length(vin)
  if isequal(vin{ii},'zero2nan')
    dozero2nan = vin{ii+1};
  end
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

if nargin < 3
  disp('» bad number of arguments, lon is required');
  close(nc);
  return
end

%set v extraction dimensions:
if isTime,     dimsv{iTime}    = num2str(t);                   dimsv2{iTime}    = dimsv{iTime};    end
if isEta_rho,  dimsv{iEta_rho} = ['1:',num2str(LenEta_rho) ];  dimsv2{iEta_rho} = dimsv{iEta_rho}; end
if isEta_u,    dimsv{iEta_u}   = ['1:',num2str(LenEta_u)   ];  dimsv2{iEta_u}   = dimsv{iEta_u};   end
if isEta_v,    dimsv{iEta_v}   = ['1:',num2str(LenEta_v)   ];  dimsv2{iEta_v}   = dimsv{iEta_v};   end
if isEta_psi,  dimsv{iEta_psi} = ['1:',num2str(LenEta_psi) ];  dimsv2{iEta_psi} = dimsv{iEta_psi}; end
if isXi_rho,   dimsv{iXi_rho}  = ['1:',num2str(LenXi_rho) ];   dimsv2{iXi_rho}  = dimsv{iXi_rho};  end
if isXi_u,     dimsv{iXi_u}    = ['1:',num2str(LenXi_u)   ];   dimsv2{iXi_u}    = dimsv{iXi_u};    end
if isXi_v,     dimsv{iXi_v}    = ['1:',num2str(LenXi_v)   ];   dimsv2{iXi_v}    = dimsv{iXi_v};    end
if isXi_psi,   dimsv{iXi_psi}  = ['1:',num2str(LenXi_psi) ];   dimsv2{iXi_psi}  = dimsv{iXi_psi};  end
if isS_rho,    dimsv{iS_rho}   = ['1:',num2str(LenS_rho)   ];  dimsv2{iS_rho}   = 'k';             end
if isS_w,      dimsv{iS_w}     = ['1:',num2str(LenS_w)     ];  dimsv2{iS_w}     = 'k';             end

dimsvSTR  = '(';
dimsvSTR2 = '(';
for d = 1:length(dimsv)
  dimsvSTR  = [dimsvSTR, dimsv{d}, ','];
  dimsvSTR2 = [dimsvSTR2,dimsv2{d},','];
end
dimsvSTR  = [dimsvSTR(1:end-1), ')'];
dimsvSTR2 = [dimsvSTR2(1:end-1),')'];

[n,tmp]=range_dims(dimsvSTR(2:end-1));
if ~(n == 2 | n == 3) % allow here 1-d arrays, to make slices in bathy, for instance
  fprintf(1,'» variable extracted is not a 2-d or 1-d array, n = %g',n);
  close(nc)
  return
end

% --------------------------------------------------- extract x and y:
if n_varexist(file,'lon_rho'),    X = nc{'lon_rho'}(:,:);  labels.x='longitude';
elseif n_varexist(file,'x_rho'),  X = nc{'x_rho'}(:,:);    labels.x='distance x';
else  fprintf(1,'» lon_rho or x_rho do not exist\n'); close(nc), return, end

if n_varexist(file,'lat_rho'),    Y = nc{'lat_rho'}(:,:);  labels.y='longitude';
elseif n_varexist(file,'y_rho'),  Y = nc{'y_rho'}(:,:);    labels.y='distance y';
else  fprintf(1,'» lat_rho or y_rho do not exist\n'); close(nc), return, end

if isXi_u | isXi_psi
  X = (X(:,2:end)+X(:,1:end-1))/2;
  Y = (Y(:,2:end)+Y(:,1:end-1))/2;
end
if isEta_v | isEta_psi
  X = (X(2:end,:)+X(1:end-1,:))/2;
  Y = (Y(2:end,:)+Y(1:end-1,:))/2;
end

y = lat;
x = linspace(min(min(X)),max(max(X)),nLAT);

% ----------------------------------------------------- extract z: (depth)

if isS_rho | isS_w
  % get h:
  if n_varexist(file,'h'),  H = nc{'h'}(:,:);
  else, fprintf(1,'» h is not present\n');    close(nc), return, end
  if isXi_u | isXi_psi,   H = (H(:,2:end)+H(:,1:end-1))/2; end
  if isEta_v | isEta_psi, H = (H(2:end,:)+H(1:end-1,:))/2; end
  h = griddata(X,Y,H,x,y,griddataMethod);

  % get zeta:
  if n_varexist(file,'zeta'),  ZETA = nc{'zeta'}(t,:,:); % t, j, i
  else, fprintf(1,'» zeta is not present\n'); close(nc), return, end
  if isXi_u | isXi_psi,   ZETA = (ZETA(:,2:end)+ZETA(:,1:end-1))/2; end
  if isEta_v | isEta_psi, ZETA = (ZETA(2:end,:)+ZETA(1:end-1,:))/2; end
  zeta = griddata(X,Y,ZETA,x,y,griddataMethod);

  [z,zw]=s_levels(h,tts,ttb,hc,N,zeta,0);
  if isS_w
    z = zw;
  end
else
  % var has no vertical comp.
  z = zeros(size(x));
end

labels.z = 'depth';

% ------------------------------------------------------- extract v:
if isS_rho | isS_w
  if isS_rho
    K = LenS_rho;
  elseif isS_w
    K = LenS_w;
  end

  wb = waitbar(0,'slice lat, Please wait...');
  for k =1:K
    str = ['V = nc{''',varname,'''}',dimsvSTR2];
    evalc(str,'');
    V=squeeze(V);
    if dozero2nan, V(V==0)=nan; end
    v(k,:) = griddata(X,Y,V,x,y,griddataMethod);
    waitbar(k/K,wb);
  end
  close(wb);

else
  str = ['V = nc{''',varname,'''}',dimsvSTR];
  evalc(str,'');
  V=squeeze(V);
  v = griddata(X,Y,V,x,y,griddataMethod);
end

close(nc)

v = v';
y = repmat(y,size(x));

% find points outside region:
[XB,YB]= roms_border(file); % region border
i=inpolygon(x,y,XB,YB);

y = repmat(y',1,size(v,2));
x = repmat(x',1,size(v,2));

if n == 2
  z=z';
end

% set points outside region as nan:
v(i==0,:) = nan;


if nargout == 1
  x = v;
end
