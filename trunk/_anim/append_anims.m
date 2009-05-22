function anim_file=append_anims(anims,type,varargin)
%APPEND_ANIMS   Join FLI/FLC animations
%   Joins two or more FLI/FLC animations side by side or up-down.
%   The number of frames in the final animation will be the minimum
%   number of frames of the input animations.
%
%   Syntax:
%      APPEND_ANIMS(ANIMS,TYPE,VARARGIN)
%
%   Inputs:
%      ANIMS     FLI/FLC animations list as cell array
%      TYPE       Append type: side by side or up-down [ {'+'} '-' ]
%      VARARGIN:
%         out, name, output animation name, by default will be the
%           names of all animations sepparated by '_'
%         Any variable arguments of ANIM_FLI, currently:
%           fps, frames per second, default is 5
%           crop, px to crop at top, bottom, right, left [0 0 0 0]
%           resize, resize percentage, default=100% ie, no resize
%           options, any ppm2fli options
%
%   Output:
%      RES   Anim created, same as out, if provided as input argument
%
%   Examples:
%     res=append_anims({'myanim1.flc','myanim2.flc'}) % will create
%     % myanim1_myanim2.flc side by side (TYPE='+')
%
%     res=append_anims({'anim1.flc','anim2.flc'},'-','out','anim.flc')
%     % will create anim.flc, appending frames up-down
%
%     res=append_anims({'anim1.flc','anim2.flc'},''resize',80);
%     % will create anim1_anim2.flc resizing 80%
%
%   MMA 21-04-2009, mma@odyle.net
%
%   See also ANIM_FLI, CAT_ANIMS, RESIZE_ANIM

% Created from the function append_anim (2-2002), now deprecated.

anim_file='';
vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'out')
    anim_file=vin{end+1};
  end
end

% gen output file name:
if isempty(anim_file)
  for i=1:length(anims)
    [p,name,ext]=fileparts(anims{i});
    anim_file=[anim_file '_' name];
  end
  anim_file=[anim_file(2:end) ext];
end

% extract fli images:
names={};
for j=1:length(anims)
  tmp=tempname;
  [status,res]=system(['unflick  ' anims{j} ' ' tmp]);

  d=dir([tmp '.*']);
  for i=1:length(d)
    names{j,i}=[tempdir d(i).name];
  end
end

% find min length:
L=inf;
for i=1:size(names,1)
  l=size(names,2);
  for j=1:l
    if isempty(names{i,j})
      l=j-1;
      break;
    end
  end
  L=min(l,L);
end

% append images:
tmp=tempname;
for i=1:L
  tmpName{i}=sprintf('%s_%07d.ppm',tmp,i);
  ims='';
  for j=1:length(anims)
    ims=[ims ' ' names{j,i}];
  end
  cmd=sprintf('convert -depth 8 %sappend %s %s',type,ims,tmpName{i});
  fprintf(1,':: appending frame %d of %d\n',i,L);
  system(cmd);
end

% create new fli:
anim_fli(tmpName,anim_file,varargin{:});

% delete tmp files:
for i=1:size(names,1)
  for j=1:size(names,2)
    delete(names{i,j})
  end
end
for i=1:length(tmpName)
  delete(tmpName{i});
end
