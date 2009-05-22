function res=convert(ims0,ext,varargin)
%CONVERT   Convert between image formats
%   Uses the ImageMagic comvert.
%
%   Syntax:
%      RES = CONVERT(IMS,EXT,VARARGIN)
%
%   Inputs:
%      IMS   Image to convert, or cell array with list of images
%      EXT   Taeget extension
%      VARARGIN:
%         crop, px to crop at top, bottom, right, left [0 0 0 0]
%         resize, resize percentage, default=100% ie, no resize
%         options, any ImageMagic convert options
%
%   Output:
%      RES   Created fimage or cell array with list of new images
%
%   Comment:
%      ImageMagick is available at http://www.imagemagick.org, but
%      for sure installed in you nix machine
%
%   MMA 21-04-2009, mma@odyle.net
%
%   See also SAVEFIG

% Created from the function tiff2ppm (16-11-2002), now deprecated.

crop='';
resize='';
options='';

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'crop')
    crop=vin{i+1};
  elseif isequal(vin{i},'resize')
    resize=vin{i+1};
  elseif isequal(vin{i},'options')
    options=[options ' ' vin{i+1}];
  end
end

notCell=0;
if ~iscell(ims0) % means isstr !
  notCell=1;
  ims0={ims0};
end

% resize str:
if ~isempty(resize), resize=sprintf('-geometry %d%%',resize); end

% crop str: top, bottom, right, left (N S E W)
if ~isempty(crop)
  sz=size(imread(ims0{1}));
  sz=[sz(2) sz(1)];
  x0=crop(4); % W
  y0=crop(1); % N
  w=sz(1)-x0-crop(3);
  h=sz(2)-y0-crop(2);
  crop=sprintf('-crop %dx%d%+d%+d',w,h,x0,y0);
end

if (~isempty(crop) || ~isempty(resize)) && isempty(strfind(options,'-depth '))
  % crop and resize may change image depth and we may have problems
  % playing a fli animation, case the images are to be used in that purpose!!
  options=[options ' -depth 8'];
end

res=cell(size(ims0));
for i=1:length(ims0)
  [p,name,ext0]=fileparts(ims0{i});
  im=fullfile(p,[name '.' ext]);
  cmd=sprintf('convert %s %s %s %s %s',crop,resize,options,ims0{i},im);
  system(cmd);
  res{i}=im;
end

if notCell
  res=res{1};
end
