function N_advanceindex(do)
%N_advanceindex
%is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% shows dialog box: select indexes for which evolution will be automatic

global H

if nargin == 0
  do='show';
end

if isequal(do,'show')
  evalc('loop   = H.advancei.loop;',  'loop   = 1;');
  evalc('pause_ = H.advancei.pause;', 'pause_ = 0;');
  evalc('vali   = H.advancei.i;',     'vali   = 0;');
  evalc('valj   = H.advancei.j;',     'valj   = 0;');
  evalc('valk   = H.advancei.k;',     'valk   = 0;');
  evalc('vall   = H.advancei.l;',     'vall   = 0;');

  h=dialog;%('WindowStyle','normal'); get(h)

  hh=.15;
  L=.25;
  Name='auto advance index...';
  set(h,'units','normalized');
  set(h,'position',[.5-L/2 .5-hh/2 L hh]);
  set(h,'Name',Name);

  hcb=.7;
  l=.15;
  H.advancei_i = uicontrol(h,'units','normalized','style','checkbox','position',[.2-l/2 hcb l l],'string','I','value',vali);
  H.advancei_j = uicontrol(h,'units','normalized','style','checkbox','position',[.4-l/2 hcb l l],'string','J','value',valj);
  H.advancei_k = uicontrol(h,'units','normalized','style','checkbox','position',[.6-l/2 hcb l l],'string','K','value',valk);
  H.advancei_l = uicontrol(h,'units','normalized','style','checkbox','position',[.8-l/2 hcb l l],'string','L','value',vall);

  %loop:
  %H.advancei_loop = uicontrol(h,'units','normalized','style','checkbox','position',[.2-l/2 .45 l*1.5 l],'string','Loop');
  lp=uicontrol(h,'units','normalized','style','text','position',[.2-l/2 .45 l l],'string','Loop');
  H.advancei_loop = uicontrol(h,'units','normalized','style','edit','position',[.2+l/2  .45 l l],'string',loop,'backgroundcolor','w','callback','N_advanceindex(''check_loop'')');
  set(lp,'Visible','off');
  set(H.advancei_loop,'Visible','off');

  %pause
  uicontrol(h,'units','normalized','style','text','position',[.2+l*1.5     .45 l l],'string','Pause');
  H.advancei_pause = uicontrol(h,'units','normalized','style','edit','position',[.2+l*2.5 .45 l l],'string',pause_,'backgroundcolor','w','callback','N_advanceindex(''check_pause'')');

  %ok, cancel
  uicontrol(h,'units','normalized','position',[.5-2.5*l .1 l*2 l],'string','OK','callback','N_advanceindex(''ok'')');
  uicontrol(h,'units','normalized','position',[.5+l/2   .1 l*2 l],'string','cancel','callback','close(gcbf);');
end

if isequal(do,'check_pause')
  val=str2num(get(H.advancei_pause,'string'));
  if ~isnumber(val,1)
    set(H.advancei_pause,'string',0);
  end
end

if isequal(do,'check_loop')
  val=str2num(get(H.advancei_loop,'string'));
  if ~isnumber(val,1)
    set(H.advancei_loop,'string',1);
  end
end


if isequal(do,'ok')
  H.advancei.i     = get(H.advancei_i,'value');
  H.advancei.j     = get(H.advancei_j,'value');
  H.advancei.k     = get(H.advancei_k,'value');
  H.advancei.l     = get(H.advancei_l,'value');
  H.advancei.loop  = get(H.advancei_loop,'string');
  H.advancei.pause = get(H.advancei_pause,'string');

  close(gcbf);
end
