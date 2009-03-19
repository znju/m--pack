function S2_plot(var)

global HANDLES ETC

if get(HANDLES.all_many_z,'value')
  stations=get(HANDLES.z_many,'string');
  stations=str2num(stations);
  NSTA=size(stations,1);
  
  set(HANDLES.z_hold,'value',0);
  S2_hold; % hold off

  for nsta=1:NSTA
    if nsta==2
      set(HANDLES.z_hold,'value',1);
      S2_hold; % hold on
    end

    set(HANDLES.z_many,'value',NSTA-nsta+1); %start from last
    S2_many;

    S2_zellipse(var,num2str(nsta));
    drawnow
  end
else
  nlines=findobj(gca,'tag','myline');
  nlines=length(nlines);
  if ~ishold 
    nlines=0;
  end
  S2_zellipse(var,num2str(nlines+1));
end
