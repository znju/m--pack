function mcontents(theDir,varargin)
%MCONTENTS   Make folder Contents file
%   Creates files Contents.m in a desired folder and subfolders.
%   A file .description must be present inside folders so that the
%   Contents.m can be created. In the second line may be a flag not
%   to create Contents.m (0). By default they are created.
%
%   Syntax:
%      MCONTENTS(FOLDER,SUB,OUT)
%
%   Inputs:
%      FOLDER   Start folder, all the subfolders will also be used
%      VARARGIN:
%         sub,  include subfoldres flag, default=1
%         out, where contents will be witten, be default one file per
%              folder is created
%         ask, by default questions may appear
%
%   MMA 27-9-2005, martinho@fis.ua.pt
%
%   See also FGETFIRST, LIST_FILES, LIST_FOLDERS, FILETYPE

%   18-06-2007 - Corrected fprintf format, and added SUB
%   25-07-2008 - Deal with .description file and added varagins

%   Department of Physics
%   University of Aveiro, Portugal

ask   = 1;
fcont = 0;
sub   = 1;
vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'ask'),   ask   = vin{i+1};
  elseif isequal(vin{i},'out'),   fcont = vin{i+1};
  elseif isequal(vin{i},'sub'),   sub   = vin{i+1};
  end
end

if sub
  dirs = list_folders(theDir);
else
  dirs={theDir};
end
skipSub=0;
prevDir='';
clog={};
for i=1:length(dirs)
  if skipSub & strmatch(prevDir,dirs{i})
    fprintf(1,' >> skipping %s\n',dirs{i});
    continue
  end
  prevDir=dirs{i};

  if i>1 & ask
    a=input([' - Process subfolder ',dirs{i},'? ([y],n) '],'s');
    if ~(isequal(a,'y') | isempty(a))
      continue
    end
  elseif ~ask
    fprintf(1,' - Processing subfolder %s\n',dirs{i});
  end

  description=[dirs{i} filesep '.description'];
  if exist(description)==2
    descr=readfile(description);
    desc=descr{1};
    if length(descr)>=2
      inc=str2num(descr{2});
      fprintf(1,'   > %s --> inc = %d\n',desc,inc);
      if ~inc
        fprintf(1,'   < not to include\n');
        skipSub=1;
        continue;
      end
    else
      fprintf(1,'   > %s\n',desc);
    end
  else
    fprintf(1,'   < no description file found\n');
    skipSub=1;
    continue;
  end
  skipSub=0;

  files_m   = list_files(dirs{i},'m');
  files_all = list_files(dirs{i});
  % find length of filenames, to create a proper format for fprintf:
  len=0;
  for n=1:length(files_all)
    [p,fname,fext] = fileparts(files_all{n});
    len=max(len,length(fname));
  end
  len=max(len,11);
  format=['%s    %-',num2str(len),'s - %s\n'];

  if ~isempty(files_all)
    if ~fcont
      cfile = [dirs{i},filesep,'Contents.m'];
      if exist(cfile,'file') == 2 & ask
        a=input([' - ',cfile,' already exists. Overwrite ? ([y],n) '],'s');
        if ~(isequal(a,'y') | isempty(a))
          disp([' - ',cfile,' not changed'])
          continue
        end
      end
      fid = fopen(cfile,'w');
      clog{end+1}=cfile;

    else
      cfile=fcont;
      fid = fopen(fcont,'a');
    end

    if isequal(fid,-1)
      fprintf(1,'    :: ERROR : unable to overwrite file : %s\n',cfile);
      return
    end

    try
      base_name = basename(dirs{i});
    catch
      base_name = dirs{i};
    end
    fprintf(fid,'%%  %s, %s\n',base_name,desc);

    % files .m:
    files_m_={};
    for j=1:length(files_m)
      % remove Contents file:
      [p,fname,fext] = fileparts(files_m{j});
      if ~isequal(fname,'Contents')
        files_m_{end+1}=files_m{j};
      end
    end
    if ~isempty(files_m_)
      fprintf(fid,'%s\n','%');
      for j=1:length(files_m_)
        [p,fname,fext] = fileparts(files_m_{j});
        fprintf(1,'    :: processing file : %s\n',files_m_{j});
        [str,name,desc] = fgetfirst(files_m_{j});
        fprintf(fid,format,'%',fname,desc);
      end
    end

    % other files:
    files_all_={};
    for j=1:length(files_all)
      % remove .m and description
      [p,fname,fext] = fileparts(files_all{j});
      if ~strcmpi(fext,'.m') & ~strcmpi(fext,'.description')
        files_all_{end+1}=files_all{j};
      end
    end
    if ~isempty(files_all_)
      fprintf(fid,'%s\n','%');
      for j=1:length(files_all_)
        fprintf(1,'    :: processing file : %s\n',files_all_{j});
        desc = filetype(files_all_{j});
        if length(desc)>50
          desc=[desc(1:50) '+'];
        end
        fprintf(fid,format,'%',basename(files_all_{j}),desc);
      end
    end

    % folders:
    folders=list_folders(dirs{i},0);
    if ~isempty(folders)
      fprintf(fid,'%s\n','%');
      for j=1:length(folders)
        description=[folders{j} filesep '.description'];
        if exist(description)==2
          fprintf(1,'    :: processing folder : %s\n',folders{j});
          desc=readfile(description);
          fprintf(fid,format,'%',['[' basename(folders{j}) ']'],desc{1});
        end
      end
    end

    % add some more info:
    if ~fcont
      add_info(fid)
      fclose(fid);
    else
      fprintf(fid,'%s\n','%');
    end

  end
end

if fcont
  fid = fopen(fcont,'a');
  if fid~=-1
    add_info(fid);
    fclose(fid);
  end
end

if ~isempty(clog)
  fprintf(1,'\n');
  for i=1:length(clog)
    fprintf(1,' : created %s\n',clog{i});
  end
end

function add_info(fid)
if isunix
  [s,me]=unix('whoami'); me=me(1:end-1);
  [s,mc]=unix('dnsdomainname -f'); mc=mc(1:end-1);
  date=datestr(now);
  fprintf(fid,'%s\n','%');
  fprintf(fid,'%s    %s, %s\n','%',me,date);
  fprintf(fid,'%s    %s\n','%',mc);
end

