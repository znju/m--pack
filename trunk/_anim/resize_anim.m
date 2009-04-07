function resize_anim(anim,geometry,g,fps)
%RESIZE_ANIM   Resize FLI/FLC animation
%
%   Syntax:
%      RESIZE_ANIM(ANIM,GEOMETRY,G,FPS)
%
%   Inputs:
%      ANIM       FLI/FLC animations to join (side by side)
%      GEOMETRY   Convert geometry [ <num>% <WxH>% ]
%      G          Size of final anim [ <width x height> {<none>} ]
%      FPS        Frames per second of final animation [ 5 ]
%
%   Result:
%      anim_resized.flc
%
%   Comments:
%      ppm2fli, unflick and convert need to be installed. Runs on UNIX
%      like machines.
%      If there is no easy way to know GEOMETRY you may extract one
%      frame with unflick:
%      unflick -b 1 -n 1 anim.flc img
%
%   Example:
%      resize_anim('anim.flc','70%','600x300',5)
%
%   MMA 16-7-2004, martinho@fis.ua.pt
%
%   See also APPEND_ANIM

%   Department of Physics
%   University of Aveiro, Portugal

anim_file='anim_resized.flc';

if nargin < 4
  fps=5;
end
if nargin < 3
  g='';
else
 g=['-g ',g];
end
if nargin < 2
  disp('# nothing to do...');
  return
end

unix(['unflick ',anim,' anim_K']);

%%%%%lista_1=ls(['-1 anim_1.*',]);
d=dir('anim_K.*')
for i=1:length(d)
  name_1{i}=d(i).name;
end

%%a=find(lista_1=='.');
%%if length(a) == 1
%%  l=length(lista_1)
%%else
%%  l=a(2)-a(1);
%%end
%
%N=length(a);
%%for i=1:N
%%  name_1(i,:)=lista_1(1+l*(i-1):l*i-1);
%%end

for i=1:length(name_1)
  disp(['# resizing ', name_1{i}]);
  %unix(['convert -geometry ',geometry,' ', name_1(i,:),' ',name_1(i,:)]);
  unix(['convert -depth 8 -geometry ',geometry,' ', name_1{i},' ',name_1{i}]);
end

speed=1000/fps;
s=['-s ',num2str(speed)];
unix(['ls -1 anim_K.* > lista']);
unix(['ppm2fli ',g,' ',s,'  -N lista ',anim_file]);

unix(['rm anim_K.*']);
unix(['rm lista']);
