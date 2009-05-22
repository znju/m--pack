function fli2mpeg(fli,mpeg,varargin)
%FLI2MPEG   Convert FLI animation to mpeg formats
%   Extracts fli frames with system unflick and creates mpeg with
%   function ANIM_MPEG.
%
%   Syntax:
%      FLI2MPEG(FLI,MPEG,VARARGIN)
%
%   Inputs:
%      FLI   Fli animation file name
%      MPEG   Output filename (by default, if FLI is /path1/.../a.fli
%             MPEG will be ./a.mpeg, ie, placed in working dir)
%      VARARGIN:
%         Varargin of ANIM_MPEG
%
%   Example:
%      fli.mpeg('/data1/anim.flc','/data2/anim.mpeg')
%
%   MMA 02-04-2009, mma@odyle.net
%   CESAM, Portugal
%
%   See also ANIM_FLI, ANIM_MPEG, FLI2MPEG

if nargin<3
  [pathstr,name,ext] = fileparts(fli);
  mpeg=[name '.mpeg'];
  fprintf(1,':: will create %s\n',mpeg);
end

% extract fli images:
tmp=tempname;
[status,res]=system(['unflick  ' fli ' ' tmp]);

d=dir([tmp '.*']);
names=cell(length(d),1);
for i=1:length(d)
  names{i}=[tempdir d(i).name];
end

% create mpeg:
anim_mpeg(names,mpeg,varargin)

% delete tmp fli images:
for i=1:length(names)
  delete(names{i})
end
