function plot_romsgrd(file,varargin)
%PLOT_ROMSGRD   Plot ROMS grid
%   Created to plot ROMS-AGRIF grid, but can use any ROMS output file.
%   In case of nesting, the child grids are also plotted.
%   Any file can be used if the grid file id given as NetCDF global
%   attribute.
%
%   Syntax:
%      PLOT_ROMSGRD(FILE,VARARGIN)
%
%   Inputs:
%      FILE   Any ROMS output file (see FIND_ROMSFILES)
%      VARARGIN:
%         axes, default=gca
%         xlim, default=limits of lon_rho
%         ylim, default=limits of lat_rho
%         isobaths,    contour levels (default=[200 1000])
%         isobaths_ls, line style for isobaths (default='k--')
%         coastline,   coastline mat file
%         mask,    show mask (default=1)
%         mask_ls, line style for mask
%         child,   <number>, show only that child (default='all')
%         border,    show border (default=1)
%         border_ls, line style for region border (see ROMS_BORDER),'b'
%         cla, clear axes before plots (default=1)
%         proj, m_map projection, default='mercator' (use 'none' if
%               you don't want to use a projection
%         proj_opts, options for the m_map projection
%
%
%   Example:
%      plot_romsgrd('stations.nc')
%
%   MMA 3-2007, martinho@fis.ua.pt
%
%   See also FIND_ROMSFILES, ROMS_BORDER

% Department of Physics
% University of Aveiro, Portugal

parse_links=0;

if nargin == 0
  disp([':: ',mfilename,' : ROMS_Agrif output  file needed']);
  return
end

grids=find_romsfiles(file,'grid',parse_links);
grds={};
for i=1:length(grids)
  if exist(grids{i})==2, grds(end+1)=grids(i); end
end
grids=grds;

if  isempty(grids) | ~exist(grids{1})
  grids=find_romsfiles(file,'his',parse_links);
end

if  isempty(grids) | ~exist(grids{1})
  grids=find_romsfiles(file,'avg',parse_links);
end

if  isempty(grids) | ~exist(grids{1})
  grids={file};
end


% load data from file:
grd0=grids{1};
[x,y,h,m] = roms_grid(grd0);
theXlim=[min(min(x)) max(max(x))];
theYlim=[min(min(y)) max(max(y))];

theAxes        = [];
theIsobaths    = [200  1000];
theCoastline   = [];
theMask        = 1;
theMask_ls     = 'r';
theChild       = 'all';
theIsobaths_ls = 'k--';
theBorder      = 1;
theBorder_ls   = 'b';
theProj        = 'mercator';
theProj_opts   = {};
cla_ = 1;

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'axes')
    theAxes=vin{i+1};
  elseif isequal(vin{i},'xlim')
    theXlim=vin{i+1};
  elseif isequal(vin{i},'ylim')
    theYlim=vin{i+1};
  elseif isequal(vin{i},'isobaths')
    theIsobaths=vin{i+1};
  elseif isequal(vin{i},'isobaths_ls')
    theIsobaths_ls=vin{i+1};
  elseif isequal(vin{i},'coastline')
    theCoastline=vin{i+1};
  elseif isequal(vin{i},'mask')
    theMask=vin{i+1};
  elseif isequal(vin{i},'mask_ls')
    theMask_ls=vin{i+1};
  elseif isequal(vin{i},'child')
    theChild=vin{i+1};
  elseif isequal(vin{i},'border')
    theBorder=vin{i+1};
  elseif isequal(vin{i},'border_ls')
    theBorder_ls=vin{i+1};
  elseif isequal(vin{i},'cla')
    cla_=vin{i+1};
  elseif isequal(vin{i},'proj')
    theProj=vin{i+1};
  elseif isequal(vin{i},'proj_opts')
    theProj_opts=vin(i+1:end);

  end
end

useproj=1;
if isequal(theProj,'none')
  useproj=0;
end

if isempty(theAxes)
  theAxes=gca;
end

axes(theAxes); if cla_, cla; end

% projection:
if ~ishold, cla, end
if useproj
  switch lower(theProj)
    case  lower({'Mercator',...
                 'Albers Equal-Area Conic',...
                 'Lambert Conformal Conic',...
                 'Miller Cylindrical',...
                 'Equidistant Cylindrical',...
                 'Oblique Mercator',...
                 'Transverse Mercator',...
                 'Sinusoidal',...
                 'Gall-Peters',...
                 'Hammer-Aitoff',...
                 'Mollweide',...
                 'UTM'})
      m_proj(theProj,'lon',theXlim,'lat',theYlim,theProj_opts{:});
    case lower({'Stereographic',...
                'Orthographic',...
                'Azimuthal Equal-area',...
                'Azimuthal Equidistant',...
                'Gnomonic',...
                'Satellite'})
      m_proj(theProj,'lon',mean(theXlim),'lat',mean(theYlim),'rad',[theXlim(1),theYlim(1)],theProj_opts{:});
  end
end
hold on
if useproj
%  m_grid('box','fancy','tickdir','off');
  m_grid('box','on');
end

% coastline:
if ~isempty(theCoastline)
  if useproj
    try
      m_usercoast(theCoastline,'patch',[.8 .8 .8])
    catch
      disp([':: ',mfilename,' : unable  to  use coastline file ',theCoastline]);
    end
  else
    try
      data=load(theCoastline);
      plot(data.lon,data.lat)
    catch
      disp([':: ',mfilename,' : unable  to  use coastline file ',theCoastline]);
    end
  end
end

% grid  children, mask and isobaths
if ~isequal(theChild,'all')
  grids=[grids(1),grids(theChild+1)];
  if isequal(theChild,0)
    grids=grids(1);
  end
end
for i=1:length(grids)
  if i>1
    [x,y,h,m] = roms_grid(grids{i});
  end

  % isobaths:
  if theIsobaths
    if useproj
      m_contour(x,y,h,theIsobaths,theIsobaths_ls);
    else
      contour(x,y,h,theIsobaths,theIsobaths_ls);
    end
  end

  % mask:
  if theMask
    if useproj
      m_contour(x,y,m,[.5 .5],theMask_ls);
    else
      contour(x,y,m,[.5 .5],theMask_ls);
    end
  end

  % region border:
  if theBorder
    [x,y]=roms_border(grids{i});
    if useproj
      m_plot(x,y,theBorder_ls);
    else
      plot(x,y,theBorder_ls);
    end
  end
end

if ~useproj
  axis([theXlim theYlim])
end
hold off
