function fname=savefig(name,ind,drive,options,varargin)
%SAVEFIG   Save figure
%
%   Syntax:
%      OUTNAME=SAVEFIG(NAME,IND,DRIVE,OPTIONS,VARARGIN)
%
%   Inputs:
%      NAME   Name of the save image, default='image' (name will be
%             'image_0000123.tif', for instance, depending on next
%             inputs, as explained below
%      IND   Image index, in the example above, 'image_0000123.tif',
%            IND is 123, default is 0
%      DRIVE   Matlab print drive, available should be, at least, -dps,
%              -dpsc, -dps2, -dpsc2 (extension ps), -deps, -depsc,
%              -deps2, -depsc2 (entension eps), -dill (ext ai), -djpeg
%              (ext jpg), -dtiff, -dtiffnocompression (ext tif) and
%              -dpng (ext png), default is -dtiff
%      OPTIONS   Print options, default is '-r0 -zbuffer'
%      VARARGIN:
%         'far', [1] or 0, if 1 FIXEDAR is done before the print
%         'fig', figure object to print, default is the current figure
%
%   Output:
%      OUTNAME   Name of the saved image
%
%   Comments:
%      The -r0 option specifies the use of the screen resolution.
%      If this option is used, printed image size will be similar to
%      image on screen cos FIXEDAR is applied.
%      For some drives, the -zbuffer option will more likely give you
%      output that emulates the screen.
%
%   Examples:
%      savefig; % saves current figure as image_0000000.tif
%      savefig('myImage',77,'-dpng') % saves current figure as
%                                    % image_0000077.png
%
%   MMA 21-04-2009, mma@odyle.net
%
%   See also FIXEDAR, CONVERT

% Created from the function get_tiff (16-11-2002), now deprecated.

far=1;
fig=[];

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'far')
    far=vin{i+1};
  elseif isequal(vin{i},'fig')
    fig=vin{i+1};
  end
end

if nargin < 4
  options='-r0 -zbuffer';
end

if nargin < 3
  drive='-dtiff';
end

if nargin < 2
  ind=0;
end

if nargin < 2
  name='image';
end

if ~isempty(fig), figure(fig); end
if far, fixedar; end

fname=sprintf('%s_%07d',name,ind);
print(drive,options,fname);

% find fname extension:

switch drive
  case {'-dps','-dpsc','-dps2','-dpsc2'}
    ext='ps';
  case {'-deps','-depsc','-deps2','-depsc2'}
    ext='eps';
  case '-dill'
    ext='ai';
  case '-djpeg'
    ext='jpg';
  case {'-dtiff','-dtiffnocompression'}
    ext='tif';
  case '-dpng'
    ext='png';
  otherwise
    ext=[];
end

% if unknown extension, check last fname* created:
if isempty(ext)
  [status,res]=system(['ls -r1 ' fname '*']);
  tmp=double(res);
  i=find(tmp==10);
  fname=res(i(end-1)+1:end-1);
else
  fname=[fname '.' ext];
end
