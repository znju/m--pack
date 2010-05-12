function [time,kin,pot,tot,vol]=roms_read_out(f,plt)
%ROMS_READ_OUT   Parse ROMS output text file
%
%   Syntax:
%     [TIME,KIN,POT,TOT,VOL] = ROMS_READ_OUT(FILE,PLT)
%
%   Inputs:
%      FILE   ROMS output file (roms.out)
%      PLT   If 1, the outputs are plotted (0)
%
%   Outputs:
%      TIME
%      KIN   Kinetic energy
%      POT   Potential energy
%      TOT   Total energy
%      VOL   Net volume
%
%   Example:
%      [time,kin,pot,tot,vol] = roms_read_out('roms.out',1);
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   01-07-2008

if nargin <2
  plt=0;
end

tag=' MAIN: started time-steping.';
nskip=2;

badFormatStr='******';
goodFormatStr='000000';

fid=fopen(f);
data=[];
n0=0;
while 1
  n0=n0+1;
  tline = fgetl(fid);
  if ~ischar(tline), break, end
  if strmatch(tag,tline), break, end
end

n=0; nl=0;
c=progress('init');

% nlines for progress:
[status,nlines]=unix(['wc -l ' f]);
nlines=str2num(str_split(nlines,' ',1));

data=repmat(nan,[nlines,7]);
while 1
  nl=nl+1;
  c=progress(c,(nl+n0)/nlines);
  tline = fgetl(fid);
  if ~ischar(tline), break, end
  if nl>nskip & isempty(findstr('_',tline))
    n=n+1;
    if n==1, L=length(tline); end

    if findstr(badFormatStr,tline)
      tline=strrep(tline,badFormatStr,goodFormatStr);
    end

    if length(tline)==L
      data(n,:)=str2num(tline);
    else
      n=n-1;
    end

  end
end
fclose(fid);
data(n+1:end,:)=[];

time = data(:,2);
kin  = data(:,3);
pot  = data(:,4);
tot  = data(:,5);
vol  = data(:,6);

if plt
  figure
  subplot(4,1,1), plot(time,kin), title('KINETIC_ENRG','interpreter','none')
  subplot(4,1,2), plot(time,pot), title('POTEN_ENRG','interpreter','none')
  subplot(4,1,3), plot(time,tot), title('TOTAL_ENRG','interpreter','none')
  subplot(4,1,4), plot(time,vol), title('NET_VOLUME','interpreter','none'), xlabel('time[DAYS')
end
