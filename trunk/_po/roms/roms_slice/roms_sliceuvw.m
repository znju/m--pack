function [x,y,z,v,labels]=roms_sliceuvw(file,type,ind,t,varargin)
%ROMS_SLICEUVW   Get velocity field at ROMS slice
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICEUVW(FILE,TYPE,I,T,VARARGIN)
%
%   Inputs:
%      FILE   ROMS output file
%      TYPE   Type of slice:
%               - slicei,   variables v and w
%               - slicelon,           v and w
%               - slicej,             u and w
%               - slicelat            u and w
%               - slicek              u and v
%               - slicekbar           ubar and vbar
%               - slicez              u and v
%      I      Indice:
%               - slicei:    indice in xi direction
%               - slicelon:  longitude [ lon [npts] ]
%               - slicej:    indice in eta direction
%               - slicelat:  latitude [ lat [npts] ]
%               - slicek:    S-level indice
%               - slicekbar: any, z will be zeros
%               - slicez:    depth (negative below zero)
%      T      Time indice
%      VARARGIN:
%         'zero2nan',[0 {1}]   if 1, zeros are converted to nan before
%            griddata interpolation (it is done by default) and used
%            only with the slicelon and slicelat types
%         's_params': structure with fields: .tts, .ttb, .hc and .N
%            These are required to calc z and so, are not always needed
%            They will be used by the function S_LEVELS when needed.
%            If this structure is not entered or any of its fields is
%            missing then the function S_PARAMS will look for this data
%            in the file
%
%   Outputs:
%      X        Position x
%      Y        Position y
%      Z        Depth
%      V        Variable at slice (u+iv)
%      LABELS   Names of variables X, Y and Z
%
%   Comment:
%      If the variable w is not present in the file, it is used as
%      zero. It is the case of (currently) ROMS-AGRIF output.
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See also ROMS_SLICE, S_LEVELS

%   Department of Physics
%   University of Aveiro, Portugal

%   ??-02-2005 - Improved
%   8-6-2008 -  rotate uv by rid angle

%           type           |  variables |   points  |
% -------------------------|------------|-----------|
%      slicei, slicelon    |   v, w     |     v     |
% -------------------------|------------|-----------|
%      slicej, slicelat    |   u, w     |     u     |
% -------------------------|------------|-----------|
%      slicek              |   u, v     |    psi    |
%      slice_kbar          | ubar, vbar |    psi    |
% -------------------------|------------|-----------|
%     slicez               |    u, v    |    psi    |
% -------------------------|------------|-----------|

% deal with lack of variable w:
% it is used as zeros (see bellow)
WisPresent = 1;
if ismember(type,{'slicei','slicelon','slicej','slicelat'}) & ~n_varexist(file,'w')
  WisPresent = 0;
  fprintf(1,'### Variable w is not present in file, using zeros\n');
end
% --------------------------------------------------------------------

vars_i_lon = {'v',    'w'   };
vars_j_lat = {'u',    'w'   };
vars_kz    = {'u',    'v'   };
vars_kbar  = {'ubar', 'vbar'};

use_griddata = 0; % so, use average
method = 'cubic'; % linear(default), cubic, nearest, v4

% warning:
%         It is not correct just make average in the vertical at slices i, j, lon and lat,
%         cos u and v points are not exactly between the w points (in the vertical),
%         so, griddata shold be used if case of bad results, like in case of bad vertical
%         resolution
%         in the slices z and k, the averages for x,y,z, u and v are more
%         acceptable cos deals with horizontal resolution

% --------------------------------------------------------------------
% slice i
% --------------------------------------------------------------------
if isequal(type,'slicei')
  % load vars:
  v = vars_i_lon{1};
  w = vars_i_lon{2};
  [xv,yv,zv,v,labelsv] = roms_slicei(file,v,ind,t,varargin{:});
  if WisPresent
    [xw,yw,zw,w,labelsw] = roms_slicei(file,w,ind,t,varargin{:});

    % get w at v points:
    if use_griddata
      [w_at_v] = griddata(yw,zw,w,yv,zv,method);
    else
      ww     = (w(2:end,:)+w(1:end-1,:))/2;
      w_at_v = (ww(:,2:end)+ww(:,1:end-1))/2;
    end
  else
    w_at_v = zeros(size(v));
  end % Wispresent

  % output:
  x = xv;
  y = yv;
  z = zv;
  v = v+sqrt(-1)*w_at_v;

  % labels:
  labels = labelsv;
end

% --------------------------------------------------------------------
% slice lon
% --------------------------------------------------------------------
if isequal(type,'slicelon')
  % load vars:
  v = vars_i_lon{1};
  w = vars_i_lon{2};

  % better make averaage also along eta, so should have v in less one point than w:
  eval('nLONw = ind(2);','nLONw = 100;');
  nLONv = nLONw-1;

  indv = [ind(1) nLONv];
  indw = [ind(1) nLONw];

  [xv,yv,zv,v,labelsv] = roms_slicelon(file,v,indv,t,varargin{:});
  if WisPresent
    [xw,yw,zw,w,labelsw] = roms_slicelon(file,w,indw,t,varargin{:});

    % get w at v points:
    if use_griddata
      [w_at_v] = griddata(yw,zw,w,yv,zv,method);
    else
      ww     = (w(2:end,:)+w(1:end-1,:))/2;   % this average can be maade cos of using nLONv ~= nLONw
      w_at_v = (ww(:,2:end)+ww(:,1:end-1))/2;
    end
  else
    w_at_v = zeros(size(v));
  end % Wispresent

  % output:
  x = xv;
  y = yv;
  z = zv;
  v = v+sqrt(-1)*w_at_v;

  % labels:
  labels = labelsv;
