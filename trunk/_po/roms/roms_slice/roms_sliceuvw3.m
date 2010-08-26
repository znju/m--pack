function [x,y,z,v,labels]=roms_sliceuvw3(file,type,ind,t,varargin)
%ROMS_SLICEUVW3   Get 3D velocity field at ROMS slice
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICEUVW3(FILE,TYPE,I,T,VARARGIN)
%
%   Inputs:
%      FILE   ROMS output file
%      TYPE   Type of slice:
%               - slicei
%               - slicelon
%               - slicej
%               - slicelat
%               - slicek
%               - slicekbar (w=0)
%               - slicez
%      I      Indice:
%               - slicei:    indice in xi direction
%               - slicelon:  longitude [ lon[npts] ]
%               - slicej:    indice in eta direction
%               - slicelat:  latitude [ lat[npts] ] 
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
%      X   Position x
%      Y   Position y
%      Z   Depth
%      V   Variable at slice (v.u, v.v, v.w)
%      LABELS    names of variables X, Y and Z
%
%   Comment:
%      If the variable w is not present in the file, it is used as
%      zero. It is the case of (currently) ROMS-AGRID output.
%
%   MMA 8-2004, martinho@fis.ua.pt
%
%   See also ROMS_SLICE, S_LEVELS

disp('DEPRECATED !!!!!!!!!!')

%   Department of Physics
%   University of Aveiro, Portugal

%   ??-02-2005 - Improved

% deal with lack of variable w:
% it is used as zeros (see bellow)
WisPresent = 1;
if ~n_varexist(file,'w')
  WisPresent = 0;
  % fprintf(1,'### Variable w is not present in file, using zeros\n');
  % this warning is already shown by roms_sliceuvw
end
% --------------------------------------------------------------------

[x,y,z,tmp,labels] = roms_sliceuvw(file,type,ind,t,varargin{:});

if isequal(type,'slicei') | isequal(type,'slicelon'), needed = 'u'; end
if isequal(type,'slicej') | isequal(type,'slicelat'), needed = 'v'; end
if isequal(type,'slicek') | isequal(type,'slicez'),   needed = 'w'; end

% --------------------------------------------------------------------
% slice i, needed = u
% --------------------------------------------------------------------
if isequal(type,'slicei')
  v3 = roms_slicei(file,needed,ind,t,'s_params',s_params);
  % get u at v:
  v3 = (v3(2:end,:)+v3(1:end-1,:))/2;
end

% --------------------------------------------------------------------
% slice lon, needed = u
% --------------------------------------------------------------------
if isequal(type,'slicelon')
  nLON= size(x,1)+1;
  ind = [ind(1) nLON];
  v3 = roms_slicelon(file,needed,ind,t,varargin{:});
  % get u at v:
  v3 = (v3(2:end,:)+v3(1:end-1,:))/2;
end

% --------------------------------------------------------------------
% slice j, needed = v
% --------------------------------------------------------------------
if isequal(type,'slicej')
  v3 = roms_slicej(file,needed,ind,t,varargin{:});
  % get v at u:
  v3 = (v3(2:end,:)+v3(1:end-1,:))/2;
end

% --------------------------------------------------------------------
% slice lat, needed = v
% --------------------------------------------------------------------
if isequal(type,'slicelat')
  nLAT= size(x,1)+1;
  ind = [ind(1) nLAT];
  v3 = roms_slicelat(file,needed,ind,t,varargin{:});
  % get v at u:
  v3 = (v3(2:end,:)+v3(1:end-1,:))/2;
end


% --------------------------------------------------------------------
% slice k, needed = w
% --------------------------------------------------------------------
if isequal(type,'slicek')
  if WisPresent
    ind1 = ind;
    ind2 = ind+1;
    v31 = roms_slicek(file,needed,ind1,t,varargin{:});
    v32 = roms_slicek(file,needed,ind2,t,varargin{:});
    % get w at rho:
    v3 = (v31+v32)/2;
    % get w at psi (uv):
    v3=(v3(2:end,:)+v3(1:end-1,:))/2;
    v3=(v3(:,2:end)+v3(:,1:end-1))/2;
  else
    v3 = zeros(size(tmp));
  end % Wispresent
end

% --------------------------------------------------------------------
% slice z, needed = w
% --------------------------------------------------------------------
if isequal(type,'slicez')
  if WisPresent
    v3 = roms_slicez(file,needed,ind,t,varargin{:});
    % get w at rho:
    v3 = (v31+v32)/2;
    % get w at psi (uv):
    v3=(v3(2:end,:)+v3(1:end-1,:))/2;
    v3=(v3(:,2:end)+v3(:,1:end-1))/2;
  else
    v3 = zeros(size(tmp));
  end % Wispresent
end

% --------------------------------------------------------------------
% slice kbar, needed = none
% --------------------------------------------------------------------
if isequal(type,'slicekbar')
  v3 = repmat(0,size(tmp));
end


% output:
if isequal(type,'slicei') | isequal(type,'slicelon')
  v.u = v3;
  v.v = real(tmp);
  v.w = imag(tmp);
end

if isequal(type,'slicej') | isequal(type,'slicelat')
  v.u = real(tmp);
  v.v = v3;
  v.w = imag(tmp);
end

if isequal(type,'slicez') | isequal(type,'slicek') | isequal(type,'slicekbar')
  v.u = real(tmp);
  v.v = imag(tmp);
  v.w = v3;
end


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

%   WARNING/TODO:
%   w should be defined at one more level than u and v, otherwise
%   got to make w(N+1,:) = w(N,:) in roms_slicei,j,lon and lat for variable = w
%   I say this, because, in case of old ROMS versions, previous to version 2,
%   w missed one vertical level, aand thus this routine will not work.
%
%   NOTICE
%   all slices (i, j, k) are done in the plane RHO, except slicek for w, which is done in the plane W
