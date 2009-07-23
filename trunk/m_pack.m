function m_pack(varargin)
%M_PACK   Starter for the MMA Matlab package, M_PACK
%   M_PACK is a matlab package created by Martinho Marta Almeida.
%   It is a collection of m files created during my PhD in Physical
%   Oceanography. It include utilities for many purposes, from
%   harmonic analysis of series to a plot of a simple arrow.
%   Many functions are related with the manipulation of NetCDF data
%   and visualization of input and output files of the ocean model
%   ROMS.
%   The main objective of this function is to add the directories to
%   path in the correct order, so that everything works fine.
%   M_PACK is freely distributed at the site:
%   http://www.odyle.net/mma/archive/m_pack
%   For any comments/suggestions use the email:
%   mma@odyle.net
%   Further information about the contents of M_PACK is available
%   at the site above
%
%   Syntax:
%      M_PACK(VARARGIN)
%
%   Input:
%      VARARGIN:
%         'start',    Will add the directories to the path in the
%                     correct order so that you can start using the
%                     available functions/utilities
%
%         'stop',     Will remove the M_PACK directories from path
%
%         'what'      Displays contents
%
%         'version'   Displays the current M_PACK version
%
%         'check'     Tries to reach a file at the M_PACK site where
%                     latest version is shown. It uses the command
%                     wget, available at least for unix like machines,
%                     I suppose
%
%         'help'      Will open help from the web. It accepts the
%                     browser executable as the second argument;
%                     by default the browser defined in docopt is used
%
%         'pdf'       Will open a short pdf document with basc
%                     information about the M_PACK. It contains a short
%                     descriptions of all the M_PACK contents.
%                     It accept the executable to
%                     read pdfs as the second argument; by default
%                     'acroread' is used under UNIX
%
%   Comments:
%      - Without input arguments, m_pack('what') is shown.
%
%      - The best way to use this may be to add m_pack('start') to
%        your local startup file.
%
%      - After realizing that seagrid (Jul-2003) has some problems
%        under some linux, the previous version (Oct-2002) is used.
%        You may try the newest seagrid in you linux machine by making
%        small modifications in this file (change tha variable
%        dirs_seagrid bellow).
%
%      - About netcdf, windows users must place dlls (netcdf.dll and
%        mexcdf53.dll) in the Matlab \bin and \bin\win32 according
%        to the author.
%
%   Examples:
%      m_pack('version')      % displays current version
%      m_pack('check')        % check for new version at the web
%      m_pack('start')        % adds M_PACK directories to the path
%      m_pack('stop')         % removes M_PACK from path
%      m_pack('what')         % displays contents
%      m_pack('start',<what>) % only starts content <what>
%      bin = '~/bin/mozilla'
%      m_pack('help',bin)     % will open the M_PACK site with mozilla
%      bin = 'gv';
%      m_pack('pdf',bin)      % will open the M_PACK pdf reference file
%
%   MMA 25-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

%   12-2004 - v 1.0
%   02-2005 - v 1.1
%   05-2005 - v 1.2
%   08-2005 - v 1.3
%   11-2005 - v 2.0
%   06-2007 - v 2.1
%   07-2008 - v 2.2

% about m_pack version:
this_version = 'svn';
version_date = 'from jul 2008';
site         = 'http://www.odyle.net/mma/';
m_pack_dir   = 'archive/m_pack/';

version_info = {
  ['                                           '],
  [' ## m_pack version ',this_version,'        '],
  ['                                           '],
  ['    - Date:   ',version_date,'             '],
  ['    - Author: Martinho Marta Almeida       '],
  ['                                           '],
  ['              Department of Earth Physics  '],
  ['              Federal University of Bahia  '],
  ['              Salvador da Bahia, Brazil    '],
  ['                                           '],
  ['    - Web:    ',site,m_pack_dir,'          '],
  ['                                           '],
  ['    - Email;  mma@odyle.net                '],
  ['                                           ']
};

% about check for new version:
version_url  = [site,m_pack_dir];
version_file = 'm_pack_current_version.txt';
execute      = 'wget';

% about help:
browser = '';

