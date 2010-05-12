function [x,y,z,v,mask]=roms_slicej(fname,varname,ind,t,varargin)
%ROMS_SLICEJ   Make ROMS slice across xi direction (j=const)
%
%   Syntax:
%      [X,Y,Z,V,M] = ROMS_SLICEJ(FILE,VARNAME,J,T,VARARGIN)
%      V =  ROMS_SLICEJ(FILE,VARNAME,J,T,VARARGIN)
%
%   Inputs:
%      FILE      ROMS input/output file
%      VARNAME   Variable to extract (array with dimension
%      J         Indice in eta direction
%      T         Time indice
%      VARARGIN:
%         's_params': structure with fields: .tts, .ttb, .hc and .N
%            This data will be searched in the file by default
%         'theta_s', s-levels theta_s
%         'theta_b', s-levels theta_b
%         'hc', s-levels hc
%         'grid', grid filename
%         'plt', plot output flag, if 3 the 3d surf ouput will be shown
%           otherwise pcolor will be used. If output is 1d is shown
%           a plot for any plt~=0
%         'ax', axes where data will be displayed if plt
%
%   Outputs:
%      X   Position x (lon_rho or x_rho, at rho  or at u/v/psi points)
%      Y   Position y (lat_rho or y_rho, at rho  or at u/ v/psi points)
%      Z   Depth (at rho or w points)
%      V   Variable at slice
%      M   Mask
%
%   Examples:
%      file = 'ocean_his.nc';
%      varname = 'temp';      % 4-d array (I and T are required)
%      j = 50;
%      t = 10;
%      [x,y,z,v,mask]=roms_slicej(file,varname,j,t);
%      figure
%      surf(x,y,z,v);
%      figure
%      pcolor(y,z,v)
%
%      varname = 'ubar';    % 3-d array (I and T are required)
%      [x,y,z,v,mask]=roms_slicej(file,varname,j,t);
%      figure
%      plot3(x,y,v)
%
%      varname = 'h';       % 2-d array (I is required)
%      [x,y,z,v,mask]=roms_slicej(file,varname,i);
%      figure
%      plot3(x,y,-v)
%
%   MMA 8-2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   21-10-2010 - IO-USP

if nargin < 3
  fprintf(1,':: %s :: bad number of arguments\n',mfilename);
  return
end

sparams = [];
tts = [];
ttb = [];
hc  = [];
grd = [];
plt = 0;
ax = [];

vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'s_params')
    sparams = vin{i+1};
    if isfield(sparams,'tts') & isfield(sparams,'ttb') & isfield(sparams,'hc')  & isfield(sparams,'N')
      tts    = sparams.tts;
      ttb    = sparams.ttb;
      hc     = sparams.hc;
      N      = sparams.N;
    end
  elseif isequal(vin{i},'theta_s'), tts = vin{i+1};
  elseif isequal(vin{i},'theta_b'), ttb = vin{i+1};
  elseif isequal(vin{i},'hc'),      hc  = vin{i+1};
  elseif isequal(vin{i},'grid') | isequal(vin{i},'grd'), grd=vin{i+1};
  elseif isequal(vin{i},'plt'), plt=vin{i+1};
  elseif isequal(vin{i},'ax'),  ax=vin{i+1};
  end
end

% get grid filename:
if isempty(grd)
  grd=fname;
  if n_attexist(fname,'grd_file')
    grd_=n_att(fname,'grd_file');
    if exist(grd_)==2, grd=grd_; end
  end
end

% get the s parameters from the file or from grid file:
[tts_,ttb_,hc_,N] = s_params(fname);
if isempty(tts_) & ~isequal(grd,fname)
  [tts_,ttb_,hc_,N] = s_params(grd);
end
if isempty(tts), tts=tts_; end
if isempty(ttb), ttb=ttb_; end
if isempty(hc),  hc =hc_;  end

x = [];
y = [];
z = [];
v = [];
mask = [];

