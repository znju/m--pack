function ncep_uvcomp(years,path,pos,tstart,tend,yL,scale)
%NCEP_UVCOMP   Compare NCEP winds of several years
%
%   Syntax:
%      NCEP_UVCOMP(YEARS,PATH,POS,TSTART,TEND,YL,SCALE)
%
%   Inputs:
%      YEARS   Years to compare
%      PATH    Path to NCEP files
%      POS     Nearest location where data will be extracted
%      TSTART  Start time [ <day-month> ]
%      TEND    End time   [ <day-month> ]
%      YL      Ylim for the subplots
%      SCALE   Scale to aplly in arrows
%
%   Comment:
%      YtickLabel has no scale, ie, has the correct value.
%      Scale is just needed cos of axis equal for vectors.
%
%   Example:
%      years  = 1995:2004
%      path   = '../';
%      tstart = '1-Feb';
%      tend   = '1-Apr';
%      pos    = [-9 41];
%      ncep_uvcomp(years,path,pos,tstart,tend);
%
%   MMA 27-5-2004, martinho@fis.ua.pt
%
%   See also NCEP_GETVAR, NCEP_GEN

%   Department of Physics
%   University of Aveiro, Portugal

L=[0 0];

if nargin < 7
  scale=.2;
end
if nargin < 6
  yL=[-10 10];
end

figure(999);

ny=length(years);
for t=1:ny
  Y=num2str(years(t));

  ts = [tstart,'-',Y];
  te = [tend,'-',Y];

  fileu=[path,'uwnd.10m.gauss.',Y,'.nc'];
  filev=[path,'vwnd.10m.gauss.',Y,'.nc'];

  Varu='uwnd';
  Varv='vwnd';

  [lon,lat,varu,time]=ncep_getvar(fileu,Varu,ts,te,pos,L);
  [lon,lat,varv,time]=ncep_getvar(filev,Varv,ts,te,pos,L);

  figure(999);
  subplot(ny,1,t)

  for i=1:length(varu)
    Pos = [time(i) 0];
    V   = scale*[varu(i) varv(i)];

    vector(Pos,V,.0001,20,'r',1); hold on
  end
  axis equal
  xlim([time(1)-2 time(end)+2]);
  grid on
  title([ts,'  -->  ',te,'  nvals = ',num2str(length(time))]);
  ylim(yL*scale);

  ytick=get(gca,'yticklabel');
  ytick=1/scale*str2num(ytick);
  ytick=num2str(ytick);
  set(gca,'yticklabel',ytick);
end
