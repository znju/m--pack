function selfpack(theDir,theOutput,theTitle,theDescription,installNotes)
%SELFPACK   Creation of self-extract packages
%   Creates a single matlab self-extract p file with all the contents
%   of a selected folder.
%   When executed, the output file will recreate the package inside a
%   folder with the same name of the main package folder. For instance
%   if the selected folder is "/home/user/package", the creted folder
%   during extraction will be "package".
%
%   Suntax:
%      SELFPACK(TARGETDIR,OUTPUT,TITLE,DESCRIPTION,INSTALLNOTES)
%
%   Inputs:
%      TARGETDIR      Folder to be packed
%      OUTPUT         Ouput file name [ 'self' ]
%      TITLE          First line in the help of the output file
%                     [ '<main folder> matlab toolbox' ]
%      DESCRIPTION    Information to be added in the help of the output
%                     file, cell array [ <none> ]
%      INSTALLNOTES   Installation notes to be shown at the end of the
%                     extraction, cell array [ <none> ]
%
%   Example:
%      theFolder      = '../../toolbox';
%      theOutput      = 'toolbox_install';
%      theTitle       = 'XPTO analysis toolbox';
%      theDescription = {'lots of files...','to do whatever...'};
%      installNotes   = {'just install... and ';'if you have doubts';
%      'write me to mail@mail.m'};
%      selfpack(theFolder,theOutput,theTitle,theDescription,installNotes);
%
%   MMA 07-09-2005, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

useTextAsBin = 1;
createPfile  = 1;
pRemoveMFile = 0;

if nargin < 1
  disp(':: you must input a folder name')
  return
elseif ~exist(theDir,'dir')
  disp(':: the selected folder do not exist')
  return
