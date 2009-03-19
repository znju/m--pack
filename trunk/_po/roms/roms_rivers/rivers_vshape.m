function f=rivers_vshape(what)
%RIVERS_VSHAPE  Create rivers vshape
%
%   Syntax:
%      F=RIVERS_VSHAPE
%
%   MMA 2005, martinho@fis.ua.pt
%
%   See also RIVERS_GEN

%   Department of Physics
%   University of Aveiro, Portugal


if isnumeric(what)
  ns = what;
  what = 'init';
elseif nargin == 0
  disp('# missing args...')
  return
end

% ------------------------- init:
if isequal(what,'init')
  x1=0;
  x2=4;
  x=linspace(x1,x2,ns);
  f = exp(x);
  f=f/sum(f);

  figure
  set(gcf,'name','Vshape','NumberTitle','off');
  axes('position',[.1 .1 .7 .8]);
  p=plot(f,1:ns,'o-'); set(p,'tag','shape');
  ylim([0 ns+1]);

  uix1 = uicontrol('units','normalized','position',[.85 .7  .1 .05],  'string','0','style','edit','tag','x1');
  uix2 = uicontrol('units','normalized','position',[.85 .65 .1 .05],  'string','4','style','edit','tag','x2');
  uix3 = uicontrol('units','normalized','position',[.85 .6  .1 .05],  'string','draw','callback','f=rivers_vshape(''genshape'');');
  uix4 = uicontrol('units','normalized','position',[.85 .55 .1 .05],  'string','done','callback','f=rivers_vshape(''done'');');

else
  uix1 = findobj(gcf,'tag','x1');
  uix2 = findobj(gcf,'tag','x2');
  x1 = str2num(get(uix1,'string'));
  x2 = str2num(get(uix2,'string'));

  p = findobj(gca,'tag','shape');
  ns = length(get(p,'xdata'));

  x=linspace(x1,x2,ns);
  f = exp(x);
  f=f/sum(f);

  set(p,'xdata',f);

  ylim([0 ns+1])

  if isequal(what,'done')
    close
  end
end
