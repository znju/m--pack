function [z,zz,dz,dzz] = pom_ztxt(ztxt)
%POM_ZTXT   Get POM vertical data from text file
%
%   Syntax:
%      [Z,ZZ,DZ,DZZ] = POM_ZTXT(FILE)
%
%   Inputs:
%      FILE   POM vertical coordinates text file
%
%   Outputs:
%      Z,ZZ,DZ,DZZ   Columns 2, 3, 4 and 5 of FILE
%
%   MMA  02-09-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

nskip=1;
fid=fopen(ztxt);

if nskip
  for i=1:nskip, fgetl(fid); end
end

% read data:
cont=0;
while 1
  cont=cont+1;
  tline = fgetl(fid);
  if isequal(tline,-1) | isempty(str2num(tline)), break, end
  data(cont,:)=str2num(tline);
end

z   = data(:,2);
zz  = data(:,3);
dz  = data(:,4);
dzz = data(:,5);

fclose(fid);
