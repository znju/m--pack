function S2_calc

global HANDLES ETC LOOK FSTA


ETC.new.many_depth_tidestruc=[];
ETC.tidestruc.tidecon=[];

stations=get(HANDLES.z_many,'string');
stations=str2num(stations);
for nsta=1:size(stations,1)
  set(HANDLES.z_many,'value',nsta);
  cont=0; 
  xe=[];
  ye=[];
  x0=[];
  y0=[];
  set(HANDLES.selectN,'string',num2str(stations(nsta,:)));
  S2_select(2);
  set(HANDLES.zcheck,'value',1);
  val=get(HANDLES.depths,'string');
  val=str2num(val);
  for i=1:length(val)        
    set(HANDLES.zlevel,'string',val(i));

    S2_hide_ax('off'); % hide stpectrum_axes
    S_lsf
%   S_fsa
%   S_t_tide

    if isempty(ETC.tidestruc.tidecon)
      return
    end
    if i==1 % first time(depth) is more than enough
      if isempty(ETC.tidestruc.name)
        set(HANDLES.tides,'string',1./ETC.tidestruc.freq);
      else
        set(HANDLES.tides,'string',ETC.tidestruc.name);
      end
    end
    set(HANDLES.depths,'value',i) 

  % plot phases:
  if ~S_isserie
    major = ETC.tidestruc.tidecon(:,1);
    minor = ETC.tidestruc.tidecon(:,3);
    inc   = ETC.tidestruc.tidecon(:,5);
    pha   = ETC.tidestruc.tidecon(:,7);
    ecc=minor./major;
    [Au, PHIu, Av, PHIv]=ep2ap(major,ecc,inc,pha);
    h=ishold;
    for t=1:length(Au)
      x=Au(t)*cos(-PHIu(t)*pi/180);
      y=Av(t)*cos(-PHIv(t)*pi/180);
      x0(i,t)= x;
      y0(i,t)= y;
      hold on
      if t < 5, color=LOOK.color.z_fg; else, color='g'; end
      marker='+'; 
      plot(x0(:,t),y0(:,t),'marker',marker,'color',color);
      if ecc(t) < 0
        cont=cont+1;
        xe(cont)=x;
        ye(cont)=y;
        plot(xe,ye,'.','color',[0 1 1]);
      end
    end
    if ~h
      hold off
    end
  end


    ETC.new.many_depth_tidestruc(nsta,i,:,:)=ETC.tidestruc.tidecon;
    drawnow

  end % for depths
end % for nsta 


if S_isserie
  set(HANDLES.major, 'enable','off');
  set(HANDLES.minor, 'enable','off');
  set(HANDLES.inc,   'enable','off');
  set(HANDLES.phase, 'enable','off');
  set(HANDLES.amp,   'enable','on');
  set(HANDLES.pha,   'enable','on');
else
  set(HANDLES.major, 'enable','on');
  set(HANDLES.minor, 'enable','on');
  set(HANDLES.inc,   'enable','on');
  set(HANDLES.phase, 'enable','on');
  set(HANDLES.amp,   'enable','off');
  set(HANDLES.pha,   'enable','off');
end

