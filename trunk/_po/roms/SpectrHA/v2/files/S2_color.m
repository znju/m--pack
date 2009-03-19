function S2_color

global HANDLES


color=[1 0 0;
       0 1 0;
       0 0 1;
       1 1 0;
       0 0 0;
       1 0 1;
       0 1 .7;
       .03 1 1];
%       1 .612 0;
%       1 .53 .421;] ;
ncolors=size(color,1);

color=flipud(color);

ch=get(HANDLES.z_ax,'children');

cont=0;
for i=1:length(ch)
  if isequal(get(ch(i),'tag'),'myline')
    cont=cont+1;
    if cont <= ncolors
      set(ch(i),'color',color(cont,:));
    end
  end
end

S2_hide_ax('on'); % hide spectrum axes

