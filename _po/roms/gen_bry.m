function gen_bry(bryname,grdname,s_rho,obc,title,time,cycle,addLLZ)
%GEN_BRY   Create ROMS boundary file
%   Based on Penven's create_bryfile.
%
%   Syntax:
%      GEN_BRY(BRY,GRD,N,OBC,TITLE,TIME,CYCLE)
%
%   Inputs:
%      BRY    Boundary file to create
%      GRD    Grid file
%      N      Number of vertical rho levels
%      OBC    Boundaries to create, S E N W, defaul=[1 1 1 1]
%      TITLE  File title, default='Boundary file'
%      TIME   Time to variable bry_time, default=0, is a reccord
%             dimension (it is the use of a reccord dimension that
%             allows files bigger  than 2G)
%      CYCLE  Time cycle (365)
%
%   Example:
%      gen_bry('roms_bry.nc','roms_grd.nc',50)
%
%   MMA 28-3-2007, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

type='Boundary file';

if nargin<8
  addLLZ=0;
end
if nargin < 7
  cycle=365;
end
if nargin < 6
  time=0;
end
if nargin < 5
  title=type;
end
if nargin < 4
  obc=[1 1 1 1];
end
if nargin < 3
  disp('# arguments needed...')
  return
end

nc=netcdf(bryname,'clobber');

nc.title = title;
nc.type = type;
nc.date = datestr(now);
nc.grd_file = grdname;
nc.path =pwd;
[status,host]=system('hostname');
nc.host=host(1:end-1);
[status,user]=system('whoami');
nc.user = user;


% dimensions:
nc('xi_u')     = n_dim(grdname,'xi_u');
nc('xi_v')     = n_dim(grdname,'xi_v');
nc('xi_rho')   = n_dim(grdname,'xi_rho');
nc('eta_u')    = n_dim(grdname,'eta_u');
nc('eta_v')    = n_dim(grdname,'eta_v');
nc('eta_rho')  = n_dim(grdname,'eta_rho');
nc('s_rho')    = s_rho;
nc('bry_time') = 0;

%  variables:
nc{'bry_time'} = ncdouble('bry_time') ;
nc{'bry_time'}.long_name = 'time for temperature climatology';
nc{'bry_time'}.units = 'day';
nc{'bry_time'}.cycle_length = cycle;

if obc(1) %  Southern boundary
  nc{'temp_south'} = ncdouble('bry_time','s_rho','xi_rho') ;
  nc{'temp_south'}.long_name = 'southern boundary potential temperature';
  nc{'temp_south'}.units = 'Celsius';
  nc{'temp_south'}.FillValue_ = 0.;

  nc{'salt_south'} = ncdouble('bry_time','s_rho','xi_rho') ;
  nc{'salt_south'}.long_name = 'southern boundary salinity';
  nc{'salt_south'}.units = 'PSU';
  nc{'salt_south'}.FillValue_ = 0.;

  nc{'u_south'} = ncdouble('bry_time','s_rho','xi_u') ;
  nc{'u_south'}.long_name = 'southern boundary u-momentum component';
  nc{'u_south'}.units = 'meter second-1';
  nc{'u_south'}.FillValue_ = 0.;

  nc{'v_south'} = ncdouble('bry_time','s_rho','xi_rho') ;
  nc{'v_south'}.long_name = 'southern boundary v-momentum component';
  nc{'v_south'}.units = 'meter second-1';
  nc{'v_south'}.FillValue_ = 0.;

  nc{'ubar_south'} = ncdouble('bry_time','xi_u') ;
  nc{'ubar_south'}.long_name = 'southern boundary vertically integrated u-momentum component';
  nc{'ubar_south'}.units = 'meter second-1';
  nc{'ubar_south'}.FillValue_ = 0.;

  nc{'vbar_south'} = ncdouble('bry_time','xi_rho') ;
  nc{'vbar_south'}.long_name = 'southern boundary vertically integrated v-momentum component';
  nc{'vbar_south'}.units = 'meter second-1';
  nc{'vbar_south'}.FillValue_ = 0.;

  nc{'zeta_south'} = ncdouble('bry_time','xi_rho') ;
  nc{'zeta_south'}.long_name = 'southern boundary sea surface height';
  nc{'zeta_south'}.units = 'meter';
  nc{'zeta_south'}.FillValue_ = 0.;

  if addLLZ
    nc{'ll_south'} = ncdouble('s_rho','xi_rho') ;
    nc{'ll_south'}.long_name = 'southern boundary lon_rho';
    nc{'ll_south'}.units = 'deg';
    nc{'ll_south'}.FillValue_ = 0.;

    nc{'llu_south'} = ncdouble('s_rho','xi_u') ;
    nc{'llu_south'}.long_name = 'southern boundary lon_u';
    nc{'llu_south'}.units = 'deg';
    nc{'llu_south'}.FillValue_ = 0.;

    nc{'llv_south'} = ncdouble('s_rho','xi_v') ;
    nc{'llv_south'}.long_name = 'southern boundary lon_v';
    nc{'llv_south'}.units = 'deg';
    nc{'llv_south'}.FillValue_ = 0.;

    nc{'z_south'} = ncdouble('bry_time','s_rho','xi_rho') ;
    nc{'z_south'}.long_name = 'southern boundary s_levels';
    nc{'z_south'}.units = 'metre';
    nc{'z_south'}.FillValue_ = 0.;

    nc{'zu_south'} = ncdouble('bry_time','s_rho','xi_u') ;
    nc{'zu_south'}.long_name = 'southern boundary u-s_levels';
    nc{'zu_south'}.units = 'metre';
    nc{'zu_south'}.FillValue_ = 0.;

    nc{'zv_south'} = ncdouble('bry_time','s_rho','xi_v') ;
    nc{'zv_south'}.long_name = 'southern boundary v-s_levels';
    nc{'zv_south'}.units = 'metre';
    nc{'zv_south'}.FillValue_ = 0.;
  end
