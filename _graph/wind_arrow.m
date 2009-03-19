function handles = wind_arrow(V,dir,pos,tt,hh,SA,c1,c2,c3,c4,ext_opt,int_opt)
%WIND_ARROW   Plot wind direction
%
%   Syntax:
%      HANDLES = WIND_ARROW(V,DIR,POS,TT,HH,SA,C1,C2,C3,C4,EOPT,IOPT)
%
%   Inputs:
%      V      Intensity
%      DIR    Direct direction (deg)
%      POS    Position [ <x y> {<0 0>} ]
%      TT     Tip angle [ 20 ]
%      HH     Tail ratio [ 0.2 ]
%      SA     Semi-axis length [ V ]
%      C1     Color of arrow axis [ 'k' ]
%      C2     Color of arrow edges [ 'k' ]
%      C3     Color of arrow (right) [ 'w' ]
%      C4     Color of arrow (left) [ 'k' ]
%      EOPT   External circumference line options (pts each 15 deg).
%             If none is not plotted [ <none> ]
%      IOPT   Internal circumference options (pts each 15 deg).
%             If none is not plotted [ <none> ]
%
%   Output:
%      HANDLES   Structure of handles
%
%   Examples:
%      figure
%      h=wind_arrow(1,70);
%      axis equal
%      V=1;
%      h=wind_arrow(V,70,[0 0],20,.2,V,'k','k','w','k','.','.');
%      h=wind_arrow(V,70,[2 1],20,.2,V,'b','k','g','r');
%
%   MMA 4-12-2002, martinho@fis.ua.pt
%
%   See also NORTH_ARROW, VECTOR

%   Department of physics
%   University of Aveiro

int = 1;
ext = 1;
if nargin < 12
  int=0;
end
if nargin < 11
  ext=0;
elseif ext_opt == 0
  ext = 0;
end
if nargin < 10
  c4='k';
end
if nargin  < 9
  c3='w';
end
if nargin < 8
  c2='k';
end
if nargin < 7
  c1='k';
end
if nargin < 6
  SA=V;
end
if nargin < 5
  hh=.2;
end
if nargin < 4
  tt=20;
end
if nargin < 3
  pos=[0 0];
end
if nargin < 2
  error('# wind_arrow needs at least V and dir as input...')
end
  
% EIXOS:
handles.axes=plot([-SA SA nan 0 0]+pos(1),[0 0 nan -SA SA]+pos(2),c1);
 hold on

% ESCALA EXTERNA:
a=5;
pts=30;
teta=[linspace(-a,a,pts) NaN linspace(90-a,90+a,pts) NaN ...
      linspace(180-a,180+a,pts) NaN linspace(270-5,270+5,pts)]*pi/180;
handles.ext_circ=plot(SA*cos(teta)+pos(1),SA*sin(teta)+pos(2),c1);
if ext
  cl=[c1,ext_opt];
  handles.ext=plot(SA*cos([0:15:360]*pi/180)+pos(1),SA*sin([0:15:360]*pi/180)+pos(2),cl);
  set(handles.ext,'MarkerSize',5);
end

% ESCALA INTERNA:
eint=2;
SA=SA/eint;
handles.int_circ=plot(SA*cos(teta)+pos(1),SA*sin(teta)+pos(2),c1);
if int
  cl=[c1,int_opt];
  handles.int=plot(SA*cos([0:15:360]*pi/180)+pos(1),SA*sin([0:15:360]*pi/180)+pos(2),cl);
  set(handles.int,'MarkerSize',5);
end

% SETA, NORTE:
P=pos;
Vn=[0 SA*eint];
r=.8;
Vn=Vn*1/r;
handles.vector=vector(P,Vn,.1,20,c1,1);

% NORTH_ARROW:
H=V;
h=hh*H;
H=H+h;
hh=h/H;
rot=dir-90;
vertice=[h*cos(rot*pi/180+pi/2) h*sin(rot*pi/180+pi/2)];
POS=pos-vertice;
handles.arrow=north_arrow('',H,hh,tt,POS,rot,c4,c3,c2);
