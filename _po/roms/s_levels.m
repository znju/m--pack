function [z,zw] = s_levels(h,t,b,hc,N,zeta,old)
%S_LEVELS   Get vertical s-coordinates levels
%
%   Syntax:
%      [Z_R,Z_W] = S_LEVELS(H,THETA_S,THETA_B,HC,N,ZETA,OLD)
%      [Z_R,Z_W] = S_LEVELS(FILE,TIME)
%
%   Inputs:
%      H         Depth matrice, positive
%      THETA_S   Surface control param [0 < < 20]
%      THETA_B   Bottom control param  [0 < < 1 ]
%      HC        Critical depth, minimum between Tcline (s-coordinate
%                surface/bottom layer width) and hmin (minimum grid
%                depth)
%      N         Number of rho levels
%      ZETA      Free surface matrice
%      OLD       If 1, levels are computed using old formula
%                [ 1 | {0} ]:
%                  A  = hc*s  + (h-hc)*C;
%                  Aw = hc*sw + (h-hc)*Cw;
%                  z_r = A  + zeta*(1+s)
%                  z_r = Aw + zeta*(1+sw)
%                else, the new is used:
%                  z_r = A  + zeta*(1+A/h)
%                  z_w = Aw + zeta*(1+Aw/h)
%
%   Output:
%      Z_R   Vertical S-coordinate depths at RHO-points
%      Z_W   Vertical S-coordinate depths at W-points
%
%   Examples:
%      [z_r,z_w] = s_levels(1000,5,.3,5,10,0);
%      h    = [1000 500; 1200 300];
%      zeta = [0 1; 2 -2];
%      [z_r,z_w] = s_levels(h,5,.3,5,10,0)
%      [z_r,z_w] = s_levels(1000,5,.3,5,10,zeta)
%      [z_r,z_w] = s_levels(h,5,.3,5,10,zeta)
%
%   MMA 18-9-2002, martinho@fis.ua.pt
%
%   See also S_PARAMS

%   Department of Physics
%   University of Aveiro, Portugal

%   19-08-2004 - Optimised
%   **-10-2004 - Added option for old or new formula
%   07-02-2004 - Change input arguments (hc instead of hmin and
%                Tcline)

% S-coordinates reference:
% Journal of Computational Physics 115, 228-244 (1994)
%    A Semi-implicit Ocean Circulation Model Using Generalized
%    Topography-Following Coordinate System
%    Yuhe Song and Dale Haidvogel

z  = [];
zw = [];

if nargin < 7
  old = 0;
end
if nargin>2 & nargin< 6
  disp('» arguments required')
  return
end

if nargin==2
  file=h;
  time=t;
  [t,b,hc,N]=s_params(file);
  h=use(file,'h');
  zeta=use(file,'zeta','+time',time);
end

% S-coordinate at RHO-points and at W-points:
sw = linspace(-1,0,N+1);
s  = (sw(2:end)+sw(1:end-1))/2;

% S-coordinate stretching curves at RHO-points and at W-points 
if t == 0
  Cw = sw;
  C  = s;
else
  Cw = (1-b) * sinh(t*sw)/sinh(t) + b* ( tanh(t*(sw+0.5)) - tanh(t/2) ) / (2*tanh(t/2));
  C  = (1-b) * sinh(t*s )/sinh(t) + b* ( tanh(t*(s +0.5)) - tanh(t/2) ) / (2*tanh(t/2));
end

%hc = min(hmin,Tcline);
h  = abs(h); % positive h

% put all data as column arrays:
sw = sw';
s  = s';
Cw = Cw';
C  = C';
if size(h,1) == 1,    h=h';       end
if size(zeta,1) == 1, zeta=zeta'; end

if ~isequal(size(h),size(zeta))
  % then one must be scalar:
  if size(h,1) ~= 1 & size(zeta,1) ~= 1
    disp('» wrong h vs zeta size')
    return
  end
end

% next lines used to generalise the calculus, decreasing number of
% iterations:
OH=ones(size(h));
OZ=ones(size(zeta));
OHZ = OH;
dim3 = 0;
if size(OH,1) == 1 & size(OZ,2) == 1
  OHZ = OZ;
elseif size(OZ,1) == 1 & size(OH,2) == 1
  OHZ = OH;
elseif ~(size(OH,2) == 1 & size(OZ,2) == 1)
  if size(OH,2) == 1
    OHZ = OZ;
  end
  dim3 = 1;
end

if dim3 % one or both is 2-d array and other is scalar (one or both means h and zeta)

  for k=1:length(s)
    term1  = OHZ*hc*s(k)  +(OZ.*h-hc)*C(k);
    term2  = OH.*zeta;
    if old
      term3  = s(k);
    else
      term3  = term1  .* (1./(OZ.*h));
    end
    z(:,:,k)  = term1  + term2  .* (1+term3);
  end

  for k=1:length(sw)
    termw1 = OHZ*hc*sw(k) +(OZ.*h-hc)*Cw(k);
    termw2 = OH.*zeta;
    if old
      termw3 = sw(k);
    else
      termw3 = termw1 .* (1./(OZ.*h));
    end
    zw(:,:,k) = termw1 + termw2 .* (1+termw3);
  end

else
  term1  = OHZ*hc*s'  +(OZ.*h-hc)*C' ; [m,n]   = size(term1);
  termw1 = OHZ*hc*sw' +(OZ.*h-hc)*Cw'; [mw,nw] = size(termw1);
  term2  = OH.*zeta *  ones(1,n);
  termw2 = OH.*zeta *  ones(1,nw);
  if old
    term3  = s';  term3  = repmat(term3,m,1);
    termw3 = sw'; termw3 = repmat(termw3,mw,1);
  else
    term3  = term1 .* (1./(OZ.*h) * ones(1,n));
    termw3 = termw1.* (1./(OZ.*h) * ones(1,nw));
  end
  z  = term1  + term2  .* (1+term3);
  zw = termw1 + termw2 .* (1+termw3);
end


% the old and new formulas:
%
% old :
%                         Aw
%                  ________|_________
%                 |                  |
% zw = zeta*(1+sw) +hc*sw +(h-hc)*Cw;
% z  = zeta*(1+s ) +hc*s  +(h-hc)*C ;
%                 |__________________|
%                          |
%                          A
% new:
%    zw  = zeta*(1+Aw/h) + Aw
%    z   = zeta*(1+A/h)  + A
%
% the reference Yuhe Song and Dale Haidvogel 1994
% describes the old formula
