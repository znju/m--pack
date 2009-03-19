function [lon,lat,var,time,out,time_num]=ncep_getvar(file,Var,tstart,tend,pos,L,fig)
%NCEP_GETVAR   Get NCEP bulk flux variable
%   Extracts a variable from NCEP NetCDF file near certain location
%   and in a specified time interval.
%
%   Syntax:
%      [LON,LAT,VAR,TIME,OUT,TN] = NCEP_GETVAR(FILE,VAR,TSTART,TEND,POS,L,FIG)
%
%  Inputs:
%     FILE     NCEP NetCDF file
%     VAR      Variable to extract
%     TSTART   Start date string [ <'D-M-Y'> ]
%     TEND     End date string [ <'D-M-Y'> ]
%     POS      Location around which data will be extracted [ <lon lat>]
%     L        extracted square of data has side 2*L(1)+1 by 2*L(2)+1,
%              so data has range i-L(1):i+L(1),j-L(2):j+L(2), being
%              i (W-E) and j (S-N) location indices near POS
%     FIG      If 1, data is plotted at tindice=1  [ {1} 0 ]
%
%   Outputs:
%      LON    Longitudes (positive, 0-->360)
%      LAT    Latitudes of the extracted square of data
%      VAR    Variable with dimensions time,lat,lon
%      TIME   Time in days being 0 at TSTART
%      OUT    Info about region limits, ie, if is inside the NCEP domain:
%             0:360 and -90:90; OUT is l r t b, if any one, then falls out the limits
%             either at l (left), r (right), t (top) or b (bottom)
%      TN     Time suitable for datestr
%
%   Comments:
%      A file coastline.mat with vars lon and lat should be in path
%      (but is not needed) so that some data is plotted just to be
%      sure data is correct!
%      First subplot is V at first time indice (pcolor) or variable
%      time series if 1 point.
%      Second one is the averaged time series.
%      Use L = [0 0] to get a time series at the closest location from
%      POS.
%
%   Examples:
%      file   = '../uwnd.10m.gauss.2003.nc';
%      Var    = 'uwnd';
%      tstart = '1-Jan-2003';
%      tend   = '1-Feb-2003';
%      pos    = [-9 41];
%      L      = [3 1];
%      [lon,lat,var,time]=ncep_getvar(file,Var,tstart,tend,pos,L);
%      [lon,lat,var,time]=ncep_getvar(file,Var,tstart,tend,pos,[100 20]);
%
%   MMA 26-5-2004, martinho@fis.ua.pt
%       34-10-2004, ability to use data outside the domain 0:360 x -90:90
%                   like when asking for points near 360... points near
%                   0 may be used
%
%   See also NCEP_ISTART, NCEP_VAR2GRID, NCEP_GEN

%   Department of Physics
%   University of Aveiro, Portugal

%   34-10-2004 - Ability to use data outside the domain 0:360 x -90:90
%                like when asking for points near 360... points near
%                0 may be used
%
%   06-06-2007 - Added output TN

eval('fig = fig;','fig = 1;');

% first, load coastline:
% longitude should be positive, so:
eval('load coastline','lon = nan; lat = nan;');
[lonc,latc] = rot_longitude(lon,lat);

disp(' ');
disp('-----------------------------------------------------------');
disp(['## file= ',file]);
disp(['  --- get closest location ---']);
% -------------------------------- get location indices:
long=pos(1);
if long < 0, long=long+360; end
latg=pos(2);

nc=netcdf(file);
  lon=nc{'lon'}(:); lon_ = lon; % just kepp to plot later
  lat=nc{'lat'}(:); lat_ = lat;
nc=close(nc);

[lon,lat]=meshgrid(lon,lat);
dist=sqrt((lon-long).^2 + (lat-latg).^2);
[j,i]=find(dist==min(min(dist))); i = i(1); j = j(1);
disp(['# closest location from ',num2str(pos),'  is i= ',num2str(i),' and j= ',num2str(j), '  [ ',num2str(lon(j,i)),' x ',num2str(lat(j,i)), ' ]']);

% ------------------------------------ get time indice:
disp(' ');
disp(['  --- get time indices ---']);
[is,ie,dt]=ncep_istart(file,tstart,tend);

% ------------------------------------ get Var in a square of side 2*L+1:
disp(' ');
disp(['  --- get VAR ',Var,' ---']);
% ------------------------- var info:
name   = n_varatt(file,Var,'long_name');
scale  = n_varatt(file,Var,'scale_factor');
offset = n_varatt(file,Var,'add_offset');
units  = n_varatt(file,Var,'units');

disp(['    » long_name = ',name]);
disp(['    » scale     = ',num2str(scale)]);
disp(['    » offset    = ',num2str(offset)]);
disp(['    » units     = ',units]);

