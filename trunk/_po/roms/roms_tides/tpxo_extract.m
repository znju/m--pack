function [hamp,hpha,uamp,upha,vamp,vpha,finalComps]=tpxo_extract(grd,gfile,hfile,ufile,varargin)
%TPXO_EXTRACT   Extract data from TPXO netcdf files
%
%   Syntax:
%      [HA,HP,UA,UP,VA,VP,C] = TPXO_EXTRACT(GRD,GFILE,HFILE,UFILE,VARARGIN)
%
%   Inputs:
%      GRD    Target ROMS netcdf grid file
%      GFILE  TPXO grid file
%      HFILE  TPXO tidal elevation file
%      UFILE  TPXO tidal transport file
%      VARARGIN:
%         'comps', {names}, cell array with tidal names, ex:
%            {'m2','s2'}, by default all components from TPXO files
%            are used
%         'hcut', <value>: due to possible bad currents values near
%            coast, remove all until hcut, default value is 30
%
%   Outputs:
%      Amplitudes and phases of H, U and V (SI units, ie, m, m/s, rad)
%      C   final components, is part of COMPS available in TPXO files
%
%   Example:
%      grd='roms_grd.nc'
%      gfile='grid_tpxo7.1.nc'
%      hfile='h_tpxo7.1.nc'
%      ufile='u_tpxo7.1.nc'
%      [hamp,hpha,uamp,upha,vamp,vpha,c]=tpxo_extract(grd,gfile,hfile,ufile)
%      [hamp,hpha,uamp,upha,vamp,vpha,c]=tpxo_extract(grd,gfile,hfile,ufile,'comps',{'m2','s2','m4'})
%
%   MMA 16-04-2009, mma@odyle.net
%
%   See also TPXO2ROMS

hcut=30;
comps='all';

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'hcut')
    hcut=vin{i+1};
  elseif isequal(vin{i},'comps')
    comps=vin{i+1};
  end
end

[x,y,h,m]=roms_grid(grd);
[eta,xi]=size(h);

% check if lon 0 line is crossed by grid:
crossZero=0;
x(x<0)=x+360;
if any(x(:)>270 & x(:)<360) & any(x(:)>0 & x(:)<90)
  crossZero=1;
end

% read components:
con=char(use(hfile,'con'));
com={};
for i=1:size(con,1)
  com{i}=trim(con(i,:));
end

if isequal(comps,'all')
  comps=com;
end

% find components inds to use:
inds=[];
for i=1:length(comps)
  found=0;
  for j=1:length(com)
    if isequal(comps{i},com{j});
      inds(end+1)=j;
      found=1;
      break;
    end
  end
  if ~found
    fprintf(1,':: component %s not found in tpxo files\n',comps{i});
  end
end
np=length(inds);

% read from tpxo grid file:
lonr  = use(gfile,'lon_z');
latr  = use(gfile,'lat_z');
maskr = use(gfile,'mz');
hr    = use(gfile,'hz');

lonu  = use(gfile,'lon_u');
latu  = use(gfile,'lat_u');
masku = use(gfile,'mu');
hu    = use(gfile,'hu');

lonv  = use(gfile,'lon_v');
latv  = use(gfile,'lat_v');
maskv = use(gfile,'mv');
hv    = use(gfile,'hv');

% repeat grid vars if crossZero:
if crossZero
  lonr=[lonr;lonr];
  lonu=[lonu;lonu];
  lonv=[lonv;lonv];
  latr=[latr;latr];
  latu=[latu;latu];
  latv=[latv;latv];
  maskr=[maskr;maskr];
  masku=[masku;masku];
  maskv=[maskv;maskv];
  hr=[hr;hr];
  hu=[hu;hu];
  hv=[hv;hv];
end

