function [x,y,z,v,labels]=roms_slice(file,varargin)
%ROMS_SLICE   Utility to extract 2D slices from ROMS output
%   A detailed explanation of ROMS_SLICE follows.
%   In the end of this help can be found an explanations of this
%   function usage and a few examples.
%
%   ROMS_SLICE was created to make slices in ROMS output files.
%   It works with recent ROMS versions and also with current ROMS-AGRIF.
%
%   It is a set of the functions:
%
%                         ROMS_SLICE
%                              |
%                ______________|__________________________________________
%               |      _______                   |                        |
%          ROMS_SLICEI        |                  |                  ROMS_SLICEISO
%               +             |                  |
%          ROMS_SLICEJ        |                  |
%               +             |                  |
%          ROMS_SLICEK        |                  |
%               +             |-- ROMS_SLICEUVW --- ROMS_SLICEUVW3
%        ROMS_SLICE_LON       |
%               +             |
%        ROMS_SLICE_LAT       |
%               +             |
%          ROMS_SLICEZ ______ |
%
%    |__________________________| |_______________________________| |___________|
%                  |                              |                       |
%        All 2,3,4-D variables      currents, u,v,w or ubar,vbar    4-D variables
%
%   See the help for each function
%
%   Next, It is explained the approximations used. They are used to
%   make extraction faster and because may give accurate results, at
%   least when resolution is good, or variability is low. The problem
%   may be in the vertical resolution cos in currents slices, w is
%   averaged at RHO s-levels, see bellow.
%   Then, there  is a scheme of the Arakawa-C grid to better understand
%   the approximations explanation.
%
%   Any suggestion to increase accuracy is welcome, as well as bug reports
%   In any case, please contact me by the email: martinho@fis.ua.pt
%
%   In order to work with these functions some other functions are
%   required. These can be found in the site:
%   http://neptuno.fis.ua.pt/~mma
%   There you can also find an interface which uses all this functions
%   at a distance of a mouse click, the RaV, ROMS Visualisation utility
%   Well, I created this for myself but hope you find it useful too...
%
%   After a certain amount of hours, these files can also work with
%   ROMS-AGRIF output, the difference is that s-coordinates information
%   is included in output files as global attributes.
%   Another difference is that currently variable w is not present in
%   ROMS-AGRIF output, so, in the currents w is used as zero!
%   If the of s-coordinates information  is not present in the files
%   it must be given as VARARGIN 's_params'
%
%   Created by Martinho Marta Almeida, 2004
%   Phys. Dep, Aveiro Univ. Portugal
%   martinho@fis.ua.pt
%   http://neptuno.fis.ua.pt/~mma
%
%
% -------------------------- approximations ---------------------------
% 1. ROMS_SLICEI:
%   i   - when eta dimension is Eta_v or Eta_psi x and y are averaged
%         (to the central point between each pair); the same happens
%         with h and zeta. The idea is obtain them at rho points
%
%   ii  - when xi dimension is Xi_u or Xi_psi, for i=1, it is used in spite of
%         be in adjacent position of rho; for i=I, I-1 is used; for all
%         others, the average  between i and i-1 levels is used
%
% 2. ROMS_SLICEJ:
%   i   - when xi dimension is Xi_u or Xi_psi, x, y, h and zeta are averaged
%
%   ii  - when eta dimension is Eta_v or Eta_psi, for j=1, it is used in spite of
%         be in adjacent position of rho; for j=J, J-1 is used;; for all
%         others, the average  between j and j-1 levels is used
%
% 3. ROMS_SLICEK
%   i   - if Xi_u or Xi_psi, x, y, h and zeta are averaged. The same happens
%         in case  of Eta_v or Eta_psi
%
% 4. ROMS_SLICELON:
%   i   - same approximation as previous (slicek)
%
% 5. ROMS_SLICELAT:
%   i   - same as previous (slicek and lon)
%
% 6. ROMS_SLICEZ:
%   i   - same as previous (slicek, lon and lat)
%
% 7. ROMS_SLICEUVW:
%   i   - if slicei or slicelon: w is averaged (twice) to v points
%         (notice that v is obtained in less one point than w)
%         if not accurate, griddata can be used
%
%   ii  - if slicej or slicelat, similar to previous is used, but with
%          w and u
%
%   iii - if slicek or z: x, y, z, u and v are averaged at psi; thus,
%         x, y and z are averaged twice and u and v, once
%
% 8. ROMS_SLICEUVW3:
%   i   - this function first runs roms_sliceuvw, so all approximations
%         of sliceuvw are also used;
%         Then also obtains the third variable, as explained bellow:
%
%   ii  - slicei and slicelon: needed var is u and is averaged at v
%         (notice that u is obtained in more one point than v)
%
%   iii - slicej and slicelat: needed var is v; it is the same as
%         previous, but using v at u
%
%   iv  - slicek and slicez: needed var is w and is averaged in the
%         vertical at rho points;
%         also here, maybe griddata should be used
%         Then is is averaged twice to be at psi points
%
%
% ------------------------ Arakawa-C grid: ---------------------------
%
% 1 ## Horizontal, slice k=const
%
% j=J    rho ---- U ---- rho ---- U ---- rho
%         |               |               |
%         |               |               |
%         V      psi      V      psi      V
%         |               |               |
%         |               |               |
%        rho ---- U ---- rho ---- U ---- rho
%         |               |               |
%         |               |               |
%         V     psi       V     psi       V
%         |               |               |
%         |               |               |
% j=1    rho ---- U ---- rho ---- U ---- rho
%
%      i=1                              i=I
%
% sizes:
%    RHO : J    x  I
%    U   : J    x  I-1
%    V   : J-1  x  I
%    W   : J    x  I    (different s-level)
%
%
% 2 ## Vertical, slice j=const
%
% kw=K+1  W - - - - - - - W - - - - - - - W (surface, zeta)
%         |               |               |
%         |               |               |
% k=K    rho ---- U ---- rho ---- U ---- rho
%         |               |               |
%         |               |               |
%         W - - - - - - - W - - - - - - - W
%         |               |               |
%         |               |               |
% k=1    rho ---- U ---- rho ---- U ---- rho
%         |               |               |
%         |               |               |
% kw=1    W - - - - - - - W - - - - - - - W (bottom, h)
%
%        i=1                             i=I
%
% sizes:
%    RHO : K    x  I
%    U   : K    x  I-1
%    V   : K    x  I    (different level j)
%    W   : K+1  x  I
%
%
% 3 ## Vertical, slice i=const
%
% kw=K+1  W - - - - - - - W - - - - - - - W (surface, zeta)
%         |               |               |
%         |               |               |
% k=K    rho ---- V ---- rho ---- V ---- rho
%         |               |               |
%         |               |               |
%         W - - - - - - - W - - - - - - - W
%         |               |               |
%         |               |               |
% k=1    rho ---- V ---- rho ---- V ---- rho
%         |               |               |
%         |               |               |
% kw=1    W - - - - - - - W - - - - - - - W (bottom, h)
%
%        j=1                             j=J
%
% sizes:
%    RHO : K    x  J
%    U   : K    x  J    (different level i)
%    V   : K    x  J-1
%    W   : K+1  x  J
%
% ------------------------------- x ----------------------------------
%
%   Syntax:
%      [X,Y,Z,V,LABELS] = ROMS_SLICE(FILE,VARARGIN)
%
%   Input:
%      FILE   ROMS output file
%      VARARGIN:
%         'slice', type of slice: 'i','j','k','lon','lat','z','
%         'ind',  indice for the slice chosen, it can be a vector with
%            two values in the case of slice lon and lat, the second
%            is n. points used for interpolation
%         'time', time indice
%         'currents', for currents slice, 2D, 3D, 2D-bar or 3D-bar(w=0): 2, 3, -2, -3
%         'variable', if not using currents choose the variable
%         's_params': structure with fields: .tts, .ttb, .hc and .N
%            These are required to calc z and so, are not always needed
%            They will be used by the function S_LEVELS when needed.
%            If this structure is not entered or any of its fields is
%            missing then the function S_PARAMS will look for this data
%            in the file
%
%   Outputs:
%      X         Position x
%      Y         Position y
%      Z         Depth
%      V         Variable at slice (u+iv and v.u v.v [v.w] for currents)
%      LABELS    Names of variables X, Y and Z
%
%   Comments:
%      The difference between 2D-bar and 3D-bar is only in the output;
%      in the first case the output is u+iv and in the second is v.u,
%      v.v v.w=0.
%      So, when asking for 2D currents the function used is
%      ROMS_SLICEUVW and the output is imaginary;
%      In the 3D case, the function used is ROMS_SLICEUVW3 and the
%      output is a structure with fields u, v and w; if barotropic
%      then w=0.
%      See the help of other roms_slice files for possible additional
%      varargin.
%
%   Examples:
%      file     = 'ocean_his.nc'
%      slice    = 'slicei';
%      variable = 'temp';
%      ind      = 50;
%      time     = 20;
%      [x,y,z,v,l]=roms_slice(file,'slice',slice,'variable',variable,'ind',ind,'time',time);
%
%      currents = 3;
%      [x,y,z,v,l]=roms_slice(file,'slice',slice,'currents',currents,'ind',ind,'time',time);
%
%      currents = -3;
%      [x,y,z,v,l]=roms_slice(file,'currents',currents,'time',time);
%
%   MMA 12-2004, martinho@fis.ua.pt
%
%   See also M_FILES, M_PACK

