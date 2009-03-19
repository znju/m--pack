function seta2d(P,V,color_edge,color_in,scale,Ruv,teta,params);
%SETA2D   Plot 2D filled arrow
%
%                        3
%                       .\  \                P=0
%                       . \     \            L=04
%           1 __________.__\2      \         PARAMS(1)=0i/04
%          0|          _i_  ,   _tt(_\4      PARAMS(2)=01/i3
%           |_______________6        /       PARAMS(3)=i,/i4
%           7           .  /       /         tt=TETA=tip angle
%                       . /     /
%                       ./  /
%                        /
%
%   Syntax:
%      SETA2D(P,V,EDGE,IN,SCALE,RUV,TETA,PARAMS)
%
%   Inputs:
%      P        Arrow origin [ <x y> ]
%      V        Arrow vector [ <u v> ]
%      EDGE     Edge color [ 'r' ]
%      IN       Inside fill color [ 'y' ]
%      SCALE    Arrow scale [ 1 ]
%      RUV      Rate u/v [ 1 ]
%      TETA     Tip angle [ 45 ]
%      PARAMS   Parameters, see scheme above [ <a b c> {<2/3 1/3 1/3>} ]
%
%   Example:
%      P=[1 1];V=[1 -1];
%      seta2d(P,V,'k','g',1,1,30,[.5 .2 .5])
%      axis equal
%
%   MMA 2001, martinho@fis.ua.pt
%
%   See also VECTOR

%   Department of physics
%   University of Aveiro

if nargin < 8
  param1=2/3;
  param2=1/3;
  param3=1/3;
else
  param1=params(1);
  param2=params(2);
  param3=params(3);
end
if nargin < 7
  teta=45;
end
if nargin < 6
  Ruv=1;
end
if nargin < 5
  scale=1;
end
if nargin < 4
  color_in='y';
end
if nargin < 3
  color_edge='r';
end
if nargin < 2
  error('seta2d needs at least P and V as input arguments');
end

V(1)=Ruv*V(1);
L=norm(V);
if ~(V(1)==0 & V(2)==0)
  r=V/L;
  L=L*scale;
  P4=P+L*r;
  Pi=P+param1*L*r;
  if V(2)==0
    aux=pi/2;
  else
    aux=atan(-V(1)/V(2));
  end
  ri=[cos(aux),sin(aux)];
  PiP3=norm(P4-Pi)*tan(teta*pi/180);
  P3=Pi+ri*PiP3;
  P5=Pi-ri*PiP3;
  P1=P+ri*PiP3*param2;
  P7=P-ri*PiP3*param2;
  b=param3*norm(P4-Pi);
  bb=b/PiP3*(PiP3-norm(P1-P));
  P2=P1+(param1*L+bb)*r;
  P6=P7+(param1*L+bb)*r;

  fill([P(1) P1(1) P2(1) P3(1) P4(1) P5(1) P6(1) P7(1) P(1)],...
       [P(2) P1(2) P2(2) P3(2) P4(2) P5(2) P6(2) P7(2) P(2)],color_in);
  ish = ishold;
  hold on
  plot([P(1) P1(1) P2(1) P3(1) P4(1) P5(1) P6(1) P7(1) P(1)],...
       [P(2) P1(2) P2(2) P3(2) P4(2) P5(2) P6(2) P7(2) P(2)],color_edge);
  if ~ish
    hold off
  end
end
