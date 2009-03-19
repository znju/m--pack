function R_histime(what)

global H

if nargin == 0
  what='all';
end


% let be always all:
what='all';

evalc('fname=H.ROMS.his.fname','fname=[]');
if isempty(fname)
  return
end

% get time info:
[time_name,time_scale,time_offset] = R_vars(fname,'time');

ncquiet;
nc=netcdf(fname);
  ot=nc{time_name}(:);
nc=close(nc);
ot = ot * time_scale + time_offset;

NDAYS = (ot(end)-ot(1))/86400;
NHIS  = length(ot);
evalc('DHIS  = (ot(2)-ot(1))/86400;','DHIS = 0;');
if isequal(DHIS,0)
  R_mvhistime('T'); % set tindex=1
end

ndays = H.ROMS.his.ndays;
nhis  = H.ROMS.his.nhis;
dhis  = H.ROMS.his.dhis;

if isequal(what,'ndays') | isequal(what,'all')
  set(ndays, 'string',NDAYS);
end
if isequal(what,'nhis') | isequal(what,'all')
  set(nhis,  'string',NHIS);
end
if isequal(what,'dhis') | isequal(what,'all')
  set(dhis,  'string',DHIS);
end

