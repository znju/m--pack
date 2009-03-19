function V = occam_slicell_fast(fname,vname,AB,IJ,M,NaN2Zero)
%OCCAN_SLICELL_FAST   Make OCCAM slice along any path
%   To be used with OCCAN_SLICELL_AUX. The combination of these two
%   files is an optimized version of OCCAN_SLICELL, when dealing with
%   multiple input files.
%
%   Syntax:
%      V  = OCCAM_SLICELL_FAST(FILE,VARNAME,AB,IJ,M3,NAN2Z)
%
%   Inputs:
%      FILE   OCCAM output file
%      VARNAME   Variable to extract (array with dimension >= 2)
%      AB,IJ     Interpolation parameters (output of OCCAN_SLICELL_AUX)
%      M         3-D mask (output of OCCAN_SLICELL_AUX)
%      NAN2Z     Flag to convert NaNs to zero, default=0
%
%   Outputs:
%     V   Variable at slice
%
%   Examples:
%     file='jan.nc';
%     varname='POTENTIAL_TEMPERATURE__MEAN_';
%     lon=[-10 10 100]; % same as lon=linspace(-10,10,200);
%     lat=[ 40 55 100]; % same as lat=linspace(40 55 100);
%     [AB,IJ,x,y,h,m,M] = occam_slicell_aux(file,lon,lat,0);
%     v = occam_slicell_fast(file,varname,AB,IJ,M);
%
%   See also OCCAN_SLICELL_AUX, OCCAN_SLICELL
%
%   MMA 16-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin < 6
  NaN2Zero=0;
end

V  = [];

v = use(fname,vname);
is3d=ndims(v)==3;
n=n_filedim(fname,'DEPTH');
if ~is3d
 n=1;
end

if ~NaN2Zero
  if is3d
    v(M==0)=nan;  % needed when there are points between sea and land!!
  else
    m=squeeze(M(1,:,:));
    v(m==0)=nan;
  end
end


for l=1:size(AB,1)
  i = IJ(l,1);
  j = IJ(l,2);
  a  = AB(l,1);
  aa = AB(l,2);
  b  = AB(l,3);
  bb = AB(l,4);

%  if i==0 | j==0 | i+1>size(x,1) | j+1>size(x,2)
  if i==0 | j==0 | i+1>size(M,2) | j+1>size(M,3)
    if ~NaN2Zero
      vv=repmat(nan,n,1);
      zz=repmat(nan,n,1);
    else
      vv=repmat(0,n,1);
      zz=repmat(0,n,1);
    end
  else

    if is3d
      vb=[v(:,i,j) v(:,i,j+1) v(:,i+1,j+1) v(:,i+1,j)];
      vv=a*b*vb(:,3) +aa*b*vb(:,4) + aa*bb*vb(:,1) + a*bb*vb(:,2);
    else
      vb=[v(  i,j) v(  i,j+1) v(  i+1,j+1) v(  i+1,j)];
      vv=a*b*vb(3) +aa*b*vb(4) + aa*bb*vb(1) + a*bb*vb(2);
    end

  end
  V(:,l)=vv;
end
