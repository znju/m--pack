function animate(self,ts,te,dt,what)
%   ANIMATE method for class slice
%   Creates FLI animation
%   ANIMATE(OBJ,I1,I2,DI,TYPE)
%   TYPE = 'time' (default) or 'indice'

% MMA, martinho@fis.ua.pt
% 24-07-2005

hold off

if nargin < 5
  what = 'time';
end

if ~ismember(what,{'time','indice'})
  disp([':: wrong animate option : ',what]);
  return
end

out = get(self,'slice_info');
is2d    = out.is2d;
is3d    = out.is3d;

% if figure already open, get limits:
fig = figfind(self);
set_limits = 0;
set_caxis  = 1;
if ~isempty(fig)
  self = limits(self,'get');
  set_limits = 1;

  % about caxis:
   cax = get(self,'slice_caxis');
   if isempty(cax)
     self = set(self,'slice_caxis',caxis);
     set_caxis = 1;
  end
end

% --------------------------------------------------------------------
cont = 0;
for t=ts:dt:te
  if isequal(what,'time')
    self = set(self,'time',t);
  elseif isequal(what,'indice')
    self = set(self,'indice',t);
  end

  self = runslice(self);
  % if limits are not set, invent:
  if ~set_limits & t==ts
    limits(self,'nice');
    self = limits(self,'get');
  end
  self = limits(self,'set');

  % about caxis:
  if ~isequal(set_caxis,1)
    set(self,'slice_caxis',caxis);
  end

   drawnow
   cont = cont+1;
   if ispc
     tifs{cont} = get_tiff(t,'image','tif','-dtiff -r0');
   else
     tifs{cont} = get_tiff(t);
   end
end
% --------------------------------------------------------------------
if isunix
  ppms = tiff2ppm('',tifs);
else
  pngs = tiff2ppm('',tifs,'png');
end

% output anim filename:
% gen unique time
t = datevec(now);
t = sprintf('%.0f_%.0f_%.0f_%.0f_%.0f_%.0f',t);
UnixAnimName = ['anim_',t,'.flc'];
PcAnimName   = ['anim_',t];

% frames per sec:
fps = 5;

% anim size:
fs = get(gcf,'position');
animDim = sprintf('%gx%g',fs(3),fs(4));

if isunix
  ppm2fli(ppms,UnixAnimName,fps,animDim);
else
  %dtaDir = input(':: please enter the DTA.EXE location, ex: c:\\dta\\  : ','s');
  dtaDir = uigetdir(pwd, 'Select the DTA.EXE Directory'); dtaDir = [dtaDir,filesep];
  dta2fli(pngs,PcAnimName,dtaDir);
end

% delete temp files:
doDelete = input(':: delete temporary files (0/1) ? ');
if doDelete
  for i=1:length(tifs)
    delete(tifs{i});
    if isunix
      delete(ppms{i});
    else
      delete(pngs{i});
    end
  end
end

if isunix
  eval(['!xanim ',UnixAnimName],'');
else
  eval(['! ',PcAnimName,'.flc']);
end
