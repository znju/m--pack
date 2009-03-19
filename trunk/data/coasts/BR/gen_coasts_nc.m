sa  = 'south_atlantic.mat';
br  = 'coastline.mat';
brs = 'br_estados_part.mat';

load(sa);
lon_sa=lon;
lat_sa=lat;

load(br);
lon_br=lon;
lat_br=lat;

load(brs);
lon_brs=lon;
lat_brs=lat;


var2nc('coasts_br.nc','lon_sa',lon_sa,'lat_sa',lat_sa,'lon_br',lon_br,'lat_br',lat_br,'lon_brs',lon_brs,'lat_brs',lat_brs);
show('coasts_br.nc')
