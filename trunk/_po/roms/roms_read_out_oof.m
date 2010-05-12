function [TIME,KIN,POT,TOT,VOL]=roms_read_out_oof(p,varargin)
%ROMS_READ_OUT_OOF   Parse ROMS output text file from OOF
%
%   Syntax:
%     [TIME,KIN,POT,TOT,VOL] = ROMS_READ_OUT_OOF(PATH,VARARGIN)
%
%   Inputs:
%      PATH   Path to OOF roms_out
%      VARARGIN:
%         plt, If 1, the outputs are plotted (0)
%         date1, initial date to read
%         date2, final date to read
%
%   Outputs:
%      TIME
%      KIN   Kinetic energy
%      POT   Potential energy
%      TOT   Total energy
%      VOL   Net volume
%
%   Example:
%      [time,kin,pot,tot,vol] = roms_read_out_oof('/home/oof/roms_out');
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   22-09-2009


date1=0;
date2=inf;
plt=0;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'date1')  date1=vin{i+1};
  elseif isequal(vin{i},'date2')  date2=vin{i+1};
  elseif isequal(vin{i},'plt')    plt=vin{i+1};
  end
end

if isstr(date1), date1= datenum(date1,'yyyymmdd'); end
if isstr(date2), date2= datenum(date2,'yyyymmdd'); end

files=list_files(p,'out',0,'_a.');

F={};
for i=1:length(files)
  D=files{i}(end-13:end-6);
  d=datenum(D,'yyyymmdd');

  if d>=date1 & d<=date2
    F{end+1}=files{i};
  end
end

% read files:
TIME=[];
KIN=[];
POT=[];
TOT=[];
VOL=[];
for i=1:length(F)
  fprintf(1,':: reading %s\n',F{i});
  [time,kin,pot,tot,vol] = roms_read_out(F{i},0);
  TIME=[TIME time(:)'];
  KIN=[KIN kin(:)'];
  POT=[POT pot(:)'];
  TOT=[TOT tot(:)'];
  VOL=[VOL vol(:)'];
end


if plt
  figure
  subplot(4,1,1), plot(TIME,KIN), title('KINETIC_ENRG','interpreter','none')
  subplot(4,1,2), plot(TIME,POT), title('POTEN_ENRG','interpreter','none')
  subplot(4,1,3), plot(TIME,TOT), title('TOTAL_ENRG','interpreter','none')
  subplot(4,1,4), plot(TIME,VOL), title('NET_VOLUME','interpreter','none'), xlabel('time[DAYS')
end
