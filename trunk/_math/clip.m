function [x,y] = clip(x,y,xl,yl,isLine)
% CLIP   Sutherland-Hodgeman clipping algorithm
%   Can be also used for line clipping.
%
%   Syntax:
%      [xc,yc] = CLIP(X,Y,XL,YL,ISLINE)
%
%   Inputs:
%      X,Y      Line/polygon to be clipped
%      XL,YL    Clipping box limits
%      ISLINE   Is line flag (default=1)
%
%   Outputs:
%      XC,YC   Includes NaNs if ISLINE
%
%   Example:
%      xl=[1 2];
%      yl=[1 2];
%      x=[1.2 2.2 2.2 1.7 1.7 1.9   2.1 2.1 1.2 ];
%      y=[2.2 2.2 0.8 0.8 1.2 0.9 0.9 1.5 1.5  ];
%
%      figure
%      plot([xl(1) xl(2) xl(2) xl(1) xl(1)],[yl(1) yl(1) yl(2) yl(2) yl(1)])
%      hold on
%      plot(x,y,'k-',x,y,'ro')
%
%      [xx,yy]=clip(x,y,xl,yl,0);
%      fill(xx,yy,'g','edgecolor','none')
%
%      [xx,yy]=clip(x,y,xl,yl,1);
%      plot(xx,yy,'r','linewidth',4)
%
%      axis([.5 2.5 .5 2.5]);
%
%   MMA 27-5-2007, martinho@fis.ua.pt
%
%   See also IN_BOX

% Department of Physics
% University of Aveiro, Portugal

if nargin < 5
  isLine=1;
end

XR=max(xl); XL=min(xl);
YT=max(yl); YB=min(yl);

XX=[min(x) max(x)];
YY=[min(y) max(y)];

x_=[];
y_=[];

if any([x(1),y(1)]~=[x(end),y(end)])
  x(end+1)=x(1);
  y(end+1)=y(1);
end

% Top:
for i=1:length(x)-1
  if y(i)<YT | isnan(y(i))
    x_=[x_ x(i)];
    y_=[y_ y(i)];
  elseif y(i)>YT & isLine
     x_=[x_ nan];
     y_=[y_ nan];
  end

  [xm,ym]=hmp([x(i) x(i+1)],[y(i) y(i+1)],XX,YT);
  if ~isempty(xm)
    x_=[x_ xm];
    y_=[y_ ym];
  elseif y(i)==YT % for line inside other
    x_=[x_ x(i)];
    y_=[y_ y(i)];
  end
end
if y(end)<YT
  x_=[x_ x(end)];
  y_=[y_ y(end)];
end
x=x_;
y=y_;
x_=[];
y_=[];

if any([x(1),y(1)]~=[x(end),y(end)])
  x(end+1)=x(1);
  y(end+1)=y(1);
end

% Left
for i=1:length(x)-1
  if x(i)>XL | isnan(y(i))
    x_=[x_ x(i)];
    y_=[y_ y(i)];
  elseif isLine
    x_=[x_ nan];
    y_=[y_ nan];
  end

  [xm,ym]=vmp([x(i) x(i+1)],[y(i) y(i+1)],XL,YY);
  if ~isempty(xm)
    x_=[x_ xm];
    y_=[y_ ym];
  end
end
if x(end)>XL
  x_=[x_ x(end)];
  y_=[y_ y(end)];
end
x=x_;
y=y_;
x_=[];
y_=[];

if any([x(1),y(1)]~=[x(end),y(end)])
  x(end+1)=x(1);
  y(end+1)=y(1);
end

% Bot:
for i=1:length(x)-1
  if y(i)>YB | isnan(y(i))
    x_=[x_ x(i)];
    y_=[y_ y(i)];
  elseif isLine
    x_=[x_ nan];
    y_=[y_ nan];
  end

  [xm,ym]=hmp([x(i) x(i+1)],[y(i) y(i+1)],XX,YB);
  if ~isempty(xm)
    x_=[x_ xm];
    y_=[y_ ym];
  end
end
if y(end)>YB
  x_=[x_ x(end)];
  y_=[y_ y(end)];
end
x=x_;
y=y_;
x_=[];
y_=[];

if any([x(1),y(1)]~=[x(end),y(end)])
  x(end+1)=x(1);
  y(end+1)=y(1);
end

% Right
for i=1:length(x)-1
  if x(i)<XR | isnan(y(i))
    x_=[x_ x(i)];
    y_=[y_ y(i)];
  elseif isLine
    x_=[x_ nan];
    y_=[y_ nan];
  end

  [xm,ym]=vmp([x(i) x(i+1)],[y(i) y(i+1)],XR,YY);
  if ~isempty(xm)
    x_=[x_ xm];
    y_=[y_ ym];
  end
end
if x(end)<XR
  x_=[x_ x(end)];
  y_=[y_ y(end)];
end
x=x_;
y=y_;

% remove adjascent nans:
if isLine
  y(isnan(x))=nan;
  x(isnan(y))=nan;
  x=split_list(x);
  y=split_list(y);
  x=join_list(x);
  y=join_list(y);
end
