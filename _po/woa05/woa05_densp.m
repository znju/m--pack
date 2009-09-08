function D=woa05_densp(ftemp, fsalt,time)

if nargin<3
  time=1;
end

T = use(ftemp,'temperature','T',time);
S = use(fsalt,'salinity','T',time);
D = sw_dens0(S,T); D=D-1000;
