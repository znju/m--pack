function S_datenum(co)
%function S_datenum(co)
%Checks datenum used for tidal prediction
%co is the object: start time, end time or dt
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt


global HANDLES ETC

% current time:
dd=datestr(now,'dd');         % day
mmm=datestr(now,'mmm');       % mounth
mm=datestr(now,'mm');         % mounth
yyyy=datestr(now,'yyyy');     % year
time=datestr(now,'HH:MM:SS'); % hour, min, sec
h=time(1:2);
m=time(4:5);
s=time(7:8);

mmm_next  = datestr(datenum(str2num(yyyy),str2num(mm)+ETC.datenum.end,str2num(dd)),'mmm');
yyyy_next = datestr(datenum(str2num(yyyy),str2num(mm)+ETC.datenum.end,str2num(dd)),'yyyy');
dd_next   = datestr(datenum(str2num(yyyy),str2num(mm)+ETC.datenum.end,str2num(dd)),'dd');

str_now  = [yyyy,',',mm,',',dd,',',h,',',m,',',s];
str_day  = [dd,'-',mmm,'-',yyyy];
str_next = [dd_next,'-',mmm_next,'-',yyyy_next];
str_dt   = [num2str(ETC.datenum.dt),' hour'];

% init:
if isequal(co,'init')
  init(str_day,str_next,str_dt);
end


if isequal(co,'s')
  str=get(HANDLES.datenum_s,'string');
  if check_datenum(str)
    set(HANDLES.datenum_s,'string',str_day);
  end
elseif isequal(co,'e')
  str=get(HANDLES.datenum_e,'string');
  if check_datenum(str)
    set(HANDLES.datenum_e,'string',str_next);
  end
end

str=get(HANDLES.datenum_dt,'string');
i=findstr(' ',str);
if isempty(i)
  i=length(str);
end
evalc('dt=str2num(str(1:i(end)-1));');
if isempty(dt) | isnan(dt)
  dt=ETC.datenum.dt;
end
if isequal(co,'dt')
  set(HANDLES.datenum_dt,'string',[num2str(dt),' hour']);
end
 

%generate tim:
ts=datenum(get(HANDLES.datenum_s,'string'));
te=datenum(get(HANDLES.datenum_e,'string'));
if ts > te
  init(str_day,str_next,str_dt);
end
%tim=ts:dt/24:te;

ETC.datenum.dt=dt;

%---------------------------------------------------------------------

function err=check_datenum(stri)
str=['datenum(''',stri,''');'];
err=0;
evalc(str,'err=1');
if ~ err
  tim=eval(str);
  if isnan(tim) | length(tim) > 1
    err=1;
  end
end

function init(str_day,str_next,str_dt)
global HANDLES
set(HANDLES.datenum_s,'string',str_day);
set(HANDLES.datenum_e,'string',str_next);
set(HANDLES.datenum_dt,'string',str_dt)

