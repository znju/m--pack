function [x,y,z,fv] = roms_sliceiso_(fname,varname,ind,t,varargin)
%ROMS_SLICEISO   Make ROMS isosurface
%
%   Syntax:
%      [X,Y,Z,FV] = ROMS_SLICEISO(FILE,VARNAME,IND,T,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
%      VARNAME   Variable to use
%      IND       Iso value
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
%         'zmin', min depth, data above this is not used
%         'zmax', max depth, data below is not used
%
%   Outputs:
%      X        Longitude of vertices
%      Y        Latitude of vertices
%      Z        Depth of vertices
%      FV       Faces and vertices
%
%   Example:
%      file = 'ocean_his.nc';
%      varname = 'salt';
%      ind = 36;
%      t = 10;
%      [x,y,z,fv]=roms_sliceiso(file,varname,ind,t);
%      figure
%      p = patch(fv);
%      set(p,'facecolor','b','edgecolor','none')
%      camlight, view(3)
%
%   MMA 8-2005, martinho@fis.ua.pt
%
%   See also ROMS_SLICE

%   Department of Physics
%   University of Aveiro, Portugal

%   Latest version, aug-2010

sparams = [];
Zmin=[];
Zmax=[];
tts = [];
ttb = [];
hc  = [];
grd = [];
plt = 0;
ax = [];
proj = 'mercator';

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

  elseif isequal(vin{i},'zmin'), Zmin = vin{i+1};
  elseif isequal(vin{i},'zmax'), Zmax = vin{i+1};
  elseif isequal(vin{i},'theta_s'), tts = vin{i+1};
  elseif isequal(vin{i},'theta_b'), ttb = vin{i+1};
  elseif isequal(vin{i},'hc'),      hc  = vin{i+1};
  elseif isequal(vin{i},'grid') | isequal(vin{i},'grd'), grd=vin{i+1};
  elseif isequal(vin{i},'plt'),  plt=vin{i+1};
  elseif isequal(vin{i},'ax'),   ax=vin{i+1};
  elseif isequal(vin{i},'proj'), proj=vin{i+1};
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

% get the s parameters from the file:
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
fv = [];
mask = [];

if nargin < 2
fprintf(1,':: %s :: bad number of arguments\n',mfilename);
  return
end

if ~isnumber(ind,1)
  disp('» bad ind input argument');
  return
end


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

% check if 3d:
iszRho = ismember('s_rho', dnames);
iszW   = ismember('s_w',   dnames);
if ~iszRho & ~iszW
  fprintf(1,':: %s :: %s has no s (vertical) dimension\n',mfilename,varname);
  return
end

% extract variable:
s='';
for i=1:length(dnames)
  if isequal(dnames{i},'time') | isequal(dnames{i},'ocean_time')
    s=[s ',' num2str(t)];
  else
    s=[s ',:'];
  end
end

s=['(' s(2:end) ')'];
nc=netcdf(fname);
evalc(['v = nc{''',varname,'''}' s]);
v=squeeze(v);

% extract x, y, h and mask:
[x,y,h,mask]=roms_grid(grd,varname(1));

% s_levels:
% get zeta:
if n_varexist(fname,'zeta'),  zeta = nc{'zeta'}(t,:,:); % t, j, i
else
  fprintf(1,':: %s : zeta is not present, using zeros\n',mfilename);
  zeta=zeros(size(h));
  %close(nc)
  %return
end
if ismember('xi_u',dnames)  | ismember('xi_psi',dnames),  zeta = (zeta(:,2:end)+zeta(:,1:end-1))/2; end
if ismember('eta_v',dnames) | ismember('eta_psi',dnames), zeta = (zeta(2:end,:)+zeta(1:end-1,:))/2; end

[z,zw]=s_levels(h,tts,ttb,hc,N,zeta);
if iszW, z=zw; end

% isosurface:
xx = repmat(x,[1 1 N]);
yy = repmat(y,[1 1 N]);
v = shiftdim(v,1);

if ~isempty(Zmin)
  i=find(z>-Zmin);
  v(i)=nan;
end

if ~isempty(Zmax)
  i=find(z<-Zmax);
  v(i)=nan;
end

fv = isosurface(xx,yy,z,zero2nan(v),ind);

fvv = fv.vertices;
if ~isempty(fvv)
  x = fvv(:,1);
  y = fvv(:,2);
  z = fvv(:,3);
end


% plt
if plt
  if ~isempty(ax)
    axes(ax);
  else
    figure, axes;
  end

  p=plot_border3d(grd); hold on
  set(p.surfh,'edgecolor','none');
  view(3);
  camlight

  p = patch(fv);
  set(p,'facecolor','b','edgecolor','none')
end
