function S2_release(sp)
%nargin: axis or subplot

global HANDLES ETC

all_ell=get(HANDLES.free_ell,'value');
if all_ell & nargin ==0
  S2_release_ell
  return
end

leg=1;
if isempty(ETC.new.leg)
  leg=0;
end

if nargin == 0
  figure;
  a=axes;
else
  a=sp;
end

warning off
copy_axes(HANDLES.z_ax,a,'Z release',1)
if leg
  legend(ETC.new.leg);
end
warning on

fig=gcf;
S2_hide_ax('on')
figure(fig)

if nargin ==0
  ap=get(gca,'position');
  ap=[ap(1) .5 ap(3) ap(4)-(.5-ap(2))];
  set(gca,'position',ap);
else
  axis equal, box on
end

ss=get(0,'ScreenSize');sh=ss(4);
set(gcf,'units','pixels');
fp=get(gcf,'position');
fp=[fp(1) sh*.1 fp(3) sh*.8];
set(gcf,'position',fp);

if leg
  S2_legend([0 0 0],'courier')
  lp=get(legend,'position'); lh=lp(4); ll=lp(3);
  ap=get(gca,'position');
  lp=[.5-ll/2 ap(2)-lh-.1 ll lh];
  set(legend,'position',lp);
end

%see_get(gcf,1)
fixedar
