function fixedar(fig)
%FIXEDAR   Set figure PaperPosition as Position
%   Enables to obtain the same size of printed figure as on screen.
%   For this the printing option -r0 and -zbuffer should be used for
%   some image formats  (like tiff and ps).
%
%   Syntax:
%      FIXEDAR(FIG)
%
%   Input:
%      FIG   Figure handle [ <gcf> ]
%
%   Example:
%      plot(1:10);
%      fixedar;
%      printpreview
%
%   MMA 7-7-2004, martinho@fis.ua.pt
%
%   See also GET_TIFF

%   Department of Physics
%   University of Aveiro, Portugal

if nargin == 0
  fig = gcf;
end

absUnits='inches';

paperUnits = get(fig,'PaperUnits');
figUnits   = get(fig,'Units');

set(fig,'PaperUnits', absUnits);
set(fig,'Units',      absUnits);

figPosition = get(fig,'Position');
paperSize   = get(fig,'PaperSize');

W = figPosition(3);
H = figPosition(4);
x = paperSize(1)/2-W/2;
y = paperSize(2)/2-H/2;

set(fig,'PaperPosition',[x y W H]);

% restore units:
set(fig,'PaperUnits',paperUnits);
set(fig,'Units',figUnits);

if W > paperSize(1) | H > paperSize(2)
  quiet=1;
  if ~quiet
    disp('## figure  is bigger than paper ...!!')
  end
end