Trange = is:ie; % corrected bellow
imax=size(lon,2);
jmax=size(lon,1);
Irange = max(1,i-L(1)):min(imax,i+L(1));
Jrange = max(1,j-L(2)):min(jmax,j+L(2));

% --------------------------------------------------- ranges
case1 = i-L(1) < 1;
case2 = i+L(1) > imax;
case3 = j-L(2) < 1;
case4 = j+L(2) > jmax;

out = [case1 case2 case3 case4];

if ~any([case1 case2 case3 case4])
  disp('  -> selected region is inside the limits');
else
  disp(['  -> selected region bigger than limits (l r t b): ',num2str([case1 case2 case3 case4])]);
end

% deal with long regions near 0
if case1 % then must get values before 360:
  i1 = imax - (-i+L(1)):imax;
  j1 = Jrange;
end

% deal with long regions near 360
if case2 % then must get values after 0
  i2 = 1:i+L(1)-imax;
  j2 = Jrange;
end

% deal with lat regions near 90
if case3 % then must get values before -90:
  i3 = Irange;
  j3 = jmax - (-j+L(2)):jmax;
end

% deal with lat regions near -90
if case4 % then must get values after 90 (90 is the first indice)
  i4 = Irange;
  j4 = 1:j+L(2)-jmax;
end
% ------------------------------------------------------------------------
var   = [];
var1  = [];
var2  = [];
var3  = [];
var4  = [];
var31 = [];
var32 = [];
var41 = [];
var42 = [];

lon  = [];
lon1 = [];
lon2 = [];
lat  = [];
lat3 = [];
lat4 = [];

%  _________________________________
% | 31 |            3          | 32 |
% |----|-----------------------|----|
% |    |                       |    |
% !    |        inside         |    |
% ! 1  |        limits         | 2  |
% !    |                       |    |
% |    |                       |    |
% |____|_______________________|____|
% ! 41 |           4           | 42 |
%  ----------------------------------
%   l              c             r
% inside limits, mean  0 =< lon <= 360 and -90 =< lat <= 90
% all the rest, I must extract separately  and then concatenate

nc=netcdf(file);
  st   = size(nc{Var},1);
  Trange = is:min(ie,st);

  var0  = nc{Var}(Trange,Jrange,Irange);
  lon0  = nc{'lon'}(Irange);
  lat0  = nc{'lat'}(Jrange);
  time = nc{'time'}(Trange);

  if case1
    var1  = nc{Var}(Trange,j1,i1);
    lon1  = nc{'lon'}(i1) - 360;
  end

  if case2
    var2  = nc{Var}(Trange,j2,i2);
    lon2  = nc{'lon'}(i2) + 360;
  end

  if case3
    var3  = nc{Var}(Trange,j3,i3);
    lat3  = nc{'lat'}(j3) + 180;
    if case1
      var31 = nc{Var}(Trange,j3,i1);
    end
    if case2
      var32 = nc{Var}(Trange,j3,i2);
    end
  end

  if case4
    var4  = nc{Var}(Trange,j4,i4);
    lat4  = nc{'lat'}(j4) - 180;
    if case1
      var41 = nc{Var}(Trange,j4,i1);
    end
    if case2
      var42 = nc{Var}(Trange,j4,i2);
    end
  end

nc = close(nc);

vl = cat(2,var31,var1,var41);
vc = cat(2,var3,var0,var4);
vr = cat(2,var32,var2,var42);
v = cat(3,vl,vc,vr);

lon = [lon1; lon0; lon2];
lat = [lat3; lat0; lat4];
[lon,lat] = meshgrid(lon,lat);

% scale and offset:
var = v*scale+offset;


disp([' --> var size = ',num2str(size(var))]);
disp('-----------------------------------------------------------');disp('');

% ----------------------- set time (day):
time_num=time/24  +datenum(1,1,1)-2; % time suitable for datestr
time=time-time(1);
time=time/24;

% ======================================================== plot:
if fig
  figure
  subplot(2,1,1)
  if size(var,2) == 1 & size(var,3) == 1
    plot(var);
  elseif size(var,2) > 1 & size(var,3) > 1
    for n=1:1%size(var,1) %plot just first:
      cla
      pcolor(lon,lat,squeeze(var(n,:,:)));
      colorbar
      hold on
      % coastline
      plot(lonc,latc);
      axis equal
      axis auto
      plot(long,latg,'ko'); % pos
      plot(lon_(i), lat_(j),'ko');

      % show contour of var0, to be sure:
      contour(lon0,lat0,squeeze(var0(1,:,:)),'w');

      title([Var,' at ',tstart,' (',units,')']);
    end
  end
  % ---------------------------- plor averaged var time serie:
  tmp1=mean(var,3);
  tmp2=mean(tmp1,2);

  subplot(2,1,2)
  plot(time,tmp2);
  title([Var,' (averaged)  between ',tstart,' and ',tend]);
end % fig