% about pdf:
acroread = 'acroread';
pdf_file = 'm_pack_2.1.pdf';


show_version = 0;
check_new    = 0;
show_web     = 0;
start_pack   = 0;
stop_pack    = 0;
show_what    = 0;
show_pdf     = 0;
toStart      = 'all';
toStop       = 'all';

if nargin == 0
  m_pack('what')
  return
end

vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'version')
    show_version = 1;
  end
  if isequal(vin{i},'check')
    check_new = 1;
  end
  if isequal(vin{i},'help')
    show_web = 1;
    eval('browser = vin{i+1};','');
  end
  if isequal(vin{i},'start')
    start_pack = 1;
    try
      toStart = vin{i+1};
    end
  end
  if isequal(vin{i},'stop')
    stop_pack = 1;
    try
      toStop = vin{i+1};
    end
  end
  if isequal(vin{i},'what')
    show_what = 1;
  end
  if isequal(vin{i},'pdf')
    show_pdf = 1;
    eval('acroread = vin{i+1};','');
  end
end

% --------------------------------------------------------------
% display version
% --------------------------------------------------------------
if show_version
  disp(strvcat(version_info))
end

% --------------------------------------------------------------
% check for new version
% --------------------------------------------------------------
if check_new
  str = [execute,' ',version_url,version_file];
  [status,result] = system(str);
  if status == 0 & ~isequal(computer,'PCWIN')
    ver = load(version_file);
    delete(version_file);
    disp(['## your M_PACK version is ',this_version]);
    disp(['## the latest release available is the version ',num2str(ver)]);
  else
    disp('## unable to check M_PACK version...');
    disp(['## please check it at ',site,m_pack_dir]);
    go = input('  -- do you want to go there now? y=1  \n     ');
    if go
      m_pack('help');
    end
  end
end

% --------------------------------------------------------------
% show web page, help
% --------------------------------------------------------------
if show_web
  if isempty(browser)
    eval(['web ',site,m_pack_dir,' -browser;']);
  else
    [status,result] = system([browser,' ',site,m_pack_dir,' &']);
  end
end

% --------------------------------------------------------------
% show pdf file
% --------------------------------------------------------------
if show_pdf
  % get path:
  base = fileparts(which(mfilename));
  pdf_file = [base,filesep,pdf_file];
  if isequal(computer,'PCWIN')
    eval(['! ',pdf_file],'');
  else
    eval(['! ',acroread ,' ',pdf_file],'');
  end
end

% --------------------------------------------------------------
% show contents (what)
% --------------------------------------------------------------
if show_what
  fprintf('\n');
  fprintf(1,' m_pack %s (%s)\n',this_version,version_date                              );
  fprintf('\n');

  fprintf(1,' --  m_files    -- diverse utilities\n'                                   );
  fprintf(1,' --  models     -- roms/pom/occam/pop  model utilities\n'                 );
  fprintf(1,' --  ncdview    -- netcdf visualisation\n'                                );
  fprintf(1,' --  ncx        -- netcdf explorer\n'                                     );
  fprintf(1,' --  netcdf     -- netcdf/matlab interface, by Charles R. Denham\n'       );
  fprintf(1,' --  seagrid    -- orthogonal grid generation, by Charles R. Denham\n'    );
  fprintf(1,' --  tidal_ell  -- tidal ellipse, by Zhigang Xu\n'                        );
  fprintf(1,' --  t_tide     -- tidal harmonic analysis (v 1.1), by Rich Pawlowicz\n'  );
  fprintf(1,' --  m_map      -- mapping package (v 1.4), by Rich Pawlowicz\n'          );
  fprintf(1,' --  misc       -- miscellaneous utilities, other authors\n'              );
  fprintf(1,' --  timeplt    -- timeplt from Rich Signell\n'                           );
  fprintf(1,' --  seawater   -- CSIRO SEAWATER Library (v 2.0.1)\n'                    );
  fprintf(1,' --  oceans     -- Oceans Toolbox for Matlab\n'                           );
  fprintf(1,' --  data       -- datasets\n'                                            );

  fprintf('\n');
  fprintf(1,' to start m_pack run m_pack(''start''), or m_pack(''start'',<what>)\n'  );
  fprintf('\n');
