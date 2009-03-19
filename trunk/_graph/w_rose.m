function w_rose(H1,H2,tt,pos,rot,c1,c2)
%W_ROSE   Draw wind rose
%
%   Syntax:
%      W_ROSE(H1,H2,TT,POS,ROT,C1,C2)
%
%   Inputs:
%      H1   Length E-W [ 1 ]
%      H2   Length N-S [ 1 ]
%      TT   Angle (deg) [ 20 ]
%      POS  Position [ <0 0> ] 
%      ROT  Direct rotation angle (deg) [ 0 ]
%      C1   Color to fill side 1 [ 'k' ]
%      C2   Color to fill side 2 [ 'w' ]
%
%   Example:
%      figure, subplot(1,2,1)
%      w_rose, axis equal
%      subplot(1,2,2)
%      w_rose(1,2,20,[1 1],10,'r','b')
%      axis equal
%
%   MMA 14-8-2002, martinho@fis.ua.pt
%
%   See also WIND_ROSE

%   Department of physics
%   University of Aveiro

if nargin < 7
    c2='w';
end
if nargin < 6
  c1='k';
end
if nargin < 5
  rot=0;
end
if nargin < 4
  pos=[0 0];
end
if nargin < 3
  tt=20;
end
if nargin < 2
  H2=1;
end
if nargin < 1
  H1=1;
end

H=abs(H1);
a=abs(H2/H1);
cor1=c1;
cor2=c2;

% finding points:
fi=.5*tt*pi/180;% 1/2 abertura dos E & W.
h=tan(fi)*H;
fi2=pi/4-atan((H/2-h)/(H/2));% 1/2 abertura dos secundarios.
x=(h-H)/(tan(-pi/2+fi)-tan(-fi));
y=tan(-fi)*x+h;
x1=(-tan(-45*pi/180-fi2)*h+h)/(tan(fi)-tan(-45*pi/180-fi2));
y1=-(tan(fi)*x1-h);
fi3=atan(x/(a*H-y));% 1/2 abertura dos N & S
x2=(h-a*H)/(tan(-pi/2+fi3)-tan(pi/4-fi2));
y2=tan(pi/4-fi2)*x2+h;

p1_x=H;
p1_y=0;
p2_x=x1;
p2_y=y1;
p3_x=H/2;
p3_y=H/2;
p4_x=x2;
p4_y=y2;
p5_x=0;
p5_y=a*H;

X_NE=[p1_x p2_x p3_x p4_x p5_x];
Y_NE=[p1_y p2_y p3_y p4_y p5_y];
X_NW=fliplr(-X_NE);
Y_NW=fliplr(Y_NE);
X_SW=-X_NE;
Y_SW=-Y_NE;
X_SE=-X_NW;
Y_SE=-Y_NW;

X=[X_NE X_NW(2:end) X_SW(2:end) X_SE(2:end)];
Y=[Y_NE Y_NW(2:end) Y_SW(2:end) Y_SE(2:end)];

Xi=[x -x -x x];
Yi=[y y -y -y];

%pos+rot.
[X,Y]=rot2d(X,Y,rot);
X=X+pos(1);
Y=Y+pos(2);
%plot(X,Y),hold on

[Xi,Yi]=rot2d(Xi,Yi,rot);
Xi=Xi+pos(1);
Yi=Yi+pos(2);

[x,y]=rot2d(x,y,rot);
x=x+pos(1);
y=y+pos(2);

x0=pos(1);
y0=pos(2);

%filling:
%E&W:
fill([x0 X(1) Xi(1) Xi(3) X(9) x0 X(5) Xi(2) Xi(4) X(13) x0],...
    [y0 Y(1) Yi(1) Yi(3) Y(9) y0 Y(5) Yi(2) Yi(4) Y(13) y0],c2) 
hold on
%N&S:
fill([x0 Xi(4) X(1) X(9) Xi(2) x0 Xi(1) X(5)  X(13) Xi(3) x0],...
    [y0 Yi(4) Y(1) Y(9) Yi(2) y0 Yi(1) Y(5)  Y(13) Yi(3) y0],c1) 
%NE&NW&SW&SE:
fill([Xi(1) X(2)  X(3) ],[Yi(1) Y(2)  Y(3) ],c1)
fill([Xi(2) X(6)  X(7) ],[Yi(2) Y(6)  Y(7) ],c1)
fill([Xi(3) X(10) X(11)],[Yi(3) Y(10) Y(11)],c1)
fill([Xi(4) X(14) X(15)],[Yi(4) Y(14) Y(15)],c1)

fill([Xi(1) X(4)  X(3) ],[Yi(1) Y(4)  Y(3) ],c2)
fill([Xi(2) X(8)  X(7) ],[Yi(2) Y(8)  Y(7) ],c2)
fill([Xi(3) X(12) X(11)],[Yi(3) Y(12) Y(11)],c2)
fill([Xi(4) X(16) X(15)],[Yi(4) Y(16) Y(15)],c2)

function [x,y] = rot2d(xi,yi,teta)
teta=teta*pi/180;
[th,r]=cart2pol(xi,yi);
[x,y]=pol2cart(th+teta,r);
