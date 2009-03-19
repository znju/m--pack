function rm_path(n)
%RM_PATH   Remove lines from path
%
%   Syntax:
%      RM_PATH(N)
%
%   Input:
%      N   Number of lines to remove from the top of the matlab path,
%          if N is string, then remove only line number N.
%
%   MMA 13-10-2006, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

if isstr(n)
  i1=str2num(n);
  i2=i1;
else
  i1=1;
  i2=n;
end

p=path;
s=str_split(p,pathsep);
for i=i1:i2
  rmpath(s{i})
  fprintf(1,':: removed from path : %s\n',s{i});
end
