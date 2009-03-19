function [t,v] = sta_slice(sta,varname,ind,tind,depths)
%STA_SLICE   Slice at ROMS station
%   Return time series at desired depths of a station from ROMS
%   stations output file.
%
%   Syntax:
%      [T,V] = STA_SLICE(STA,VAR,IND,TIND,DEPTH)
%
%   Inputs:
%      STA   Stations file
%      VAR   Variable name
%      IND   Station indice
%      TIND  Time index, ex: 123, '10:end-5'
%      DEPTHS
%
%   Example:
%      [t,v]=sta_slice('stations.nc','u',123,'2:end',[-10 -100 -200])
%
%   MMA 5-5-2007, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

isW=0;

vv   = use(sta,varname, 'stanum',ind,'ftime',tind)';
zeta = use(sta,'zeta',  'stanum',ind,'ftime',tind)';
h    = use(sta,'h',     'stanum',ind);
ntimes=size(vv,2);

[tts,ttb,hc,N] = s_params(sta);
hh=repmat(h,1,ntimes);
[zr,zw]=s_levels(hh,tts,ttb,hc,N,zeta);

if isW
  zz=zw';
else
  zz=zr';
end

zz(2:end+1,:)=zz; zz(1,:)=-inf; zz(end+1,:)=inf;
vv(2:end+1,:)=vv; vv(1,:)=nan;  vv(end+1,:)=nan;

for i=1:length(depths)
  depth=depths(i);

  k=zz>=depth;
  d=k(2:end,:)-k(1:end-1,:);
  d(2:end+1,:)=d;
  d(1,:)=0;
  iM=logical(d);

  k=zz<depth;
  d=k(1:end-1,:)-k(2:end,:);
  d(end+1,:)=0;
  im=logical(d);

  zUp   = zz(iM);
  zDown = zz(im);
  coefUp   = (zUp-depth)./(zUp-zDown);
  coefDown = (depth-zDown)./(zUp-zDown);

  vUp   = vv(iM);
  vDown = vv(im);

  vUp(coefDown==0)=0;
  vDown(coefUp==0)=0;

  V = coefUp.*vDown + coefDown.*vUp;

  v(:,i)=V(:);
end

if v(:,1)==1e15, v(:,1)=0; end

if nargout==1
  t=v;
else
  t = use(sta,'scrum_time','ftime',tind)/86400;
end
