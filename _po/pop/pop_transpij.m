function Tr = pop_transpij(files,lons,lats,isgeo,varargin)
%POP_TRANSPIJ   POP transport across fixed index vertical section
%
%   Syntax:
%      Tr = POP_TRANSPIJ(FILES,ILON,JLAT,ISGEO,VARARGIN)
%
%   Inputs:
%      FILES   POP output list of files (cell) of just one file str
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
%   See also OCCAM_TRANSPIJ, POM_TRANSPIJ
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
    xi =n_indnear(fname,'u_lon',lons,1);
    eta=n_indnear(fname,'u_lat',lats);
  else
    xi=lons;
    eta=lats;
  end
  xis  = [num2str(xi(1))  ':' num2str(xi(end))];
  etas = [num2str(eta(1)) ':' num2str(eta(end))];

  % get x and vel:
  lon = use(fname,'u_lon', 'u_lon',xis,'u_lat',etas);
  lat = use(fname,'u_lat', 'u_lon',xis,'u_lat',etas);
  if isJ
    v   = use(fname,'V',   'u_lon',xis,'u_lat',etas)*0.01;
    x=lon;
    r=R*cos(lat*pi/180);
  elseif isI
    v   = use(fname,'U',   'u_lon',xis,'u_lat',etas)*0.01;
    x=lat;
    r=R;
  end

  % get ssh:
  % no ssh present!

  % calc dx:
  x=x*pi/180 * r;
  x=(x(2:end)+x(1:end-1))/2;
  dx=diff(x);
  if halfdxi, dx=[dx(1)/2 dx(:)'];
  else        dx=[dx(1) dx(:)'];
  end
  if halfdxe, dx=[dx(:)' dx(end)/2];
  else        dx=[dx(:)' dx(end)];
  end

  % calc dz:
  z=use(fname,'w_dep');
  dz=diff(z);

  % add ssh:
  % no ssh present!

  % area:
  A=dz*dx;

  % transport:
  v(isnan(v))=0;
  vpos=v;
  vneg=v;
  vpos(v<0)=0;
  vneg(v>0)=0;

  t=A.*v;       T=sum(t(:))/1E6;
  tpos=A.*vpos; Tpos=sum(tpos(:))/1E6;
  tneg=A.*vneg; Tneg=sum(tneg(:))/1E6;
  Tr(i,:)=[T Tpos Tneg];

  if ~quiet
    fprintf(1,'%6.2f %6.2f %6.2f\n',[T Tpos Tneg]);

    lon=use(fname,'u_lon','u_lon',xis,'u_lat',etas);
    lat=use(fname,'u_lat','u_lon',xis,'u_lat',etas);
    if isI
      fprintf(1,'lon = %6.2f\n',lon)
      fprintf(1,'lat = %6.2f to %6.2f\n',lat(1),lat(end))
    else
      fprintf(1,'lat = %6.2f\n',lat)
      fprintf(1,'lon = %6.2f to %6.2f\n',lon(1),lon(end))
    end
  end

end
