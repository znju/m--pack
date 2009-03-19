function R_pointer(what)
global H

showi   = H.ROMS.grid.i;
showj   = H.ROMS.grid.j;
showlon = H.ROMS.grid.lon;
showlat = H.ROMS.grid.lat;
evalc('pointercr = H.ROMS.pointer.cross  ;',  '');
evalc('pointersq = H.ROMS.pointer.square ;',  '');
evalc('pointeri  = H.ROMS.pointer.linei  ;',  ''); % lon x lat
evalc('pointerj  = H.ROMS.pointer.linej  ;',  ''); % lon x lat
evalc('pointerXi   = H.ROMS.pointer.lineXi     ;',  ''); % i x j
evalc('pointerEta  = H.ROMS.pointer.lineEta    ;',  ''); % i x j
evalc('pointerXim   = H.ROMS.pointer.lineXim   ;',  ''); % i x j, marker
evalc('pointerEtam  = H.ROMS.pointer.lineEtam  ;',  ''); % i x j, marker


% set visible lines:
ij     = H.menu_guidesij;
lonlat = H.menu_guideslonlat;
none   = H.menu_guidesnone;
both   = H.menu_guidesboth;

visible_ij     = get(ij,    'checked');
visible_lonlat = get(lonlat,'checked');
if isequal(get(both,'checked'),'on')
  visible_ij     = 'on';
  visible_lonlat = 'on';
end


% lon, lat variables:
lonr=H.ROMS.lonr;
latr=H.ROMS.latr;

% colors:
cax                 = H.theme.inctfg;
color_XiEta         = [.38 .576 .851];
color_XiEtam        = [0 0 0];
color_lonlat        = cax;
color_lonlat_marker = [0 0 0];
color_cross_on      = [0 0 0];
color_cross_off     = cax;
color_square_on     = cax;
color_square_off    = [0 0 0];


% --------------------------------------------------------------------
% edit lon and lat
% --------------------------------------------------------------------
if isequal(what,'lon') | isequal(what,'lat')
  lon=str2num(get(showlon,'string'));
  lat=str2num(get(showlat,'string'));
  if isnumber(lon,1) & isnumber(lat,1)
    set(pointersq,'xdata',lon,'ydata',lat);
    set(pointercr,'xdata',lon,'ydata',lat);

    % update string I x J:
    dist=(lonr-lon).^2 + (latr-lat).^2;
    [j,i]=find(dist==min(min(dist)));
    set(showi,'string',i);
    set(showj,'string',j);

    % move lines lon x lat:
    set(pointeri,'xdata',[lon lon],'ydata',[min(min(latr)) max(max(latr))]);
    set(pointerj,'xdata',[min(min(lonr)) max(max(lonr))],'ydata',[lat lat]);

    % move lines i x j:
    set(pointerXi, 'xdata',lonr(:,i),'ydata',latr(:,i));
    set(pointerEta,'xdata',lonr(j,:),'ydata',latr(j,:));
    % markers:
    set(pointerXim, 'xdata',lonr([1 end],i),'ydata',latr([1 end],i));
    set(pointerEtam,'xdata',lonr(j,[1 end]),'ydata',latr(j,[1 end]));
  end
end

% --------------------------------------------------------------------
% edit i and j
% --------------------------------------------------------------------
if isequal(what,'i') | isequal(what,'j')
  I=str2num(get(showi,'string'));
  J=str2num(get(showj,'string'));
  if isnumber(I,1) & isnumber(J,1) & I <= size(lonr,2) & J <= size(lonr,1)
    set(pointersq, 'xdata',lonr(J,I),'ydata',latr(J,I));
    set(pointercr, 'xdata',lonr(J,I),'ydata',latr(J,I));

    % update string lon x lat:
    set(showlon,'string',lonr(J,I));
    set(showlat,'string',latr(J,I));

    lon=lonr(J,I);
    lat=latr(J,I);

    % move lines lon x lat:
    set(pointeri,'xdata',[lon lon],'ydata',[min(min(latr)) max(max(latr))]);
    set(pointerj,'xdata',[min(min(lonr)) max(max(lonr))],'ydata',[lat lat]);

    % move lines i x j:
    i=I; j=J;
    set(pointerXi,  'xdata',lonr(:,i),'ydata',latr(:,i));
    set(pointerEta, 'xdata',lonr(j,:),'ydata',latr(j,:));
    % markers:
    set(pointerXim, 'xdata',lonr([1 end],i),'ydata',latr([1 end],i));
    set(pointerEtam,'xdata',lonr(j,[1 end]),'ydata',latr(j,[1 end]));
  end
end

