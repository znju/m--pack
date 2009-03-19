function tidal_to_frc(ftide,ffrc)
%TIDAL_TO_FRC   Append tidal to forcing file
%   Adds the contenst of a ROMS tidal forcing file to an existent
%   forcing file.
%
%   Syntax:
%      TIDAL_TO_FRC(TIDAL,FRC)
%
%   Inputs:
%      TIDAL   ROMS tidal forcing file
%      FRC     ROMS forcing file
%
%   MMA 27-12-2006, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

nc=netcdf(ffrc,'w');

nc.grd_file    = n_fileatt(ftide,'grd_file');
nc.components  = n_fileatt(ftide,'components');
nc.tidal_start = n_fileatt(ftide,'tidal_start');

nc('tide_period')=n_filedim(ftide,'tide_period');

nc{'tide_period'} = ncdouble('tide_period');
nc{'tide_period'}.long_name = ncchar('Tide angular period');
nc{'tide_period'}.long_name = 'Tide angular period';
nc{'tide_period'}.units = ncchar('Hours');
nc{'tide_period'}.units = 'Hours';

nc{'tide_Ephase'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Ephase'}.long_name = ncchar('Tidal elevation phase angle');
nc{'tide_Ephase'}.long_name = 'Tidal elevation phase angle';
nc{'tide_Ephase'}.units = ncchar('Degrees');
nc{'tide_Ephase'}.units = 'Degrees';

nc{'tide_Eamp'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Eamp'}.long_name = ncchar('Tidal elevation amplitude');
nc{'tide_Eamp'}.long_name = 'Tidal elevation amplitude';
nc{'tide_Eamp'}.units = ncchar('Meter');
nc{'tide_Eamp'}.units = 'Meter';

nc{'tide_Cmin'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cmin'}.long_name = ncchar('Tidal current ellipse semi-minor axis');
nc{'tide_Cmin'}.long_name = 'Tidal current ellipse semi-minor axis';
nc{'tide_Cmin'}.units = ncchar('Meter second-1');
nc{'tide_Cmin'}.units = 'Meter second-1';

nc{'tide_Cmax'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cmax'}.long_name = ncchar('Tidal current, ellipse semi-major axis');
nc{'tide_Cmax'}.long_name = 'Tidal current, ellipse semi-major axis';
nc{'tide_Cmax'}.units = ncchar('Meter second-1');
nc{'tide_Cmax'}.units = 'Meter second-1';

nc{'tide_Cangle'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cangle'}.long_name = ncchar('Tidal current inclination angle');
nc{'tide_Cangle'}.long_name = 'Tidal current inclination angle';
nc{'tide_Cangle'}.units = ncchar('Degrees between semi-major axis and East');
nc{'tide_Cangle'}.units = 'Degrees between semi-major axis and East';

nc{'tide_Cphase'} = ncdouble('tide_period', 'eta_rho', 'xi_rho');
nc{'tide_Cphase'}.long_name = ncchar('Tidal current phase angle');
nc{'tide_Cphase'}.long_name = 'Tidal current phase angle';
nc{'tide_Cphase'}.units = ncchar('Degrees');
nc{'tide_Cphase'}.units = 'Degrees';

% ---------------- fill:
disp('filling vars...')
nc{'tide_period'}(:) = use(ftide,'tide_period');
nc{'tide_Eamp'}(:)   = use(ftide,'tide_Eamp');
nc{'tide_Ephase'}(:) = use(ftide,'tide_Ephase');
nc{'tide_Cphase'}(:) = use(ftide,'tide_Cphase');
nc{'tide_Cangle'}(:) = use(ftide,'tide_Cangle');
nc{'tide_Cmin'}(:)   = use(ftide,'tide_Cmin');
nc{'tide_Cmax'}(:)   = use(ftide,'tide_Cmax');
close(nc);
