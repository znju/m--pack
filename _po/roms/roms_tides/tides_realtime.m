function tides_realtime(frcstd,frctarget,Ymin,Mmin,Dmin,Yorig)
%TIDES_REALTIME   Correct ROMS tidal data from standard to real time
%
%   Syntax:
%      TIDES_REALTIME(FRCSTD,FRCTARGET,Y,M,D,YORIG)
%
%   Inputs:
%      FRCSTD    ROMS tidal forcing file with standard data
%      FRCTARGET ROMS forcing file to be written/created
%      Y,M,D     Reference year, month and day
%      YORIG     Year of origin (when roms time is zero, considering
%                the model starts from the beginning of the year
%
%   Example:
%      frcstd='roms_tidal_std.nc'
%      frctarger='roms_frc.nc'
%      y=2009
%      m=7
%      d=1 % tidal amps and phases corrected to 1-jul-2009
%      y0=2009
%      tides_realtime(frcstd,frctarget,y,m,d,y0)
%
%   M MA, 17-04-2009, mma@odyle.net
%
%   See also TPXO_EXTRACT TPXO2ROMS EGBERT_CORRECT

hour=0;
minute=0;
sec=0;

Morig=1;
Dorig=1;

% create tidal forcing file or add tidal data to existing roms file:
if exist(frctarget)~=2
  xi  = n_dim(frcstd,'xi_rho');
  eta = n_dim(frcstd,'eta_rho');
  % create file with required dims:
  nc=netcdf(frctarget,'clobber');
  nc('xi_rho')=xi;
  nc('eta_rho')=eta;
  close(nc);
else
  if ~n_dimexist(frctarget,'xi_rho') | ~n_dimexist(frctarget,'eta_rho')
    fprintf(1,':: Dimensions xi or eta not found in frc file %s !!\n',frc);
    return
  end
end

% get periods and components:
period=use(frcstd,'tide_period');
components='';
comps={};
for i=1:length(period)
  comps{i}=lower(trim(freq2name(1/period(i))));
  components=[components ' ' trim(comps{i})];
end
components=trim(components);

% load tidal data:
epha   = use(frcstd,'tide_Ephase');
eamp   = use(frcstd,'tide_Eamp');
cmin   = use(frcstd,'tide_Cmin');
cmax   = use(frcstd,'tide_Cmax');
cangle = use(frcstd,'tide_Cangle');
cphase = use(frcstd,'tide_Cphase');

% conv ellipse params to amps and phases:
ecc=cmin./cmax;
[uamp,upha,vamp,vpha]=ep2ap(cmax,ecc, cangle,cphase);

% calc corrections:
date_mjd=mjd(Ymin,Mmin,Dmin);
[pf,pu,t0,phase_mkB]=egbert_correct(date_mjd,hour,minute,sec,comps);
t0=t0-24*mjd(Yorig,Morig,Dorig);
correc_amp=pf;
correc_phase=-phase_mkB-pu+360*t0./period;

% apply corrections:
if length(period)==1
  eamp = eamp*correc_amp(i);
  uamp = uamp*correc_amp(i);
  vamp = vamp*correc_amp(i);

  epha = mod(epha+correc_phase(i),360.0);
  upha = mod(upha+correc_phase(i),360.0);
  vpha = mod(vpha+correc_phase(i),360.0);
else
  for i=1:length(period)
    eamp(i,:,:) = eamp(i,:,:)*correc_amp(i);
    uamp(i,:,:) = uamp(i,:,:)*correc_amp(i);
    vamp(i,:,:) = vamp(i,:,:)*correc_amp(i);

    epha(i,:,:) = mod(epha(i,:,:)+correc_phase(i),360.0);
    upha(i,:,:) = mod(upha(i,:,:)+correc_phase(i),360.0);
    vpha(i,:,:) = mod(vpha(i,:,:)+correc_phase(i),360.0);
  end
end

% conv amps and phases to ellipse params:
[cmax,ecc,cangle,cphase]=ap2ep(uamp,upha,vamp,vpha);
cmin=ecc.*cmax;

% fill data:
nc_add_tides(frctarget,length(comps),date_mjd,components)
nc=netcdf(frctarget,'w');
nc{'tide_Eamp'}(:)    = eamp;
nc{'tide_Ephase'}(:)  = epha;
nc{'tide_Cmin'}(:)    = cmin;
nc{'tide_Cmax'}(:)    = cmax;
nc{'tide_Cangle'}(:)  = cangle;
nc{'tide_Cphase'}(:) = cphase;
close(nc);
