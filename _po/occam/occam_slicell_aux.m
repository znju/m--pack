function [AB,IJ,x,y,h,m,M] = occam_slicell_aux(fname,X,Y,isUV)
%OCCAN_SLICELL_AUX   Make OCCAM slice along any path
%   To be used with OCCAN_SLICELL_FAST. The combination of these two
%   files is an optimized version of OCCAN_SLICELL, when dealing with
%   multiple input files.
%
%   Syntax:
%     [AX,IJ,X,Y,H,M,M3]  = OCCAM_SLICELL_AUX(FILE,LON,LAT,ISUV)
%
%   Inputs:
%      FILE   OCCAM output file
%      LON    Longitude vector; If length is 3, lon will be
%             linspace(LON(1),LON(2),LON(3)
%      LAT    Latitude vector, linspace is also used if length is 3
%      ISUV   Is uv variable flag
%
%   Outputs:
%     AX,IJ   Interpolation parameters
%     X,Y,H,M,M3   Grid data
%
%   See OCCAN_SLICELL_FAST, OCCAN_SLICELL
%
%   MMA 16-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if length(X)==3, X=linspace(X(1),X(2),X(3)); else X=X(:)'; end
if length(Y)==3, Y=linspace(Y(1),Y(2),Y(3)); else Y=Y(:)'; end

X=X(:)';
Y=Y(:)';

if isUV
  [x,y,h,m,M]=occam_grid(fname,'uv');
else
  [x,y,h,m,M]=occam_grid(fname,'r');
end
x(x>180)=x(x>180)-360;
X(X>180)=X(X>180)-360;

IJ=[];
AB=[];
for l=1:length(X)
  xx=X(l); yy=Y(l);
  [i,j]=find_nearest(x,y,xx,yy); i=i(1); j=j(1);

  j0=j;
  if xx<x(i,j),  j=j-1; end
  if yy<y(i,j0), i=i-1; end

  IJ(l,:)=[i,j];
  if i==0 | j==0 | i+1>size(x,1) | j+1>size(x,2)
    AB(l,:)=[nan nan nan nan];
  else
    xb=[x(i,j) x(i,j+1) x(i+1,j+1) x(i+1,j)];
    yb=[y(i,j) y(i,j+1) y(i+1,j+1) y(i+1,j)];

    a=(xx-xb(1))/(xb(2)-xb(1)); aa=1-a;
    b=(yy-yb(1))/(yb(4)-yb(1)); bb=1-b;

    AB(l,:)=[a aa b bb];
  end
end
