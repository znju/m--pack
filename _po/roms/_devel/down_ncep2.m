% create ncep2 blk files


Y=2002:2007;
Y=2004;

yref=2000;
path='/home_neptuno/mma/ncep/NCEP2/';
grd = '../../remo/grelhas/new_grid/roms_grd_new.nc';

blk_tag='roms_blk_rot';
gen_blk=2;

ncep2blk(Y,yref,grd,path,blk_tag,gen_blk)
