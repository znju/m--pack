function cat_anims(files,varargin)
%CAT_ANIMS   Concatenate fli/flc files
%   Joins two or more FLI/FLC animations in time.
%
%   Syntax:
%      CAT_ANIMS(FILES,VARARGIN)
%
%   Inputs:
%      FILES   List of animation files as a cell array
%      VARARGIN:
%         anim, output animation filename, default=anim.flc
%         size, size of output anim, default the same as anim 1
%         fps, frames per second, default the same as anim 1
%         rm1, remove firts frame of all anims except first; if false
%            all frames are used, else, the first frame is removed in
%            all animations but first. This may be used in case that
%            frame is already included in the previous file (as last
%            frame), default=0
%
%   Requires:
%      *nix machine
%      ppm2fli and unflick
%
%   Example:
%     cat_anims({'anim1.flc','anim2.flc'}
%
%   MMA 27-08-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

rmFirst = 0;
imsize  = 0;
speed   = 0; % frames per sec
anim_file = 'anim_cat.flc';

quiet = 1;
unflick  = 'unflick';
ppm2fli_ = 'ppm2fli';

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'rm1'),  rmFirst = vin{i+1};
  elseif isequal(vin{i},'size'), imsize  = vin{i+1};
  elseif isequal(vin{i},'fps'),  speed   = vin{i+1};
  elseif isequal(vin{i},'anim'), anim_file = vin{i+1};
  end
end

tmp={};
for i=1:length(files)
  f=files{i};
  tmp{i}=tempname;
  fprintf(1,':: extracting anim %s\n',f);
  [status,res]=system([unflick ' ' f ' ' tmp{i}]);
end

names={};
allnames={};
for i=1:length(files)
  d=dir([tmp{i} '.*']);

  % do not use 1st image, of 2nd, 3rd... anim, in case is the same as
  % last one of previous anim:
  j1=1;
  if i>1 & rmFirst
    j1=2;
  end

  % images to use:
  for j=j1:length(d)
    names{end+1}=[tempdir d(j).name];
  end

  % all names, to remove:
  for j=1:length(d)
    allnames{end+1}=[tempdir d(j).name];
  end

end

% find anim size:
if ~imsize
  if isunix
    [status,res]=unix(['file ' files{1}]); res=res(1:end-1);
    res=str_split(res);
    for i=1:length(res)
       if strfind(res{i},'width')==1
         width=res{i}(length('width')+2:end);
       elseif strfind(res{i},'height')==1
         height=res{i}(length('height')+2:end);
       end
    end
    imsize=['-g ' width 'x' height];
  else
    imsize='';
  end
else
  imsize=['-g ' imsize];
end

% find anim speed:
if ~speed
  if isunix
    [status,res]=unix(['file ' files{1}]); res=res(1:end-1);
    res=str_split(res);
    for i=1:length(res)
      if strfind(res{i},'ticks/frame')==1
       speed=res{i}(length('ticks/frame')+2:end);
     end
    end
    speed=['-s ' speed];
  else
    speed='';
  end
else
  speed=['-s ' num2str(1000/speed)];
end

% create file with list of images:
fileslist=tempname;
allnames{end+1}=fileslist;
fid=fopen(fileslist,'w');
for i=1:length(names)
  fprintf(fid,'%s\n',names{i});
end

% create new anim:
cmd=[ppm2fli_ ' '  imsize ' ' speed ' -N ' fileslist ' ' anim_file ];
system(cmd);

% remove tmp files:
for i=1:length(allnames)
  if ~quiet
    fprintf(1,' -> deleting file %s\n',allnames{i})
  end
  delete(allnames{i});
end
