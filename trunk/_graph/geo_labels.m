function geo_labels(ca,ax,dec,label)
%GEO_LABELS   Format tickLabels
%   Sets decimals of tickLables and adds a string like ' ºN'.
%
%   Syntax:
%      GEO_LABELS(AXES,AXIS,DEC,LABEL)
%
%   Inputs:
%      AXES   The axes to use
%      AXIS   The axis to use, 'x','y' or 'z'
%      DEC    Number of decimals
%      LABEL  Label to add at the end of each tickLabel [ {''} <string> ]
%
%   Example:
%      figure
%      plot(1:10)
%      geo_labels(gca,'x',2,' ºE')
%      geo_labels(gca,'y',1,'')
%
%   MMA 16-1-2005, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

if nargin < 4
  label = '';
end
if nargin < 3
  disp('# arguments required')
  return
end

eval(['lab = get(ca,''',ax,'ticklabel'');']);
str='';
int = size(lab,2);
format = ['%',num2str(int),'.',num2str(dec),'f'];
for i = 1:size(lab,1)
  tmp = str2num(lab(i,:));
  tmp  = sprintf(format,tmp);
  tmp = [tmp ,label];
  str = strvcat(str,tmp);
end
eval(['set(gca,''',ax,'ticklabel'',str);']);
