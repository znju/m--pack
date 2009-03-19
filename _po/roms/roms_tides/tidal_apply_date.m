function tidal_apply_date(ftidal,date,ndays,grd)
%TIDAL_APPLY_DATE   Apply date to a ROMS tidal forcing file
%   Starting from Greenwich based data, corrections are applied to
%   all amplitudes and phases of the tidal data.
%   The corretctions are done by tt_predic, a modified version of
%   the Pawlowicz's file from T_TIDE.
%   A new file is created with the date included in the name.
%
%   Syntax:
%      TIDAL_APPLY_DATE(TIDAL,GRD,DATE,NDAYS)
%
%   Inputs:
%      TIDAL   Tidal forcing file, without date corrections
%      GRD     Grid file, needed for the nodal corrections
%      DATE    Reference date for the new file, [y m d hr mn sec]
%              or [y m d]
%      NDAYS   The corrections need a duration interval, it can be
%              the duration you expect to run the simulation
%      GRD     Grid file, needed for the nodal corrections, by
%              default is used the name stored at the file (TIDAL)
%              global attribute 'grd_file'
%
%   Example:
%      % this example will create the new file tidal_frc.nc_2007_1_1
%      tidal = 'tidal_frc.nc';
%      grd   = 'roms_grd.nc';
%      date  = [2007 1 1];
%      ndays = 90;
%      tidal_apply_date(tidal,grd,date,ndays)
%
%   MMA 27-12-2006, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

if nargin <4
  if n_fileattexist(ftidal,'grd_file')
    grd = n_fileatt(ftidal,'grd_file');
  else
    error(':: provide the grid filename (not found in attribute grd_file');
  end
end
[xg,yg]=roms_grid(grd);

% gen tim. corrections of t_predic are done at the central tim!
if length(date)==6
  [year,month,day,hr,minute,second]=unpack(date);
else
  [year,month,day]=unpack(date);
  hr=0;minute=0;second=0;
end
tim=datenum(year,month,day,hr:hr+24*ndays,minute,second);

% gen tidestruc for t_predic:
ts.freq=1./use(ftidal,'tide_period');

% load amp and phase from original file:
ampH  = use(ftidal,'tide_Eamp');
phaH  = use(ftidal,'tide_Ephase');
% calc amps and phas for u and v:
phaE  = use(ftidal,'tide_Cphase');
incE  = use(ftidal,'tide_Cangle');
cminE = use(ftidal,'tide_Cmin');
semaE = use(ftidal,'tide_Cmax');
eccE=cminE./semaE;
[ampU, phaU, ampV, phaV] = ep2ap(semaE,eccE,incE,phaE);

tsH=ts;
tsU=ts;
tsV=ts;

m=0.00000001; % just to avoid warning inside tt_predic
c=progress('init');
for i=1:size(xg,1)
  c=progress(c,i/size(xg,1));
  for j=1:size(xg,2)
    latitude = yg(i,j);

    % gen tidecons for H, U and V:
    tsH.tidecon=[ampH(:,i,j) ampH(:,i,j)+m phaH(:,i,j) phaH(:,i,j)+m];
    tsU.tidecon=[ampU(:,i,j) ampU(:,i,j)+m phaU(:,i,j) phaU(:,i,j)+m];
    tsV.tidecon=[ampV(:,i,j) ampV(:,i,j)+m phaV(:,i,j) phaV(:,i,j)+m];

    [y,amp_H,pha_H]=tt_predic(tim,tsH,'latitude',latitude);
    [y,amp_U,pha_U]=tt_predic(tim,tsU,'latitude',latitude);
    [y,amp_V,pha_V]=tt_predic(tim,tsV,'latitude',latitude);

    ampH(:,i,j)=amp_H; phaH(:,i,j)=pha_H;
    ampU(:,i,j)=amp_U; phaU(:,i,j)=pha_U;
    ampV(:,i,j)=amp_V; phaV(:,i,j)=pha_V;
  end
end
% go back to ellipse parameters:
[semaE,eccE,incE,phaE]   = ap2ep(ampU, phaU, ampV, phaV);

% done, add to new file:
newTidal=[ftidal,'_',num2str(year),'_',num2str(month),'_',num2str(day)]
system(['cp ',ftidal,' ',newTidal])

nc=netcdf(newTidal,'w');
  nc{'tide_Eamp'}(:)   = nan2zero(ampH);
  nc{'tide_Ephase'}(:) = nan2zero(phaH);
  nc{'tide_Cphase'}(:) = nan2zero(phaE);
  nc{'tide_Cangle'}(:) = nan2zero(incE);
  nc{'tide_Cmin'}(:)   = nan2zero(semaE.*eccE);
  nc{'tide_Cmax'}(:)   = nan2zero(semaE);

  nc.tidal_start=datestr(datenum([year,month,day,hr,minute,second]),31);
close(nc);

% check nans:
n_filenans(newTidal)

fprintf(1,':: done, created file %s\n',newTidal);
