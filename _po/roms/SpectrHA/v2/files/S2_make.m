function S2_make(what)
global HANDLES ETC FSTA
% fazer tudo duma vez...

isall=0
if nargin == 0
  what='all';
  isall=1
end

ismajor=0;
isminor=0;
isinc=0;
isphase=0;
isecc=0; %--------------- MMA 29-4-2004: add ECC
if isequal(what,'major') | isall
  ismajor=1;
end
if isequal(what,'minor') | isall
  isminor=1;
end
if isequal(what,'inc') | isall
  isinc=1;
end
if isequal(what,'phase') | isall
  isphase=1;
end
%--------------- MMA 29-4-2004: add ECC
if isequal(what,'ecc') | isall
  isecc=1;
end
%------------- end

location='Avr'
%location='Lx'
%location='Si'
%location='Fr'

set(HANDLES.all_many_z,'value',1)
set(HANDLES.no_depth,'value',1)
S2_hide_ax('on');
S2_cla;

if ismajor
S2_radio_e('major');
  type='     MAJOR';
  set(HANDLES.no_mean,'value',0);
  fname=[location,'_major_noH'];
  tit=['~',location,'    ',sprintf('%4.1f ºN',FSTA.lat),type,'  -Z'];
  do_all(fname,tit)
  set(HANDLES.no_mean,'value',1);
  fname=[location,'_major_noH_noM'];
  tit=[tit,'  -Mean'];
  do_all(fname,tit)
end

if isminor
S2_radio_e('minor');
  type='     MINOR';
  set(HANDLES.no_mean,'value',0);
  fname=[location,'_minor_noH'];
  tit=['~',location,'    ',sprintf('%4.1f ºN',FSTA.lat),type,'  -Z'];
  do_all(fname,tit)

  set(HANDLES.no_mean,'value',1);
  fname=[location,'_minor_noH_noM'];
  tit=[tit,'  -Mean'];
  do_all(fname,tit)
end

if isinc
S2_radio_e('inc');
  type='     INC';
  set(HANDLES.no_mean,'value',0);
  fname=[location,'_inc_noH'];
  tit=['~',location,'    ',sprintf('%4.1f ºN',FSTA.lat),type,'  -Z'];
  do_all(fname,tit)

  set(HANDLES.no_mean,'value',1);
  fname=[location,'_inc_noH_noM'];
  tit=[tit,'  -Mean'];
  do_all(fname,tit)
end

if isphase
S2_radio_e('phase');
  type='     PHASE';
  set(HANDLES.no_mean,'value',0);
  fname=[location,'_phase_noH'];
  tit=['~',location,'    ',sprintf('%4.1f ºN',FSTA.lat),type,'  -Z'];
  do_all(fname,tit)

  set(HANDLES.no_mean,'value',1);
  fname=[location,'_phase_noH_noM'];
  tit=[tit,'  -Mean'];
  do_all(fname,tit)
end

%--------------- MMA 29-4-2004: add ECC
if isecc
S2_radio_e('ecc');
  type='     ECC';
  set(HANDLES.no_mean,'value',0);
  fname=[location,'_ecc_noH'];
  tit=['~',location,'    ',sprintf('%4.1f ºN',FSTA.lat),type,'  -Z'];
  do_all(fname,tit)

  set(HANDLES.no_mean,'value',1);
  fname=[location,'_ecc_noH_noM'];
  tit=[tit,'  -Mean'];
  do_all(fname,tit)
end

%----------------------- end
%=====================================================================
function do_all(fname,tit)

global HANDLES

tides=get(HANDLES.tides,'string');
ntides=size(tides,1);

for i=1:ntides
  tide=tides(i,1:2);
  set(HANDLES.tides,'value',i);
  S2_allZ;
  S2_color
  S2_release

  tit2=[tit,'  ',tide]; 
  h=title(tit2);
  set(h,'FontSize',14,'FontWeight','bold')
 
  fname1=strrep(fname,'noH',[tide,'_noH']);
  fname2=[fname1,'.ps'];

  disp(['#####  ',fname2])
  print('-dpsc2',fname2);
  close
end