end

% --------------------------------------------------------------
% start and stop M_PACK:
% --------------------------------------------------------------

if start_pack | stop_pack
  % matlab version:
  % some paths are different in matlab < 6
  v=version;
  ir=find(v=='R');
  ie=find(v==')');
  v=str2num(v(ir+1:ie-1));

  sep  = filesep;
  base = fileparts(which(mfilename));

  % data:
  dirs_data  = {
    [base sep 'data'],
    [base sep 'data' sep 'coasts'],
    [base sep 'data' sep 'coasts' sep 'PI'],
    [base sep 'data' sep 'coasts' sep 'BR'],
  };

  % m_files:
  % - requires netcdf, t_tide, tidal_ellipse, m_map
  dirs_m_files  = {
    [base,sep,'_anim'],
    [base,sep,'_graph'],
    [base,sep,'_graph',sep,'draw_bar'],
    [base,sep,'_graph',sep,'pylab_colormaps'],
    [base,sep,'_io'],
    [base,sep,'_math'],
    [base,sep,'_math',sep,'ssa_under_construction'],
    [base,sep,'_math',sep,'ssa_under_construction',sep,'ssagui'],
    [base,sep,'_misc'],
    [base,sep,'_nc'],
    [base,sep,'_str']
  };                                  

  % dirs_models:
  % - requires m_files, ncdview, t_tide, tidal_ellipse, netcdf and
  % misc (other_authors)
  dirs_models = {
    [base,sep,'_po'],
    [base,sep,'_po',sep,'roms'],
    [base,sep,'_po',sep,'roms',sep,'slice'],
    [base,sep,'_po',sep,'roms',sep,'slice',sep,'demo_slice'],
    [base,sep,'_po',sep,'roms',sep,'roms_ncep'],
    [base,sep,'_po',sep,'roms',sep,'roms_rivers'],
    [base,sep,'_po',sep,'roms',sep,'roms_slice'],
    [base,sep,'_po',sep,'roms',sep,'roms_tides'],
    [base,sep,'_po',sep,'roms',sep,'roms_tides',sep,'corr_rtools'],
    [base,sep,'_po',sep,'roms',sep,'SpectrHA',sep,'v1',sep,'config'],
    [base,sep,'_po',sep,'roms',sep,'SpectrHA',sep,'v1',sep,'files'],
    [base,sep,'_po',sep,'roms',sep,'SpectrHA',sep,'v1',sep,'help'],
    [base,sep,'_po',sep,'roms',sep,'SpectrHA',sep,'v1'],
    [base,sep,'_po',sep,'roms',sep,'SpectrHA',sep,'v2',sep,'files'],
    [base,sep,'_po',sep,'roms',sep,'SpectrHA',sep,'v2',sep,'modif'],
    [base,sep,'_po',sep,'roms',sep,'SpectrHA',sep,'v2'],
    [base,sep,'_po',sep,'roms',sep,'RaV'],
    [base,sep,'_po',sep,'roms',sep,'RaV',sep,'files'],
    [base,sep,'_po',sep,'pom'],
    [base,sep,'_po',sep,'occam'],
    [base,sep,'_po',sep,'pop'],
  };

  % dirs_ncdview:
  % - requires m_files and netcdf
  dirs_ncdview  = {
    [base,sep,'_nc',sep,'NCDView',sep,'config'],
    [base,sep,'_nc',sep,'NCDView',sep,'datasets'],
    [base,sep,'_nc',sep,'NCDView',sep,'files'],
    [base,sep,'_nc',sep,'NCDView',sep,'help'],
    [base,sep,'_nc',sep,'NCDView'],
  };

  % - requires netcdf
  dirs_ncx  = {
    [base,sep,'_nc',sep,'ncx']
  };


  % other authors, netcdf:
  [pth,fname,ext]=fileparts(which(mfilename));
  dirs_netcdf=netcdf_paths([pth,sep,'other_authors',sep,'netcdf'],0);

  % other authors, seagrid:
  if isequal(computer,'PCWIN')
    if v >=12
      dirs_seagrid = {
        [base,sep,'other_authors',sep,'seagrid',sep,'presto'],
        [base,sep,'other_authors',sep,'seagrid',sep,'seagrid_Jul_2003'],
        [base,sep,'other_authors',sep,'seagrid',sep,'seagrid_mex',sep,'pcwin_v6'],
      };
    else
      dirs_seagrid = {
        [base,sep,'other_authors',sep,'seagrid',sep,'presto'],
        [base,sep,'other_authors',sep,'seagrid',sep,'seagrid_Jul_2003'],
        [base,sep,'other_authors',sep,'seagrid',sep,'seagrid_mex',sep,'pcwin_v5'],
      };
    end
  else
    dirs_seagrid   = {
      [base,sep,'other_authors',sep,'seagrid',sep,'presto'],
      [base,sep,'other_authors',sep,'seagrid',sep,'seagrid_Oct_2002'],
      [base,sep,'other_authors',sep,'seagrid',sep,'seagrid_mex',sep,'glx'],
    };
  end

  % other authors, tidal_ellipse
  dirs_tidal_ell={
    [base,sep,'other_authors',sep,'tidal_ellipse']
  };

  % other authors, t_tide
  dirs_t_tide   = {
    [base,sep,'other_authors',sep,'t_tide']
  };

  % other authors, misc
  dirs_misc     = {
    [base,sep,'other_authors',sep,'misc']
  };

  % other authors, m_map
  dirs_m_map    = {
    [base,sep,'other_authors',sep,'m_map_1.4']
  };

  % other authors, timeplt
  dirs_timeplt  = {
    [base,sep,'other_authors',sep,'timeplt']
  };

  % other authors, seawater
  dirs_seawater  = {
    [base,sep,'other_authors',sep,'seawater']
  };

  % other authors, oceans
  dirs_oceans  = {
    [base,sep,'other_authors',sep,'oceans']
  };


  if start_pack
    n = 0;
    add={};

    % add m_files:
    if isequal(toStart,'m_files') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_m_files);
      add{n} = ['  --> adding m_files' str];
    end

    % add models:
    if isequal(toStart,'models') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_models);
      add{n} = ['  --> adding roms, pom, occam, pop' str];
    end

    % add ncdview:
    if isequal(toStart,'ncdview') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_ncdview);
      add{n} = ['  --> adding ncdview' str];
    end

    % add ncx:
    if isequal(toStart,'ncx') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_ncx);
      add{n} = ['  --> adding ncx' str];
    end

    % add netcdf:
    if isequal(toStart,'netcdf') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_netcdf);
      add{n} = ['  --> adding netcdf' str];
    end

    % add seagrid:
    if isequal(toStart,'seagrid') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_seagrid);
      add{n} = ['  --> adding seagrid' str];
    end

    % add tidal_ellipse:
    if isequal(toStart,'tidal_ell') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_tidal_ell);
      add{n} = ['  --> adding tidal_ellipse' str];
    end

    % add t_tide:
    if isequal(toStart,'t_tide') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_t_tide);
      add{n} = ['  --> adding t_tide' str];
    end

    % add m_map:
    if isequal(toStart,'m_map') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_m_map);
      add{n} = ['  --> adding m_map' str];
    end

    % add misc:
    if isequal(toStart,'misc') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_misc);
      add{n} = ['  --> adding misc' str];
    end

    % add timeplt:
    if isequal(toStart,'timeplt') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_timeplt);
      add{n} = ['  --> adding timeplt' str];
    end

    % add seawater:
    if isequal(toStart,'seawater') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_seawater);
      add{n} = ['  --> adding seawater' str];
    end

    % add oceans:
    if isequal(toStart,'oceans') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_oceans);
      add{n} = ['  --> adding oceans' str];
    end


