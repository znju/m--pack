function [x,y]=m_input(N,varargin)
%M_INPUT   Graphical input from mouse
%   Similar to ginput. Input with mouse is done N times or until
%   right mouse button is pressed.
%   Without output arguments, the selected position is shown.
%
%   Syntax:
%      [X,Y] = M_INPUT(N,VARARGIN)
%
%   Inputs:
%      N   Number of inputs (mouse clicks) [ inf ]
%      VARARGIN:
%         'pointer', mouse pointer shape [ 'crosshair' ]
%
%   Output:
%      X, Y   Selected position
%
%   Example:
%      m_input(inf,'pointer','fullcrosshair');
%
%   MMA 2004, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

if nargin==0
  N=inf;
end

pointer_tmp = 'crosshair';
vin = varargin;
for ii=1:length(vin)
  if isequal(vin{ii},'pointer')
    pointer_tmp = vin{ii+1};
  end
end

x=[];
y=[];

fig = gcf;
ax  = gca;

uistate=uisuspend(fig);
uirestore(uistate,'WindowButtonMotionFcn')
set(fig,'pointer',pointer_tmp);
button = 'normal';
n=0;
while strcmp(button,'normal') & n < N
  keydown = waitforbuttonpress;
  button = get(fig, 'SelectionType');
  if  strcmp(button,'normal')
      cp=get(ax,'currentpoint');
      n=n+1;
      x(n)=cp(1,1);
      y(n)=cp(1,2);
      if nargout == 0
        fprintf('\n');
        fprintf(' x = %f\n',x(n));
        fprintf(' y = %f\n',y(n));
      end
  end
end % while
uirestore(uistate);
uirestore(uistate,'pointer');