end

if obc(2)==1 % Eastern boundary
  nc{'temp_east'} = ncdouble('bry_time','s_rho','eta_rho') ;
  nc{'temp_east'}.long_name = 'eastern boundary potential temperature';
  nc{'temp_east'}.units = 'Celsius';
  nc{'temp_east'}.FillValue_ = 0.;


  nc{'salt_east'} = ncdouble('bry_time','s_rho','eta_rho') ;
  nc{'salt_east'}.long_name = 'eastern boundary salinity';
  nc{'salt_east'}.units = 'PSU';
  nc{'salt_east'}.FillValue_ = 0.;

  nc{'u_east'} = ncdouble('bry_time','s_rho','eta_rho') ;
  nc{'u_east'}.long_name = 'eastern boundary u-momentum component';
  nc{'u_east'}.units = 'meter second-1';
  nc{'u_east'}.FillValue_ = 0.;

  nc{'v_east'} = ncdouble('bry_time','s_rho','eta_v') ;
  nc{'v_east'}.long_name = 'eastern boundary v-momentum component';
  nc{'v_east'}.units = 'meter second-1';
  nc{'v_east'}.FillValue_ = 0.;

  nc{'ubar_east'} = ncdouble('bry_time','eta_rho') ;
  nc{'ubar_east'}.long_name = 'eastern boundary vertically integrated u-momentum component';
  nc{'ubar_east'}.units = 'meter second-1';
  nc{'ubar_east'}.FillValue_ = 0.;

  nc{'vbar_east'} = ncdouble('bry_time','eta_v') ;
  nc{'vbar_east'}.long_name = 'eastern boundary vertically integrated v-momentum component';
  nc{'vbar_east'}.units = 'meter second-1';
  nc{'vbar_east'}.FillValue_ = 0.;

  nc{'zeta_east'} = ncdouble('bry_time','eta_rho') ;
  nc{'zeta_east'}.long_name = 'eastern boundary sea surface height';
  nc{'zeta_east'}.units = 'meter';
  nc{'zeta_east'}.FillValue_ = 0.;

  if addLLZ
    nc{'ll_east'} = ncdouble('s_rho','eta_rho') ;
    nc{'ll_east'}.long_name = 'eastern boundary lat_rho';
    nc{'ll_east'}.units = 'deg';
    nc{'ll_west'}.FillValue_ = 0.;

    nc{'llu_east'} = ncdouble('s_rho','eta_u') ;
    nc{'llu_east'}.long_name = 'eastern boundary lat_u';
    nc{'llu_east'}.units = 'deg';
    nc{'llu_east'}.FillValue_ = 0.;

    nc{'llv_east'} = ncdouble('s_rho','eta_v') ;
    nc{'llv_east'}.long_name = 'eastern boundary lat_v';
    nc{'llv_east'}.units = 'deg';
    nc{'llv_east'}.FillValue_ = 0.;

    nc{'z_east'} = ncdouble('bry_time','s_rho','eta_rho') ;
    nc{'z_east'}.long_name = 'eastern boundary s_levels';
    nc{'z_east'}.units = 'metre';
    nc{'z_east'}.FillValue_ = 0.;

    nc{'zu_east'} = ncdouble('bry_time','s_rho','eta_u') ;
    nc{'zu_east'}.long_name = 'eastern boundary u-s_levels';
    nc{'zu_east'}.units = 'metre';
    nc{'zu_east'}.FillValue_ = 0.;

    nc{'zv_east'} = ncdouble('bry_time','s_rho','eta_v') ;
    nc{'zv_east'}.long_name = 'eastern boundary v-s_levels';
    nc{'zv_east'}.units = 'metre';
    nc{'zv_east'}.FillValue_ = 0.;
  end