% SEA, OCEANS

    % add data:
    if isequal(toStart,'data') | isequal(toStart,'all')
      n=n+1;
      str=add_dirs(dirs_data);
      add{n} = ['  --> adding data' str];
    end

    disp(' ');
    if isequal(toStart,'all')
      disp(strvcat(add))
      disp(' ');
      disp(['## m_pack ',this_version,' (',version_date,') started']);
    elseif isempty(add)
      disp([':: unknown <what> = ',toStart])
    else
      disp([strvcat(add),' (m_pack ',this_version,')']);
    end
    disp(' ');

  elseif stop_pack
    n = 0;
    remove={};
    warning off

    % remove m_files:
    if isequal(toStop,'m_files') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_m_files);
      remove{n} = ['  --> removed m_files' str];
    end

    % remove models:
    if isequal(toStop,'models') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_models);
      remove{n} = ['  --> removed roms, pom, occam, pop' str];
    end

    % remove ncdview:
    if isequal(toStop,'ncdview') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_ncdview);
      remove{n} = ['  --> removed ncdview' str];
    end

    % remove ncx:
    if isequal(toStop,'ncx') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_ncx);
      remove{n} = ['  --> removed ncx' str];
    end

    % remove netcdf:
    if isequal(toStop,'netcdf') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_netcdf);
      remove{n} = ['  --> removed netcdf' str];
    end

    % remove seagrid:
    if isequal(toStop,'seagrid') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_seagrid);
      remove{n} = ['  --> removed seagrid' str];
    end

    % remove tida_ellipse
    if isequal(toStop,'tidal_ell') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_tidal_ell);
      remove{n} = ['  --> removed tidal_ellipse' str];
    end

    % remove t_tide:
    if isequal(toStop,'t_tide') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_t_tide);
      remove{n} = ['  --> removed t_tide' str];
    end

    % remove m_map:
    if isequal(toStop,'m_map') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_m_map);
      remove{n} = ['  --> removed m_map' str];
    end

    % remove misc:
    if isequal(toStop,'misc') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_misc);
      remove{n} = ['  --> removed misc' str];
    end

    % remove timeplt:
    if isequal(toStop,'timeplt') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_timeplt);
      remove{n} = ['  --> removed timeplt' str];
    end

    % remove seawater:
    if isequal(toStop,'seawater') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_seawater);
      remove{n} = ['  --> removed seawater' str];
    end

    % remove oceans:
    if isequal(toStop,'oceans') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_oceans);
      remove{n} = ['  --> removed oceans' str];
    end

    % remove data:
    if isequal(toStop,'data') | isequal(toStop,'all')
      n = n+1;
      str=rm_dirs(dirs_data);
      remove{n} = ['  --> removed data' str];
    end

    disp(' ');
    if isequal(toStop,'all')
      disp(strvcat(remove))
      disp(' ');
      disp('## m_pack is stopped');
    elseif isempty(remove)
      disp([':: unknown <what> = ',toStop])
    else
      disp(strvcat(remove))
    end
    disp(' ');

    warning on
  end
