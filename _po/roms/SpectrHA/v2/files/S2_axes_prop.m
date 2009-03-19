function S2_axes_prop

global HANDLES LOOK

%axes(HANDLES.spectrum_axes);

set(gca,'color',LOOK.color.z_bg); 
set(gca,'xcolor',LOOK.color.z_fg);
set(gca,'ycolor',LOOK.color.z_fg);

t=get(gca,'title');
x=get(gca,'xlabel');
y=get(gca,'ylabel');

set(t,'color',LOOK.color.z_fg);
set(x,'color',LOOK.color.z_fg);
set(y,'color',LOOK.color.z_fg);
