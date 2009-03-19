function M=m_smooth(M,param);
%M_SMOOTH   Smooth 2D array
%   Smooths matrice with with a window B-A-B on lines and then
%   on columns; A=PARAM, B=(1-PARAM)/2.
%
%   Syntax:
%      M = M_SMOOTH(M,PARAM)
%
%   Inputs:
%      M       Matrice to smooth
%      PARAM   Smoothing parameter [ 0.5 ]
%
%   Output:
%      M   Smoothed matrice
%
%   Example:
%     a = peaks;
%     b = rand(size(a));
%     M = a+b;
%     figure, contour(M);
%     Mk = m_smooth(M);
%     Mr = m_smooth(M,.9);
%     hold on, contour(Mk,'k');
%     contour(Mr,'r--');
%
%     MMA 30-3-2004, martinho@fis.ua.pt
%
%     See also MAF, SMOOTH_R

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 2
  param=.5;
end

A=param;
B=(1-param)/2;
C=1-B;

M(2:end-1,:) = A*M(2:end-1,:)+B*M(1:end-2,:)+B*M(3:end,:);
M(1,:)       = C*M(1,:)      +B*M(2,:);
M(end,:)     = C*M(end,:)    +B*M(end-1,:);

M(:,2:end-1) = A*M(:,2:end-1)+B*M(:,1:end-2)+B*M(:,3:end);
M(:,1)       = C*M(:,1)      +B*M(:,2);
M(:,end)     = C*M(:,end)    +B*M(:,end-1);