% limit tpxo grid around target grid:
i1=find(lonr(:,1)<=min(x(:))); i1=max(1,i1(end)-2);
i2=find(lonr(:,1)>=max(x(:))); i2=min(length(lonr(:,1)),i2(1)+1);
j1=find(latr(1,:)<=min(y(:))); j1=max(1,j1(end)-2);
j2=find(latr(1,:)>=max(y(:))); j2=min(length(latr(1,:)),j2(1)+1);

lonr=lonr(i1:i2,j1:j2);
latr=latr(i1:i2,j1:j2);
maskr=maskr(i1:i2,j1:j2);
hr=hr(i1:i2,j1:j2);

lonu=lonu(i1:i2,j1:j2);
latu=latu(i1:i2,j1:j2);
masku=masku(i1:i2,j1:j2);
hu=hu(i1:i2,j1:j2);

lonv=lonv(i1:i2,j1:j2);
latv=latv(i1:i2,j1:j2);
maskv=maskv(i1:i2,j1:j2);
hv=hv(i1:i2,j1:j2);

% read from hfile and ufile:
hamp=nan*zeros([np eta xi]);
hpha=nan*zeros([np eta xi]);
uamp=nan*zeros([np eta xi]);
upha=nan*zeros([np eta xi]);
vamp=nan*zeros([np eta xi]);
vpha=nan*zeros([np eta xi]);
finalComps={};
for i=1:length(inds)
  finalComps{i}=com{inds(i)};
  fprintf(1,'\n:: extracting component %s\n',com{inds(i)});

  fprintf(1,'    - amp');
  w=use(hfile,'ha','nc',inds(i)); w=w(i1:i2,j1:j2); w(maskr==0)=nan;
  w=griddata(lonr,latr,w,x,y);
  w(m==0)=nan; is=isnan(w);
  w(is)=griddata(x(~is),y(~is),w(~is),x(is),y(is),'nearest');
  hamp(i,:,:)=w;

  fprintf(1,' - pha');
  w=use(hfile,'hp','nc',inds(i)); w=w(i1:i2,j1:j2); w(maskr==0)=nan;
  w=interp2pi(lonr,latr,w,x,y,'gri');
  w(m==0)=nan; is=isnan(w);
  w(is)=griddata(x(~is),y(~is),w(~is),x(is),y(is),'nearest');
  hpha(i,:,:)=w;

  fprintf(1,' - amp u');
  w=use(ufile,'ua','nc',inds(i))*0.01; w=w(i1:i2,j1:j2); w(masku==0)=nan; w(hu<hcut)=nan;
  w=griddata(lonu,latu,w,x,y);
  w(m==0)=nan; is=isnan(w);
  w(is)=griddata(x(~is),y(~is),w(~is),x(is),y(is),'nearest');
  uamp(i,:,:)=w;

  fprintf(1,' - pha u');
  w=use(ufile,'up','nc',inds(i)); w=w(i1:i2,j1:j2); w(masku==0)=nan; w(hu<hcut)=nan;
  w=interp2pi(lonu,latu,w,x,y,'gri');
  w(m==0)=nan; is=isnan(w);
  w(is)=griddata(x(~is),y(~is),w(~is),x(is),y(is),'nearest');
  upha(i,:,:)=w;

  fprintf(1,' - amp v');
  w=use(ufile,'va','nc',inds(i))*0.01; w=w(i1:i2,j1:j2); w(maskv==0)=nan; w(hv<hcut)=nan;
  w=interp2pi(lonv,latv,w,x,y,'gri');
  w(m==0)=nan;  is=isnan(w);
  w(is)=griddata(x(~is),y(~is),w(~is),x(is),y(is),'nearest');
  vamp(i,:,:)=w;

  fprintf(1,' - pha v\n');
  w=use(ufile,'vp','nc',inds(i)); w=w(i1:i2,j1:j2); w(maskv==0)=nan; w(hv<hcut)=nan;
  w=griddata(lonv,latv,w,x,y);
  w(m==0)=nan;  is=isnan(w);
  w(is)=griddata(x(~is),y(~is),w(~is),x(is),y(is),'nearest');
  vpha(i,:,:)=w;
end
