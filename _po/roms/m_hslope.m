function [x,y,dhdx,dhde,slope,r]=m_hslope(fname,iprint,iplot);
%M_HSLOPE   Compute bathymetry slope
%   hslope (Rutgers University) changed by MMA (14-9-2001)
%   to avoid display of some vars
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 1997 Rutgers University.                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                           %
% function [x,y,dhdx,dhde,slope,r]=hslope(fname,iprint,iplot)               %
%                                                                           %
% This function computes the bathymetry slope from a SCRUM NetCDF file.     %
%                                                                           %
% On Input:                                                                 %
%                                                                           %
%    fname       NetCDF file name (character string).                       %
%    iprint      Optional, flag for printing out information (integer):     %
%                  iprint = 0, do not print information.                    %
%                  iprint = 1, print information.                           %
%    iplot       Optional, flag for plotting (integer):                     %
%                  iplot  = 0, do not plot data.                            %
%                  iplot  = 1, plot data.                                   %
%                                                                           %
% On Output:                                                                %
%                                                                           %
%    x           X-positions.                                               %
%    y           Y-positions.                                               %
%    dhdx        Bathymetry gradient in the XI-direction.                   %
%    dhde        Bathymetry gradient in the ETA-direction.                  %
%    slope       Bathymetry slope.                                          %
%    r           R-value.                                                   %
%                                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%  If not provided, set-up printing and ploting data switch.

if (nargin < 3),
  iplot=1;
end,
if (nargin < 2),
  iprint=1;
end,

%  Read in bathymetry.

nc=netcdf(fname,'nowrite');
  h=nc{'h'}(:);
nc=close(nc);
hmin=min(min(h));
hmax=max(max(h));
havg=mean(mean(h));
hmed=median(median(h));

[Lp,Mp]=size(h);
L=Lp-1;
M=Mp-1;

%----------------------------------------------------------------------------
%  Read in curvilinear grid metrics.
%----------------------------------------------------------------------------

nc=netcdf(fname,'nowrite');
  pm=nc{'pm'}(:);
  pn=nc{'pn'}(:);
nc=close(nc);

dx=1./pm; dx=dx./1000;
dy=1./pn; dy=dy./1000;

dxmin=min(min(dx));
dxmax=max(max(dx));
dxavg=mean(mean(dx));
dxmed=median(median(dx));

dymin=min(min(dy));
dymax=max(max(dy));
dyavg=mean(mean(dy));
dymed=median(median(dy));

%----------------------------------------------------------------------------
%  Read in Land/Sea mask.
%----------------------------------------------------------------------------

nc=netcdf(fname,'nowrite');
  rmask=nc{'mask_rho'}(:);
  pmask=nc{'mask_psi'}(:);
nc=close(nc);

%----------------------------------------------------------------------------
%  Read in positions.
%----------------------------------------------------------------------------

nc=netcdf(fname,'nowrite');
  spherical=nc{'spherical'}(:);
if (spherical == 'T' | spherical == 't'),
  xr=nc{'lon_rho'}(:);
  yr=nc{'lat_rho'}(:);
  x(1:L,1:M)=0.25.*(xr(1:L,1:M)+xr(2:Lp,1:M)+xr(1:L,2:Mp)+xr(2:Lp,2:Mp));
  y(1:L,1:M)=0.25.*(yr(1:L,1:M)+yr(2:Lp,1:M)+yr(1:L,2:Mp)+yr(2:Lp,2:Mp));
else
  xr=nc{'x_rho'}(:);
  yr=nc{'y_rho'}(:);
  x(1:L,1:M)=0.25.*(xr(1:L,1:M)+xr(2:Lp,1:M)+xr(1:L,2:Mp)+xr(2:Lp,2:Mp));
  y(1:L,1:M)=0.25.*(yr(1:L,1:M)+yr(2:Lp,1:M)+yr(1:L,2:Mp)+yr(2:Lp,2:Mp));
end

%----------------------------------------------------------------------------
%  Compute bathymetry gradients at PSI-points.
%----------------------------------------------------------------------------

hx(1:L,1:Mp)=0.5.*(pm(1:L,1:Mp)+pm(2:Lp,1:Mp)).*(h(2:Lp,1:Mp)-h(1:L,1:Mp));
hy(1:Lp,1:M)=0.5.*(pm(1:Lp,1:M)+pm(1:Lp,2:Mp)).*(h(1:Lp,2:Mp)-h(1:Lp,1:M));

dhdx(1:L,1:M)=0.5.*(hx(1:L,1:M)+hx(1:L,2:Mp));
dhde(1:L,1:M)=0.5.*(hy(1:L,1:M)+hy(2:Lp,1:M));

%----------------------------------------------------------------------------
%  Compute R-factor.
%----------------------------------------------------------------------------

