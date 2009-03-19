function R2 = smoot_r(R,L)
%SMOOT_R   Smooth 2D array with a square filter
%   Each point will be the average of the 2L+1 (side) square.
%
%   Syntax:
%      R2 = SMOOTH_R(R,L)
%
%   Inputs:
%      R   Matrice to smooth
%      L   Side of smoothing square will be 2L+1
%
%   Output:
%      R2  Smoothed matrice
%
%   Comment:
%      Created to smooth bathymetric r parameter at function bat_smooth
%
%   Example:
%      a = peaks;
%      b = rand(size(a));
%      M = a+b;
%      figure, contour(M);
%      Mk = smooth_r(M,2);
%      Mr = smooth_r(M,1);
%      hold on, contour(Mk,'k');
%      contour(Mr,'r--');
%
%   MMA 2001, martinho@fis.ua.pt
%
%   See also M_SMOOTH, MAF

%   Department of Physics
%   University of Aveiro, Portugal

%   **-8-2004 - Fixed

[I,J]=size(R);

for i=1:I
  for j=1:J
    Lji(i,j)=min(j-1,L);
    Lje(i,j)=min(J-j,L);

    Lii(i,j)=min(i-1,L);
    Lie(i,j)=min(I-i,L);

    p=length( i-Lii(i,j):i+Lie(i,j) ) * length(j-Lji(i,j):j+Lje(i,j));

    R2(i,j)=sum(sum(R(i-Lii(i,j):i+Lie(i,j),j-Lji(i,j):j+Lje(i,j))))/p;
  end
end