end

if obc(3)==1 % Northern boundary
  nc{'temp_north'} = ncdouble('bry_time','s_rho','xi_rho') ;
  nc{'temp_north'}.long_name = 'northern boundary potential temperature';
  nc{'temp_north'}.units = 'Celsius';
  nc{'temp_north'}.FillValue_ = 0.;

  nc{'salt_north'} = ncdouble('bry_time','s_rho','xi_rho') ;
  nc{'salt_north'}.long_name = 'northern boundary salinity';
  nc{'salt_north'}.units = 'PSU';
  nc{'salt_north'}.FillValue_ = 0.;

  nc{'u_north'} = ncdouble('bry_time','s_rho','xi_u') ;
  nc{'u_north'}.long_name = 'northern boundary u-momentum component';
  nc{'u_north'}.units = 'meter second-1';
  nc{'u_north'}.FillValue_ = 0.;

  nc{'v_north'} = ncdouble('bry_time','s_rho','xi_rho') ;
  nc{'v_north'}.long_name = 'northern boundary v-momentum component';
  nc{'v_north'}.units = 'meter second-1';
  nc{'v_north'}.FillValue_ = 0.;

  nc{'ubar_north'} = ncdouble('bry_time','xi_u') ;
  nc{'ubar_north'}.long_name = 'northern boundary vertically integrated u-momentum component';
  nc{'ubar_north'}.units = 'meter second-1';
  nc{'ubar_north'}.FillValue_ = 0.;

  nc{'vbar_north'} = ncdouble('bry_time','xi_rho') ;
  nc{'vbar_north'}.long_name = 'northern boundary vertically integrated v-momentum component';
  nc{'vbar_north'}.units = 'meter second-1';
  nc{'vbar_north'}.FillValue_ = 0.;

  nc{'zeta_north'} = ncdouble('bry_time','xi_rho') ;
  nc{'zeta_north'}.long_name = 'northern boundary sea surface height';
  nc{'zeta_north'}.units = 'meter';
  nc{'zeta_north'}.FillValue_ = 0.;

  if addLLZ
    nc{'ll_north'} = ncdouble('s_rho','xi_rho') ;
    nc{'ll_north'}.long_name = 'northern boundary lon_rho';
    nc{'ll_north'}.units = 'deg';
    nc{'ll_north'}.FillValue_ = 0.;

    nc{'llu_north'} = ncdouble('s_rho','xi_u') ;
    nc{'llu_north'}.long_name = 'northern boundary lon_u';
    nc{'llu_north'}.units = 'deg';
    nc{'llu_north'}.FillValue_ = 0.;

    nc{'llv_north'} = ncdouble('s_rho','xi_v') ;
    nc{'llv_north'}.long_name = 'northern boundary lon_v';
    nc{'llv_north'}.units = 'deg';
    nc{'llv_north'}.FillValue_ = 0.;

    nc{'z_north'} = ncdouble('bry_time','s_rho','xi_rho') ;
    nc{'z_north'}.long_name = 'northern boundary s_levels';
    nc{'z_north'}.units = 'metre';
    nc{'z_north'}.FillValue_ = 0.;

    nc{'zu_north'} = ncdouble('bry_time','s_rho','xi_u') ;
    nc{'zu_north'}.long_name = 'northern boundary u-s_levels';
    nc{'zu_north'}.units = 'metre';
    nc{'zu_north'}.FillValue_ = 0.;

    nc{'zv_north'} = ncdouble('bry_time','s_rho','xi_v') ;
    nc{'zv_north'}.long_name = 'northern boundary v-s_levels';
    nc{'zv_north'}.units = 'metre';
    nc{'zv_north'}.FillValue_ = 0.;
  end

