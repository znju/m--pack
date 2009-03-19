function S2_release_ell

global ETC HANDLES FSTA

ETC.new.fig=figure;
ETC.new.fig2=figure;

tides=get(HANDLES.tides,'string');
ntides=size(tides,1);
for i=1:ntides
  set(HANDLES.tides,'value',i)
  S2_hide_ax('off');
  S2_allZ
  hold off
  figure(ETC.new.fig);
  a=subplot(4,2,i);
  S2_release(a);
  S2_hide_ax('on');

  figure(ETC.new.fig2)
  subplot(4,2,i);
  x0=ETC.new.x0(1,:);
  y0=ETC.new.x0(2,:);
  for nz = 1:length(ETC.new.ecc)
    ecc=ETC.new.ecc(nz);
    if ecc > 0
      marker='+';
    else
      marker='.';
    end
    pp=plot(x0(nz),y0(nz),'k'); set(pp,'marker',marker); hold on
  end
  p=plot(x0,y0,'k-');
  plot(x0(1),y0(1),'ro')
  axis equal
  title([tides(i,:),'  sta: ',num2str(FSTA.i)]);
end

figure(ETC.new.fig2);
all_strings('helvetica',5)
ss=get(0,'ScreenSize');sh=ss(4);
set(gcf,'units','pixels');
fp=get(gcf,'position');
fp=[fp(1) sh*.1 fp(3) sh*.8];
set(gcf,'position',fp);
see_get(gcf,1)

figure(ETC.new.fig);
all_strings('helvetica',5)
