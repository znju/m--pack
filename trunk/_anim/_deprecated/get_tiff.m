function final_name=get_tiff(T,image_name,format,options,convert_format,convert_opts)
%GET_TIFF   Print current image
%   Useful in loops generating images, prints current image to the
%   desired format and can convert to another using the ImageMagick
%   convert.
%
%   Syntax:
%      IMG = GET_TIFF(T,IMAGE_NAME,FORMAT,OPTIONS,CONVERT_FORMAT,CONVERT_OPTS)
%
%   Inputs:
%      T                 Image index, IMAGE_NAME_00...T.format [ {0} ... n ]
%      IMAGE_NAME        Name of printed image [ 'image' ]
%      FORMAT            Printed image format [ 'tif' ]
%      OPTIONS           Matlab print options [ '-dtiff -r0 -zbuffer' ]
%      CONVERT_FORMAT    Convert format [ 'ppm' ]
%      CONVERT_OPTS      ImageMagick convert options [ <none> ]
%
%   Output:
%      IMG   Final image name
%
%   Result:
%      images, converted images
%
%   Comments:
%     The -r0 option specifies the use of the screen resolution.
%     If this option is used, printed image size will be similar to
%     image on screen cos FIXEDAR is applied.
%     The -zbuffer option will more likely give you output that
%     emulates the screen.
%
%   Requirement:
%      ImageMagick convert must be installed, if convert will be used
%      ImageMagick is available at:
%      http://www.imagemagick.org/
%
%   Examples:
%      get_tiff(1,'image','ps','-dpsc2 -loose');
%      get_tiff(1,'image','tif','-dtiff -r0 -zbuffer','ppm','-geometry 70%');
%      get_tiff(1,'image','png','-dpng  -r0 -zbuffer');
%
%   MMA 16-11-2002, martinho@fis.ua.pt
%
%   See also FIXEDAR, TIFF2PPM, DSP

%   Department of Physics
%   University of Aveiro, Portugal

%   07-07-2004 - Some modifications
%   06-07-2005 - Added output IMG

fprintf(1,'\n:: %s is DEPRECATED, use %s instead\n',mfilename,'savefig');

final_name = [];
if nargin < 6
  convert_opts ='';
end
if nargin < 5
  convert_format='';
end
if nargin < 4 
  options='-dtiff -r0 -zbuffer';
end
if nargin < 3
  format='tif';
end
if nargin < 2
  image_name='image';
end
if nargin < 1
  T=0;
end

if T<10
  fname=[image_name,'_000',int2str(T),'.',format];
elseif T<100
  fname=[image_name,'_00',int2str(T),'.',format];
elseif T<1000
  fname=[image_name,'_0',int2str(T),'.',format];
else
  fname=[image_name,'_',int2str(T),'.',format];
end

% FIXEDAR:
if ~isempty(findstr(' -r0 ',options))
  eval('fixedar');
end

printstr=['print ',options,'  ',fname];
eval(printstr);

if ~isempty(convert_format)
  % search for ImageMagick convert:
  [s]=evalc('! convert');
  if isempty(findstr('ImageMagick',s))
    disp('## ImageMagick convert not found... convert not done')
    return
  end
  evalstr=['! convert ',convert_opts,' ',fname,' ',fname(1:end-length(format)),convert_format];
  eval(evalstr);
end

final_name = fname;
