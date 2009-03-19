function [handle,keyHandle]=mm_vec(s,x,y,u,v,varargin)
%MM_VEC   Draw vector fields on M_MAP projections
%   This is a simpler and faster version of the m_map function m_vec.
%
%   Syntax:
%      [H,HK] = MM_VEC(S,X,Y,U,V,VARARGIN)
%
%   Inputs:
%      S      Scale factor, arrow data units per inch.
%      X, Y   Fields positions, longitude and latitude
%      U, V   Field values, W-E and S-N components
%      VARARGIN:
%        C, CData
%        'key', <string> make a labelled arrow
%        Any other options of the function VFIELD
%
%   Outputs:
%      H    handle for the plotted field
%      HK   handle for the string, when using 'key' as varargin
%
%   Comment:
%      M_MAP is a mapping toolbox from Rich Pawlowicz freely
%      available at http://www2.ocgy.ubc.ca/~rich/map.html
%
%   Example:
%      figure
%      m_proj('mercator','lon',[-12 -5],'lat',[37 45])
%      m_coast
%      m_grid('box','fancy')
%      x = -12:.4:-5; y = 37:.5:45;
%      [x,y] = meshgrid(x,y);
%      z=(x+10).^2 + (y-40).^2;   [u,v] = gradient(z/max(max(z)),.2,.15);
%      c = sqrt(u.^2+v.^2);
%      mm_vec(2,x,y,u,v,c)
%      colorbar
%      [h,hh] = mm_vec(2,-7,36.5,1,0,'fill',1,'key','1 cm.s^-1')
%
%   MMA 28-7-2005, martinho@fis.ua.pt
%
%   See also VFIELD

%   Department of physics
%   University of Aveiro

handle    = [];
keyHandle = [];
clip      = 'on'; % except for the key
UVperIn   = s;

% get key:
showKey = 0;
for n=1:length(varargin)
  if isequal(varargin{n},'key')
      key = varargin{n+1};
      showKey = 1;
      clip = 'off';
    break
  end
end

% -------------------------------------------- from m_vec, m_map
OrigAxUnits = get(gca,'Units');
if OrigAxUnits(1:3) == 'nor'
   OrigPaUnits = get(gcf, 'paperunits');
   set(gcf, 'paperunits', 'inches');
   figposInches = get(gcf, 'paperposition');
   set(gcf, 'paperunits', OrigPaUnits);
   axposNor = get(gca, 'position');
   axWidLenInches = axposNor(3:4) .* figposInches(3:4);
else
   set(gca, 'units', 'inches');
   axposInches = get(gca, 'position');
   set(gca, 'units', OrigAxUnits);
   axWidLenInches = axposInches(3:4);
end

% Multiply inches by the following to get data units:
scX = diff(get(gca, 'XLim'))/axWidLenInches(1);
scY = diff(get(gca, 'YLim'))/axWidLenInches(2);
sc = max([scX;scY]);  %max selects the dimension limited by
                      % the plot box.

uvmag = abs(u + i*v);
L = uvmag*sc/UVperIn;

[xs, ys] = m_ll2xy(x,y, 'clip', clip);
[xsp, ysp] = m_ll2xy(x+0.1*u./uvmag, y+0.1*v.*cos(y*pi/180)./uvmag, 'clip', clip);
Ang = angle( (xsp-xs) + i*(ysp-ys) );
% ----------------------------------------------------------------------------------
x=xs;
y=ys;
u = L.*cos(Ang);
v = L.*sin(Ang);

ish = ishold; hold on
handle = vfield(x,y,u,v,varargin{:});
if showKey
  set(handle,'clipping','off');
  keyHandle = text(x,y,key);
  set(keyHandle,'VerticalAlignment','top');%,'HorizontalAlignment','right');
end
if ~ish, hold off; end
