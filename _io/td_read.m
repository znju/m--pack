function [time,time_ref,data] = td_read(file,type,ref,ignore,fig)
%TD_READ   Time data read
%   Reads time and data from text file where first columns are time
%   and last ones are the data, see example bellow.
%   The file may have text at beginning and end.
%
%   Syntax:
%      [TIME,TIME_REF,DATA] = TD_READ(FILE,TYPE,REF,IGNORE,FIG)
%      [TIME,DATA] = TD_READ(...)
%
%   Inputs:
%      FILE      Text file to read
%      TYPE      Way time is present, cell array
%                [ {'yyyy','mm','dd','HH','MM','SS'} ]
%                   accepted elements:
%                   'SS'   --> second
%                   'MM'   --> minute
%                   'HH'   --> hour
%                   'dd'   --> day
%                   'mm'   --> month (abb. or full, in eng, pt or es)
%                   'yyyy' --> year
%                   'yy'   --> year - 2000
%      REF       Reference time, time as string accepted by DATENUM,
%                if not 0, a vector TIME_REF may be returned, in days,
%                where this is the time zero, [ 0 ]
%      INGNORE   String (or cell array) to ignore inside lines;
%                suppose after hour there is a string, like GMT+1
%                then at str2num the result would be null, so such
%                string shall be removed, [ '' ]
%      FIG       Show results, if not 0, a plot is done; if length > 1
%                then first element accounts for show_weeks (plot vertical
%                lines at the start of new week) and second, for months
%                [ 1 ]
%
%   Outputs:
%      TIME       Time as unix timestamp
%      TIME_REF   Time in days, since REF (if REF == 0, then TIME_REF
%                 is empty
%      DATA       The data
%
%   Example:
%      fname = 'file_test_td_read.txt';
%      fid = fopen(fname,'w');
%      fprintf(fid,'this is a test...\n');
%      fprintf(fid,'2002 3   5 2       0.4 0\n');
%      fprintf(fid,'2002 4   5 3       0.5 2\n');
%      fprintf(fid,'2002 May 5 4 WEST  0.1 0\n');
%      fprintf(fid,'2002 6   5 5 GMT   0.0 1\n');
%      fclose(fid);
%      type = {'yyyy','mm','dd','HH'};
%      ref  = '1-Apr-2002';
%      ignore = {'GMT','WEST'};
%      fig    = 1;
%      figure
%      [time,time_ref,data] = td_read(fname,type,ref,ignore,fig);
%      figure
%      [time,time_ref,data] = td_read(fname,type,ref,ignore,[0 1]);
%      figure,
%      type = {'yyyy','mm','dd'};
%      ref = 0;
%      [time,data] = td_read(fname,type,ref,ignore,[0 1]);
%      delete(fname)
%
%   MMA 10-2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

addYear=2000; % valu to add if year is yy, like 04 means 2004

data     = [];
time     = [];
time_ref = [];

if nargin < 5
  fig = 1;
end
if nargin < 4
  ignore = {''};
end
if nargin < 3
  ref = 0;
end
if nargin < 2
  type = {'yyyy','mm','dd','HH','mm','SS'};
end
if nargin == 0
  disp('## nothing to do...');
end

show_fig    = 1;
show_weeks  = 1; % vertical lines for weeks
show_months = 1; % vertical lines for mounths
show_ref    = 1; % time relative to ref

if length(fig) > 1
  show_weeks  = fig(1);
  show_months = fig(2);
end

if isequal(fig,0)
  show_fig = 0;
end
if ref == 0
  show_ref = 0;
end

% --------------------------------------------------------------------
% read data:
% --------------------------------------------------------------------
fprintf(1,'## reading data from file %s\n',file);

% file is supposed to have some lines of text and then the data

% read header:
fid=fopen(file);
while 1
  tline = fgetl(fid);
  if isequal(tline,-1) % deal with end-of-file
    return
  end

  for i = 1:length(ignore)
    eval('m = strrep(tline,ignore{i},'' '');','');
  end
  m = str2num(m);
  if ~isempty(m)
    break % data is suppsed to start here
  else % show the header lines:
    disp(tline)
  end
end

% read data:
cont=1;
while 1
  cont=cont+1;
  tline = fgetl(fid);
  if isequal(tline,-1) % deal with end-of-file
    break
    %return
  end

  for i = 1:length(ignore)
    eval('tline = strrep(tline,ignore{i},'' '');','');
  end
  if ~ischar(tline)
    break
  end
  if isempty(str2num(tline))
    % try to remove some characters or change mounts 2 numbers:
    tline=mounth2num(tline);
  end
  if ~isempty(str2num(tline))
    m(cont,:) = str2num(tline);
  else
    break % this allows footer
  end
end
fclose(fid);
fprintf(1,'## found %g lines of data\n',size(m,1));

% --------------------------------------------------------------------
% build time:
% --------------------------------------------------------------------
sec  = 0;mint = 0;hour = 0;day  = 0;mes  = 0;year = 0;
% find sec:
i=ismember(type,'SS');   if any(i), sec   = m(:,i);        end
% find minutes:
i=ismember(type,'MM');   if any(i), mint  = m(:,i);        end
% find hours:
i=ismember(type,'HH');   if any(i), hour = m(:,i);         end
% find days:
i=ismember(type,'dd');   if any(i), day  = m(:,i);         end
% find mounts:
i=ismember(type,'mm');   if any(i), mes  = m(:,i);         end
% find years (yyyy):
i=ismember(type,'yyyy'); if any(i), year = m(:,i);         end
% find years (yy):
i=ismember(type,'yy');   if any(i), year = m(:,i)+addYear; end

% --------------------------------------------------------------------
% gen data
% --------------------------------------------------------------------
n = length(type);
data = m(:,n+1:end);

time     = datenum(year,mes,day,hour,mint,sec);
if show_ref % not calc if ~show_ref
  timeRef  = datenum(ref);
  time_ref = time-timeRef;
end

if nargout == 2
  time_ref = data;
end

% --------------------------------------------------------------------
% plot data:
% --------------------------------------------------------------------
if show_fig
  ax1=axes;
  plot(time,data);
  datetick('x',1);

  if show_ref
    ax2=axes('position',get(ax1,'position'));
    plot(time_ref,data);
    set(ax2,'XAxisLocation','top')
  end

  if show_weeks | show_months
    % add lines of mounths and weeks
    axes(ax1);
    hold on
    % find months:
    day1=datenum(datestr(time(1),1));
    day2=datenum(datestr(time(end),1));
    days=day1:day2;
    yl=ylim;
    for i=1:length(days)
      % weeks:
      if show_weeks
        if datestr(days(i),'d') == 'M'
          plot([days(i) days(i)],[yl(1) yl(2)],'r');
        end
      end

      % months
      if show_months
        if str2num(datestr(days(i),'dd')) == 1
          plot([days(i) days(i)],[yl(1) yl(2)],'k');
        end
      end % show_months
    end
  end % show_weeks | show_months

  if show_ref
    axes(ax1);
    xl1=xlim;
    axes(ax2)
    xlim(xl1-timeRef)
    axes(ax1);
  end

end % show_fig
% --------------------------------------------------------------------

function tline=mounth2num(tline)
% remove some symbols used in dates: / \
tline=strrep(tline,'/',' ');
tline=strrep(tline,'\',' ');

% replace names of mounths by numbers: but first, convert all to lower
tline=lower(tline);

tline=strrep(tline,'jan','01'); tline=strrep(tline,'january',   '01'); % en
tline=strrep(tline,'feb','02'); tline=strrep(tline,'february',  '02'); % en
tline=strrep(tline,'mar','03'); tline=strrep(tline,'mars',      '03'); % en
tline=strrep(tline,'apr','04'); tline=strrep(tline,'april',     '04'); % en
tline=strrep(tline,'may','05'); tline=strrep(tline,'may',       '05'); % en
tline=strrep(tline,'jun','06'); tline=strrep(tline,'june',      '06'); % en
tline=strrep(tline,'jul','07'); tline=strrep(tline,'july',      '07'); % en
tline=strrep(tline,'aug','08'); tline=strrep(tline,'august',    '08'); % en
tline=strrep(tline,'sep','09'); tline=strrep(tline,'september', '09'); % en
tline=strrep(tline,'oct','10'); tline=strrep(tline,'october',   '10'); % en
tline=strrep(tline,'nov','11'); tline=strrep(tline,'november',  '11'); % en
tline=strrep(tline,'dec','12'); tline=strrep(tline,'december',  '12'); % en

tline=strrep(tline,'jan','01'); tline=strrep(tline,'janeiro',   '01'); % pt
tline=strrep(tline,'fev','02'); tline=strrep(tline,'fevereiro', '02'); % pt
tline=strrep(tline,'mar','03'); tline=strrep(tline,'março',     '03'); % pt
tline=strrep(tline,'abr','04'); tline=strrep(tline,'abril',     '04'); % pt
tline=strrep(tline,'mai','05'); tline=strrep(tline,'maio',      '05'); % pt
tline=strrep(tline,'jun','06'); tline=strrep(tline,'junho',     '06'); % pt
tline=strrep(tline,'jul','07'); tline=strrep(tline,'julho',     '07'); % pt
tline=strrep(tline,'ago','08'); tline=strrep(tline,'agosto',    '08'); % pt
tline=strrep(tline,'set','09'); tline=strrep(tline,'setembro',  '09'); % pt
tline=strrep(tline,'out','10'); tline=strrep(tline,'outubro',   '10'); % pt
tline=strrep(tline,'nov','11'); tline=strrep(tline,'novembro',  '11'); % pt
tline=strrep(tline,'dez','12'); tline=strrep(tline,'dezembro',  '12'); % pt

tline=strrep(tline,'ene','01'); tline=strrep(tline,'janeiro',   '01'); % es
tline=strrep(tline,'feb','02'); tline=strrep(tline,'fevereiro', '02'); % es
tline=strrep(tline,'mar','03'); tline=strrep(tline,'março',     '03'); % es
tline=strrep(tline,'abr','04'); tline=strrep(tline,'abril',     '04'); % es
tline=strrep(tline,'may','05'); tline=strrep(tline,'maio',      '05'); % es
tline=strrep(tline,'jun','06'); tline=strrep(tline,'junho',     '06'); % es
tline=strrep(tline,'jún','06'); tline=strrep(tline,'júnio',     '06'); % es
tline=strrep(tline,'jul','07'); tline=strrep(tline,'julio',     '07'); % es
tline=strrep(tline,'júl','07'); tline=strrep(tline,'júlio',     '07'); % es
tline=strrep(tline,'ago','08'); tline=strrep(tline,'agosto',    '08'); % es
tline=strrep(tline,'sep','09'); tline=strrep(tline,'septiembre','09'); % es
tline=strrep(tline,'oct','10'); tline=strrep(tline,'octubre',   '10'); % es
tline=strrep(tline,'nov','11'); tline=strrep(tline,'noviembre', '11'); % es
tline=strrep(tline,'dec','12'); tline=strrep(tline,'deciembre', '12'); % es
