function R_flttime(what)

global H

if nargin == 0
  what='all';
end


% let be always all:
what='all';

evalc('fname=H.ROMS.flt.fname','fname=[]');
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
NFLT  = length(ot);
evalc('DFLT  = (ot(2)-ot(1))/86400*24*60;','DFLT = 0;');
if isequal(DFLT,0)
  R_mvflttime('T'); % set tindex=1
end

ndays = H.ROMS.flt.ndays;
nflt  = H.ROMS.flt.nflt;
dflt  = H.ROMS.flt.dflt;

if isequal(what,'ndays') | isequal(what,'all')
  set(ndays, 'string',NDAYS);
end
if isequal(what,'nflt') | isequal(what,'all')
  set(nflt,  'string',NFLT);
end
if isequal(what,'dflt') | isequal(what,'all')
  set(dflt,  'string',DFLT);
end

