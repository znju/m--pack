function [var,z,ot,ij]=get_sta(pos,varname,file,t,plot_contour,fig)
%GET_STA   Get vertical profile of a ROMS variable (deprecated)
%   Returns vertical variable at a certain location.
%
%   Syntax:
%      [VAR,Z,OT,IJ] = GET_STA(POS,VARNAME,FILE,T,CONTOUR,FIG)
%
%   Inputs:
%      POS       Position where data will be extracted, may be
%                [longitude latitude] or absolute position in file;
%                in this case should be introduced as string ['i j'].
%                If using ROMS stations file, and absolute position only i
%                is needed ['i']
%      VARNAME   Variable to extract
%      FILE      NetCDF ROMS output history or stations file
%      T         Time index of variable, t=0 means all times
%      CONTOUR   If set, region will be plotted with depth contours 
%                defined by this variable   [h1 h2 ... hn].
%                If using stations file only stations are plotted, so
%                this can be any value
%      FIG       Figure handle for plot   [ 1 ]
%
%   Output:
%      VAR   Vertical profile of variable 
%      Z     Depth
%      OT    Ocean_time at time index T
%      IJ    Grid indexes, same as POS if absolute position in file
%            is used
%
%   Comment:
%      The following variables must exist in file:
%      - lon_rho
%      - lat_rho
%      - h
%      - zeta
%      - "varname"
%      - theta_s
%      - theta_b
%      - tcline
%
%   This function is ** DEPRECATED **, use ROMS_TS instead
%
%   Examples:
%      pos=[-10.2 40.5];
%      varname='salt';
%      file='roms_his.nc';
%      t=20;
%      plot_contour=[50 200 500];
%      fig=1;
%      [var,z,ot]=get_sta(pos,varname,file,t,plot_contour,fig);
%
%      pos=['20'];
%      file='roms_sta.nc';
%      [var,z,ot]=get_sta(pos,varname,file,t,1,fig);
%
%   MMA 19-3-2004, martinho@fis.ua.pt
%
%   See also S_PARAMS, S_LEVELS, ROMS_TS

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 6
  fig=1; % figure handle
end

if nargin >= 5
  vv=plot_contour;
  do_contour=1;
  if length(vv) == 1, vv=[vv vv]; end;
else
  do_contour=0;
end

warn_str='';
if nargin < 4
  warn_str=strvcat(warn_str,'# you must provide time index');
end

if nargin < 3
  warn_str=strvcat(warn_str,'# you must provide roms his or sta file');
end

if nargin < 2
  warn_str=strvcat(warn_str,'# you must provide variable to extract');
end

if nargin < 1
  warn_str=strvcat(warn_str,'# you must provide position, Jesus Crist... ');
end

if ~isempty(warn_str)
  disp(warn_str); 
  return;
end

% ---------------------- load variables:
nc=netcdf(file);
  lon=nc{'lon_rho'}(:);
  lat=nc{'lat_rho'}(:);
  h=nc{'h'}(:);
  if t==0
    ot=nc{'ocean_time'}(:);
  else
    ot=nc{'ocean_time'}(t);
  end
  mask=nc{'mask_rho'}(:);
nc=close(nc);

issta=0;
if size(lon,2)==1
  issta=1;
end

% ---------------------- position:
if isstr(pos)
  pos=str2num(pos);
  if length(pos)==1 % sta, not his
    i=pos(1);
    j=1;
  else
    i=pos(2);
    j=pos(2);
  end
else % just find nearest lon x lat pos (not str)
  dist=sqrt((lon-pos(1)).^2 + (lat-pos(2)).^2);
  [i,j]=find(dist==min(min(dist)));
end
% if sta, only i matters.

ij=[i j]; % output variable

%-------------------------- load required vars at pos:
nc=netcdf(file);
if t== 0 % all times
  if ~issta % his file
    zeta=nc{'zeta'}(:,i,j); % t y x 
    temp=nc{varname}(:,:,i,j);% t k y x

    str=sprintf('# loading %s from his at:  %g %g = %6.3f ºW %6.3f ºN   t= all',varname,i,j,lon(i,j),lat(i,j));
    disp(str);

  else % stations file
    zeta=nc{'zeta'}(:,i); % t pos 
    temp=nc{varname}(:,i,:);% t pos k

    str=sprintf('# loading %s from sta at:  %g %g = %6.3f ºW %6.3f ºN   t= all',varname,i,j,lon(i,j),lat(i,j));
    disp(str);
  end
else

  if ~issta % his file
    zeta=nc{'zeta'}(t,i,j); % t y x 
    temp=nc{varname}(t,:,i,j);% t k y x 

    str=sprintf('# loading %s from his at:  %g %g = %6.3f ºW %6.3f ºN   t= %6.3f d',varname,i,j,lon(i,j),lat(i,j),ot/86400);
    disp(str);

  else % stations file 
    zeta=nc{'zeta'}(t,i); % t pos 
    temp=nc{varname}(t,i,:);% t pos k

    str=sprintf('# loading %s from sta at:  %g %g = %6.3f ºW %6.3f ºN   t= %6.3f d',varname,i,j,lon(i,j),lat(i,j),ot/86400);
    disp(str);
  end
end
nc=close(nc);

%----------------------- plot position and contours h:
if do_contour
  if ~issta
    figure(fig), subplot(1,2,1),
    contour(lon,lat,mask,[.5,.5],'b');
    m_axis(lon,lat,.1,.1);
    hold on
    contour(lon,lat,h,[vv],'k');
    plot_box(lon,lat,'k')

    plot(lon(i,j), lat(i,j),'ro');

    title(sprintf('h= %7.2f  ixj= %g x %g',h(i,j),i,j))
  else
    figure(fig), subplot(1,2,1)
    p=plot(lon,lat,'b.'); hold on
    plot(lon(i,j), lat(i,j),'ro');
    title(sprintf('h= %7.2f  ixj= %g x %g',h(i,j),i,j))
  end
end

%---------------------------- s_levels:
hmin=min(min(h));
H=h(i,j);

[THETA_S,THETHA_B,TCLINE,N] = s_params(file);
[z_r,z_w]=s_levels(H, hmin, THETA_S,THETHA_B,TCLINE,N,zeta,0);

if isequal(varname,'w')
  z_r = z_w;
end

%------------------------------ output:

var=temp;
z=z_r;

if do_contour
  subplot(1,2,2),
  plot(var,z);

  title(sprintf('%s time= %5.4f days',varname, ot/86400))
end
