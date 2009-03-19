function tide=S_config_T_TIDE
%function S_config_T_TIDE
%Configuration file for T_TIDE
%configure:
%          all t_tide options
%          t_predic options
%          use or not start time for stations and mat files
%          use or not latitude   "    "          "     "
%S_config_LSF is used to get names and ellipse colors
%See also S_config_LSF
%
%%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt


global ETC FSTA FLOAD

tide=S_config_LSF; % using start time, end time, names and colors of LSF; 
%ps: in S_config_LSF, if names~1, all ellipses created by t_tide will have the color
%LOOK.defaultEllipseColor, as well as all other constiuints not listed in S_config_LSF


% T_TIDE options:

latitude               = [];       % Ex:  latitude=30;
start_time             = [];       % Ex:  start_time=10;
output                 = 'none';   % Ex:  output='filename.data'
prefilt                = [];       % Ex:  prefilt='.1,.1';
secular                = [];       % Ex:  secular='mean';
inference.name         = [];       % Ex:  inference.name='[''M2'';''S2'']'
inference.reference    = [];       % Ex:  inference.reference='[''K1'';''K2'']';
inference.amprat       = [];       % Ex:  inference.amprat='[.33093;.27215]';
inference.phase_offset = [];       % Ex:  inference.phase_offset='[-7.07;-22.40]'; 
shallow                = [];       % Ex:  shallow='[''M10'']'
rayleigh               = [];       % Ex:  rayleigh=2
error                  = [];       % Ex:  error='linear'
synthesis              = [];       % Ex:  synthesis=10


% use station latitude:
sta_lat=0;
% use loaded mat file latitude:
file_lat=1;

% use loaded mat file start_time: if so, no phase corrections are done
%                                 see [sectrha]->phases t_tide
file_start_time=1;
% use a start time in data from stations file:
sta_start_time=0; % ex: datenum(2001,12,19,18,0,0)
%                 % 0 mean not use 
 
%========================================================= do not edit
if S_isstation & sta_lat
  latitude=FSTA.lat;
end
if ~S_isstation & file_lat
  latitude=FLOAD.position(2);
end
if isnan(latitude)
  latitude=[];
end

if S_isstation & ~isequal(sta_start_time,0)
  start_time=sta_start_time;
end
if ~S_isstation & file_start_time
  start_time=FLOAD.start_time;
  if isnan(start_time)
    start_time=[];
  else
    S_check_displace('default');
  end
end

%---------------------------------------------------------------------
if ~isempty(inference.name)
  inference=strcat(inference.name,',',inference.reference,',',...
                   inference.amprat,',',inference.phase_offset);
else
  inference=[];
end

str='';
if ~isempty(latitude);
  str=[str,',''latitude'',',num2str(latitude)];
end
if ~isempty(start_time)
  str=[str,',''start_time'',',num2str(start_time)];
end
if ~isempty(output)
  str=[str,',''output'',''',output,''''];
end
if ~isempty(prefilt)
  str=[str,',''prefilt'',',prefilt];
end
if ~isempty(secular)
  str=[str,',''secular'',''',secular,''''];
end
if ~isempty(inference)
  str=[str,',''inference'',',inference];
end
if ~isempty(shallow)
  str=[str,',''shallow'',',shallow];
end
if ~isempty(rayleigh)
  str=[str,',''rayleigh'',',num2str(rayleigh)];
end
if ~isempty(error)
  str=[str,',''error'',''',error,''''];
end
if ~isempty(synthesis);
  str=[str,',''synthesis'',',num2str(synthesis)];
end
%---------------------------------------------------------------------

tide.eval=str;


%=====================================================================
% used for t_predic:

predic_latitude=latitude;
predic_synthesis=synthesis; 

tide.predic_latitude=predic_latitude;
tide.predic_synthesis=predic_synthesis;
