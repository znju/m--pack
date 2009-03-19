function R_statime(what)

global H

if nargin == 0
  what='all';
end


% let be always all:
what='all';

evalc('fname=H.ROMS.sta.fname','fname=[]');
if isempty(fname)
  return
end

% get time info:
[time_name, time_scale, time_offset] = R_vars(fname,'time');
nc=netcdf(fname);
ot = nc{time_name}(:);
ot = ot * time_scale + time_offset;
nc=close(nc);

NDAYS = (ot(end)-ot(1))/86400;
NSTA  = length(ot);
evalc('DSTA  = (ot(2)-ot(1))/86400*24;','DSTA = 0;'); % hours

% keep DSTA for filter dt:
H.ROMS.sta.dsta_hours = DSTA;

if isequal(DSTA,0)
  R_mvstatime('T'); % set tindex=1
end

ndays = H.ROMS.sta.ndays;
nsta  = H.ROMS.sta.nsta;
dsta  = H.ROMS.sta.dsta;

if isequal(what,'ndays') | isequal(what,'all')
  set(ndays, 'string',NDAYS);
end
if isequal(what,'nsta') | isequal(what,'all')
  set(nsta,  'string',NSTA);
end
if isequal(what,'dsta') | isequal(what,'all')
  set(dsta,  'string',DSTA);
end

