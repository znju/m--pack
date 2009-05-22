function anim_mpeg(images,anim,varargin)
%ANIM_MPEG   Create MPEG animation
%   Uses encoder to create animation.
%   Currently supported encoders are mencode and ffmpeg.
%
%   Syntax:
%      ANIM_MPEG(IMAGES,ANIM,VARARGIN)
%
%   Inputs:
%      IMAGES  Images (cell array)
%      ANIM    Animation to create
%      VARARGIN:
%        fps, frames per second, default is 5 for mencode; for ffmpeg
%             the min is 20 (default) and max is 160 for mpeg files;
%             for other types the default is also 5
%        crop, px to crop at top, bottom, left, right [0 0 0 0]
%        resize, resize percentage, default=100% ie, no resize
%        options, any encoder options
%        encoder (or enc), executable to use, ffmpeg or mencoder (default)
%
%   Comments:
%      ffmpeg is available at http://www.ffmpeg.org
%      mencoder is available at http://www.mplayerhq.hu
%      At least one of those encoders  is required!
%      Also required ImageMagick (convert), http://www.imagemagick.org
%
%      - mencoder command is in the form:
%        mencoder  mf://<tmp dir>/image_%07d.png -mf type=png:fps=5
%        -ovc lavc -lavcopts vcodec=mpeg4 -oac copy -of mpeg -o <anim>
%
%      - ffmpeg command is in the form:
%        ffmpeg  -y -sameq -loop_output 0 -r 20 -i <tmp dir>/image_%07d.png
%        <anim>
%
%   Examples:
%      ppms={'image1.ppm','image2,ppm',... ,'imagen.ppm'};
%      %or ppms=list_files(path,'ppm');
%      anim_mpeg(ppms,'anim1.mpg','enc','ffmpeg'); % will use 30 fps
%      anim_mpeg(ppms,'anim1.avi','enc','ffmpeg'); % will use 5 fps
%      anim_mpeg(ppms,'anim2.mp4'); % will use mencoder and 5 fps
%      anim_mpeg(ppms,'anim2.avi'); % will use mencoder and 5 fps
%
%   MMA 02-04-2009, mma@odyle.net
%   CESAM, Portugal
%
%   See also ANIM_FLI, FLI2MPEG, SAVEFIG

fps='auto';
crop='';
resize='';
options='';
enc = 'auto';

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
  elseif isequal(vin{i},'encoder') || isequal(vin{i},'enc')
    enc=vin{i+1};
  end
end

[pathstr,name,ext]=fileparts(anim);
is_mpeg=ismember(ext,{'.mpg','.mpeg','.mp4'});

% select encoder:
encoders={'mencoder','ffmpeg'};
found=zeros(size(encoders));
for i=1:length(encoders)
  [status,Enc]=unix(['which ' encoders{i}]);
  if status==0, found(i)=1; end
end

if ~isequal(enc,'auto')
  [is,loc]=ismember(enc,encoders);
  if ~is
    fprintf(1,':: selected encoder not available, select from:\n')
    for i=1:length(encoders), fprintf(1,'    - %s\n',encoders{i}); end
    return
  else
    enc=encoders{loc};
    % check if found:
    if ~found(loc)
      fprintf(1,':: selected encoder not found in the system\n');
      return
    end

  end
else
  loc=find(found);
  if ~isempty(loc), enc=encoders{loc}; end
end

if ~any(found)
  fprintf(1,':: none of the following encoders found in the system::\n')
  for i=1:length(encoders), fprintf(1,'    - %s\n',encoders{i}); end
  return
end

% check fps:
if isequal(fps,'auto')
  fps=5;
  if isequal(enc,'ffmpeg') && is_mpeg, fps=20; end
end
if isequal(enc,'ffmpeg') && is_mpeg
  fps=min(160,max(fps,20));
end
fprintf(1,':: fps will be %d\n',fps);

% create tmp files:
tmpExt    = 'png';
if isequal(enc,'ffmpeg') && ~(isempty(resize) && isempty(crop))
  tmpExt    = 'gif'; % ffmpeg does not works after convert otherwise!
end
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

% convert create tmp images:
fprintf(1,':: converting files ...\n');
dest={};
for i=1:length(images)
  dest{i}=fullfile(tmp_dir,sprintf(['%s' tmpFormat '.%s'],tmpName,i,tmpExt));
  cmd=sprintf('convert %s %s %s %s',crop,resize,images{i},dest{i});
  %disp(cmd);
  unix(cmd);
end
files=fullfile(tmp_dir,[tmpName tmpFormat '.' tmpExt]);

% encode:
lp=0;
if isequal(enc,'ffmpeg')
  cmd=sprintf('ffmpeg %s -y -sameq -loop_output 0 -r %d -i %s %s',options,fps,files, anim);
  disp(cmd)
  % LD_LIBRARY_PATH must be unset in order to GLIBC be found out of matlab tree, so:
  lp=getenv('LD_LIBRARY_PATH');
  setenv('LD_LIBRARY_PATH','');
  unix(cmd);
elseif  isequal(enc,'mencoder')
  % select -of option (Available output formats, see mencoder -of help)
  if is_mpeg
    lp=getenv('LD_LIBRARY_PATH');
    setenv('LD_LIBRARY_PATH','');
    ofStr='-of mpeg';
  else % like .avi
    ofStr='';
  end
  cmd=sprintf('mencoder %s mf://%s -mf type=%s:fps=%d -ovc lavc -lavcopts vcodec=mpeg4 -oac copy %s -o %s',options,files,tmpExt,fps,ofStr,anim);

  disp(cmd);
  unix(cmd);
end

% reset LD_LIBRARY_PATH
if lp
  setenv('LD_LIBRARY_PATH',lp);
end

% remove tmp dir and tmp files:
rmdir(tmp_dir,'s');
