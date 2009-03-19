function h=plot_sticks(t,u,v,varargin)
%PLOT_STICKS   Plot time,u,v arrows
%
%   Syntax:
%      H = PLOT_STICKS(T,U,V,VARARGIN)
%
%   Inputs:
%      T,U,V   Time, velocity in the directions x and y
%      VARARGIN:
%         r, rate for length of x and y axis (default=0.5)
%         xpadd, padding at left and right (default=[5 5])
%         ylim
%         yt, yticks
%         xt, xticks
%         xtl, xticklabel
%
%   Output:
%      H   VFIELD handle
%
%   MMA 24-7-2006, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

manualYticks=0;
manualXticks=0;
manualXtickLabels=0;

r=1/2;
xpadd=[5 5];
yl=[min(v) max(v)];

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'r')
    r=vin{i+1};
  elseif isequal(vin{i},'xpadd')
    xpadd=vin{i+1};
  elseif isequal(vin{i},'ylim')
    yl=vin{i+1};
  elseif isequal(vin{i},'yt')
    manualYticks=1;
    yticks=vin{i+1};
  elseif isequal(vin{i},'xt')
    manualXticks=1;
    xticks=vin{i+1};
  elseif isequal(vin{i},'xtl')
    manualXtickLabels=1;
    xtickLabels=vin{i+1};
  end
end

% calc scale:
dx=t(end)-t(1) +sum(xpadd);
dy=diff(yl);
scale=dx/dy*r;

h=vfield(t,t*0,u*scale,v*scale,'tr',0); axis equal

% limits:
ylim(yl*scale)
xlim([t(1)-xpadd(1) t(end)+xpadd(2)])

% yticks:
if ~manualYticks
  yticks=get(gca,'ytick');
  ytickLabels=yticks/scale;
else
  ytickLabels=yticks;
  yticks=yticks*scale;
end
set(gca,'ytick',yticks);
set(gca,'yticklabel',ytickLabels)

% xticks:
if manualXticks
  set(gca,'xtick',xticks)
end
if manualXtickLabels
  set(gca,'xticklabel',xtickLabels)
end
