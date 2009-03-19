function varargout=pom_s_levels(varargin)
%POM_S_LEVELS   Get POM vertical s-coordinates levels
%
%   Syntax:
%      N         = POM_S_LEVELS(DATAFILE)
%      [Z_R,Z_W] = POM_S_LEVELS(DATAFILE,H,ZETA,FLIPZ)
%      [Z_R,Z_W] = POM_S_LEVELS(ZZ,Z,H,ZETA,FLIPZ)
%      [Z_R,Z_W] = POM_S_LEVELS(OUTFILE,TIME,FLIPZ)
%
%   Inputs:
%      DATAFILE POM depths text file
%      H        Depths
%      ZETA     Surface elevation
%      FLIPZ    Revert depths flag (default=0)
%      ZZ       POM zz
%      Z        POM z
%      OUTFILE  POM output file
%      TIME     Time indice
%
%   Outputs:
%      N     Number of internal levels
%      Z_R   Vertical S-coordinate depths at RHO-points
%      Z_W   Vertical S-coordinate depths at W-points
%
%   MMA  xx-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

nskip=1;

if length(varargin)==1
  datafile=varargin{1};
  [sr,sw] = z_fromfile(datafile,nskip);
  varargout={length(sr)};
  return
end

if isstr(varargin{1})
  fname=varargin{1};
  if isnc(fname)
    % get all data from netcdf file
    time = varargin{2};
    sw  = use(fname,'z');
    sr  = use(fname,'zz'); srSub=sr(end);  sr=sr(1:end-1);
    ssh = use(fname,'elb','time',time);
    h   = use(fname,'h');
    if nargin<3, flipZ=0;
    else, flipZ=varargin{3};end
  else
    % get sw and sr from text file
    datafile = fname;
    h        = varargin{2};
    ssh      = varargin{3};
    if nargin<4, flipZ=0;
    else, flipZ=varargin{4};end
    [sr,sw] = z_fromfile(datafile,nskip);
    srSub=sr(end);  sr=sr(1:end-1);
  end
else
  sr  = varargin{1}; srSub=sr(end);  sr=sr(1:end-1);
  sw  = varargin{2};
  h   = varargin{3};
  ssh = varargin{4};
  if nargin<5, flipZ=0;
  else, flipZ=varargin{5};end
end

if flipZ
  sr=flipud(sr(:));
  sw=flipud(sw(:));
end

for i=1:length(sr)
  zr(:,:,i)=sr(i)*(h+ssh) + ssh;
  zw(:,:,i)=sw(i)*(h+ssh) + ssh;
end
i=i+1;
zw(:,:,i)=sw(i)*(h+ssh) + ssh;

zrSubSurface=srSub*(h+ssh) + ssh;

varargout{1}=zr;
varargout{2}=zw;
varargout{3}=zrSubSurface;


function [sr,sw] = z_fromfile(fname,nskip)
fid=fopen(fname);

if nskip
  for i=1:nskip, fgetl(fid); end
end

% read data:
cont=0;
while 1
  cont=cont+1;
  tline = fgetl(fid);
  if isequal(tline,-1) | isempty(str2num(tline)), break, end
  data(cont,:)=str2num(tline);
end

sr=data(:,3);
sw=data(:,2);
fclose(fid);
