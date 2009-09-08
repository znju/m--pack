function D=occam_densp(f)


T = use(f,'POTENTIAL_TEMPERATURE__MEAN_');
S = use(f,'SALINITY__MEAN_'); S=S*1000+35;
D = sw_dens0(S,T); D=D-1000;
