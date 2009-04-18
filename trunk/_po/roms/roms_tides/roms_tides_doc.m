% tasks:
% 1- create standard tidal forcing file
% 2- transforn standard to real time data creating a new forcing file or appendig to some existing one
% 3- create roms-tools tpxo file from original tpxo netcdf files
% 4- create forcing file using roms-tools functions
%
% 1.
%
% grd='roms_grd.nc'
%
% p='~/tpxo_data/global/'; %path to netcdf tpxo data
% gfile=[p 'grid_tpxo7.1.nc']
% hfile=[p 'h_tpxo7.1.nc']
% ufile=[p 'u_tpxo7.1.nc']
% frc='roms_tidal_std.nc'
%
% comps={'m2','k1','m4'}
%
% tpxo2roms(frc,grd,gfile,hfile,ufile,'comps',comps)
%
%
% 2.
%
% frcstd=frc;
% frctarget='roms_frc.nc';
%
% y=2000;
% m=1
% d=1
% y0=2000
%
% tides_realtime(frcstd,frctarget,y,m,d,y0)
%
%
% 3.
%
% %create atlantic ocean file:
% version=2008
% fname='TPXO_atlantic_2008.nc'
% gfile='AO/gridAO2008.nc'
% hfile='AO/hf.AO_2008.nc'
% ufile='AO/uv.AO_2008.nc'
% tpxo2rtools(fname,gfile,hfile,ufile,version)
%
%
% 4.
% grdname='roms_grd_new.nc'
% frcname='roms_frc_tidal_test.nc'
% Roa=0;
%
% % USING Atlantic ocean solution:
%
% tidename=[PATH '/TPXO_atlantic_2008.nc']
% Ntides=11;
% % Chose order from the rank in the AO TPXO file :
% % "M2 S2 N2 K2 K1 O1 P1 Q1 m4 ms4 mn4"
% % " 1  2  3  4  5  6  7  8  9  10  11"
% tidalrank=[1 2 3 4 5 6 7 8 9 10 11];
%
% % USING global solution:
% tidename=[PATH '/TPXO_7.1.nc']
% Ntides=10;
% % Chose order from the rank in the TPXO file :
% % "M2 S2 N2 K2 K1 O1 P1 Q1 Mf Mm"
% % " 1  2  3  4  5  6  7  8  9 10"
% tidalrank=[1 2 3 4 5 6 7 8 9 10];
%
%
% Yorig         = 2000; % reference time for vector time
%                       % in roms initial and forcing files
% Ymin          = 2000;               % first forcing year
% Mmin          = 1;                  % first forcing month
% Dmin          = 1;                  % Day of initialization
% Hmin          = 0;                  % Hour of initialization
% Min_min       = 0;                  % Minute of initialization
% Smin          = 0;                  % Second of initialization
% makeplot=0
%
% h=use(grdname,'h');
% [eta,xi]=size(h);
%
%
% old_frc=0
%
% if ~old_frc
%   nc=netcdf(frcname,'clobber');
%   nc('xi_rho')=xi;
%   nc('eta_rho')=eta;
%   close(nc);
% end
%
% make_tides_AO % if using AO solution
% make_tides    % if using global solution

