function ncep_gen(tstart,tend,grid,varargin)
%NCEP_GEN   Generate ROMS bulk fluxes forcing files from NCEP
%   Giving the start time, end time and grid file, this function
%   downloads all required data from the NCEP reanalysis ftp site
%   and creates a ROMS forcing file for bulk fluxes with all the
%   required fields: wind, radiation, cloud, humidity, pressure,
%   precipitation and temperature.
%
%   Syntax:
%      NCEP_GEN(TSTART,TEND,GRID,VARARGIN)
%
%   Inputs:
%      TSTART      Start date string [ <'D-M-Y'> ]
%      TEND        End date string [ <'D-M-Y'> ]
%      GRID        The NetCDF grid filename
%      VARARGIN: (none is required)
%         'pos',   Location around which data will be extracted [ <lon lat>]
%                  default is grid centre
%         'L',     Extracted square of data has side 2*L(1)+1 by 2*L(2)+1,
%                  default is [dlon/4+2 dlat/4 +2]
%         'path',  Where ncep files are, or shall be downloaded
%                  default is 'ncep_<year>_files'
%         'to',    Destination directory for forcing files
%                  default is 'frc_<tstart>_<tend>'
%         'label', Label to forcing files, as wind_label_nc
%                  default is 'frc'
%         'nc',    NetCDF ncgen executable
%                  default is ncgen
%         'fig',   If 1, some data is shown  [ {1} 0 ]
%                  (data is plotted at tindice=1, and region average
%                  time series is also shown)
%   Comments:
%      steps/functions used:
%
%                         NCEP_GEN
%                             |
%             ________________|_______________
%            |                |               |
%      NCEP_SETTINGS     NCEP_GETFILE     NCEP_GENFRC
%                                      _______|______
%                                     |              |
%                                NCEP_GENCDL   NCEP_VAR2GRID
%                                                    |
%                                                NCEP_GETVAR
%                                                    |
%                                                NCEP_ISTART
%
%      other related functions:
%      (but not used by NCEP_GEN) functions:
%      - NCEP_UVCOMP
%
%      if you want you create a single forcing, like wind...,
%      use NCEP_GENFRC instead, however you must provide more input data
%
%   Example:
%      grid   = 'ocean_grd.nc';
%      tstart = '1-Jan-2002';
%      tend   = '1-Feb-2002';
%      nc     = '/usr/local/bin/ncgen';
%      ncep_gen(tstart,tend,grid,'nc',nc);
%
%   MMA 10-2004, martinho@fis.ua.pt
%
%   See also NCEP_SETTINGS, NCEP_GETFILE, NCEP_GENFRC, NCEP_UVCOMP

%   Department of Physics
%   University of Aveiro, Portugal

%   07-02-2005 - Corrected a small mistake

% apply default data:
def_pos   = 0;
def_L     = 0;
def_path  = 0;
def_label = 0;
def_nc    = 0;
def_to    = 0;
def_fig   = 0;

vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'pos')
    pos = vin{i+1};
    def_pos = 1;
  end
  if isequal(vin{i},'L')
    L = vin{i+1};
    def_L = 1;
  end
  if isequal(vin{i},'path')
    tmp_dir = vin{i+1};
    def_path = 1;
  end
  if isequal(vin{i},'to')
    dest_dir = vin{i+1};
    def_to = 1;
  end
  if isequal(vin{i},'label')
    label = vin{i+1};
    def_label = 1;
  end
  if isequal(vin{i},'nc')
    NC = vin{i+1};
    def_nc = 1;
  end
  if isequal(vin{i},'fig')
    fig = vin{i+1};
    def_fig = 1;
  end
end


if ~def_pos
  % use central position as pos:
  nc = netcdf(grid);
    pos(1) = mean(mean(nc{'lon_rho'}(:)));
    pos(2) = mean(mean(nc{'lat_rho'}(:)));

    if ~def_L
      lon_max = max(max(nc{'lon_rho'}(:)));
      lon_min = min(min(nc{'lon_rho'}(:)));
      dlon = lon_max - lon_min;

      lat_max = max(max(nc{'lat_rho'}(:)));
      lat_min = min(min(nc{'lat_rho'}(:)));
      dlat = lat_max - lat_min;
    end

  nc = close(nc);
  disp([' ## using pos = ',num2str(pos)]);
end

if ~def_L
  % ncep resolution ~2 deg, so:
  L(1) = ceil(dlon/4 +2);
  L(2) = ceil(dlat/4 +2);
  disp([' ## using L = ',num2str(L)]);
end

if ~def_label, label    = 'frc';                    end
if ~def_nc,    NC       = 'ncgen';                  end
if ~def_to,    dest_dir = ['frc_',tstart,'_',tend]; end
if ~def_fig,   fig      = 1;                        end

% --------------------------------------------------------------------

% search for files in path:
% get year:
year1  = explode(tstart,'-',3);
year2  = explode(tend,'-',3);
if ~isequal(year1,year2)
  disp('# start year and end year must be equal...')
 return
else
  year=year1;
end

% set tmp_dir:
if ~def_path, tmp_dir  = ['ncep_',num2str(year),'_files']; end

