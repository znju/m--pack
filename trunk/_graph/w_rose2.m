function handles = w_rose2(rout1,rin2,pos,rot,c1,c2,label)
%W_ROSE2   Draw wind rose
%
%   Syntax:
%      HANDLES = W_ROSE2(R,L,POS,ROT,C1,C2,LABEL)
%
%   Inputs:
%      R       Radius [ 9 ]
%      L       Base length of triangles [ 1 ]
%      POS     Position [ <0 0> ]
%      ROT     Rotation [ 0 ]
%      C1      Color of main triangles
%              [ <r g b> {<0.8863 0.7451 0.2549>} ]
%      C2      Color of secondary triangles
%              [ <r g b> {<0.8863 0.7451 0.2549>} ]
%      LABEL   Text to label direction [ 'N' ]
%
%   Output:
%      HANDLES   Handles for all objects drawn
%
%   Examples:
%      figure, subplot(1,2,1)
%      h=w_rose2
%      subplot(1,2,2)
%      h=w_rose2(5,.5,[-10,40],15,[0 1 0],[1 0 0]);
%      set(h.fill_l(1:3),'facecolor','b')
%      set(h.label,'fontsize',12)
%
%   MMA 5-11-2003, martinho@fis.ua.pt
%
%   See also W_ROSE

%   Department of physics
%   University of Aveiro

%   24-07-2008 - Renamed from wind_rose, cos another wind_rose as an
%                intensity/frequency/direction plot was created.

if nargin < 7
  label='N';
end
if nargin < 6
  c2=[0.8863    0.7451    0.2549];
end
if nargin < 5
  c1=[0.8745    0.3373    0.2588];
end
if nargin < 4
  rot=0;
end
if nargin < 3
  pos=[0 0];
end
if nargin < 2
  rin2=1;
end
if nargin < 1
  rout1=9;
end

% ------- radius and lengths:
%rout1 = 2nd circumference (from outside)
%rin2  = side of triangles

rout2=rout1*1.03; % outer circumference
% inside triangles:
L=rin2;
H=rout1;
% inside circumferences:
r_in=L*.4;
r_in1=L;
r_in2=L*1.5;

% ------ colors:
cor_r1=c2;
cor_r2=c1;
cor_l1=c2;
cor_l2=c1;

%»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
ish=ishold;
% ----------- outer circumferences:
tt=linspace(0,2*pi,200);
x=rout1*cos(tt);
y=rout1*sin(tt);
[x,y]=rot2d(x,y,rot); % not needed !!
x=x+pos(1);
y=y+pos(2);
handles.rout1=plot(x,y,'k');     hold on,  axis equal  % handles.rout1
x=rout2*cos(tt);
y=rout2*sin(tt);
[x,y]=rot2d(x,y,rot); % not needed !!
x=x+pos(1); 
y=y+pos(2);
handles.rout2=plot(x,y,'k');                           % handles.rout2


%------------ inside triangles:
xri=[0 L 0 0];
yri=[0   0 H 0];
xli=[0 -L 0 0];
yli=[0 0 H 0];
ang=30;
tt=fliplr([0 180 90 270, 45 135 225 315, 22.5 67.5 112.5 157 202.5 247 292.5 337.5]);
for i=1:length(tt)
  if i > 8
    corR=cor_r1;
    corL=cor_l1;
  else
    corR=cor_r2;
    corL=cor_l2;
  end
  [xr,yr]=rot2d(xri,yri,tt(i)); 
  [xr,yr]=rot2d(xr,yr,rot);
  xr=xr+pos(1);
  yr=yr+pos(2);

  [xl,yl]=rot2d(xli,yli,tt(i)); 
  [xl,yl]=rot2d(xl,yl,rot);
  xl=xl+pos(1);
  yl=yl+pos(2);
  
  handles.fill_r(i)=fill(xr,yr,corR);                 % handles.fill_r
  handles.fill_l(i)=fill(xl,yl,corL);                 % handles.fill_l
end

%------------ inside circumferences:
tt=linspace(0,2*pi,200);
handles.fill_in3=fill(r_in2*cos(tt)+pos(1),r_in2*sin(tt)+pos(2),cor_r1); % handles.fill_in3
handles.fill_in2=fill(r_in1*cos(tt)+pos(1),r_in1*sin(tt)+pos(2),cor_r1); % handles.fill_in2
handles.fill_in1=fill(r_in*cos(tt)+pos(1),r_in*sin(tt)+pos(2),cor_r1);   % handles.fill_in1

%------------ North arrow and label:
hh=rout2*1.15;
h=rout2/3;
l=h/3;
x=[0 l/2 0 0 -l/2 0 0];
y=[0 h/3 h 0  h/3 h 0]+hh;
[x,y]=rot2d(x,y,rot);
x=x+pos(1);
y=y+pos(2);
handles.north=fill(x,y,cor_r1);                        % handles.north

x=0;
y=rout2;
[x,y]=rot2d(x,y,rot);
x=x+pos(1);
y=y+pos(2);
handles.label=text(x,y,label,'HorizontalAlignment','center',... % handles.label
  'VerticalAlignment','bottom','fontsize',16,'rotation',rot);
%set(handles.label,'fontname','Roman');

if ~ ish
  hold off
end

function [x,y] = rot2d(xi,yi,teta)
%ROT2D   2D rotatiom
teta=teta*pi/180;
[th,r]=cart2pol(xi,yi);
[x,y]=pol2cart(th+teta,r);
