function handle = ellfield(x0,y0,major,minor,inc,phase,varargin)
%ELLFIELD   Draw ellipses field using major, minor, inc and phase
%   Uses the ellipses parameters major, minor, inc and phase to
%   draw a field of ellipses as lines or patches.
%
%   Syntax:
%      HANDLE = ELLFIELD(X,Y,MAJOR,MINOR,INC,PHA,VARARGIN)
%
%   Inputs:
%      X, Y     Ellipses centre, N-D arrays
%      MAJOR, MINOR, INC, PHA   Ellipses parameters, N-D arrays
%      VARARGIN:
%         C, patches CData, N-D array, or line color  [ 'k' ]
%         'incl', [ 0 | {1} ], show inclination radial line
%         'tipl', <val>, tip length with respect to MAJOR [ 0.1 ]
%         (the tip is drawn at the intersection of the radial line and
%         the ellipse)
%         'z', <val>, z level where each ellipse is drawn, N-D array or
%            scaler applyed to all ellipses [ 0 ]
%
%   Output:
%      HANDLE   Handle for the lines or patches
%
%   Examples:
%      figure
%      x = linspace(1,100,8);
%      y = linspace(1,100,10);
%      [x,y] = meshgrid(x,y);
%      major = (x+y)/30;
%      minor = sqrt(x+y)/10;
%      inc   = x/2;
%      phase = y;
%      C     = minor./major;
%
%      subplot(2,2,1)
%      ellfield(x,y,major,minor,inc,phase,C);
%      caxis([.1 .5]), axis equal
%      subplot(2,2,2)
%      ellfield(x,y,major,minor,inc,phase,'b');
%      axis equal
%      subplot(2,2,3)
%      C = inc;
%      ellfield(x,y,major,minor,inc,phase,C,'z',y);
%      axis equal, view(3)
%      subplot(2,2,4)
%      ellfield(x,y,major,minor,inc,phase,y,'incl',0,'tipl',0);
%      axis equal, colorbar
%
%   MMA 15-3-2006, mma@odyle.net

handle = [];
if nargin < 6
  disp(['## ',mfilename,' : x, y, major, minor, inc and pha are needed']);
  return
end

usePatch = 0;
incl     = 1;
color    = 'k';
tipl     = 0.1;
z        = 0;
for i=1:length(varargin)
  if i==1
    if iscolor(varargin{i})
      color = varargin{i};
    elseif isnumeric(varargin{i});
      C = varargin{i};
      usePatch = 1;
    end
  end
  if isequal(varargin{i},'incl')
    incl = varargin{i+1};
  end
  if isequal(varargin{i},'tipl')
    tipl = varargin{i+1};
  end
  if isequal(varargin{i},'tipa')
    tipa = varargin{i+1};
  end  
  if isequal(varargin{i},'z')
    z = varargin{i+1};
  end
end

% Check sizes: -------------------------------------------------------
s = size(x0);
n = prod(s);
if size(y0)~=s | size(major)~=s | size(minor)~=s | size(inc)~=s | size(phase)~=s
  disp(['## ',mfilename,' : inconsistent size of input variables']);
  return
end

if usePatch & size(C)~=s
  disp(['## ',mfilename,' : bad size of C']);
  return
end

if prod(size(z))~=1 & size(z)~=s
  disp(['## ',mfilename,' : bad size of z']);
  return
end

% Build x,y: ---------------------------------------------------------
t     = linspace(0,2*pi,100)'; st   = size(t);
major = reshape(major,1,n);    sm   = size(major);
minor = reshape(minor,1,n);    fmaj = major;
inc   = reshape(inc,1,n);
phase = reshape(phase,1,n);

t     = repmat(t,sm);
major = repmat(major,st);
minor = repmat(minor,st);
inc   = repmat(inc,st);
phase = repmat(phase,st);

x=major.*cos(t-phase*pi/180);
y=minor.*sin(t-phase*pi/180);

[th,r] = cart2pol(x,y);
[x,y]  = pol2cart(th+inc*pi/180,r);

% Add inc line and arrow: --------------------------------------------
a    = fmaj*tipl; % arrow tip length
Fi   = 30; % arrow tip angle
teta = atan2(y(end,:)-y(end-1,:),x(end,:)-x(end-1,:))*180/pi;
fi   = (180-Fi+teta)*pi/180;
fii  = (180+Fi+teta)*pi/180;
Fi   = Fi*pi/180;
 
nans = repmat(nan,sm);
zs   = repmat(0,sm);

P1 = [x(1,:); y(1,:)];
P2 = [P1(1,:)+a.*cos(fi)/cos(Fi);  P1(2,:)+a.*sin(fi)/cos(Fi);  P1(end,:)];
P3 = [P1(1,:)+a.*cos(fii)/cos(Fi); P1(2,:)+a.*sin(fii)/cos(Fi); P1(end,:)];

if incl
  x = [x; nans; zs; P1(1,:); nans; P2(1,:); P1(1,:); P3(1,:)];
  y = [y; nans; zs; P1(2,:); nans; P2(2,:); P1(2,:); P3(2,:)];
else
  x = [x; nans; P2(1,:); P1(1,:); P3(1,:)];
  y = [y; nans; P2(2,:); P1(2,:); P3(2,:)];
end
nt = size(x,1);

% Add x0,y0: ---------------------------------------------------------
x0(fmaj==0)=nan;
x0(isnan(fmaj))=nan;
x  = x+repmat(reshape(x0,1,n),nt,1);
y  = y+repmat(reshape(y0,1,n),nt,1);

% Deal with z: -------------------------------------------------------
if prod(size(z))==1
  z = repmat(z,size(x));
else
  z = repmat(reshape(z,1,n),nt,1);  
end

% Plot: --------------------------------------------------------------
if ~usePatch
  theView = view;
  handle = plot3(x,y,z,'color',color);
  view(theView);
else
  % Build Vertices, Faces and Colors: --------------------------------
  Vx = reshape(x,prod(size(x)),1);
  Vy = reshape(y,prod(size(y)),1);
  Vz = reshape(z,prod(size(z)),1);
  C  = reshape(repmat(reshape(C,sm),nt,1),n*nt,1);
  F  = reshape([1:n*nt],nt,n)';

  handle = patch(Vx,Vy,Vz,C);
  set(handle,'Faces', F,'edgecolor','interp');
end


function is = iscolor(in)
%ISCOLOR   Check if color string or rgb triple
%
%   Syntax:
%      IS = ISCOLOR(COLOR)
%
%   Input:
%      COLOR   rgb value, color short or long name
%
%   Output:
%      IS   0 or 1
%
%  Examples:
%     iscolor('g')
%     iscolor('green')
%     iscolor([0 1 0])
%
%   MMA 8-2005, martinho@fis.ua.pt

is=0;
str_color = {
             'w'; 'white'   ;
             'b'; 'blue'    ;
             'g'; 'green'   ;
             'r'; 'red'     ;
             'c'; 'cyan'    ;
             'm'; 'magenta' ;
             'y'; 'yellow'  ;
             'k'; 'black'
            };
if isstr(in)
  if ismember(in,str_color)
    is = 1;
    return
  end
elseif prod(size(in))==3 & ~isnan(in) & in>=0 & in<=1
  is = 1;
end
