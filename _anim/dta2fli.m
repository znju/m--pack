function dta2fli(pngfiles,animfile,dtadir,options)
%DTA2FLI   Create FLI/FLC animations on Windows
%   Uses David K. Mason dta.exe to create FLC or AVI animation.
%
%   Syntax:
%      DTA2FLI(PNG_FILES,ANIM_FILE,DTA_DIR,OPTIONS)
%
%   Inputs:
%      PNG_FILES   Images selection [ 'image*.png' ]
%                  or the list of files to use as a cell array
%      ANIM_FILE   Animation name [ 'anim' ]
%      DTA_DIR     Path to dta.exe
%      OPTIONS     Options of dta.exe [ <none> ]
%
%   Comments:
%      Windows program DTA.EXE must be available.
%      It can be obtained at:
%      http://www.povray.org/ftp/pub/povray/utilities/dta/
%      This function runs on Windows, for UNIX like machines use
%      PPM2FLI instead.
%      For more detailed information about creation and visualisation
%      of FLI/FLC animations, see the site:
%      http://neptuno.fis.ua.pt/~mma/etc/anims/anims.htm
%
%   Examples:
%      dta2fli('my_images*.png','myanim','c:\dta\');
%      dta2fli('my_images*.png','myanim','c:\dta\','/FAVI');
%      % the first example produces the FLC animation  myanim.flc
%      % the second one produces the AVI animatioan myanim.avi
%
%   MMA 7-7-2004, martinho@fis.ua.pt
%
%   See also PPM2FLI, GET_TIFF, FIXEDAR, TIFF2PPM, APPEND_ANIM

%   Department of Physics
%   University of Aveiro, Portugal

%   18-07-2005 - Enable PNG_FILES as cell array.

if nargin < 4
  options='';
end
if nargin < 3
  disp('## more arguments needed...');
  return
end

if ~iscell(pngfiles)
  d=dir(pngfiles);
  if isempty(d)
    disp(['## warning: no files matching ',pngfiles]);
    return
  end
  pngfiles = {d.name};
end

filenames = '';
for i=1:length(pngfiles)
  filenames = [filenames,' ',pngfiles{i}];
end

% search for dta.exe on dtadir:
dta=[dtadir,'dta.exe'];
if ~isequal(exist(dta),2)
  disp(['## warning: dta.exe not found : ',dta]);
  return
end

% create animation:
run = ['"',dta,'" ',filenames,' /O',animfile,' ',options,' &'];
dos(run);

disp(' ')
disp(['## done, created ',animfile,'.flc']);
disp(' ')
