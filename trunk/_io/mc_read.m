function out = mc_read(file,nskip)
%MC_READ   Read multi column text file
%   Reads text files with data in columns of arbitrary length but
%   with left alignment.
%
%   Syntax:
%      OUT = MC_READ(FILE,NSKIP)
%
%   Input:
%      FILE   Text file with multi column data
%      NSKIP  Number of header lines to skip [0]
%
%   Output:
%      OUT   Cell array with the columns
%
%   Comment:
%      Left alignment is a requirement of the first column. See the
%      example.
%
%   Example:
%      % file has the data:
%      3.0     8.0     10.0
%      5.0     2.0     11.0
%      21.0            12.0
%      27.0
%      out = mc_read(file) % will produce out{1}=col_1, out{2}=col_2
%                          % and out{3}=col_3
%
%   MMA 1-12-2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   17-06-2008 - Added argument NSKIP

if nargin < 2
  nskip=0
end

fprintf(1,'## reading data from file %s\n',file);

fid=fopen(file);

if nskip
  for i=1:nskip, fgetl(fid); end
end

% read data:
cont=0;
while 1
  cont=cont+1;
  tline = fgetl(fid);
  if isequal(tline,-1)
    last  = 1;
    break
  end

  tmp = str2num(tline);
  % ok, now I must suppose data is aligned, to detect to which column data belongs!!
  if cont == 1
    numCols = length(tmp);
    for i = 1:numCols
      pos_tmp = findstr(tline,num2str(tmp(i)));
      pos(i)  = pos_tmp(1); % data may be repeated
    end
    pos(end+1) = length(tline)+1;
  end
  col = [];
  for i = 1:numCols
    if  length(tline) +1 < pos(end), tline((end+1) : pos(end)) = ' '; end
    eval('str = tline(pos(i) : pos(i+1)-1);','str=[];');
    if ~isempty(str)
      tmp = str2num(str);
      if ~isempty(tmp),  eval(['col_',num2str(i),'(cont) = tmp(1);']); end
    end
  end
end

fprintf(1,'## done, found %g columns\n',numCols);
for i = 1:numCols
  eval(['out{i} = col_',num2str(i),';']);
  eval(['len = length(col_',num2str(i),');']);
  fprintf(1,'  --> length col_%g = %g\n',i,len);
end
fclose(fid);