end
% deal with filesep:
theDir = strrep(theDir,'/',filesep);
theDir = strrep(theDir,'\',filesep);
theDir = strrep(theDir,':',filesep);
theDir = realpath(theDir);

% find the main folder (remove extra path):
lastDir = basename(theDir);
thePath = dirname(theDir);

if nargin < 2
  theOutput = 'self.m';
else
  theOutput = [theOutput,'.m'];
end

if nargin < 3
  theTitle   = [lastDir,' matlab toolbox'];
end

if nargin < 4
  theDescription = {};
end

if nargin < 5
  installNotes = {};
end

% check the output file:
mFile = theOutput;
pFile = [theOutput(1:end-1),'p'];
if createPfile
  finalFile = pFile;
else
  finalFile = mFile;
end

if exist([pwd,filesep,finalFile],'file') | exist([pwd,filesep,mFile],'file')
  if exist([pwd,filesep,mFile],'file') & createPfile
    fprintf(1,'\n :: Warning: the file %s will be lost !!\n',mFile);
  end
  fprintf(1,'\n :: Warning: the file %s already exist\n',finalFile);
  while 1
    ans = input('\n    wanna continue ([y],n) ? ','s');
    if isempty(ans) | isequal(ans,'y')
      break
    elseif isequal(ans,'n')
      fprintf(1,'\n opperation canceled\n\n');
      return
    end
  end
  fprintf(1,'\n')
end

% get all available subdirs and number of files:
dirs   = get_dirs(theDir);
nfiles = get_nfiles(dirs);

if nfiles > 0
  fprintf(1,'\n%s\n',' ---------------------------------------------------');
  fprintf(1,'%s\n',' self extractor generator matlab utility');
  fprintf(1,' %s\n',theTitle);
  for i=1:length(theDescription)
    fprintf(1,' %s\n',theDescription{i});
  end
  fprintf(1,'   :: found %d folder\n',length(dirs));
  fprintf(1,'   :: found %d files\n',nfiles);
else
  disp(':: there are no files to process')
  return
end

% add first lines:
process_init(theOutput,theTitle,theDescription);

% add folders:
process_folders(dirs,theOutput,theTitle,theDescription,thePath,lastDir);

% add files:
[numok,numbad] = process_files(dirs,theOutput,useTextAsBin,thePath);

% add final lines:
process_final(theOutput,installNotes);

% add functions:
process_funcs(theOutput);

% create p file and delete the m file:

if createPfile
  pcode([pwd,filesep,theOutput]);
  if pRemoveMFile
    delete([pwd,filesep,theOutput]);
  end
end

% show size of the output file:
d  = dir(finalFile);
nb = d.bytes;
fprintf(1,'\n   :: done --  created file %s (%d bytes)\n',finalFile,nb);
fprintf(1,  '   :: number of files added     = %d\n',numok);
fprintf(1,  '   :: number of files NOT added = %d\n',numbad);
fprintf(1,'\n   :: the installation folder is %s\n',lastDir);
fprintf(1,'%s\n\n',' ---------------------------------------------------');

% --------------------------------------------------------------------

function process_init(output,title,description);
fid=fopen(output,'w');

% function line:
fprintf(fid,'function %s\n',output(1:end-2));

% first line:
fprintf(fid,'%%%s',upper(output(1:end-2)));
fprintf(fid,'%s %s\n','   Installer of the',title);

% description:
for i=1:length(description)
  fprintf(fid,'%%   %s\n',description{i});
end

% more info:
fprintf(fid,'%%\n%s\n','%   This is a self extraction file which will create the toolbox');
fprintf(fid,'\n');
fprintf(fid,'%%   Ceated in %s\n',datestr(now));
fprintf(fid,'%%   by the utility %s from Martinho Marta Almeida, martinho@fis.ua.pt\n',mfilename);
fprintf(fid,'\n');
fclose(fid);

% --------------------------------------------------------------------

function withErrors = process_folders(dirs,output,title,description,thePath,lastDir)
fid = fopen(output,'a');

%%% find the main folder (remove extra path):
%%[p,last] = lastdir(dirs{1});

for i=1:length(dirs)
  % first I need to remove the extra path so that only the last dir remains:
  dirs{i} = strrep(dirs{i},thePath,'');
  dirs{i}=dirs{i}(2:end);

  fprintf(fid,'%s%d%s%s%s\n','dirs(',i,') = {[''',dirs{i},''']};');
end

fprintf(fid,'\n');
fprintf(fid,'%s\n','theMainDir = dirs{1};');

% show title and descripton:
fprintf(fid,'%s\n','fprintf(1,''\n ---------------------------------------------------\n'');');
fprintf(fid,'%s\n','fprintf(1,'' Installation of the matlab toolbox:\n'');');
fprintf(fid,'%s\n', ['fprintf(1,'' %s\n'',''',title,''');']);
for i=1:length(description)
  fprintf(fid,'%s\n', ['fprintf(1,'' %s\n'',''',description{i},''');']);
end

% ask if wanna continue:
fprintf(fid,'%s\n', 'fprintf(1,''\n The files will be written in the folder %s\n'',theMainDir);');
fprintf(fid,'%s\n', 'fprintf(1,''\n :: press Ctrl C to stop or any key to continue\n\n'');');
fprintf(fid,'%s\n', 'try');
fprintf(fid,'%s\n', '  pause');
fprintf(fid,'%s\n', 'catch');
fprintf(fid,'%s\n', '  fprintf(1,'' installation canceled\n\n'');');
fprintf(fid,'%s\n', '  return');
fprintf(fid,'%s\n', 'end');

% check if first folder already exists:
fprintf(fid,'\n');
fprintf(fid,'%s\n', 'if exist([pwd,filesep,theMainDir],''dir'')');
fprintf(fid,'%s\n', '  fprintf(1,''\n :: Warning: the installation folder %s already exist\n'',theMainDir);');
fprintf(fid,'%s\n', '  while 1');
fprintf(fid,'%s\n', '    ans = input(''\n    wanna continue ([y],n) ? '',''s'');');
fprintf(fid,'%s\n', '    if isempty(ans) | isequal(ans,''y'')');
fprintf(fid,'%s\n', '      break');
fprintf(fid,'%s\n', '    elseif isequal(ans,''n'')');
fprintf(fid,'%s\n', '      fprintf(1,''\n installation canceled\n\n'');');
fprintf(fid,'%s\n', '      return');
fprintf(fid,'%s\n', '    end');
fprintf(fid,'%s\n', '  end');
fprintf(fid,'%s\n', '  fprintf(1,''\n'')');
fprintf(fid,'%s\n', 'end');

% create all folders:
fprintf(fid,'\n');
fprintf(fid,'%s\n','withErrors = 0;');
fprintf(fid,'%s\n','for i=1:length(dirs)');
fprintf(fid,'%s\n','  if ~exist([pwd,filesep,dirs{i}],''dir'')');
fprintf(fid,'%s\n','    fprintf(1,''   creating folder %s'',dirs{i});');
fprintf(fid,'%s\n','    try');
fprintf(fid,'%s\n','      mkdir(dirs{i});');
fprintf(fid,'%s\n','      fprintf(1,''\n'');');
fprintf(fid,'%s\n','    catch');
fprintf(fid,'%s\n','      fprintf(1,'' -- ERROR\n'')');
fprintf(fid,'%s\n','      withErrors = 1;');
fprintf(fid,'%s\n','    end');
fprintf(fid,'%s\n','  else');
fprintf(fid,'%s\n','    fprintf(1,''   the folder %s already exist\n'',dirs{i});');
fprintf(fid,'%s\n','  end');
fprintf(fid,'%s\n','end');
fclose(fid);

% --------------------------------------------------------------------

function [numFilesOK,numFilesBAD] = process_files(dirs,output,useTextAsBin,thePath)
fid = fopen(output,'a');

% find the main folder (remove extra path):
subDirs = dirs;
for nd=1:length(dirs)
  subDirs{nd}(1:length(thePath)+1) = '';
end

numFilesOK  = 0;
numFilesBAD = 0;
for i=1:length(dirs)
  str=['currentDir=[''',dirs{i},'''];'];
  eval(str);
  str=['currentShownDir=[''',subDirs{i},'''];'];
  eval(str);
  fprintf(1,'   entering in folder %s\n',currentShownDir);
  d=dir(currentDir);
  isd     = zeros(size(d));
  nisnull = zeros(size(d));
  for n=1:length(d)
    isd(n)     = d(n).isdir;  % is dir
    nisnull(n) = d(n).bytes;  % not is null
  end
  % the nisnull condition is needed when dirs are chmod -x
  files   = {d(~isd&nisnull).name};
  folders = {d(~~isd).name};

  if isempty(files) & length(folders) == 2
    fprintf(1,'   the folder %s IS EMPTY\n',currentDir);
  end

  for n=1:length(files)
    currentFile = files{n};
    fprintf(1,'        processing file %s\n',currentFile);

    theFile = [currentDir,filesep,currentFile];

    % check file type:
    [isbin,type] = isbinary(theFile);

    if ~isempty(isbin)
      f=fopen(theFile);
      c=fread(f);
      theRealSize=prod(size((c)));
      if ~isbin & ~useTextAsBin
        c=char(c');
        c=strrep(c,char(13),'');
        c=strrep(c,'''','''''');
        if c(end)==10, c=c(1:end-1); end
        c=strrep(c,char(10),['\n'');' 10 'fprintf(fid,''%s\n'',''']);
        c=['fprintf(fid,''%s\n'',''',c,''');'];
        theType = 'text';
      else
        c=sprintf('%02x\n',c);
        c(3:3:end)=''; 
        nChar=70;
        m=floor(length(c)/nChar);
        tmp='';
        tmp=reshape(c(1:m*nChar),nChar,m);
        tmp=tmp';
        if mod(length(c),nChar)
          tmp=strvcat(tmp,c(m*nChar+1:end));
        end
        tmp(:,2:end+1)=tmp;
        tmp(:,1)='''';
        tmp(:,end+1) = '''';
        tmp(:,end+1) = ',';
        tmp(:,end+1) = 10;
        tmp(1,end)=10;
        c=tmp;
        theType = 'binary';
      end
      theSize=prod(size((c)));
      if ~isbin & ~useTextAsBin
        fprintf(fid,'\n');
        fprintf(fid,'%s\n',['file = [''',subDirs{i},''',filesep,''',currentFile,'''];']);
        fprintf(fid,'%s\n',['[withErrors,fid] = ini_file(file,''',type,''');']);
        fwrite(fid,c);
        fprintf(fid,'\n');
        fprintf(fid,'%s\n','fclose(fid);');
      else
        fprintf(fid,'\n');
        fprintf(fid,'%s\n',['file = [''',subDirs{i},''',filesep,''',currentFile,'''];']);
        fprintf(fid,'%s\n',['[withErrors,fid] = ini_file(file,''',type,''');']);
        fprintf(fid,'%s\n','hex = [');
        fprintf(fid,'%s',c');
        fprintf(fid,'%s\n','];');
        fprintf(fid,'%s\n','finnish_file(fid,hex);');
      end
      f=fclose(f);

    numFilesOK = numFilesOK + 1;
    else
      numFilesBAD = numFilesBAD + 1;
      fprintf(1,'        UNABLE to processing file %s\n',currentFile);
    end % ~isempty(isbin)

  end
end
fclose(fid);

% --------------------------------------------------------------------

function process_final(output,installNotes)
fid = fopen(output,'a');

fprintf(fid,'\n');

% show install notes:
if ~isempty(installNotes)
  fprintf(fid,'%s\n', 'fprintf(1,''\n'');');
end
for i=1:length(installNotes)
  fprintf(fid,'%s\n', ['fprintf(1,'' %s\n'',''',installNotes{i},''');']);
end

fprintf(fid,'\n');

% show installation finnished:
fprintf(fid,'%s\n', 'if withErrors');
fprintf(fid,'%s\n', '  fprintf(1,''\n installation finnished WITH ERRORS\n\n'')');
fprintf(fid,'%s\n', 'else');
fprintf(fid,'%s\n', '  fprintf(1,''\n installation finnished\n'')');
fprintf(fid,'%s\n','   fprintf(1,'' ---------------------------------------------------\n\n'');');
fprintf(fid,'%s\n', 'end');

fclose(fid);

% --------------------------------------------------------------------

function process_funcs(output)
fid = fopen(output,'a');

fprintf(fid,'\n');

fprintf(fid,'%s\n', 'function bin=hex_to_bin(s)');
fprintf(fid,'%s\n', 'c = zeros(1, 256);');
fprintf(fid,'%s\n', 'c(abs(''0''):abs(''9'')) = 0:9;');
fprintf(fid,'%s\n', 'c(abs(''a''):abs(''f'')) = 10:15;');
fprintf(fid,'%s\n', 'hex = double(s);');
fprintf(fid,'%s\n', 'bin = 16*c(hex(1:2:end)) + c(hex(2:2:end));');

fprintf(fid,'\n');

fprintf(fid,'%s\n', 'function [withErrors,fid] = ini_file(file,type)');
fprintf(fid,'%s\n', 'fid=fopen(file,''w'');');
fprintf(fid,'%s\n','if fid == -1');
fprintf(fid,'%s\n','  errstr = '' -- ERROR'';');
fprintf(fid,'%s\n','  withErrors = 1;');
fprintf(fid,'%s\n','else');
fprintf(fid,'%s\n','  errstr='''';');
fprintf(fid,'%s\n','  withErrors = 0;');
fprintf(fid,'%s\n','end');
fprintf(fid,'%s\n','if isempty(type)');
fprintf(fid,'%s\n',['  fprintf(1,''       adding file %s%s\n'',file,errstr)']);
fprintf(fid,'%s\n','else');
fprintf(fid,'%s\n',['  fprintf(1,''       adding file %s (%s)%s\n'',file,type,errstr)']);
fprintf(fid,'%s\n','end');