% files required:
files=[];
% wind:
ncep = ncep_settings(year,'wind');
files{end+1} = ncep(1).file;
files{end+1} = ncep(2).file;
% cloud
ncep = ncep_settings(year,'cloud');
files{end+1} = ncep.file;
% radiation
ncep = ncep_settings(year,'radiation');
files{end+1} = ncep(1).file;
files{end+1} = ncep(2).file;
files{end+1} = ncep(3).file;
files{end+1} = ncep(4).file;
% humidity
ncep = ncep_settings(year,'humidity');
files{end+1} = ncep.file;
% pressure
ncep = ncep_settings(year,'pressure');
files{end+1} = ncep.file;
% precipitation
ncep = ncep_settings(year,'precipitation');
files{end+1} = ncep.file;
% temperature
ncep = ncep_settings(year,'temperature');
files{end+1} = ncep.file;

for i=1:length(files)
  fprintf(1,'  » required :  %s\n',files{i})
end
fprintf(1,'\n');

% search files in tmp_dir:
d=dir(tmp_dir);
is =zeros(size(files));
for i=1:length(d)
  f=d(i).name;
  tmp = ismember(files,f);
  is=is | tmp;
end

for i=1:length(is)
  if ~is(i)
    fprintf(1,'  » not found :  %s\n',files{i})
  else
    fprintf(1,'  »     found :  %s\n',files{i})
  end
end

% create tmp_dir if it do not exists:
if ~isdir(tmp_dir)
  [status,msg] = mkdir(tmp_dir);
  if status ~=1
    disp(msg);
  end
end

% download  required  files and move to tmp_dir:
datafile=[];
for i=1:length(is)
  if ~is(i)
    fprintf(1,'  » attempt to download :  %s\n',files{i})
    type=explode(files{i},'.',1); type = type{1};
    ncep_getfile(year,type);
    %[status,msg] = copyfile(files{i},tmp_dir);
    %if status == 1
    %  evalc(['delete ',files{i}],'');
    %end
    eval(['!mv ',files{i},' ',tmp_dir]);
  end
  datafile{end+1} = [tmp_dir,'/',files{i}];
end

for i=1:length(datafile)
  fprintf(1,'  » datafile :  %s\n',datafile{i})
end


% create tmp_dir if it do not exists:
if ~isdir(dest_dir)
  [status,msg] = mkdir(dest_dir);
  if status ~=1
    disp(msg);
  end
end

%------------------------------------------------------------------
fprintf(1,'\n');
nc = NC;
frc_files = [];

% wind
type='wind';
file=[];
file{1}=datafile{1};
file{2}=datafile{2};
[fcdl,fnc] = ncep_genfrc(type,grid,file,tstart,tend,pos,L,label,nc,fig);
eval(['!rm ',fcdl]);
eval(['!mv ',fnc,' ',dest_dir]);
frc_files{end+1} = fnc;

% cloud
type='cloud';
file=[];
file=datafile{3};
[fcdl,fnc] = ncep_genfrc(type,grid,file,tstart,tend,pos,L,label,nc,fig);
eval(['!rm ',fcdl]);
eval(['!mv ',fnc,' ',dest_dir]);
frc_files{end+1} = fnc;

% radiation
type='radiation';
file=[];
file{1}=datafile{4};
file{2}=datafile{5};
file{3}=datafile{6};
file{4}=datafile{7};
[fcdl,fnc] = ncep_genfrc(type,grid,file,tstart,tend,pos,L,label,nc,fig);
eval(['!rm ',fcdl]);
eval(['!mv ',fnc,' ',dest_dir]);
frc_files{end+1} = fnc;

% humidity
type='humidity';
file=[];
file=datafile{8};
LWarn=L;
posWarn=[-12 41];
[fcdl,fnc] = ncep_genfrc(type,grid,file,tstart,tend,posWarn,LWarn,label,nc,fig);
eval(['!rm ',fcdl]);
eval(['!mv ',fnc,' ',dest_dir]);
frc_files{end+1} = fnc;

% pressure
type='pressure';
file=[];
file=datafile{9};
[fcdl,fnc] = ncep_genfrc(type,grid,file,tstart,tend,pos,L,label,nc,fig);
eval(['!rm ',fcdl]);
eval(['!mv ',fnc,' ',dest_dir]);
frc_files{end+1} = fnc;

% precipitation
type='precipitation';
file=[];
file=datafile{10};
[fcdl,fnc] = ncep_genfrc(type,grid,file,tstart,tend,pos,L,label,nc,fig);
eval(['!rm ',fcdl]);
eval(['!mv ',fnc,' ',dest_dir]);
frc_files{end+1} = fnc;

% temperature
type='temperature';
file=[];
file=datafile{11};
[fcdl,fnc] = ncep_genfrc(type,grid,file,tstart,tend,pos,L,label,nc,fig);
eval(['!rm ',fcdl]);
eval(['!mv ',fnc,' ',dest_dir]);
frc_files{end+1} = fnc;


% show all done:
fprintf(1,'\n');
fprintf(1,'==========================================================================\n');
fprintf(1,'## Done, files created:\n');
for i=1:length(frc_files)
  f = [dest_dir,'/',frc_files{i}];
  fprintf(1,'    -->  %s\n',f);
end

fprintf(1,'\n');
fprintf(1,'==========================================================================\n');
fprintf(1,'## Files contents:\n');

for i=1:length(frc_files)
  f = [dest_dir,'/',frc_files{i}];
  fprintf(1,'    -->  %s\n',f);
  show(f,[1 1])
  fprintf(1,'----------------------------------------------------------------------\n');
end
