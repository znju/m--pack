function [X,Y,Xi,Yi] = lclip(x,y,xb,yb)
%LCLIP   Line clipping using clipping polygon with arbitrary shape
%
%   Syntax:
%      [XC,YC,XI,YI] = LCLIP(X,Y,YP,XP)
%
%   Inputs:
%      X,Y   Line to be clipped
%
%   Outputs:
%      XC,YC   Clipped line (with NaNs)
%
%   Exaple:
%      xb=[0.6 0.9 1.5 1.6 1.8 2.0 2.5 2.3 1.6 0.8 0.6];
%      yb=[1.3 1.4 1.6 1.4 2.3 1.6 1.8 0.9 1.1 0.4 1.3];
%
%      x=[0.6 0.7 1.0 1.0 1.2 1.4 2.1 2.3 1.5  2.4 1.8];
%      y=[1.6 1.3 1.0 1.3 1.7 1.4 2.4 2.2 1.75 1.6 0.7];
%
%      figure
%      plot(xb,yb), hold on
%      plot(x,y,'r-x')
%
%      [X,Y,Xi,Yi]=lclip(x,y,xb,yb);
%      plot(X,Y,'.-k','linewidth',2)
%      plot(Xi,Yi,'ro','markersize',10)
%
%   MMA 28-5-2007, martinho@fis.ua.pt
%
%   See also CLIP, IN_POLYGON, IN_BOX

% Department of Physics
% University of Aveiro, Portugal

% check points inside, outside, in border and in vertice:
for i=1:length(x)
  xi=x(i);
  yi=y(i);
  [is,isb,isv] = in_polygon(xi,yi,xb,yb);
  Is(i)  = is;
  Isb(i) = isb;
  Isv(i) = isv;
end

X=[];
Y=[];
for i=1:length(x)-1
  if Is(i)
    X=[X x(i)];
    Y=[Y y(i)];
  end
  if ~(Isb(i) | Isb(i+1))
    [a,b]=meetpoint(xb,yb,[x(i) x(i+1)],[y(i) y(i+1)]);

     L=length(a);
    if L > 1
      if Is(i)
          aa=repmat(nan,[1 length(a)+ceil(length(a)/2)]);
          bb=repmat(nan,[1 length(b)+ceil(length(b)/2)]);
          aa(1)=a(1);
          bb(1)=b(1);
          for j=1:ceil(length(a)/2)-1
              aa(3*j:3*j+1)=a(2*j:2*j+1);
              bb(3*j:3*j+1)=b(2*j:2*j+1);
          end
          aa(end)=a(end);
          bb(end)=b(end);
      else
          aa=repmat(nan,[1 length(a)+ceil(length(a)/2)-1]);
          bb=repmat(nan,[1 length(b)+ceil(length(b)/2)-1]);
          aa(1)=a(1);
          bb(1)=b(1);
          LL=length(aa);
          for j=1:ceil(length(a)/2)%-1
              aa((j-1)*3+1:min(LL,(j-1)*3+2))=a((j-1)*2+1:min(L,(j-1)*2+2));
              bb((j-1)*3+1:min(LL,(j-1)*3+2))=b((j-1)*2+1:min(L,(j-1)*2+2));
          end
          aa(end)=a(end);
          bb(end)=b(end);
      end
      a=aa;
      b=bb;
    end
    if ~Is(i+1)
      a=[a nan];
      b=[b nan];
    end
    X=[X a];
    Y=[Y b];
  end
end
if Is(end)
  X=[X x(end)];
  Y=[Y y(end)];
end

%Xi=x(boolean(Is));
%Yi=y(boolean(Is));
Xi=x(logical(Is));
Yi=y(logical(Is));
