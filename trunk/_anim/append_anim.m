function append_anim(anim1,anim2,geometry,g,fps,type)
%APPEND_ANIM   Join two FLI/FLC animations
%   Joins two FLI/FLC animations side by side or up-down.
%
%   Syntax:
%      APPEND_ANIM(ANIM1,ANIM2,GEOMETRY,G,FPS,TYPE)
%
%   Inputs:
%      ANIM1      Left (up) animation
%      ANIM2      Right (down) animation
%      GEOMETRY   Convert scale factor [ '100%' ]
%      G          Size of final anim [ <width x height> {<none>} ]
%      FPS        Frames per second of final animation [ 5 ]
%      TYPE       Append type: side by side or up-down [ {'+'} '-' ]
%
%   Result:
%      anim_ap.flc
%
%   Requirements:
%      Runs on UNIX machines and requires ppm2fli, unflick and convert
%
%   Comment:
%      Anims may have different number of frames. The final animation
%      will have the minimum of them.
%
%   Example:
%      append_anim('anim1.flc','anim2.flc','70%','600x300',5)
%
%   MMA 2-2002, martinho@fis.ua.pt
%
%   See also PPM2FLI, TIFF2PPM, GET_TIFF, RESIZE_ANIM

%   Department of Physics
%   University of Aveiro, Portugal

%   16-07-2004 - Added TYPE argument

anim_file='anim_ap.flc';

if nargin < 6
  type='+';
end
if nargin < 5
  fps=5;
end
if nargin < 4
  g='none';
end
if nargin < 3
  geometry='100%';
end

unix(['unflick ',anim1,' anim_1']);
unix(['unflick ',anim2,' anim_2']);

lista_1=ls(['-1 anim_1.*',]);
lista_2=ls(['-1 anim_2.*',]);

a=find(lista_1=='.');
a_2=find(lista_2=='.');
if length(a) == 1
  l=length(lista_1)
else
  l=a(2)-a(1);
end

N=min(length(a),length(a_2));
for i=1:N
  name_1(i,:)=lista_1(1+l*(i-1):l*i-1);
  name_2(i,:)=lista_2(1+l*(i-1):l*i-1);
  name_3(i,:)=strcat(name_1(i,:),'_', name_2(i,:));
end

for i=1:N
  disp(['# appending ', name_1(i,:),' with ',name_2(i,:)]);
  unix(['convert -geometry ',geometry,' ',type,'append ', name_1(i,:),' ',name_2(i,:),' ',name_3(i,:)]);
end

speed=1000/fps;
s=['-s ',num2str(speed)];
unix(['ls -1 anim_1.*_anim_2.* > lista']);
if isequal(g,'none');
  unix(['ppm2fli ',s,'  -N lista ',anim_file]);
else
  unix(['ppm2fli -g ',g,' ',s,'  -N lista ',anim_file]);
end

unix(['rm anim_1.*']);
unix(['rm anim_2.*']);
unix(['rm lista']);
