function S_close
%function S_close
%Closes SpectrHA log file and figure (closereq)
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global ETC INFO

closereq; %

if exist('ETC') %if var is deleted...
  fid=fopen(ETC.logname,'a');
  fprintf(fid,'%s\n','');
  fprintf(fid,'%s\n','-----------------------------------------');
  str=[INFO.label,' was created by ',INFO.author,', 2003'];
  fprintf(fid,'%s\n',str);
  for i=1:size(INFO.address,1)
    fprintf(fid,'%s\n',INFO.address(i,:));
  end
  fprintf(fid,'%s\n',INFO.www);
  fprintf(fid,'%s\n',INFO.email);
  fprintf(fid,'%s\n','-----------------------------------------');
  fprintf(fid,'%s\n',datestr(now));
  fclose(fid);
end

