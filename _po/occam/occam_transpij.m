function Tr = occam_transpij(files,lons,lats,isgeo,varargin)
%OCCAM_TRANSPIJ   OCCAM transport across fixed index vertical section
%
%   Syntax:
%      Tr = OCCAM_TRANSPIJ(FILES,ILON,JLAT,ISGEO,VARARGIN)
%
%   Inputs:
%      FILES   OCCAM output list of files (cell) of just one file str
%      ILON    Indice for meridional slices, may be a longitude, so
%              that nearest index i is used. If has length 2, then
%              the transport will be zonal and between the 2 values
%      JLAT    Similar to ILON, but for the zonal case
%      ISGEO   If 1 then ILON and JLAT are lon and lat coordinates,
%              otherwise, are index in x and y directions
%      VARARGIN:
%        quiet, if 0 some messagens may be printed (default=0)
%        halfdxi, if 1, first cell dx will be divided by 2 (default=1)
%        halfdxe, if 1, last cell dx will be divided by 2 (default=1)
%
%   Outputs:
%      Tr   2-D array with total, total positive and total negative
%           transports in the 1st, 2nd and 3rd columns
%
%   See also OCCAM_TRANSP
%
%   MMA 13-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

quiet=0;
halfdxi=1;
halfdxe=1;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'quiet'),   quiet   = vin{i+1};
  elseif isequal(vin{i},'halfdxi'), halfdxi = vin{i+1};
  elseif isequal(vin{i},'halfdxe'), halfdxe = vin{i+1};
  end
end

R=6371*1000;

if nargin<4
  isgeo=1;
end

if ~iscell(files), files={files}; end

isI=0;
isJ=0;

if     length(lons)==2, isJ=1;
elseif length(lats)==2, isI=1;
end

Tr=[];
for i=1:length(files)
  fname=files{i};

  % get inds:
  if isgeo
    xi =n_indnear(fname,'LONGITUDE_U',lons,1);
    eta=n_indnear(fname,'LATITUDE_U',lats);
  else
    xi=lons;
    eta=lats;
  end
  xis  = [num2str(xi(1))  ':' num2str(xi(end))];
  etas = [num2str(eta(1)) ':' num2str(eta(end))];

  % get ssh, x and vel:
  ssh = use(fname,'SEA_SURFACE_HEIGHT__MEAN_','LONGITUDE_T',xis,'LATITUDE_T',etas)*0.01;
  lon = use(fname,'LONGITUDE_U',         'LONGITUDE_U',xis,'LATITUDE_U',etas);
  lat = use(fname,'LATITUDE_U',          'LONGITUDE_U',xis,'LATITUDE_U',etas);
  if isJ
    v   = use(fname,'V_VELOCITY__MEAN_', 'LONGITUDE_U',xis,'LATITUDE_U',etas)*0.01;
    x=lon;
    r=R*cos(lat*pi/180);
  elseif isI
    v   = use(fname,'U_VELOCITY__MEAN_', 'LONGITUDE_U',xis,'LATITUDE_U',etas)*0.01;
    x=lat;
    r=R;
  end

  % calc dx:
  dx=diff(x); dx=dx(1);
  dx=dx*pi/180 *r;

  % calc dz:
  z=use(fname,'DEPTH_EDGES')*0.01;
  dz=diff(z);

  % add ssh:
  dz=repmat(dz,1,size(v,2));
  dz(1,:)=dz(1,:)+ssh(:)';

  % area:
  A=dz*dx;
  if halfdxi
    A(:,1)=A(:,1)/2;
  end
  if halfdxe
    A(:,end)=A(:,end)/2;
  end

  % transport:
  vpos=v;
  vneg=v;
  vpos(v<0)=0;
  vneg(v>0)=0;

  t=A.*v;       T=sum(t(:))/1E6;
  tpos=A.*vpos; Tpos=sum(tpos(:))/1E6;
  tneg=A.*vneg; Tneg=sum(tneg(:))/1E6;

  if ~quiet
    fprintf(1,'%6.2f %6.2f %6.2f\n',[T,Tpos,Tneg]);
  end
  Tr(i,:)=[T Tpos Tneg];
end