% --------------------------------------------------------------------
% init
% --------------------------------------------------------------------
if isequal(what,'init')
  % draw it:
  [J,I]=size(lonr);
  halfJ=round(J/2);
  halfI=round(I/2);
  lon=lonr(halfJ,halfI);
  lat=latr(halfJ,halfI);
  H.ROMS.pointer.square = plot(lon,lat,'s','EraseMode','xor','color',color_square_off);
  H.ROMS.pointer.linei  = plot([lon lon],[min(min(latr)) max(max(latr))],'r-s','EraseMode','xor','visible','off','color',color_lonlat,'markeredgecolor',color_lonlat_marker);
  H.ROMS.pointer.linej  = plot([min(min(lonr)) max(max(lonr))],[lat lat],'r-s','EraseMode','xor','visible','off','color',color_lonlat,'markeredgecolor',color_lonlat_marker);
  H.ROMS.pointer.cross  = plot(lon,lat,'+','markerSize',20,'EraseMode','xor','color',color_cross_off);

  % show vals:
  set(showj,   'string',halfJ);
  set(showi,   'string',halfI);
  set(showlon, 'string',lon);
  set(showlat, 'string',lat);

  % i x j:
  i=I;j=J;
  H.ROMS.pointer.lineXi   = plot(lonr(:,i),latr(:,i),'erasemode','xor','visible','off','color',color_XiEta);
  H.ROMS.pointer.lineEta  = plot(lonr(j,:),latr(j,:),'erasemode','xor','visible','off','color',color_XiEta);
  % marker:
  H.ROMS.pointer.lineXim  = plot(lonr([1 end],i),latr([1 end],i),'+','erasemode','xor','visible','off','color',color_XiEtam,'markersize',8);
  H.ROMS.pointer.lineEtam = plot(lonr(j,[1 end]),latr(j,[1 end]),'+','erasemode','xor','visible','off','color',color_XiEtam,'markersize',8);

  set(gcf,'WindowButtonDownFcn','R_pointer(''get'')');
end

% --------------------------------------------------------------------
% get
% --------------------------------------------------------------------
if isequal(what,'get')
  if isequal(gco,pointersq)  |  isequal(gco,pointercr)
    set(gcf,'WindowButtonMotionFcn','R_pointer(''move'')');

    set(pointeri,'visible',visible_lonlat);
    set(pointerj,'visible',visible_lonlat);

    set(pointerXi,  'visible',visible_ij);
    set(pointerEta, 'visible',visible_ij);
    set(pointerXim, 'visible',visible_ij);
    set(pointerEtam,'visible',visible_ij);

    % change color of square and cross:
    set(pointersq,'color',color_square_on);
    set(pointercr,'color',color_cross_on);
  end
end

% --------------------------------------------------------------------
% move
% --------------------------------------------------------------------
if isequal(what,'move')
  cp=get(gca,'CurrentPoint');
  set(pointersq,'xdata',cp(1,1),'ydata',cp(1,2));
  set(pointercr,'xdata',cp(1,1),'ydata',cp(1,2));
  set(gcf,'WindowButtonUpFcn','R_pointer(''stop'')');

  % show position lon x lat:
  set(showlon,'string',sprintf('%8.4f',cp(1,1)));
  set(showlat,'string',sprintf('%8.4f',cp(1,2)));

  % show  position: I x J:
  lon=cp(1,1);
  lat=cp(1,2);
  dist=(lonr-lon).^2 + (latr-lat).^2;
  [j,i]=find(dist==min(min(dist))); i=i(1); j=j(1);
  set(showi,'string',i);
  set(showj,'string',j)

  % move lines lon x lat:
  set(pointeri,'xdata',[lon lon],'ydata',[min(min(latr)) max(max(latr))]);
  set(pointerj,'xdata',[min(min(lonr)) max(max(lonr))],'ydata',[lat lat]);

  % move lines i x j:
  set(pointerXi,  'xdata',lonr(:,i),'ydata',latr(:,i));
  set(pointerEta, 'xdata',lonr(j,:),'ydata',latr(j,:));
  % markers:
  set(pointerXim, 'xdata',lonr([1 end],i),'ydata',latr([1 end],i));
  set(pointerEtam,'xdata',lonr(j,[1 end]),'ydata',latr(j,[1 end]));

end

% --------------------------------------------------------------------
% stop
% --------------------------------------------------------------------
if isequal(what,'stop')
  set(gcf,'WindowButtonMotionFcn','');
  set(gcf,'WindowButtonUpFcn','');

  % allow hide lines when using mouse righy button:
  button=get(gcf,'selectiontype');
  % normal = left mouse button
  % alt    = rigth mouse button
  % extend = third (wheel) mouse button
  if isequal(button,'alt') & (isequal(gco,pointersq)  |  isequal(gco,pointercr))
    set(pointeri,    'visible','off');
    set(pointerj,    'visible','off');
    set(pointerXi,   'visible','off');
    set(pointerEta,  'visible','off');
    set(pointerXim,  'visible','off');
    set(pointerEtam, 'visible','off');
  end

  % bring pointer square up:
  handles = get(gca,'children');
  if handles(1) ~= pointersq
    ud_handles(pointersq,'top')
  end

  % change color of square and cross:
  set(pointersq,'color',color_square_off);
  set(pointercr,'color',color_cross_off);

  % keep fcn to restore after use draw-bar: (see R_drawbar)
  H.ROMS.fcn.down   = get(gcf,'WindowButtonDownFcn');
  H.ROMS.fcn.motion = get(gcf,'WindowButtonMotionFcn');
  H.ROMS.fcn.up     = get(gcf,'WindowButtonUpFcn');
end