end

if obc(4)==1 % Western boundary
  nc{'temp_west'} = ncdouble('bry_time','s_rho','eta_rho') ;
  nc{'temp_west'}.long_name = 'western boundary potential temperature';
  nc{'temp_west'}.units = 'Celsius';
  nc{'temp_west'}.FillValue_ = 0.;

  nc{'salt_west'} = ncdouble('bry_time','s_rho','eta_rho') ;
  nc{'salt_west'}.long_name = 'western boundary salinity';
  nc{'salt_west'}.units = 'PSU';
  nc{'salt_west'}.FillValue_ = 0.;

  nc{'u_west'} = ncdouble('bry_time','s_rho','eta_rho') ;
  nc{'u_west'}.long_name = 'western boundary u-momentum component';
  nc{'u_west'}.units = 'meter second-1';
  nc{'u_west'}.FillValue_ = 0.;

  nc{'v_west'} = ncdouble('bry_time','s_rho','eta_v') ;
  nc{'v_west'}.long_name = 'western boundary v-momentum component';
  nc{'v_west'}.units = 'meter second-1';
  nc{'v_west'}.FillValue_ = 0.;

  nc{'ubar_west'} = ncdouble('bry_time','eta_rho') ;
  nc{'ubar_west'}.long_name = 'western boundary vertically integrated u-momentum component';
  nc{'ubar_west'}.units = 'meter second-1';
  nc{'ubar_west'}.FillValue_ = 0.;

  nc{'vbar_west'} = ncdouble('bry_time','eta_v') ;
  nc{'vbar_west'}.long_name = 'western boundary vertically integrated v-momentum component';
  nc{'vbar_west'}.units = 'meter second-1';
  nc{'vbar_west'}.FillValue_ = 0.;

  nc{'zeta_west'} = ncdouble('bry_time','eta_rho') ;
  nc{'zeta_west'}.long_name = 'western boundary sea surface height';
  nc{'zeta_west'}.units = 'meter';
  nc{'zeta_west'}.FillValue_ = 0.;

  if addLLZ
    nc{'ll_west'} = ncdouble('s_rho','eta_rho') ;
    nc{'ll_west'}.long_name = 'western boundary lat_rho';
    nc{'ll_west'}.units = 'deg';
    nc{'ll_west'}.FillValue_ = 0.;

    nc{'llu_west'} = ncdouble('s_rho','eta_u') ;
    nc{'llu_west'}.long_name = 'western boundary lat_u';
    nc{'llu_west'}.units = 'deg';
    nc{'llu_west'}.FillValue_ = 0.;

    nc{'llv_west'} = ncdouble('s_rho','eta_v') ;
    nc{'llv_west'}.long_name = 'western boundary lat_v';
    nc{'llv_west'}.units = 'deg';
    nc{'llv_west'}.FillValue_ = 0.;

    nc{'z_west'} = ncdouble('bry_time','s_rho','eta_rho') ;
    nc{'z_west'}.long_name = 'western boundary s_levels';
    nc{'z_west'}.units = 'metre';
    nc{'z_west'}.FillValue_ = 0.;

    nc{'zu_west'} = ncdouble('bry_time','s_rho','eta_u') ;
    nc{'zu_west'}.long_name = 'western boundary u-s_levels';
    nc{'zu_west'}.units = 'metre';
    nc{'zu_west'}.FillValue_ = 0.;

    nc{'zv_west'} = ncdouble('bry_time','s_rho','eta_v') ;
    nc{'zv_west'}.long_name = 'western boundary v-s_levels';
    nc{'zv_west'}.units = 'metre';
    nc{'zv_west'}.FillValue_ = 0.;
  end


end

% write reccord:
for i=1:length(time)
  nc{'bry_time'}(i) =  time(i);
end

close(nc)