fprintf(fid,'\n');

fprintf(fid,'%s\n', 'function finnish_file(fid,hex)');
fprintf(fid,'%s\n','if fid~=-1');
fprintf(fid,'%s\n','  hex=reshape(hex'',1,prod(size(hex)));');
fprintf(fid,'%s\n','  hex=strrep(hex,'' '','''');');
fprintf(fid,'%s\n','  bin=hex_to_bin(hex);');
fprintf(fid,'%s\n','  fwrite(fid,bin);');
fprintf(fid,'%s\n','  fclose(fid);');
fprintf(fid,'%s\n','end');

fclose(fid);

% --------------------------------------------------------------------

function [dirs,n]=get_dirs(current,dirs)
if nargin < 2, dirs = {current}; end
n=length(dirs);
str = ['d=dir([''',current,''']);'];
eval(str);
for i=1:length(d)
  cdir=d(i);
  if cdir.isdir==1 & ~isequal(cdir.name,'..') & ~isequal(cdir.name,'.')
    n=n+1;
    dirs{n}=[current,''',filesep,''',cdir.name];
    [dirs,n]=get_dirs(dirs{n},dirs);
  end
end

% --------------------------------------------------------------------

function nfiles=get_nfiles(dirname)
nfiles = 0;
for i=1:length(dirname)
  str=['d=dir([''',dirname{i},''']);'];
  eval(str);
  isd     = zeros(size(d));
  nisnull = zeros(size(d));
  for n=1:length(d)
    isd(n)     = d(n).isdir;  % is dir
    nisnull(n) = d(n).bytes;  % not is null
  end
  % the nisnull condition is needed when dirs are chmod -x
  files = {d(~isd&nisnull).name};
  nfiles = length(files) + nfiles;
end

% --------------------------------------------------------------------

function [isbin,type]=isbinary(file)
isbin=0;
type='';
fid=fopen(file);
if fid~=-1
  c=fread(fid,1000);
  if any(c==0), isbin = 1; end
  fclose(fid);
  if isbin
    type='binary';
  else
    type='text';
  end
else
  isbin=[];
  type='';
end

% --------------------------------------------------------------------

function output = basename(theFile)
d = realpath(theFile);
[path,name,ext]=fileparts(d);
output = [name,ext];

function output = dirname(theFile)
d = realpath(theFile);
[path,name,ext]=fileparts(d);
output = path;

function output = realpath(thePath)
output = [];
isfile = 0;
if exist(thePath,'file') == 2 & isempty(which(thePath))
  [path,name,ext]=fileparts(thePath);
  thePath =  path;
  isfile = 1;
end
current = cd;
if exist(thePath,'dir') == 7 & ~isempty(dir(thePath))
  cd(thePath);
  output = cd;
  cd(current);
  if isempty(output)
    if isunix, new = filesep; end
    if ispc,   new='C:\';     end
  end
end
if isfile
  output = [output,filesep,name,ext];
end
