function [t,z,v,x,y] = roms_ts(file,varname,varargin)
%ROMS_TS   Extract time series and z-profiles from ROMS output
%   Extracts time series from ROMS files at the indices the file
%   is defined.
%
%   Syntax:
%      [T,Z,V,X,Y] = ROMS_TS(FILE,VARNAME,VARARGIN)
%
%   Inputs:
%      FILE      ROMS output file
%      VARNAME   ROMS variable
%      VARARGIN:
%         'time',    time indice or time in days if string (the closest)
%         'station', station indice
%         'eta',     eta_rho[u, v, psi] indice
%         'xi',      xi_rho[u, v, psi] indice
%         's',       s_rho or s_w indice
%         'z'        depth
%         'show',    {0}1, if 1, the result is plotted
%
%   Outputs:
%      T   Time in days
%      Z   Depth
%      V   Variable time series/vertical profile
%      X   Location x
%      Y   Location y
%
%   Exampes:
%      file    = 'sta.nc';
%      varname = 'temp';
%      station = 123;
%      [t,z,v,x,y] = roms_ts(file,varname,'station',station);
%
%      time = '5'; % days
%      [t,z,v,x,y] = roms_ts(file,varname,'station',station,'time',time,'show',1);
%
%   MMA 6-2-2004, martinho@fis.ua.pt
%
%   See also ROMS_EXTRACTSTR, RUSE

%   Department of Physics
%   University of Aveiro, Portugal

v = [];
t = [];
z = [];
x = [];
y = [];

set_time    = 0;
set_station = 0;
set_xi   = 0;
set_eta  = 0;
set_xi_eta  = 0;
set_slev    = 0;
set_depth   = 0;
set_hmin    = 0;
set_show = 0;

vin = varargin;
for ii=1:length(vin)
  if isequal(vin{ii},'time')
    itime       = vin{ii+1};
    set_time    = 1;
  end
  if isequal(vin{ii},'station')
    istation    = vin{ii+1};
    set_station = 1;
  end
  if isequal(vin{ii},'eta')
    ieta        = vin{ii+1};
    set_eta     = 1;
  end
  if isequal(vin{ii},'xi')
    ixi         = vin{ii+1};
    set_xi      = 1;
  end
  if isequal(vin{ii},'s')
    is          = vin{ii+1};
    set_slev    = 1;
  end
  if isequal(vin{ii},'z')
    depth       = vin{ii+1};
    set_depth   = 1;
  end
  if isequal(vin{ii},'hmin')
    hmin        = vin{ii+1};
    set_hmin    = 1;
  end
  if isequal(vin{ii},'show')
    set_show    = vin{ii+1};
  end

end

if set_eta & set_xi
  set_xi_eta = 1;
end

% --------------------------------------------------------------------
% check if file is station or other by looking for the dimension
% station:
% --------------------------------------------------------------------
isstation = 0;
if n_dimexist(file,'station') | n_dimexist(file,'stanum') , isstation  = 1; end
if isstation & ~set_station
  disp('# istation not definned (file is a stations file) ');
  return
end
if ~isstation & ~set_xi_eta
  disp('# xi and eta not definned (file is not a stations file) ');
  return
end

% --------------------------------------------------------------------
% check if variable has vertical component:
% --------------------------------------------------------------------
vcomp = 0;
if n_vardimexist(file,varname,'s_rho') | n_vardimexist(file,varname,'s_w')
  vcomp = 1;
end

% --------------------------------------------------------------------
% create string of ruse varargin:
% --------------------------------------------------------------------

% ALLOW use of time as string to be the time in days, then get the
% closets time indice:
% first, get it all
if set_time
  if isstr(itime)
    if     n_varexist(file,'ocean_time'), tvar = 'ocean_time';
    elseif n_varexist(file,'scrum_time'), tvar = 'scrum_time';
    end
    if ~isempty(tvar),    t = ruse(file,tvar); t = t/86400;  end
    td = str2num(itime);
    dist = (t-td).^2;
    itime = find(dist == min(dist));
  end
end

