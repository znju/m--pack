function  varargout = find_romsfiles(file,type,parse_links)
%FIND_ROMSFILES   Find ROMS filenames
%   From one ROMS output/input file finds other files. The search is
%   done through the NetCDF global attributes of thc original file.
%
%   Syntax:
%     FILES = FIND_ROMSFILES(FILE,TYPE,PL)
%
%   Inputs:
%      FILE   ROMS input/output file
%      TYPE   Type of the file to search, can be:
%             his, rst, avg, flt, sta, frc, ini, all (default)
%      PL     Parse links flag, needed when using symbolic links (def=1)
%
%   Output:
%      FILES   Cell array
%
%   Example:
%      find_romsfiles('stations.nc','grd')
%
%   MMA 12-9-2007, martinho@fis.ua.pt
%
%   See also PLOT_ROMSGRD, ROMS_BORDER

% Department of Physics
% University of Aveiro, Portugal

varargout={};

if nargin < 3
  parse_links=1;
end

if nargin<2
  type='all';
end

if nargin == 0
  [filename, pathname] = uigetfile('*.nc', 'Pick the ROMS file');
  if ~(isequal(filename,0) | isequal(pathname,0))
    file=fullfile(pathname, filename);
  else
    return
  end
end

if parse_links
  file_=parse_symb_link(file);
else
  file_=file;
end
[pathstr,name,ext]=fileparts(file_);
files={};
if ismember(type,{'grid','all'})
  % about grid files, first, check if file is a grid file:
  type=n_fileatt(file,'type');
  if isempty(type)
    type=n_fileatt(file,'title');
  end
  if ~isempty(findstr(lower(type),'grid')) % then, this is a grid file
    files=[files,get_files(file,pathstr)];
  else
    files=[files,get_files(file,'grd_file',pathstr)];
  end
end
if ismember(type,{'his','all'}),   files=[files,get_files(file,'his_file',pathstr)]; end
if ismember(type,{'rst','all'}),   files=[files,get_files(file,'rst_file',pathstr)]; end
if ismember(type,{'avg','all'}),   files=[files,get_files(file,'avg_file',pathstr)]; end
if ismember(type,{'flt','all'}),   files=[files,get_files(file,'flt_file',pathstr)]; end
if ismember(type,{'sta','all'}),   files=[files,get_files(file,'sta_file',pathstr)]; end
if ismember(type,{'frc','all'}),   files=[files,get_files(file,'frc_file',pathstr)]; end
if ismember(type,{'ini','all'}),   files=[files,get_files(file,'ini_file',pathstr)]; end

varargout{1}=files;

function files=get_files(file,attname,pathstr)
files={};
if nargin > 2
  filename=n_fileatt(file,attname);
  if isempty(filename)
    return
  end
else
  filename=file;
end
if exist(filename)~=2
  filename=fullfile(pathstr,filename);
end
n = length(dir([filename,'.*']));
files={filename};
for i=1:n
  files(end+1)={[filename,'.',num2str(n)]};
end


function file=parse_symb_link(file)
[status,res]=system(['ls -l ',file]);
tmp=strfind(res,'->');
if ~isempty(tmp)
  file=res(tmp+3:end);
end

