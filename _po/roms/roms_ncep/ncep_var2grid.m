function [lonr,latr,v,time]=ncep_var2grid(grid,file,Var,tstart,tend,pos,L,fig)
%NCEP_VAR2GRID   Interpolate NCEP variable to ROMS grid
%
%   Syntax:
%      [LONR,LATR,V] = NCEP_VAR2GRID(GRID,FILE,VAR,TSTART,TEND,POS,L,FIG)
%
%   Inputs:
%      All equal to NCEP_GETVAR, except GRID, the NetCDF grid filename
%
%   Outputs:
%      LONR   Longitude of grid
%      LATR   Latitude of grid
%      V      Variable in GRID
%      TIME   Time in days beeing 0 at TSTART
%      FIG    If 1, data is plotted at tindice=1, as well as the region
%             average time series [ {1} 0 ]
%
%   Comments:
%      If coast at right and there are nans at right, values are kept
%      constant from left to right.
%      If only one point, it is used in all region.
%      First subplot is V at first time indice (pcolor) or variable
%      time series if 1 point.
%      Second one is the averaged time series.
%      **
%      ** NOTICE: think it works well if grid crosses lon = 0, or
%      ** lat = +-90, but better check the output graphic to be sure;
%      **  If wrong, small modificationsmust be done in this file...
%      **
%
%   Examples:
%      grid   = 'roms_grd.nc'
%      file   = '../uwnd.10m.gauss.2003.nc';
%      Var    = 'uwnd';
%      tstart = '1-Jan-2003';
%      tend   = '1-Feb-2003';
%      pos    = [-9 41];
%      L      = [2 3];
%      [lonr,latr,v,time]=ncep_var2grid(grid,file,Var,tstart,tend,pos,L);
%
%      % example to use only vals on water and fill until right boundary:
%      pos=[-11 41];
%      L=[1 3];
%      [lonr,latr,v,time]=ncep_var2grid(grid,file,Var,tstart,tend,pos,L);
%
%      % example to use only one value in all region:
%      L=[0 0];
%      pos=[-9 41];
%      [lonr,latr,v,time]=ncep_var2grid(grid,file,Var,tstart,tend,pos,L);
%
%   MMA 26-5-2004, martinho@fis.ua.pt
%
%   See also NCEP_ISTART, NCEP_GETVAR, NCEP_GENFRC, NCEP_GEN

%   Department of Physics
%   University of Aveiro, Portugal

%   24-10-2004 - Some changes so that grid may by outside the domain
%                0:360 x -90:90

eval('fig = fig;','fig = 1;');
nc=netcdf(grid);
  lonr = nc{'lon_rho'}(:);
  latr = nc{'lat_rho'}(:);
nc=close(nc);
% lonr must be in the limits 0:360, so:
eval('lonr(find(lonr<0))   = lonr+360;',''); % eval, cos if none then error
eval('lonr(find(lonr>360)) = lonr-360;','');

% latr must be in the limits -90:90, so:
eval('latr(find(latr<-90)) = latr+180;','');
eval('latr(find(latr>90))  = latr-180;','');

% ----------------------------------------- get var from NCEP file:
[lon,lat,var,time,out]=ncep_getvar(file,Var,tstart,tend,pos,L,fig);

% now, must deal with longitudes near 360 and 0,
% % and latitudes near 90 and -90:
% this is in variable out, see ncep_getvar for details
if out(1) % then long must have negative vals
  eval('lonr(find(lonr>180)) = lonr-360;','');
end

if out(2) % the longitude must have val > 360
  eval('lonr(find(lonr<180) = lonr+360;','');
end

if out(3) % then lat must have vals > 90
  eval('latr(find(latr<0)) = latr +180;','');
end

if out(4) % then lat must have vals bellow -90
  eval('latr(find(latr>0)) = latr -180;','');
end

%% check limits
c(1) = min(min(lonr)) > min(min(lon));
c(2) = max(max(lonr)) < max(max(lon));
c(3) = min(min(latr)) > min(min(lat));
c(4) = max(max(latr)) < max(max(lat));
if ~all(c)
  disp('###### warning, some limits ARE not be correct... better take a look in file ncep_var2grid')
end

% ----------------------------------------- interp to grid:
if ~out(2)
  eval('lonr(find(lonr<0))=lonr+360;','');
end

if size(var,3) == 1 == size(var,2)
  wb = waitbar(0,['same value: ',Var,' to grid...']);
  for t=1:size(var,1)
    waitbar(t/size(var,1),wb);
    v(t,:,:)=repmat(squeeze(var(t,:,:)),size(lonr));
  end
  close(wb);
else
  wb = waitbar(0,['interp ',Var,' to grid...']);
  for t=1:size(var,1)
    waitbar(t/size(var,1),wb);
    v(t,:,:)=griddata(lon,lat,squeeze(var(t,:,:)),lonr,latr);
  end
  close(wb);

  %------------------------------------------- fill nans
  if nan_count(v)
    % fill values until mask with values on sea:
    wb = waitbar(0,['filling nans until mask...']);
    for t=1:size(v,1)
      waitbar(t/size(v,1),wb);
      for j=1:size(lonr,1)
        for i=1:size(lonr,2)
          if isnan(v(t,j,i))
            if i==1
              disp('WARNING, nan found in the first indice..... change L or pos');
            else
              v(t,j,i)=v(t,j,i-1);
            end
          end
        end
      end
    end
    close(wb);
  end % if nan_count

end

% ------------------------------------------ plot:
if fig
  a=get(gcf,'children');
  axes(a(3));
  hold on

  pc=pcolor(lonr,latr,squeeze(v(1,:,:)));
  set(pc,'edgecolor','none');
  %axis([min(min(lonr))-1 max(max(lonr))+1 min(min(latr))-1 max(max(latr))+1]);
  colorbar
  plot_border(lonr,latr);

  % look for nans:
  if nan_count(v)
    disp(['# WARNING: found NaNs in variable...']);
  else
    disp(['OK, no NaNs found in variable.']);
  end
end % fig