str = '';
if set_time
  if isstr(itime),    str = [str,',''time'',''',    itime,''''                             ];
  else,               str = [str,',''time'',',      num2str(itime)                         ];
  end
end
if set_station
  if isstr(istation), str = [str,',''station'',''', istation,''''                           ];
  else,               str = [str,',''station'',',   num2str(istation)                       ];
  end
end
if set_xi_eta,
  if isstr(ieta)      str = [str,',xi'',''',        ixi,          ',''eta'',''',ieta,''''   ];
  else                str = [str,',''xi'',',        num2str(ixi), ',''eta'',',num2str(ieta) ];
  end
end
if set_slev & ~set_depth
  if isstr(is),       str = [str,',''s'',''',       is,''''                                 ];
  else,               str = [str,',''s'',',         num2str(is)                             ];
  end
end

%% better not accept this here... it would complicate s_levels bellow,
%  so do not allow selection of multiple indices as string:
evalc('iss(1) = isstr(itime);',    'iss(1)=0;');
evalc('iss(2) = isstr(istation);', 'iss(2)=0;');
evalc('iss(3) = isstr(ieta);',     'iss(3)=0;');
evalc('iss(4) = isstr(is);',       'iss(4)=0;');
if any(iss)
  disp('# selection of multiple indices as string not implemented...')
  return
end

% --------------------------------------------------------------------
% get variable:
% --------------------------------------------------------------------
if ~n_varexist(file,varname)
  disp(['# variable ',varname,' not found in file...']);
  return
end
eval(['v = ruse(file,varname',str,');']);

if isempty(v)
  return
end

% --------------------------------------------------------------------
% get time:
% --------------------------------------------------------------------
tvar = [];
if     n_varexist(file,'ocean_time'), tvar = 'ocean_time';
elseif n_varexist(file,'scrum_time'), tvar = 'scrum_time';
end

if ~isempty(tvar)
  eval(['t = ruse(file,tvar',str,');']);
  t = t/86400;
end

% --------------------------------------------------------------------
% get lon and lat:
% --------------------------------------------------------------------
xvar = [];
yvar = [];
if     n_varexist(file,'lon_rho'), xvar = 'lon_rho';
elseif n_varexist(file,'x_rho'),   xvar = 'x_rho';
end
if     n_varexist(file,'lat_rho'), yvar = 'lat_rho';
elseif n_varexist(file,'y_rho'),   yvar = 'y_rho';
end

if ~isempty(xvar)
  eval(['x = ruse(file,xvar',str,');']);
end

if ~isempty(yvar)
  eval(['y = ruse(file,yvar',str,');']);
end

% --------------------------------------------------------------------
% get depth and interp at depth if set_depth and if variable has a
% depth component: dimension s_rho or s_w
% --------------------------------------------------------------------
if vcomp
  % get s-parameters:
  [tts,ttb,hc,n] = s_params(file);

  % get hmin:
  if ~set_hmin
    hmin = min(min(ruse(file,'h')));
  end

  % get h:
  hvar = 'h';
  eval(['h = ruse(file,hvar',str,');']);
  % THIS MAY NOT BE CORRECT when using a stations file, the minimum
  % depth of the stations may not be the minimum depth of the grid file

  % get zeta:
  zetavar = 'zeta';
  eval(['zeta_ = ruse(file,zetavar',str,');']);
  if size(zeta_,1)>size(t,1), zeta_=zeta_(1:size(t,1),:); end

  [z,zw] = s_levels(h,tts,ttb,hc,n,zeta_);

  if n_vardimexist(file,varname,'s_w')
    z = zw;
    n = size(z,2); % n+1
  end

  tz = repmat(t,1,n);

  if set_slev
    z=z(:,is);

  elseif set_depth  % interp at depth:
    if ~set_time
      v  = griddata(tz,z,v,t,depth);
    else
      v  = interp1(z,v,depth);
      t  = t(1,:);
      z  = repmat(depth,size(v));
    end
    z = repmat(depth,size(v));
  elseif ~set_time
    t = tz;
  end

else
  z = zeros(size(v));
end

% --------------------------------------------------------------------
% remove bad values:
% --------------------------------------------------------------------
val = 1e34;
x(x>=val) = nan;
y(y>=val) = nan;
t(t>=val) = nan;
z(z>=val) = nan;
v(v>=val) = nan;

% --------------------------------------------------------------------
% plot:
% --------------------------------------------------------------------
if set_show
  %figure

  % ----------------------------------------------------------- profile at itime
  if set_time & vcomp
    a = [mean(v) mean(v) nan min(v) max(v) nan min(v) max(v)];
    b = [-h zeta_ nan 0 0 nan -h -h];
    plot(a,b,'r'); hold on
    plot(v,z);

    % labels: title
    if set_station
      label = sprintf('%s profile, itime = %g, station = %g',varname,itime,istation);
    else
      label = sprintf('%s profile, itime = %g, ixi = %g, ieta = %g',varname,itime,ixi,ieta);
    end
    title(label,'interpreter','none');

    % labels: xlabel
    labelx{1} = sprintf('location = %5.2f x %5.2f',x,y);
    labelx{2} = sprintf('time = %5.2f days',t);
    xlabel(labelx,'interpreter','none');

    % labels: ylabel
    ylabel('depth','interpreter','none');

  % ------------------------------------------------------------- profile at all times
  elseif ~set_depth & ~set_slev & vcomp
    pcolor(t,z,v); shading flat, colorbar

    % labels: title
    if set_station
      label = sprintf('%s profile, station = %g',varname,istation);
    else
      label = sprintf('%s profile, ixi = %g, ieta = %g',varname,ixi,ieta);
    end
    title(label,'interpreter','none');

    % labels: xlabel
    labelx{1} = sprintf('location = %5.2f x %5.2f',x,y);
    labelx{2} = sprintf('time = %5.2f to %5.2f days',t(1,1),t(end,1));
    xlabel(labelx,'interpreter','none');

    % labels: ylabel
    ylabel('depth','interpreter','none');

  % ----------------------------------------------------------------- time series at depth or s-lev
  else
    plot(t,v)

    % labels: title
    if n_vardimexist(file,varname,'s_rho') | n_vardimexist(file,varname,'s_w')
      if set_station
        if set_slev, label = sprintf('%s time series, station = %g, s-level = %g',varname,istation,is);
        else         label = sprintf('%s time series, station = %g, depth = %g',varname,istation,depth);
        end
      else
        if set_slev,   label = sprintf('%s time series, ixi = %g, ieta = %g, s-level = %g',varname,ixi,ieta,is);
        else           label = sprintf('%s time series, ixi = %g, ieta = %g, depth = %g',varname,ixi,ieta,depth);
        end
      end

    else
      if set_station
        if set_slev, label = sprintf('%s time series, station = %g',varname,istation);
        else         label = sprintf('%s time series, station = %g',varname,istation);
        end
      else
        if set_slev,   label = sprintf('%s time series, ixi = %g, ieta = %g',varname,ixi,ieta);
        else           label = sprintf('%s time series, ixi = %g, ieta = %g',varname,ixi,ieta);
        end
      end

    end
    title(label,'interpreter','none');

    % labels: xlabel
    labelx{1} = [tvar, '(days)'];
    labelx{2} = sprintf('location = %5.2f x %5.2f',x,y);
    xlabel(labelx,'interpreter','none');

    % labels: ylabel
    ylabel(varname,'interpreter','none');

    grid on
  end

end % set_show