end

function [status,result] = system(str)
% it looks like matlab prior to 6 does not contain system
if isequal(computer,'PCWIN') | isequal(computer,'PCWIN64')
  [status,result] = dos(str);
else
  [status,result] = unix(str);
end

function str=add_dirs(dirs)
incDeprec=' (inc deprecated stuff)';
incDevel =' (inc devel stuff)';
str1='';
str2='';
for i=1:length(dirs),
  addpath(dirs{i});

  deprecatedFolder=fullfile(dirs{i},'_deprecated');
  if exist(deprecatedFolder)==7
    addpath(deprecatedFolder);
    str1=incDeprec;
  end

  develFolder=fullfile(dirs{i},'_devel');
  if exist(develFolder)==7
    addpath(develFolder);
    str2=incDevel;
  end
end
str=[str1 str2];


function str=rm_dirs(dirs)
incDeprec=' (inc deprecated stuff)';
incDevel =' (inc devel stuff)';
str1='';
str2='';
for i=1:length(dirs),
  rmpath(dirs{i});

  deprecatedFolder=fullfile(dirs{i},'_deprecated');
  if exist(deprecatedFolder)==7
    rmpath(deprecatedFolder);
    str1=incDeprec;
  end

  develFolder=fullfile(dirs{i},'_devel');
  if exist(develFolder)==7
    rmpath(develFolder);
    str2=incDevel;
  end
end
str=[str1 str2];

