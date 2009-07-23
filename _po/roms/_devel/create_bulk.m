function  create_forcing(frcname,grdname,title,bulkt,bulkc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 	Create an empty netcdf heat flux bulk forcing file
%       frcname: name of the forcing file
%       grdname: name of the grid file
%       title: title in the netcdf file
%       Last modif: 14/10/2005 add sustr,svstr,uwnd,vwnd,pres vars
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nc=netcdf(grdname);
L=length(nc('xi_psi'));
M=length(nc('eta_psi'));
result=close(nc);
Lp=L+1;
Mp=M+1;

nw = netcdf(frcname, 'clobber');
result = redef(nw);

%
%  Create dimensions
%

nw('xi_u') = L;
nw('eta_u') = Mp;
nw('xi_v') = Lp;
nw('eta_v') = M;
nw('xi_rho') = Lp;
nw('eta_rho') = Mp;
nw('xi_psi') = L;
nw('eta_psi') = M;
nw('bulk_time') = 0;%length(bulkt);
%
%  Create variables and attributes
%
nw{'bulk_time'}              = ncdouble('bulk_time');
nw{'bulk_time'}.long_name    = ncchar('bulk formulation execution time');
nw{'bulk_time'}.long_name    = 'bulk formulation execution time';
nw{'bulk_time'}.units        = ncchar('days');
nw{'bulk_time'}.units        = 'days';
nw{'bulk_time'}.cycle_length = bulkc;

nw{'tair'}             = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'tair'}.long_name   = ncchar('surface air temperature');
nw{'tair'}.long_name   = 'surface air temperature';
nw{'tair'}.units       = ncchar('Celsius');
nw{'tair'}.units       = 'Celsius';

nw{'rhum'}             = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'rhum'}.long_name   = ncchar('relative humidity');
nw{'rhum'}.long_name   = 'relative humidity';
nw{'rhum'}.units       = ncchar('fraction');
nw{'rhum'}.units       = 'fraction';

nw{'prate'}            = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'prate'}.long_name  = ncchar('precipitation rate');
nw{'prate'}.long_name  = 'precipitation rate';
nw{'prate'}.units      = ncchar('cm day-1');
nw{'prate'}.units      = 'cm day-1';

nw{'wspd'}             = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'wspd'}.long_name   = ncchar('wind speed 10m');
nw{'wspd'}.long_name   = 'wind speed 10m';
nw{'wspd'}.units       = ncchar('m s-1');
nw{'wspd'}.units       = 'm s-1';

nw{'radlw'}            = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'radlw'}.long_name  = ncchar('outgoing longwave radiation');
nw{'radlw'}.long_name  = 'outgoing longwave radiation';
nw{'radlw'}.units      = ncchar('Watts meter-2');
nw{'radlw'}.units      = 'Watts meter-2';
nw{'radlw'}.positive   = ncchar('upward flux, cooling water');
nw{'radlw'}.positive   = 'upward flux, cooling water';

nw{'radsw'}            = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'radsw'}.long_name  = ncchar('solar shortwave radiation');
nw{'radsw'}.long_name  = 'shortwave radiation';
nw{'radsw'}.units      = ncchar('Watts meter-2');
nw{'radsw'}.units      = 'Watts meter-2';
nw{'radsw'}.positive   = ncchar('downward flux, heating water');
nw{'radsw'}.positive   = 'downward flux, heating water';

nw{'sustr'} = ncdouble('bulk_time', 'eta_u', 'xi_u');
nw{'sustr'}.long_name = ncchar('surface u-momentum stress');
nw{'sustr'}.long_name = 'surface u-momentum stress';
nw{'sustr'}.units = ncchar('Newton meter-2');
nw{'sustr'}.units = 'Newton meter-2';

nw{'svstr'} = ncdouble('bulk_time', 'eta_v', 'xi_v');
nw{'svstr'}.long_name = ncchar('surface v-momentum stress');
nw{'svstr'}.long_name = 'surface v-momentum stress';
nw{'svstr'}.units = ncchar('Newton meter-2');
nw{'svstr'}.units = 'Newton meter-2';

nw{'uwnd'} = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'uwnd'}.long_name = ncchar('10m u-wind component');
nw{'uwnd'}.long_name = 'u-wind';
nw{'uwnd'}.units = ncchar('meter second-1');
nw{'uwnd'}.units = 'm/s';

nw{'vwnd'} = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'vwnd'}.long_name = ncchar('10m v-wind component');
nw{'vwnd'}.long_name = 'v-wind';
nw{'vwnd'}.units = ncchar('meter second-1');
nw{'vwnd'}.units = 'm/s';

nw{'dlwrf'} = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'dlwrf'}.long_name = ncchar('Downward Longwave Radiation Flux at Surface');
nw{'dlwrf'}.long_name = 'Downward Longwave Radiation';
nw{'dlwrf'}.units = ncchar('Watts meter-2');
nw{'dlwrf'}.units = 'Watts meter-2';


nw{'pres'} = ncdouble('bulk_time', 'eta_rho', 'xi_rho');
nw{'pres'}.long_name = ncchar('Surface Pressure');
nw{'pres'}.long_name = 'Surface Pressure';
nw{'pres'}.units = ncchar('Pascals');
nw{'pres'}.units = 'Pascals';



result = endef(nw);

%
% Create global attributes
%

nw.title = ncchar(title);
nw.title = title;
nw.date = ncchar(date);
nw.date = date;
nw.grd_file = ncchar(grdname);
nw.grd_file = grdname;
nw.type = ncchar('ROMS heat flux bulk forcing file');
nw.type = 'ROMS heat flux bulk forcing file';

%
% Write time variables
%
for i=1:length(bulkt)
  if mod(i,100)==0
    fprintf(1,':: filling reccord var %d of %d\n',i,length(bulkt));
  end
  nw{'bulk_time'}(i) = bulkt(i);
end

close(nw);
