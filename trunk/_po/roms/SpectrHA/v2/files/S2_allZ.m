function S2_allZ

global HANDLES ETC LOOK

draw_ellipses=0;
val=get(HANDLES.spectrum_axes,'visible');
if isequal(val,'on') & S_isplotted('ellipse')
  draw_ellipses=1;
else

  ismajor = get(HANDLES.major_box,'value');
  isminor = get(HANDLES.minor_box,'value');
  isinc   = get(HANDLES.inc_box,'value');
  isphase = get(HANDLES.phase_box,'value');
%-------------------- MMA, 29-4-2004: add ECC
  isecc   = get(HANDLES.ecc_box,'value');
%---------------------------------------------- end

  isamp   = get(HANDLES.amp_box,'value');
  ispha   = get(HANDLES.pha_box,'value');

  if isequal(get(HANDLES.major, 'enable'),'off');
    ismajor = 0;
    isminor = 0;
    isinc   = 0;
    isphase = 0;
    isecc   = 0; %-------------------- MMA, 29-4-2004: add ECC
  end
  if isequal(get(HANDLES.amp, 'enable'),'off');
    isamp   = 0;
    ispha   = 0;
  end


  if ismajor
    S2_plot('major')
  elseif isminor
    S2_plot('minor')
  elseif isinc
    S2_plot('inc')
  elseif isphase
    S2_plot('phase')
  elseif isamp
    S2_plot('amp');
  elseif ispha
    S2_plot('pha');
%-------------------- MMA, 29-4-2004: add ECC
  elseif isecc
    S2_plot('ecc');
%---------------------------------------------- end
  end
end

%------------------------------------------------------- draw_ellipse:
if draw_ellipses
  S2_hide_ax('on');
  
  sta=get(HANDLES.z_many,'value');
  tide=get(HANDLES.tides,'value');
  
  nz=size(ETC.new.many_depth_tidestruc,2);
 
  for i=1:nz
    S_pointer('watch')
   
    major = ETC.new.many_depth_tidestruc(sta,i,tide,1);
    minor = ETC.new.many_depth_tidestruc(sta,i,tide,3);
    inc   = ETC.new.many_depth_tidestruc(sta,i,tide,5);
    phase = ETC.new.many_depth_tidestruc(sta,i,tide,7);

    color=get(ETC.ellipse(tide),'color');

    h=plot_ellipse(major,minor,inc,phase,[0 0]);
    set(h,'color',color);
    S2_axes_prop;
    axis equal
    hold on
    h=plot_axis(major);
    set(h,'color',LOOK.color.plot_axis);

    ecc=minor/major;
    [Au, PHIu, Av, PHIv]=ep2ap(major,ecc,inc,phase);
    x(i)=Au*cos(-PHIu*pi/180);
    y(i)=Av*cos(-PHIv*pi/180);
    plot(x,y,'r-+');    

    set(HANDLES.z_hold,'value',1)
    drawnow

    S_pointer
    ETC.new.ecc(i)=ecc;
  end
 ETC.new.x0=[x;  y]; 

 ETC.new.leg=[];
 delete(legend)
 tides=get(HANDLES.tides,'string');
 stas=get(HANDLES.z_many,'string');
 tide=tides(tide,:);
 sta=stas(sta,:);
 title([tide,' sta: ',num2str(sta)]);
end
