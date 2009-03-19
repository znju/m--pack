function R_mvstatime(what)

global H

if nargin == 0
  return
end

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

NSTA=length(ot);

tindex = H.ROMS.sta.tindex;
tval   = H.ROMS.sta.tval;
tstep  = H.ROMS.sta.tstep;

ti   = str2num(get(tindex, 'string'));
steps = get(tstep,  'string');
autot=0; if findstr(steps,'+'), autot=1; end
step = str2num(strrep(steps,'+',''));

if isequal(what,'<')
  T    = ti-step;
  if T < 1
    T = NSTA;
  end
  time = ot(T)/86400;
  set(tindex, 'string',T);
  set(tval,   'string',time);
end

if isequal(what,'>')
  T    = ti+step;
  if T > NSTA
    T = 1;
  end
  time = ot(T)/86400;
  set(tindex, 'string',T);
  set(tval,   'string',time);
end

if isequal(what,'i')
  if isempty(ti) | ti < 1 | ti > NSTA
    T = 1;
    time = ot(T)/86400;
    set(tindex, 'string',T);
    set(tval,   'string',time);
  end
end

if isequal(what,'step')
  % ok, but let me use "step+": if + after number itime will change
  % automaticaly when pressing > or <
  if findstr(steps,'+')
    steps_=strrep(steps,'+','');
    step = str2num(steps_);
    if ~(isnumber(step,1) & step >= 1 & step <= NSTA)
      set(tstep,'string',1);
    end
  else
    if step < 1 | step > NSTA
      set(tstep,'string',1);
    end
  end
  if isempty(step)
    set(tstep,'string',1);
  end
end

if isequal(what,'T')
  T = 1;
  time = ot(T)/86400;
  set(tindex, 'string',T);
  set(tval,   'string',time);
end


% plot if dispcb is checked:
if get(H.ROMS.sta.dispcb,'value')
  R_stadisp;
end


%%%%%%%%%
if isequal(what,'>')
  if autot & T ~= 1
    drawnow
    R_mvstatime('>')
  end
end
