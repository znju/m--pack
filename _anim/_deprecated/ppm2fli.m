function ppm2fli(ppmfiles,anim_file,fps,size,options);
%PPM2FLI   Create FLI/FLC animations on UNIX like machines
%   Uses UNIX ppm2fli to create FLI/FLC animation.
%
%   Syntax:
%      PPM2FLI(PPM_FILES,ANIM_FILE,FPS,SIZE,OPTIONS)
%
%   Inputs:
%      PPM_FILES   Images selection [ '*.ppm' ]
%                  or the list of files to use as a cell array
%      ANIM_FILE   Animation name [ 'anim.flc' ]
%      FPS         Frames per second [ 5 ]
%      SIZE        Animation size [ <width x hight> {<none>} ]
%      OPTIONS     Options of the unix ppm2fli   [ <none> ]
%
%   Comment:
%      unix ppm2fli must be installed. ppm2fli  is available at:
%      http://vento.pi.tu-berlin.de/fli.html
%      This function runs on UNIX like machines. For Windows use
%      DTA2FLI instead.
%      For more detailed information about creation and visualisation
%      of FLI/FLC animations, see the site:
%      http://neptuno.fis.ua.pt/~mma/etc/anims/anims.htm
%
%   Example:
%      ppm2fli('*.ppm','anim.flc',5,'300x500');
%
%   MMA 19-11-2002, martinho@fis.ua.pt
%
%   See also DTA2FLI, GET_TIFF, FIXEDAR, TIFF2PPM, APPEND_ANIM

%   Department of Physics
%   University of Aveiro, Portugal

%   07-07-2004 - Some modifications
%   18-07-2005 - Enable PPM_FILES as cell array

fprintf(1,'\n:: %s is DEPRECATED, use %s instead\n',mfilename,'anim_fli');

if nargin < 5
  options=' ';
end
if nargin < 4 
  size=' ';
else
  size=['-g ',size];
end
if nargin < 3
  fps=4;
end
if nargin < 2
  anim_file='anim.flc';
end
if nargin < 1
  ppmfiles='*.ppm';
end

listFile = 'ppmlist_tmp';
if iscell(ppmfiles)
  fid = fopen(listFile,'w');
  for i=1:length(ppmfiles)
    fprintf(fid,'%s\n',ppmfiles{i});
  end
  fclose(fid);
else
  unix(['ls -1 ',ppmfiles,' > ',listFile]);
end

speed=1000/fps;
s=['-s ',num2str(speed)];

unix(['ppm2fli ',s,' ',size,' -N ',listFile,' ',options,' ',anim_file]);
unix(['rm ',listFile]);