end

% --------------------------------------------------------------------
% slice j
% --------------------------------------------------------------------
if isequal(type,'slicej')
  % load vars:
  u = vars_j_lat{1};
  w = vars_j_lat{2};

  [xu,yu,zu,u,labelsu] = roms_slicej(file,u,ind,t,varargin{:});
  if WisPresent
    [xw,yw,zw,w,labelsw] = roms_slicej(file,w,ind,t,varargin{:});

    % get w at u points:
    if use_griddata
      [w_at_u] = griddata(xw,zw,w,xu,zu,method);
    else
      ww     = (w(2:end,:)+w(1:end-1,:))/2;
      w_at_u = (ww(:,2:end)+ww(:,1:end-1))/2;
    end
  else
    w_at_u = zeros(size(u));
  end % Wispresent

  % output:
  x = xu;
  y = yu;
  z = zu;
  v = u+sqrt(-1)*w_at_u;

  % labels:
  labels = labelsu;
end

% --------------------------------------------------------------------
% slice lat
% --------------------------------------------------------------------
if isequal(type,'slicelat')
  % load vars:
  u = vars_j_lat{1};
  w = vars_j_lat{2};

  % better make average also along eta, so should have v in less one point than w:
  eval('nLONw = ind(2);','nLONw = 100;');
  nLONu = nLONw-1;

  indu = [ind(1) nLONu];
  indw = [ind(1) nLONw];

  [xu,yu,zu,u,labelsu] = roms_slicelat(file,u,indu,t,varargin{:});
  if WisPresent
    [xw,yw,zw,w,labelsw] = roms_slicelat(file,w,indw,t,varargin{:});

    % get w at u points:
    if use_griddata
      [w_at_u] = griddata(xw,zw,w,xu,zu,method);
    else
      ww     = (w(2:end,:)+w(1:end-1,:))/2;
      w_at_u = (ww(:,2:end)+ww(:,1:end-1))/2;
    end
  else
    w_at_u = zeros(size(u));
  end % Wispresent

  % output:
  x = xu;
  y = yu;
  z = zu;
  v = u+sqrt(-1)*w_at_u;

  % labels:
  labels = labelsu;
end

% --------------------------------------------------------------------
% slice k, kbar, z
% --------------------------------------------------------------------
if isequal(type,'slicek') | isequal(type,'slicekbar') | isequal(type,'slicez')

  % load vars:
  if isequal(type,'slicek') | isequal(type,'slicez')
    u = vars_kz{1};
    v = vars_kz{2};
  elseif isequal(type,'slicekbar')
    u = vars_kbar{1};
    v = vars_kbar{2};
  end

  if isequal(type,'slicek') | isequal(type,'slicekbar')
    [xu,yu,zu,u,labelsu] = roms_slicek(file,u,ind,t,varargin{:});
    [xv,yv,zv,v,labelsv] = roms_slicek(file,v,ind,t,varargin{:});
  elseif isequal(type,'slicez')
    [xu,yu,zu,u,labelsu] = roms_slicez(file,u,ind,t,varargin{:});
    [xv,yv,zv,v,labelsv] = roms_slicez(file,v,ind,t,varargin{:});
  end

  % get u and v "at psi"
  xxu=(xu(2:end,:)+xu(1:end-1,:))/2;
  xxv=(xv(:,2:end)+xv(:,1:end-1))/2;
  X=(xxu+xxv)/2;

  zzu=(zu(2:end,:)+zu(1:end-1,:))/2;
  zzv=(zv(:,2:end)+zv(:,1:end-1))/2;
  Z=(zzu+zzv)/2;

  yyu=(yu(2:end,:)+yu(1:end-1,:))/2;
  yyv=(yv(:,2:end)+yv(:,1:end-1))/2;
  Y=(yyu+yyv)/2;

  U=(u(2:end,:)+u(1:end-1,:))/2;
  V=(v(:,2:end)+v(:,1:end-1))/2;

  % output:
  x = X;
  y = Y;
  z = Z;

  % rot uv:
  ang=use(file,'angle');
  ang=(ang(1:end-1,:)+ang(2:end,:))/2;
  ang=(ang(:,1:end-1)+ang(:,2:end))/2;
  [U,V]=rot2d(U,V,ang*180/pi);

  v = U + sqrt(-1)*V;

  % labels:
  s = findstr(labelsu.x,'at ');
  labx = [labelsu.x(1:s-1),' at uv'];
  s = findstr(labelsu.y,'at ');
  laby = [labelsu.y(1:s-1),' at uv'];
  labels.x = labx;
  labels.y = laby;
  labels.z = labelsu.z;
end
