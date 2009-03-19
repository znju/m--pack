function vector2d (P,V,color,scale,Ruv,teta,param1,fill_opt);
%VECTOR2D   Draw arrow 2D
%
%   Syntax:
%      VECTOR2D(P,V,COLOR,SCALE,RUV,TETA,PARAM,FILLIT)
%
%   Inputs:
%      P        Arrow origin [ <x y> ]
%      V        Arrow vector [ <u v> ]
%      COLOR    Arrow color [ 'k' ]
%      SCALE    Arrow scale [ 1 ]
%      RUV      Rate u/v [ 1 ]
%      TETA     Tip angle [ 45 ]
%      PARAM    1-tip scale with respect to intensity [ 2/3 ]
%      FILLIT   Fill option of tip [ {0} | 1 ]
%
%   Comment:
%      DEPRECATED, use VECTOR instead
%
%   Example:
%      P=[1 1];V=[1 -1];
%      vector2d(P,V,'r',1,1,45,2/3,1)
%      axis equal
%
%   MMA 2001, martinho@fis.ua.pt
%
%   See also VECTOR

%   Department of physics
%   University of Aveiro

if nargin < 8
  fill_opt=0;
end
if nargin < 7
  param1=2/3;
end
if nargin < 6
  teta=45;
end
if nargin < 5 
  Ruv=1;
end
if nargin < 4
  scale=1;
end
if nargin < 3
  color='k';
end
if nargin < 2
  error('## VECTOR2 needs at least P and V as input arguments...');
end
if nargin > 8
  error('## too many input arguments...');
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
  plot([P(1) P4(1)],[P(2) P4(2)],color),hold on
  plot([P3(1) P4(1) P5(1)],[P3(2) P4(2) P5(2)],color)
  if fill_opt==1;
    fill([P3(1) P4(1) P5(1) P3(1)],[P3(2) P4(2) P5(2) P3(2)],color);
  end
  hold off
end
