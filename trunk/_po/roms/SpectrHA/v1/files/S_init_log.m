function status = S_init_log(logname);
%function S_init_log(logname);
%Starts SpectrHA log file
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global INFO

status = [];

[fid,err_msg]=fopen(logname,'w');

if ~isempty(err_msg)
  status = 'error';
  return
end

fprintf(fid,'%s\n',INFO.label);
fprintf(fid,'%s\n',INFO.title);
fprintf(fid,'%s\n',INFO.version);
fprintf(fid,'%s\n','Log file');
fprintf(fid,'%s\n',datestr(now));
fprintf(fid,'%s\n','-----------------------------------------');
fprintf(fid,'%s\n','');
fclose(fid);
