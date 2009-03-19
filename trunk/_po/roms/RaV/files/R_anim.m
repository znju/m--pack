function R_anim(do)

global H

evalc('fname=H.ROMS.his.fname','fname=[]');
if isempty(fname)
  return
end

% t1, t2, dt:
t1 = H.ROMS.ANIM.t1;
t2 = H.ROMS.ANIM.t2;
dt = H.ROMS.ANIM.dt;

% --------------------------------------------------------------------
% preview
% --------------------------------------------------------------------
if isequal(do,'preview')
  % use intermediate time index:
  t=round((t1+t2)/2);
  wdlg=warndlg({'creating tiff preview','please wait'},'','modal');
  createfig(t,'preview',wdlg);
end

% --------------------------------------------------------------------
% animate
% --------------------------------------------------------------------
if isequal(do,'ok')
  for t=t1:dt:t2
     createfig(t,'anim');
  end
  ppm2fli('*.ppm','anim.flc',5,'300x500');
end

% --------------------------------------------------------------------

function createfig(t,what,handle)
global H
% get data:
% colors:
xcolor = H.ROMS.ANIM.xcolor;
ycolor = H.ROMS.ANIM.ycolor;
tcolor = H.ROMS.ANIM.tcolor;
acolor = H.ROMS.ANIM.acolor;
fcolor = H.ROMS.ANIM.fcolor;

% axis off, caxis and fig  pos:
axoff   = H.ROMS.ANIM.axoff;
cax     = H.ROMS.ANIM.caxis;
figposs = H.ROMS.ANIM.figpos;

% settings:
% avoid other fig;
set(H.ROMS.his.newfig,'value',0);
set(H.ROMS.his.tindex,'string',t);
R_disp;

set(gcf,'InvertHardcopy','off');

cax = gca;
color_bar = H.ROMS.output_figure.colorbar;
set(cax,'xcolor', xcolor);
set(cax,'ycolor', ycolor);
set(cax,'color',  acolor);
set(gcf,'color',  fcolor);
% colorbar:
set(color_bar,'xcolor', xcolor);
set(color_bar,'ycolor', ycolor);
% title:
tl = get(cax,'title');
set(tl,'color',tcolor);


if axoff
  axis off
end

if isequal(what,'preview')
  fname=get_tiff(t,'preview_img');
  if ishandle(handle)
    close(handle);
  end
  dsp(fname);
end
if isequal(what,'anim')
  get_tiff(t,'image','tif','-dtiff','ppm','-geometry 70%');
end
