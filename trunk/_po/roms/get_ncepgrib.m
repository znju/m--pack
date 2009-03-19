function get_ncepgrib(year1,month1,year2,month2,url)
%GET_NCEPGRIB   Download NCEP grib files form NOMAD
%   Downloads PGB and FLX files using wget and cheks the local files
%   with cksum. The files will be placed in a folder
%   grib_data_y1_m1,y2_m2, where yi,mi are the year, mounth inputs.
%
%   Syntax:
%      GET_NCEPGRIB(YEAR1,MONTH1,YEAR2,MONTH2,URL)
%
%   Inputs:
%      YEAR1,MONTH1   Initial year and month
%      YEAR2,MONTH2   Final year and month
%      URL   Files location, default is:
%            http://nomad3.ncep.noaa.gov/pub/reanalysis-2/6hr/
%
%   MMA 26-6-2006, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

global site_pl site_npl name_pl name_npl command
global files_pl files_npl files_pl__cksum files_npl_cksum

if nargin < 5
  site     = 'http://nomad3.ncep.noaa.gov/pub/reanalysis-2/6hr/';
end
site_pl  = [site,'pgb/'];
site_npl = [site,'flx/'];

name_pl  = 'pgb.';
name_npl = 'flx.ft06.';

command  = 'wget --tries=100 ';

% new folder to create:
m1=num2str(month1); if length(m1)==1, m1=['0',m1]; end
m2=num2str(month2); if length(m2)==1, m2=['0',m2]; end
folder=['grib_data_',num2str(year1),'_',m1,'_',num2str(year2),'_',m2];
if exist(folder)~=7
  [succ,msg]=mkdir(folder);
  if msg~=''
    disp(msg)
    disp([mfilename,'  stopped !!'])
  end
end

files_pl        = {};
files_npl       = {};
files_pl__cksum = {};
files_npl_cksum = {};

if year2 > year1
  for m=month1:12
    tasklist(year1,m)
  end

  for m=1:month2
    tasklist(year2,m)
  end

  for y=year1+1:year2-1
    for m=1:12
      tasklist(y,m)
    end
  end
else
  for m=month1:month2
    tasklist(year1,m)
  end
end

nfiles = length(files_pl);
% show task:
disp(' ## tasks: ');
for i=1:nfiles
  fprintf(1,'  - will wget %s\n',files_pl{i})
end
for i=1:nfiles
  fprintf(1,'  - will wget %s\n',files_npl{i})
end
%for i=1:length(files_pl__cksum)
%  fprintf(1,'  - will wget %s\n',files_pl__cksum{i})
%end
%for i=1:length(files_npl_cksum)
%  fprintf(1,'  - will wget %s\n',files_npl_cksum{i})
%end

fprintf(1,'\n :: press Ctrl C to stop or any key to continue\n\n');
try
  pause
catch
  return
end

curr_dir=cd;
cd(folder);
% get the files:
fprintf(1,'\n\n ## wget: ');
for i=1:nfiles
  fname1 = files_pl{i};
  fname2 = files_npl{i};
  fname3 = files_pl__cksum{i};
  fname4 = files_npl_cksum{i};

  fprintf(1,'\n -- downloading file = %s \n',fname1); system([command,fname1]);
  fprintf(1,'\n -- downloading file = %s \n',fname2); system([command,fname2]);
  fprintf(1,'\n -- downloading file = %s \n',fname3); system([command,fname3]);
  fprintf(1,'\n -- downloading file = %s \n',fname4); system([command,fname4]);
end

% cksum:
fprintf(1,'\n\n ## cksum: ');
for i=1:nfiles
  fname1 = files_pl{i};        fname1=fname1(length(site_pl)+1:end);
  fname2 = files_pl__cksum{i}; fname2=fname2(length(site_pl)+1:end);
  cksum(fname1,fname2);
end
for i=1:nfiles
  fname1 = files_npl{i};       fname1=fname1(length(site_npl)+1:end);
  fname2 = files_npl_cksum{i}; fname2=fname2(length(site_npl)+1:end);
  cksum(fname1,fname2);
end

cd(curr_dir);


function task = tasklist(y,m)
global site_pl site_npl name_pl name_npl command
global files_pl files_npl files_pl__cksum files_npl_cksum
month=num2str(m);
year=num2str(y);
if length(month)==1, month=['0',month]; end

fname_pl  = [site_pl, name_pl, year,month];
fname_npl = [site_npl,name_npl,year,month];
fname_pl__cksum = [fname_pl,'.cksum'];
fname_npl_cksum = [fname_npl,'.cksum'];

files_pl(end+1)        = {fname_pl};
files_npl(end+1)       = {fname_npl};
files_pl__cksum(end+1) = {fname_pl__cksum};
files_npl_cksum(end+1) = {fname_npl_cksum};


function cksum(localFile,sumFile)
[status,sumLocal]=system(['cksum ',localFile]);
sumFile = fileread(sumFile);
if sumLocal==sumFile
  res='OK';
else
  res='WRONG'
end
fprintf(1,'\n -- cksum of file = %s is %s\n',localFile,res);
