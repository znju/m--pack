function veltransf(Obj)
%   VELTRANS method for class slice
%   Deals with transformation of coords when using arrows with
%   vertical slices

% MMA, martinho@fis.ua.pt
% 8-2005

self = Obj;

out = get(self,'slice_info');
isvel = out.isvel;
ishoriz = out.ishoriz;
isi = out.isi;
isj = out.isj;
is2d = out.is2d;

if ~isvel | ishoriz
  return
end

[tx,ty,tz] = get(self,'vel_slice_transf');

show_bottom        = get(self,'bottom_show');
show_bathy         = get(self,'bathy_show');
show_bathyc        = ~isempty(get(self,'bathy_cvals'));
show_region_border = get(self,'border_show');
show_mask          = get(self,'mask_show');
show_zeta          = get(self,'zeta_show');
show_coastline     = get(self,'coastline_show');

if show_bottom
  handle  = getbytag(self,'bottom','search');
  if ~isempty(handle)
    if ishandle(handle), transf(handle,tx,ty,tz); end
  end
end
if show_zeta
  handle  = getbytag(self,'zeta','search');
  if ~isempty(handle)
    if ishandle(handle), transf(handle,tx,ty,tz); end
  end
end
if show_mask
  handle  = getbytag(self,'mask','search');
  if ~isempty(handle)
    if ishandle(handle), transf(handle,tx,ty,tz); end
  end
end

% also do it for the slice, if previos exist and is not vel:
handle  = getbytag(self,'the slice','search');
if ~isempty(handle)
  handle = handle(end);
  if ishandle(handle)
    dataTag = get(handle,'tag');
    prev_varname = getfromtag(self,dataTag,'variable');
    if ~ismember(prev_varname,{'vel','velbar'})
      transf(handle,tx,ty,tz);
    end
  end
end

% about ticks:
[x,y,z]=get(self,'bathy_data'); z=-z;
if isempty(x)
  [x,y,z]=get(self,'slice_data');
end
[xtick,ytick,ztick] = genticks(gca,x,y,z);
if is2d
  if isi
    xtick = ytick;
    ytick = ztick;
  elseif isj
    ytick = ztick;
  end
end
transf_ticks(xtick,ytick,ztick,tx,ty,tz);

function transf(handle,tx,ty,tz)
xd = get(handle,'xdata');
yd = get(handle,'ydata');
zd = get(handle,'zdata');
mx = tx(1); xi = tx(2); xif = tx(3);
my = ty(1); yi = ty(2); yif = ty(3);
mz = tz(1); zi = tz(2); zif = tz(3);
xd = mx*(xd-xi) + xif;
yd = my*(yd-yi) + yif;
zd = mz*(zd-zi) + zif;
set(handle,'xdata',xd,'ydata',yd,'zdata',zd);

function transf_ticks(xt,yt,zt,tx,ty,tz)
mx = tx(1); xi = tx(2); xif = tx(3);
my = ty(1); yi = ty(2); yif = ty(3);
mz = tz(1); zi = tz(2); zif = tz(3);
xts = mx*(xt-xi) + xif;
yts = my*(yt-yi) + yif;
zts = mz*(zt-zi) + zif;

set(gca,'xtick',xts,'xticklabel',xt)
set(gca,'ytick',yts,'yticklabel',yt)
set(gca,'ztick',zts,'zticklabel',zt)
