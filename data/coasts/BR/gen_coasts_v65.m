sa  = 'south_atlantic_coast.dat';
br  = 'brasil_coast.dat';
brs = 'br_estados_parte.dat';

s=load(sa);
lon=s(:,1);
lat=s(:,2);
save south_atlantic_v65 lon lat

b=load(br);
lon=b(:,1);
lat=b(:,2);
save coastline_v65 lon lat

b=load(brs);
lon=b(:,1);
lat=b(:,2);
save br_estados_part_v65 lon lat
