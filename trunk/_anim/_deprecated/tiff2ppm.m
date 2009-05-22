function list = tiff2ppm(options,tif,ppm);
%TIFF2PPM   Convert between image formats
%   Uses the ImageMagic comvert to convert one image format (tif)
%   to another (ppm).
%
%   Syntax:
%      LIST = TIFF2PPM(OPTIONS,TIF,PPM)
%
%   Inputs:
%      OPTIONS   ImageMagick convert options [ <none> ]
%      TIF       Original image extension [ 'tif' ]
%                or the list of files to convert as a cell array
%      PPM       Final image format [ 'ppm' ]
%
%   Output:
%      LIST   Cell array with the converted files
%
%   Requires:
%      ImageMagick convert must be installed. ImageMagick is available
%      at:
%      http://www.imagemagick.org
%
%   Comment:
%      All images in current dir with extension TIF will be used if
%      TIF is the images extension
%
%   Example:
%      tiff2ppm('-geometry 70%')
%
%   MMA 16-11-2002, martinho@fis.ua.pt
%
%   See also GET_TIFF, FIXEDAR, PPM2FLI, APPEND_ANIM

%   Department of Physics
%   University of Aveiro, Portugal

%   07-07-2004 - Some modifications
%   18-07-2005 - Enable TIF as cell array

fprintf(1,'\n:: %s is DEPRECATED, use %s instead\n',mfilename,'convert');

list = [];
if nargin < 3
  ppm='ppm';
end
if nargin < 2
  tif='tif';
end
if nargin < 1
  options=' ';
end

if iscell(tif)
  lista = tif;
  % find extension (tif)
  p = find(lista{1} == '.');
  if ~isempty(p)
    p = p(end);
    if p == length(lista{1})
      disp('# unknown file extension')
      return
    end
    tif = lista{1}(p+1:end);
  else
    disp('# unknown file extension')
    return
  end
else
  d=dir(['*.',tif]);
  lista=struct2cell(d);
  if isempty(lista)
    disp(['## no ',tif,' files found...']);
    return
  end
  lista=lista(1,:);
end

% search for ImageMagick convert:
[s]=evalc('! convert');
if isempty(findstr('ImageMagick',s))
  disp('## ImageMagick convert not found... convert not done')
  return
end

lista2 = strrep(lista,tif,ppm);
for i=1:length(lista)
  name1 = lista{i};
  name2 = lista2{i};
  disp(['# convert ', name1,' to ',name2]); 
  eval(['! convert ',options,' ',name1,' ',name2]);
  list{i} = name2;
end
