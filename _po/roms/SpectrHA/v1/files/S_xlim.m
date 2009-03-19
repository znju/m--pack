function S_xlim
%function S_xlim
%Controls spectrum axes xlim
%'e'('end') and 's'('start') can be used as well as numbers
%default xlim cam be changed in file S_settings.m
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES ETC LOOK

axes(HANDLES.spectrum_axes);
% refresh legend
S_upd_legend;

xlim=get(gca,'xlim');
dx=xlim(2)-xlim(1);
str_i=get(HANDLES.xlim_i,'string'); xlim_i=str2num(str_i);
str_e=get(HANDLES.xlim_e,'string'); xlim_e=str2num(str_e);


bad1=isempty(xlim_i) & ~strncmpi(str_i,'start',1);
bad2=isempty(xlim_e) & ~strncmpi(str_e,'end',1);
bad3=size(xlim_i)~=1 & ~strncmpi(str_i,'start',1);
bad4=size(xlim_e)~=1 & ~strncmpi(str_e,'end',1);
bad5=isnan(xlim_i);
bad6=isnan(xlim_e);
bad=[bad1 bad2 bad3 bad4 bad5 bad6];

if any(bad)
  set(gca,'xlim',xlim);
  set(HANDLES.xlim_i,'string',xlim(1));
  set(HANDLES.xlim_e,'string',xlim(2));
  return
end

%---------------------------------------------------------------------
if gcbo == HANDLES.xlim_i
  if ~strncmpi(str_i,'start',1);
    tmp=xlim_i >= xlim_e;
    set(gca,'xlim',[xlim_i,xlim_e*~tmp + (xlim_i+dx)*tmp]);
    xlim_=get(gca,'xlim');
    set(HANDLES.xlim_e,'string',xlim_(2));
  else
    axis auto
    axis tight
    xlim_=get(gca,'xlim');
    set(gca,'xlim',[xlim_(1) xlim_e]);
    set(HANDLES.xlim_i,'string',xlim_(1));
  end  
end

if gcbo == HANDLES.xlim_e
  if ~strncmpi(str_e,'end',1);
    tmp=xlim_e <= xlim_i;
    set(gca,'xlim',[xlim_i*~tmp + (xlim_e-dx)*tmp,xlim_e]);
    xlim_=get(gca,'xlim');
    set(HANDLES.xlim_i,'string',xlim_(1));
  else
    axis auto
    axis tight
    xlim_=get(gca,'xlim');
    set(gca,'xlim',[xlim_i xlim_(2)]);
    set(HANDLES.xlim_e,'string',xlim_(2));
  end 
end

if gcbo == HANDLES.xlim
  axis normal
  set(gca,'xlim',ETC.default_xlim)
  set(HANDLES.xlim_i,'string',ETC.default_xlim(1));
  set(HANDLES.xlim_e,'string',ETC.default_xlim(2));
end
