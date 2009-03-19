function handles = north_arrow(lab,H,hh,tt,pos,rot,cL,cR,opt);
%NORTH_ARROW   Draw direction arrow
%
%         ^       ^    HH = h/H
%        /|\      |    o  = origin, pos
%       / | \
%      /  |  \    H
%     / / h \ \
%    /    o    \  |
%                 |
%    < -- b -- >  v
%
%   Syntax:
%      HANDLES = NORTH_ARROW(LAB,H,HH,TT,POS,ROT,CL,CR,OPT)
%
%   Inputs:
%      LAB   Text to insert at arrow tip [ 'N' ]
%      H     Height [ 1 ]
%      HH    h/HH, see scheme above [ 0.3 ]
%      TT    Angle (deg) [ 30 ]
%      POS   Position, point o [ <x y> {<0 0>} ]
%      ROT   Rotation [ 0 ]
%      CL    Color to fill left side [ 'g' ]
%      CR    Color to fill right side [ 'r' ]
%      OPT   Plot options of the plotted lines [ 'k' ]
%
%   Output:
%      HANDLES   Handles to text, fill and plot
%
%   Examples:
%      figure
%      north_arrow('W',1,.3,30,[1 1],30,'r','w','k');
%      axis equal, ylim([.8 2.2]);
%
%   MMA 13-8-2002, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

if nargin < 9,  opt = 'k';   end
if nargin < 8,  cR  = 'r';   end
if nargin < 7,  cL  = 'g';   end
if nargin < 6,  rot = 0;     end
if nargin < 5,  pos = [0 0]; end
if nargin < 4,  tt  = 30;    end
if nargin < 3,  hh  = .3;    end
if nargin < 2,  H   = 1;     end
if nargin < 1,  lab = 'N';   end

h2=hh*H;
tt=tt*pi/180;
b=2*tan(tt/2)*H;

X=[0 b/2 0 -b/2 0 0];
Y=[h2 0 H 0 h2 H];
[X,Y]=rot2d(X,Y,rot);
xL=[-b/2 0 0 -b/2];
yL=[0 h2 H 0];
[xL,yL]=rot2d(xL,yL,rot);
xR=[0 b/2 0 0];
yR=[h2 0 H h2];
[xR,yR]=rot2d(xR,yR,rot);

h=ishold;
handles.fillL=fill(xL+pos(1),yL+pos(2),cL); 
hold on
handles.fillR=fill(xR+pos(1),yR+pos(2),cR);
handles.plot=plot(X+pos(1),Y+pos(2),opt);
handles.text=text(X(3)+pos(1),Y(3)+pos(2),lab);
set(handles.text,'HorizontalAlignment','center');
set(handles.text,'VerticalAlignmen','bottom');
set(handles.text,'rotation',rot);

if ~h
  hold off
end

function [x,y] = rot2d(xi,yi,teta)
teta=teta*pi/180;
[th,r]=cart2pol(xi,yi);
[x,y]=pol2cart(th+teta,r);
