function S_choose(what)
%function S_choose(what)
%controls SpectrHA radio buttons
%what can be:'ellipse'
%            'serie'
%            'station'
%            'file'
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

if nargin == 0
  % ellipses vs series:
  if gco == HANDLES.radio_is_ell
    serie2ell
  elseif gco == HANDLES.radio_is_serie
    ell2serie
  end
  
  % matfile vs stations netcdf file:
  if gco == HANDLES.radio_is_station
    file2sta
  elseif gco == HANDLES.radio_is_file
    sta2file
  end
  
else
  if isequal(what,'ellipse')
    serie2ell;
  elseif isequal(what,'serie')
    ell2serie;
  elseif isequal(what,'station')
    file2sta;
  elseif isequal(what,'file')
    sta2file;
  end
end

%---------------------------------------------------------------------
function serie2ell
global HANDLES
set(HANDLES.radio_is_serie,'value',0);
set(HANDLES.radio_is_ell,'value',1);
set(HANDLES.vars,'value',1,'string',['U&Vbar';'U&V   ']);
set(HANDLES.vlevels,'value',1,'string',int2str(1)); 

function ell2serie
global HANDLES
set(HANDLES.radio_is_serie,'value',1);
set(HANDLES.radio_is_ell,'value',0);
set(HANDLES.vars,'value',1,'string',['ZETA';'Ubar';'Vbar';'U   ';'V   ']);
set(HANDLES.vlevels,'value',1,'string',int2str(1));

function file2sta
global HANDLES
set(HANDLES.radio_is_station,'value',1);
set(HANDLES.radio_is_file,'value',0);   
set(HANDLES.vars,'enable','on');
set(HANDLES.vlevels,'enable','on');

function sta2file
global HANDLES
IS.todo.source='matfile';
set(HANDLES.radio_is_station,'value',0);
set(HANDLES.radio_is_file,'value',1);  
set(HANDLES.vars,'enable','off');
set(HANDLES.vlevels,'enable','off');
