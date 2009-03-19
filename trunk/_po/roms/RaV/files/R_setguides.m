function R_setguides(what)
% set which grid guides to show

global H

ij     = H.menu_guidesij;
lonlat = H.menu_guideslonlat;
none   = H.menu_guidesnone;
both   = H.menu_guidesboth;

% uncheck all:
guides = {ij,lonlat,none,both};
for i=1:length(guides)
  set(guides{i},'checked','off');
end

% check current:
handle = ['H.menu_guides',what];
eval(['set(',handle,',''checked'',''on'');']);

% show/hide guides:
evalc('pointercr = H.ROMS.pointer.cross  ;',  'pointercr = nan;');
evalc('pointersq = H.ROMS.pointer.square ;',  'pointersq = nan;');
evalc('pointeri  = H.ROMS.pointer.linei  ;',  'pointeri  = nan;'); % lon x lat
evalc('pointerj  = H.ROMS.pointer.linej  ;',  'pointerj  = nan;'); % lon x lat
evalc('pointerXi   = H.ROMS.pointer.lineXi     ;',  'pointerXi   = nan;'); % i x j
evalc('pointerEta  = H.ROMS.pointer.lineEta    ;',  'pointerEta  = nan;'); % i x j
evalc('pointerXim   = H.ROMS.pointer.lineXim   ;',  'pointerXim  = nan;'); % i x j, marker
evalc('pointerEtam  = H.ROMS.pointer.lineEtam  ;',  'pointerEtam = nan;'); % i x j, marker
% hide all, except sq and cross
if ishandle(pointeri),     set(pointeri,    'visible','off'), end
if ishandle(pointerj),     set(pointerj,    'visible','off'), end
if ishandle(pointerXi),    set(pointerXi,   'visible','off'), end
if ishandle(pointerEta),   set(pointerEta,  'visible','off'), end
if ishandle(pointerXim),   set(pointerXim,  'visible','off'), end
if ishandle(pointerEtam),  set(pointerEtam, 'visible','off'), end
% show choosen:
if isequal(what,'ij') | isequal(what,'both')
  set(pointerXi,    'visible','on')
  set(pointerEta,   'visible','on')
  set(pointerXim,   'visible','on')
  set(pointerEtam,  'visible','on')
end
if isequal(what,'lonlat') | isequal(what,'both')
  set(pointeri,     'visible','on')
  set(pointerj,     'visible','on')
end

