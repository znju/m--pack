function lines=readfile(file,isURL)
%READFILE   Read file to cell array
%
%   Syntax:
%      LINES = READFILE(FILE,ISURL
%
%   Inputs:
%      FILE
%      ISURL   Is URL flag; is so UNIX wget is used to download the
%              file, by default is false except if FILE starts with
%              'http://'
%
%   Output:
%      LINES   Cell array with the lines of FILE, where each line
%              ends with the newline character
%
%   Examples:
%      % read some local file:
%      lines = readfile([matlabroot,'/bin/mexopts.sh']);
%
%      % read from web:
%      lines = readfile('http://www.gnu.org/licenses/gpl.txt');
%
%   MMA 28-3-2007, martinho@fis.ua.pt
%
%   See also JOIN_LIST, SPLIT_LIST

% Department of Physics
% University of Aveiro, Portugal

lines=[];

if nargin <2
  isURL=0;
end

if findstr('http://',file)==1
  isURL=1;
end

if isURL
  [status,msg]=system('wget');
  if status~=1 % the status is 1 in this case!
    disp([':: ',mfilename,' requires wget and it was not found!!'])
    return
  else
    tmp=tempname;
    [status,msg]=system(['wget -nv ',file,' -O ',tmp]);
    if status==0
      file=tmp;
    else
       disp([':: ERROR using ',mfilename,' :'])
      disp(msg);
      return
    end
  end
end

fid=fopen(file);
lines={};
while 1
  line = fgetl(fid);
  if ~ischar(line), break, end
  lines{end+1}=line;
end
fclose(fid);

if isURL
  delete(tmp)
end
