function [str,name,desc] = fgetfirst(theFile)
%FGETFIRST   Get m-file description
%   Returns the first commented line of an m file.
%   Also returns the first word (usually the function name) and the
%   rest this line (usually the function description).
%
%   Syntax:
%      [LINE,NAME,DESC] = FGETFIRST(FILE)
%
%   Input:
%      FILE   Matlab function (or script)
%
%   Outputs:
%      LINE   First commented line
%      NAME   First LINE word
%      DESC   LINE but NAME (trimmed)
%
%   Example:
%      [line,name,desc] = fgetfirst(which('fgetfirst'))
%
%   MMA 27-9-2005, martinho@fis.ua.pt
%
%   See also MCONTENTS

%   Department of Physics
%   University of Aveiro, Portugal


str  = '';
name = '';
desc = '';
fid = fopen(theFile);
if fid == -1
  return
end
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
  try
    tline = ltrim(tline);
    if tline(1) == '%'
      str = tline;
      break
    end
  end
end
fclose(fid);
try
  str = trim(str(2:end));
  i=find(str==' ');
  i=i(1);
  name = str(1:i-1);
  desc = trim(str(i:end));
end
