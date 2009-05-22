function anim_fli(images,anim,varargin)
%ANIM_FLI   Create FLI animation
%   Uses system ppm2fli to create animation.
%
%   Syntax:
%      ANIM_FLI(IMAGES,ANIM,VARARGIN)
%
%   Inputs:
%      IMAGES  Images (cell array)
%      ANIM    Animation to create
%      VARARGIN:
%        fps, frames per second, default is 5
%        crop, px to crop at top, bottom, right, left [0 0 0 0]
%        resize, resize percentage, default=100% ie, no resize
%        options, any ppm2fli options
%
%   Comments:
%      ppm2fli  is available at http://vento.pi.tu-berlin.de/fli.html
%      At pcwin use DTA2FLI instead
%
%   Examples:
%      images={'image1.GIF','image2,PPM',... ,'imagen.TIF'};
%      anim_fli(images,'anim.flc');
%
%   MMA 02-04-2009, mma@odyle.net
%   CESAM, Portugal
%
%   See also ANIM_MPEG, FLI2MPEG, DTA2FLI, SAVEFIG

fps=5;
crop='';
resize='';
options='';

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'fps')
    fps=vin{i+1};
  elseif isequal(vin{i},'crop')
    crop=vin{i+1};
  elseif isequal(vin{i},'resize')
    resize=vin{i+1};
  elseif isequal(vin{i},'options')
    options=vin{i+1};
  end
end

% create tmp files (apart from crop and resize, not all may be ppms)
tmpExt    = 'ppm';
tmpName   = 'image_';
tmpFormat = '%07d';
tmp_dir=tempname;
mkdir(tmp_dir);

% resize str:
if ~isempty(resize), resize=sprintf('-geometry %d%%',resize); end

% crop str:
if ~isempty(crop)
  sz=size(imread(images{1}));
  sz=[sz(2) sz(1)];
  x0=crop(4); % W
  y0=crop(1); % N
  w=sz(1)-x0-crop(3);
  h=sz(2)-y0-crop(2);
  crop=sprintf('-crop %dx%d%+d%+d',w,h,x0,y0);
end

convertOptions='';
if ~isempty(crop) || ~isempty(resize)
  % crop and resize may change image depth and we may have problems
  % playing the animation, so:
  convertOptions=[convertOptions ' -depth 8'];
end

% convert create tmp images:
fprintf(1,':: converting files ...\n');
dest={};
for i=1:length(images)
  dest{i}=fullfile(tmp_dir,sprintf(['%s' tmpFormat '.%s'],tmpName,i,tmpExt));
  cmd=sprintf('convert %s %s %s %s %s',crop,resize,convertOptions,images{i},dest{i});
  %disp(cmd);
  unix(cmd);
end
files=fullfile(tmp_dir,[tmpName tmpFormat '.' tmpExt]);

% new images size:
sz=size(imread(dest{1}));
sz=sprintf('-g %dx%d',sz(2),sz(1));

% create list file:
listFile=fullfile(tmp_dir,'ppmlist');
fid=fopen(listFile,'w');
for i=1:length(dest)
  fprintf(fid,'%s\n',dest{i});
end
fclose(fid);

% ppm2fli:
fps=sprintf('-s %d',1000/fps);
cmd=['ppm2fli ' fps ' ' sz ' -N ' listFile ' ' options ' ' anim];
unix(cmd);

% remove tmp dir and tmp files:
rmdir(tmp_dir,'s');
