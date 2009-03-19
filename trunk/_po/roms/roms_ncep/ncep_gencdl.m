function [cdl_name,nc_name]=ncep_gencdl(type,dims,label,ncgen,desc)
%NCEP_GENCDL   Create NetCDF cdl and nc file of ROMS bulk forcings
%   Generates cdl and NetCDF file for several types of forcings.
%   The cdl file has the name type.cdl.
%   NetCDF file has the name type_label.nc and is created by ncgen -b.
%
%   Syntax:
%      [CDL_NAME,NC_NAME] = NCEP_GENCDL(TYPE,DIMS,LABEL,NC,DESC)
%
%
%   Inputs:
%      TYPE    Type of forcing, currently can be:
%              - wind
%              - cloud
%              - radiation
%              - humidity
%              - pressure
%              - precipitation
%              - temperature
%              - all: all together
%     DIMS    Dimensions x,y and t [ <x,y,t> ]
%     LABEL   Label to use in the name of the NetCDF file [ 'frc' ]
%     NC      String with ncgen executable, if not used, then ncgen is not used
%             and .nc file not created
%     DESC    Description to use as global attribute [ '<type> forcing file; <DEC>' ]
%
%   Outputs:
%      CDL_NAME   Name of the cdl  file created
%      NC_NAME    Name of the NetCDF file created
%
%     Comments:
%        If NCGEN is not specified, NetCDF file is not created.
%        NetCDF is created by ncgen -b type.cdl
%
%     Example:
%        type  = 'cloud';
%        dims  = [30 20 100];
%        label = 'test';
%        nc    = '/usr/local/NetCDF/bin/ncgen';
%        [fcdl,fnc] = ncep_gencdl(type,dims,label,nc)
%
%   MMA 28-5-2004, martinho@fis.ua.pt
%
%   See also NCEP_GENFRC, NCEP_GEN

%   Department of Physics
%   University of Aveiro, Portugal

%   ??-10-2004 - Added extra data to radiation file

if nargin < 5
  desc = '';
end

if nargin < 4
  nc = 0;
else
  nc = 1;
end
if nargin < 3
  label='frc';
end
if nargin < 2
  disp('## dims must be specified...');
  return
end
if nargin == 0
  disp('## type and dims must be specified...');
end

types={'wind','cloud','radiation','humidity','pressure','precipitation','temperature'};
if ~isequal(type,'all')
  types={type};
end

cdl_name = [];
nc_name  = [];

x = dims(3);
y = dims(2);
t = dims(1);

cdl = [type,'.cdl'];
fid = fopen(cdl,'w');


% ------------------------------------- first line:
fname=[type,'_',label];
fprintf(fid,'netcdf %s {\n',fname);

% ------------------------------------- set dimensions:
fprintf(fid,'dimensions:\n');
fprintf(fid,'        xi_rho   = %d ;\n',x);
fprintf(fid,'        eta_rho  = %d ;\n',y);
for n=1:length(types)
  [dims,info,info_t,info_file] = get_info(types{n});
  for i=1:length(dims)
    fprintf(fid,'        %s = %d ;\n',dims(i).time,t);
  end
end

% ------------------------------------- set variables:
fprintf(fid,'variables:\n');

if isempty(info)
  disp(['## unknown type: ',type]);
  fclose(fid);
  delete(cdl);
  return;
end

for n=1:length(types)
  [dims,info,info_t,info_file] = get_info(types{n});

  % ------------------ set time:
  for i=1:length(info_t)
    fprintf(fid,'        %s\n',info_t(i).name);
    fprintf(fid,'        %s\n',info_t(i).lname);
    fprintf(fid,'        %s\n',info_t(i).units);
    fprintf(fid,'        %s\n',info_t(i).field);
  end

  % ------------------ set vars:
  for i=1:length(info)
    fprintf(fid,'        %s\n',info(i).name);
    fprintf(fid,'        %s\n',info(i).lname);
    fprintf(fid,'        %s\n',info(i).units);
    fprintf(fid,'        %s\n',info(i).field);
    fprintf(fid,'        %s\n',info(i).time);
  end

end

% ------------------------------------- set global attributes:
if isequal(type,'all')
  info_file.description = [':description = "bulk fluxes forcing file" ;'];