hx(1:L,1:Mp)=abs(h(2:Lp,1:Mp)-h(1:L,1:Mp))./(h(2:Lp,1:Mp)+h(1:L,1:Mp));
hy(1:Lp,1:M)=abs(h(1:Lp,2:Mp)-h(1:Lp,1:M))./(h(1:Lp,2:Mp)+h(1:Lp,1:M));

r(1:L,1:M)=max(max(hx(1:L,1:M),hx(1:L,2:Mp)), ...
               max(hy(1:L,1:M),hy(2:Lp,1:M)));

rmin=min(min(r));
rmax=max(max(r));
ravg=mean(mean(r));
rmed=median(median(r));

%----------------------------------------------------------------------------
%  Compute slope PSI-points.
%----------------------------------------------------------------------------

slope=sqrt(dhdx.*dhdx + dhde.*dhde);

smin=min(min(slope));
smax=max(max(slope));
savg=mean(mean(slope));
smed=median(median(slope));
srms=std(std(slope));

%----------------------------------------------------------------------------
%  Compute barotropic timestep (s) limit.
%----------------------------------------------------------------------------

dt=0.5.*1000.0.*sqrt(dx.*dx + dy.*dy)./sqrt(9.807.*h);

dtmin=min(min(dt));
dtmax=max(max(dt));
dtavg=mean(mean(dt));
dtmed=median(median(dt));

%----------------------------------------------------------------------------
%  Print information.
%----------------------------------------------------------------------------

if (iprint),
  disp('  ');
  disp(['Minimum dx (km) = ', num2str(dxmin)]);
  disp(['Maximum dx (km) = ', num2str(dxmax)]);
  disp(['Mean    dx (km) = ', num2str(dxavg)]);
  disp(['Median  dx (km) = ', num2str(dxmed)]);

  disp('  ');
  disp(['Minimum dy (km) = ', num2str(dymin)]);
  disp(['Maximum dy (km) = ', num2str(dymax)]);
  disp(['Mean    dy (km) = ', num2str(dyavg)]);
  disp(['Median  dy (km) = ', num2str(dymed)]);

  disp('  ');
  disp(['Minimum dt (s) = ', num2str(dtmin)]);
  disp(['Maximum dt (s) = ', num2str(dtmax)]);
  disp(['Mean    dt (s) = ', num2str(dtavg)]);
  disp(['Median  dt (s) = ', num2str(dtmed)]);

  disp('  ');
  disp(['Minimum depth (m) = ', num2str(hmin)]);
  disp(['Maximum depth (m) = ', num2str(hmax)]);
  disp(['Mean    depth (m) = ', num2str(havg)]);
  disp(['Median  depth (m) = ', num2str(hmed)]);

  disp('  ');
  disp(['Minimum r-value = ', num2str(rmin)]);
  disp(['Maximum r-value = ', num2str(rmax)]);
  disp(['Mean    r-value = ', num2str(ravg)]);
  disp(['Median  r-value = ', num2str(rmed)]);

  disp('  ');
  disp(['Minimum Slope = ', num2str(smin)]);
  disp(['Maximum Slope = ', num2str(smax)]);
  disp(['Mean    Slope = ', num2str(savg)]);
  disp(['Median  Slope = ', num2str(smed)]);
  disp(['    RMS Slope = ', num2str(srms)]);

end,

%----------------------------------------------------------------------------
%  Plot data.
%----------------------------------------------------------------------------

if (iplot),

 figure;
 pcolor(xr,yr,h); shading flat; colorbar;
 title('Bathymetry (m)');
 xlabel(['Min  = ', num2str(hmin),'   Max  = ', num2str(hmax), ...
         '   Mean  = ', num2str(havg), '   Median  = ', num2str(hmed)]);
 grid;

 figure;
 pcolor(x,y,slope); shading flat; colorbar;
 title('Bathymetric Slope');
 xlabel(['Min  = ', num2str(smin),'   Max  = ', num2str(smax), ...
         '   Mean  = ', num2str(savg), '   Median  = ', num2str(smed)]);
 grid;

 figure;
 pcolor(x,y,r); shading flat; colorbar;
 title('Bathymetry r-value');
 xlabel(['Min  = ', num2str(rmin),'   Max  = ', num2str(rmax), ...
         '   Mean  = ', num2str(ravg), '   Median  = ', num2str(rmed)]);
 grid;

 figure;
 pcolor(xr,yr,dt); shading flat; colorbar;
 title('Barotropic Timestep Limit (seconds)');
 xlabel(['Min  = ', num2str(dtmin),'   Max  = ', num2str(dtmax), ...
         '   Mean  = ', num2str(dtavg), '   Median  = ', num2str(dtmed)]);
 grid;
end,

return
