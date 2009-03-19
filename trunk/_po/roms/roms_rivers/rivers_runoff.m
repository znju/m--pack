function [tout,qout] = rivers_runoff(datafile,nrivers,varargin)
%RIVERS_RUNOFF   Set rivers runoff for ROMS rivers forcing file
%
%   Syntax:
%      [TOUT,QOUT] = RIVERS_RUNOFF(DATAFILE,NRIVERS,VARARGIN)
%
%   Example:
%      rivers_runoff(f,2,'ts','1-feb-2001','te','10-Apr-2001','Qconst',5000);
%
%   MMA 2005, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

tout = [];
qout = [];

dt = 1;
rivernames = '';
ts = '';
te = '';
Qconst = [];

vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'rivernames')
    rivernames = vin{i+1};
  end
  if isequal(vin{i},'Qconst')
    Qconst = vin{i+1};
  end
  if isequal(vin{i},'ts')
    ts = vin{i+1};
  end
  if isequal(vin{i},'te')
    te = vin{i+1};
  end
  if isequal(vin{i},'dt')
    dt = vin{i+1};
  end
end

if nargin < 2
  nrivers = 1;
end
if nargin == 0
  disp('## missing datafile...');
  return
end


if length(Qconst) < nrivers
  Qconst(end+1:nrivers) = 0;
end

thenames = rivernames;
if length(thenames) < nrivers
  for i=length(thenames)+1:nrivers
    thenames{i} = 'unknown river';
  end
end

names = '';
for i=1:length(rivernames)
  names = [names,', ',rivernames{i}];
end
names = names(3:end);


disp([' ---> building runoff from file ',datafile]);

% --------------------------------------------------------------------
% read first line to get the date:
% --------------------------------------------------------------------
fid=fopen(datafile);
line = fgetl(fid);
i=findstr(line,'since');
if ~isempty(i)
  tstart = line(i+5:end);
else
  tstart = 'unknown';
  % if is the case, then just use all values
end
disp(['## tstart in file ',datafile,' = ',tstart])

% --------------------------------------------------------------------
% read the rest of the file:
% --------------------------------------------------------------------
data = [];
cont = 1;
while 1
  line = fgetl(fid);
  if ~ischar(line), break, end
  data(cont,:) = str2num(line);
  cont = cont+1;
end
fclose(fid);

time = data(:,1);
Q    = data(:,2:end);
for i=1:size(Q,2)
  evalc(['q',num2str(i),'=Q(:,i);']);
  figure
  evalc(['plot(time,q',num2str(i),')']);
  title(['river ',thenames{i},' runoff']);
  xlabel(['time (days) since ',tstart])
end
disp(['## found data in file for ',num2str(size(Q,2)),' rivers']);

miss = nrivers - size(Q,2);
if miss > 0
  disp(['## will use constant runoff for other rivers = ',num2str(Qconst(1:miss))]);

  n = size(Q,1);
  for i=1:miss
    Q = [Q repmat(Qconst(i),n,1)];
  end
end

% --------------------------------------------------------------------
% create runoff for the desired date and dt:
% --------------------------------------------------------------------
if isequal(tstart,'unknown')
  % then the file must have the correct values of time and runoff !!
  tout = time;
  qout = Q;
else
  if isempty(ts) | isempty(te)
    disp('## you must provide arguments ts (tstart) and te (tend)...');
    return
  end


  if datenum(tstart) > datenum(ts)
    disp('## date in data file is higher than desired output time...')
    disp('## missing data will be converted to zero !!');
    %return
  end
  tout = [datenum(ts):dt:datenum(te)] - datenum(ts);
  tin  = time + datenum(tstart) - datenum(ts) -1; % -1 cos data in file is at the end of days!

  % interp runoff to tout:
  for i=1:nrivers
    qi = interp1(tin,Q(:,i),tout);

    figure
    plot(tin,Q(:,i))
    hold on
    plot(tout,qi,'r');

    % detect the nans amd convert them to zero:
    is=isnan(qi);
    if any(is)
      plot(tout(is),0,'r+');
      qi=nan2zero(qi);
    end

    title(['river ',thenames{i},' runoff']);
    xlabel(['time (days) since ',ts,' until ',te])

    qout(:,i) = qi';
  end

end

% show final results:
figure
plot(tout,qout)
legend(thenames)
if ~isequal(tstart,'unknown')
  xlabel(['time (days) since ',ts,' until ',te])
end