end
% apply input description:
info_file.description = [info_file.description(1:end-3),' ',desc,'" ;'];
fprintf(fid,'\n');
fprintf(fid,'// global attributes:\n');
fprintf(fid,'                %s\n',info_file.description);
fprintf(fid,'                %s\n',info_file.author);
fprintf(fid,'                %s\n',info_file.date);

% ------------------------------------- last line:
fprintf(fid,'}');

fclose(fid);

%===============================================  create NetCDF  file
if nc
  disp(['## creating  ',fname,'.nc from  ',cdl]);
  eval(['! ',ncgen,' -b ',cdl]);
end

%---------------- output:
cdl_name = cdl;
nc_name  = [fname,'.nc'];


function [dims,info,info_t,info_file] = get_info(type)
switch type
  case 'wind'
    dims.time       = 'wind_time';
    v{1}            = 'Uwind';
    v{2}            = 'Vwind';

    info_t.name     = ['double ',dims.time,'(',dims.time,') ;'                                           ];
    info_t.lname    = ['       ',dims.time,':long_name = "surface wind time" ;'                          ];
    info_t.units    = ['       ',dims.time,':units = "day" ;'                                            ];
    info_t.field    = ['       ',dims.time,':field = "time, scalar, series" ;'                           ];
    %info_t.cycle   = '        wind_time:cycle_length = 360.0 ;'; % cycle not needed!

    info(1).name    = ['float ',v{1},'(',dims.time,', eta_rho, xi_rho) ;'                                ];
    info(1).lname   = ['      ',v{1},':long_name = "surface u-wind component" ;'                         ];
    info(1).units   = ['      ',v{1},':units = "meter second-1" ;'                                       ];
    info(1).field   = ['      ',v{1},':field = "u-wind, scalar, series" ;'                               ];
    info(1).time    = ['      ',v{1},':time = "',dims.time,'" ;'                                         ];

    info(2).name    = ['float ',v{2},'(',dims.time,', eta_rho, xi_rho) ;'                                ];
    info(2).lname   = ['      ',v{2},':long_name = "surface v-wind component" ;'                         ];
    info(2).units   = ['      ',v{2},':units = "meter second-1" ;'                                       ];
    info(2).field   = ['      ',v{2},':field = "v-wind, scalar, series" ;'                               ];
    info(2).time    = ['      ',v{2},':time = "',dims.time,'" ;'                                         ];


  case 'cloud'
    dims.time       = 'cloud_time'; v = 'cloud';

    info_t.name     = ['double ',dims.time,'(',dims.time,') ;'                                           ];
    info_t.lname    = ['       ',dims.time,':long_name = "time for cloud fraction" ;'                    ];
    info_t.units    = ['       ',dims.time,':units = "day" ;'                                            ];
    info_t.field    = ['       ',dims.time,':field = "time, scalar, series" ;'                           ];

    info.name       = ['float ',v,'(',dims.time,', eta_rho, xi_rho) ;'                                   ];
    info.lname      = ['      ',v,':long_name = "cloud fraction" ;'                                      ];
    info.units      = ['      ',v,':units = "nondimensional" ;'                                          ];
    info.field      = ['      ',v,':field = "cloud, scalar, series" ;'                                   ];
    info.time       = ['      ',v,':time = "',dims.time,'" ;'                                            ];


  case 'radiation'
    dims(1).time    = 'srf_time'; v{1} = 'swrad';    % shortwave
    dims(2).time    = 'lrf_time'; v{2} = 'lwrad';    % longwave
    dims(3).time    = 'lhf_time'; v{3} = 'latent';   % latent
    dims(4).time    = 'sen_time'; v{4} = 'sensible'; % sensible
    dims(5).time    = 'shf_time'; v{5} = 'shflux';   % surface net

    info_t(1).name  = ['double ',dims(1).time,'(',dims(1).time,') ;'                                     ];
    info_t(1).lname = ['       ',dims(1).time,':long_name = "time for solar shortwave radiation flux" ;' ];
    info_t(1).units = ['       ',dims(1).time,':units = "day" ;'                                         ];
    info_t(1).field = ['       ',dims(1).time,':field = "time, scalar, series" ;'                        ];

    info_t(2).name  = ['double ',dims(2).time,'(',dims(2).time,') ;'];
    info_t(2).lname = ['       ',dims(2).time,':long_name = "time for net longwave radiation flux" ;'    ];
    info_t(2).units = ['       ',dims(2).time,':units = "day" ;'                                         ];
    info_t(2).field = ['       ',dims(2).time,':field = "time, scalar, series" ;'                        ];

    info_t(3).name  = ['double ',dims(3).time,'(',dims(3).time,') ;'                                     ];
    info_t(3).lname = ['       ',dims(3).time,':long_name = "time for net latent heat flux" ;'           ];
    info_t(3).units = ['       ',dims(3).time,':units = "day" ;'                                         ];
    info_t(3).field = ['       ',dims(3).time,':field = "time, scalar, series" ;'                        ];

    info_t(4).name  = ['double ',dims(4).time,'(',dims(4).time,') ;'                                     ];
    info_t(4).lname = ['       ',dims(4).time,':long_name = "time for sensible heat flux" ;'             ];
    info_t(4).units = ['       ',dims(4).time,':units = "day" ;'                                         ];
    info_t(4).field = ['       ',dims(4).time,':field = "time, scalar, series" ;'                        ];

    info_t(5).name  = ['double ',dims(5).time,'(',dims(5).time,') ;'                                     ];
    info_t(5).lname = ['       ',dims(5).time,':long_name = "time for surface net heat flux" ;'          ];
    info_t(5).units = ['       ',dims(5).time,':units = "day" ;'                                         ];
    info_t(5).field = ['       ',dims(5).time,':field = "time, scalar, series" ;'                        ];

    info(1).name    = ['float ',v{1},'(',dims(1).time,', eta_rho, xi_rho) ;'                             ];
    info(1).lname   = ['      ',v{1},':long_name = "solar shortwave radiation flux" ;'                   ];
    info(1).units   = ['      ',v{1},':units = "Watts meter-2" ;'                                        ];
    info(1).field   = ['      ',v{1},':field = "shortwave radiation, scalar, series" ;'                  ];
    info(1).time    = ['      ',v{1},':time = "',dims(1).time,'" ;'                                      ];

    info(2).name    = ['float ',v{2},'(',dims(2).time,', eta_rho, xi_rho) ;'                             ];
    info(2).lname   = ['      ',v{2},':long_name = "net longwave radiation flux" ;'                      ];
    info(2).units   = ['      ',v{2},':units = "Watts meter-2" ;'                                        ];
    info(2).field   = ['      ',v{2},':field = "longwave radiation, scalar, series" ;'                   ];
    info(2).time    = ['      ',v{2},':time = "',dims(2).time,'" ;'                                      ];

    info(3).name    = ['float ',v{3},'(',dims(3).time,', eta_rho, xi_rho) ;'                             ];
    info(3).lname   = ['      ',v{3},':long_name = "net latent heat flux" ;'                             ];
    info(3).units   = ['      ',v{3},':units = "Watts meter-2" ;'                                        ];
    info(3).field   = ['      ',v{3},':field = "latent heat flux, scalar, series" ;'                     ];
    info(3).time    = ['      ',v{3},':time =  "',dims(3).time,'" ;'                                     ];

    info(4).name    = ['float ',v{4},'(',dims(4).time,', eta_rho, xi_rho) ;'                             ];
    info(4).lname   = ['      ',v{4},':long_name = "net sensible heat flux" ;'                           ];
    info(4).units   = ['      ',v{4},':units = "Watts meter-2" ;'                                        ];
    info(4).field   = ['      ',v{4},':field = "sensible heat flux, scalar, series" ;'                   ];
    info(4).time    = ['      ',v{4},':time =  "',dims(4).time,'" ;'                                     ];

    info(5).name    = ['float ',v{5},'(',dims(5).time,', eta_rho, xi_rho) ;'                             ];
    info(5).lname   = ['      ',v{5},':long_name = "surface net heat flux" ;'                            ];
    info(5).units   = ['      ',v{5},':units = "Watts meter-2" ;'                                        ];
    info(5).field   = ['      ',v{5},':field = "surface net heat flux, scalar, series" ;'                ];
    info(5).time    = ['      ',v{5},':time = "',dims(5).time,'" ;'                                      ];


  case 'humidity'
    dims.time       = 'qair_time'; v = 'Qair';

    info_t.name     = ['double ',dims.time,'(',dims.time,') ;'                                           ];
    info_t.lname    = ['       ',dims.time,':long_name = "time for surface air relative humidity" ;'     ];
    info_t.units    = ['       ',dims.time,':units = "day" ;'                                            ];
    info_t.field    = ['       ',dims.time,':field = "time, scalar, series" ;'                           ];

    info.name       = ['float ',v,'(',dims.time,', eta_rho, xi_rho) ;'                                   ];
    info.lname      = ['      ',v,':long_name = "surface air relative humidity" ;'                       ];
    info.units      = ['      ',v,':units = "percentage" ;'                                              ];
    info.field      = ['      ',v,':field = "Qair, scalar, series" ;'                                    ];
    info.time       = ['      ',v,':time = "',dims.time,'" ;'                                            ];


  case 'pressure'
    dims.time       = 'pair_time'; v = 'Pair';

    info_t.name     = ['double ',dims.time,'(',dims.time,') ;'                                           ];
    info_t.lname    = ['       ',dims.time,':long_name = "time for surface air pressure" ;'              ];
    info_t.units    = ['       ',dims.time,':units = "day" ;'                                            ];
    info_t.field    = ['       ',dims.time,':field = "time, scalar, series" ;'                           ];

    info.name       = ['float ',v,'(',dims.time,', eta_rho, xi_rho) ;'                                   ];
    info.lname      = ['      ',v,':long_name = "surface air pressure" ;'                                ];
    info.units      = ['      ',v,':units = "milibar" ;'                                                 ];
    info.field      = ['      ',v,':field = "Pair, scalar, series" ;'                                    ];
    info.time       = ['      ',v,':time  = "',dims.time,'" ;'                                           ];


  case 'precipitation'
    dims.time       = 'rain_time'; v = 'rain';

    info_t.name     = ['double ',dims.time,'(',dims.time,') ;'                                           ];
    info_t.lname    = ['       ',dims.time,':long_name = "time for rain fall rate" ;'                    ];
    info_t.units    = ['       ',dims.time,':units = "day" ;'                                            ];
    info_t.field    = ['       ',dims.time,':field = "time, scalar, series" ;'                           ];

    info.name       = ['float ',v,'(',dims.time,', eta_rho, xi_rho) ;'                                   ];
    info.lname      = ['      ',v,':long_name = "rain fall rate" ;'                                      ];
    info.units      = ['      ',v,':units = "kilogram meter-2 second-1" ;'                               ];
    info.field      = ['      ',v,':field = "rain, scalar, series" ;'                                    ];
    info.time       = ['      ',v,':time = "',dims.time,'"  ;'                                           ];


  case 'temperature'
    dims.time       = 'tair_time'; v = 'Tair';

    info_t.name     = ['double ',dims.time,'(',dims.time,') ;'                                           ];
    info_t.lname    = ['       ',dims.time,':long_name = "time for surface air temperature" ;'           ];
    info_t.units    = ['       ',dims.time,':units = "day" ;'                                            ];
    info_t.field    = ['       ',dims.time,':field = "time, scalar, series" ;'                           ];

    info.name       = ['float ',v,'(',dims.time,', eta_rho, xi_rho) ;'                                   ];
    info.lname      = ['      ',v,':long_name = "surface air temperature" ;'                             ];
    info.units      = ['      ',v,':units = "Celsius" ;'                                                 ];
    info.field      = ['      ',v,':field = "Tair, scalar, series" ;'                                    ];
    info.time       = ['      ',v,':time = "',dims.time,'" ;'                                            ];

otherwise
   dims   = [];
   info_t = [];
   info   = [];
end

info_file.description = [':description = "',type,' forcing file" ;'];
evalc('[a,logname]=unix(''whoami'');','logname=[];');
%strrep(logname,char(10),'p'); % remove line feed (ascii 10)
logname=logname(1:end-1);
info_file.author      = [':author = "',logname,'" ;'];
info_file.date        = [':date = "',datestr(now),'" ;'];

return