%   Department of Physics
%   University of Aveiro, Portugal

%   ??-02-2005 - When using varargin s_params the functions will not
%                look for the s-parameters anymore
%   ??-08-2005 - Added ROMS_SLICEISO (but cannot be called by this
%                function)

x      = [];
y      = [];
z      = [];
v      = [];
labels = [];

iscurrents3d     = 0;
iscurrents2d     = 0;
iscurrents3d_bar = 0;
iscurrents2d_bar = 0;

use_s_params = 0;
use_slice    = 0;
use_ind      = 0;
use_time     = 0;
use_currents = 0;
use_variable = 0;

vin = varargin;
for ii=1:length(vin)
  if isequal(vin{ii},'s_params')
    s_params = vin{ii+1};
    use_s_params = 1;
  end
  if isequal(vin{ii},'slice')
    slice = vin{ii+1};
    use_slice = 1;
  end
  if isequal(vin{ii},'ind')
    ind = vin{ii+1};
    use_ind = 1;
  end
  if isequal(vin{ii},'time')
    time = vin{ii+1};
    use_time = 1;
  end
  if isequal(vin{ii},'currents')
    currents = vin{ii+1};
    if isequal(currents,3),  iscurrents3d     = 1; end
    if isequal(currents,2),  iscurrents2d     = 1; end
    if isequal(currents,-3), iscurrents3d_bar = 1; end
    if isequal(currents,-2), iscurrents2d_bar = 1; end
    use_currents = 1;
  end
  if isequal(vin{ii},'variable')
    varname = vin{ii+1};
    use_variable = 1;
  end