% check if variable exists:
if ~n_varexist(fname,varname)
  fprintf(1,':: %s :: variable %s not found in file %s\n',mfilename,varname,fname);
  return
end

% check time:
vdims=n_vardims(fname,varname);
dnames=keys(vdims);
dvalues=values(vdims);
ntimes  = 0;
if ismember('time',dnames), ntimes=vdims('time');
elseif ismember('ocean_time',dnames), ntimes=vdims('ocean_time');
end

if ntimes>0 & nargin < 4
  fprintf(1,':: %s :: bad number of arguments, t is required\n',mfilename);
  return
end

if ntimes>0 & t>ntimes
  fprintf(1,':: %s :: t = %g exceeds time dimension (%g)\n',mfilename,t,ntimes);
  return
end

% check ind:
ninds=0;
if ismember('eta_rho',dnames),   ninds=vdims('eta_rho');
elseif ismember('eta_u',dnames), ninds=vdims('eta_u');
elseif ismember('eta_v',dnames), ninds=vdims('eta_v');
end

if ind>ninds
  fprintf(1,':: %s :: ind = %g exceeds eta dimension (%g)\n',mfilename,ind,ninds);
  return
end

% check if 3d:
iszRho = ismember('s_rho', dnames);
iszW   = ismember('s_w',   dnames);

% extract variable:
s='';
for i=1:length(dnames)
  if isequal(dnames{i},'time') | isequal(dnames{i},'ocean_time')
    s=[s ',' num2str(t)];
  elseif isequal(dnames{i},'eta_rho') | isequal(dnames{i},'eta_u') | isequal(dnames{i},'eta_v')
    s=[s ',' num2str(ind)];
  else
    s=[s ',:'];
  end
end

s=['(' s(2:end) ')'];
nc=netcdf(fname);
evalc(['v = nc{''',varname,'''}' s]);
v=squeeze(v);

% extract x, y, h and mask:
[x,y,h,mask]=roms_grid(grd,varname(1),'eta',ind); mask1d=mask;

if nargout>1 | plt
  if iszRho
    x=repmat(x(:)',[N 1]);
    y=repmat(y(:)',[N 1]);
    mask=repmat(mask(:)',[N 1]);
  elseif iszW
    x=repmat(x(:)',[N+1 1]);
    y=repmat(y(:)',[N+1 1]);
    mask=repmat(mask(:)',[N+1 1]);
  end

  if iszRho | iszW
    % get zeta:
    if n_varexist(fname,'zeta'),  zeta = nc{'zeta'}(t,ind,:); % t, j, i
    else
      fprintf(1,':: %s : zeta is not present, using zeros\n',mfilename);
      zeta=zeros(size(h));
      %close(nc)
      %return
    end
    if ismember('xi_u',dnames) | ismember('xi_psi',dnames), zeta = (zeta(2:end)+zeta(1:end-1))/2; end

    [z,zw]=s_levels(h,tts,ttb,hc,N,zeta);
    if iszW, z=zw'; else, z=z'; end

  else
    % var has no vertical comp.
    z = zeros(size(x));
  end
else
  x=v;
end

% plt:
if plt
  vv=v;
  vv(mask==0)=nan;
  if ~isempty(ax)
    axes(ax);
  else
    figure, axes;
  end

  if prod(size(v))==length(v) % 1d
    plot(x,vv);
  else % 2d
    if plt==3
      p=plot_border3d(grd); hold on
      set(p.surfh,'edgecolor','none');
      view(3);
      camlight
      s=surf(x,y,z,vv); set(s,'edgecolor','none','facelighting','none');
      caxis([min(vv(:)) max(vv(:))]);
    else
      s=pcolor(x,z,vv); set(s,'edgecolor','none');
      hold on
      h(mask1d==0)=nan;
      zeta(mask1d==0)=nan;
      plot(x,-h);
      plot(x,zeta);
      colorbar
    end
  end
end
