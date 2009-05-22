function anim_file=resize_anim(anim,varargin)
%RESIZE_ANIM   Resize FLI/FLC animation
%   More than resize, any option of ANIM_FLI can be used, like crop
%   for instance.
%
%   Syntax:
%      RES = RESIZE_ANIM(ANIM,VARARGIN)
%
%   Inputs:
%      ANIM       FLI/FLC animations to change
%      VARARGIN:
%         out, name, output animation name, by default, if ANIM is
%           anim.flc, RES will be anim_resized.flc
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
%     res=resize_anim('myanim.flc','crop',[20 0 0 0], 'resize',70)
%     % will crop 20 px at top and resize 70%; res will be
%     % myanim_resized.flc
%
%     res=resize_anim('myanim.flc','resize',80,'out','new_anim.flc')
%     % will resize 80% creating the animation RES='new_anim.flc'
%
%   MMA 21-04-2009, mma@odyle.net
%   fully rewritten from original version of 16-07-2004
%
%   See also ANIM_FLI, CAT_ANIMS, APPEND_ANIMS

[p,name,ext]=fileparts(anim);
anim_file=fullfile(p,[name '_resized' ext]);

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'out')
    anim_file=vin{end+1};
  end
end

% extract fli images:
tmp=tempname;
[status,res]=system(['unflick  ' anim ' ' tmp]);

d=dir([tmp '.*']);
names=cell(length(d),1);
for i=1:length(d)
  names{i}=[tempdir d(i).name];
end

% create resized fli:
anim_fli(names,anim_file,varargin{:});

% delete tmp fli images:
for i=1:length(names)
  delete(names{i})
end