end

if ~use_slice & ~(iscurrents2d_bar | iscurrents3d_bar)
  disp('# you must choose a slice...');
  return
end

% --------------------------------------------------------------------
% not for currents
% --------------------------------------------------------------------
if ~use_currents

  if ~use_variable
    disp(['# no variable chosen for ',slice]);
    return
  end
  if use_ind & use_time & use_s_params
    eval(['[x,y,z,v,labels]=roms_',slice,'(file,varname,ind,time,varargin{:});']);
  elseif use_ind & use_time
    eval(['[x,y,z,v,labels]=roms_',slice,'(file,varname,ind,time);']);
  elseif use_ind & ~use_time
    eval(['[x,y,z,v,labels]=roms_',slice,'(file,varname,ind);']);
  elseif ~use_ind & use_time
    eval(['[x,y,z,v,labels]=roms_',slice,'(file,varname,0,time);']);
  else
    eval(['[x,y,z,v,labels]=roms_',slice,'(file,varname);']);
  end
end

% --------------------------------------------------------------------
% currents
% --------------------------------------------------------------------
if use_currents

  if iscurrents3d | iscurrents2d
    if ~use_ind,  disp(['# insufficient input arguments: missing ind']); return, end
    if ~use_time, disp(['# insufficient input arguments: missing time']); return, end
  end

  if iscurrents3d
    type = slice;
    if use_s_params
      [x,y,z,v,labels]=roms_sliceuvw3(file,type,ind,time,varargin{:});
    else
       [x,y,z,v,labels]=roms_sliceuvw3(file,type,ind,time);
    end

  elseif iscurrents2d
    type = slice;
    if use_s_params
      [x,y,z,v,labels]=roms_sliceuvw(file,type,ind,time,varargin{:});
    else
       [x,y,z,v,labels]=roms_sliceuvw(file,type,ind,time);
    end

  elseif iscurrents3d_bar
    type = 'slicekbar';
    ind = nan;
    if use_s_params
      [x,y,z,v,labels]=roms_sliceuvw3(file,type,ind,time,varargin{:});
    else
       [x,y,z,v,labels]=roms_sliceuvw3(file,type,ind,time);
    end

  elseif iscurrents2d_bar
    type = 'slicekbar';
    ind = nan;
    if use_s_params
      [x,y,z,v,labels]=roms_sliceuvw(file,type,ind,time,varargin{:});
    else
       [x,y,z,v,labels]=roms_sliceuvw(file,type,ind,time);
    end
  end

end
