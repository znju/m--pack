function tpxo2rtools(fname,gfile,hfile,ufile,version)
%TPXO2RTOOLS   Convert TPXO netcdf files to roms-tools format
%
%   Syntax:
%      TPXO2RTOOLS(FNAME,GFILE,HFILE,UFILE,VERSION)
%
%   Inputs:
%      FNAME   Output filename
%      GFILE   TPXO grid file
%      HFILE   TPXO tidal elevation file
%      UFILE   TPXO tidal transport file
%      VERSION   TPXO version number, default empty
%
%  Example:
%     gfile='grid_tpxo7.1.nc'
%     hfile='h_tpxo7.1.nc'
%     ufile='u_tpxo7.1.nc'
%     tpxo2rtools('tpxo_7.1.nc',gfile,hfile,ufile,7.1)
%
%   MMA 16-04-2009, mma@odyle.net

if nargin <5
  version=0;
end

% get components:
con=char(use(hfile,'con'));
comp='';
periods=[];
for i=1:size(con,1)
  comp=[comp ' ' trim(con(i,:))];
  periods(i)=1/name2freq(con(i,:));
end
comp=comp(2:end);


% create file:
nc = netcdf(fname,'clobber');

% Global attributes:
nc.title = ncchar([' TPXO ' num2str(version)]);
nc.date = ncchar(datestr(now));
nc.components = ncchar(comp);

% Dimensions:
nx=n_dim(hfile,'nx');
ny=n_dim(hfile,'ny');
np=n_dim(hfile,'nc');
nc('lon_r')   = nx;
nc('lat_r')   = ny;
nc('lon_u')   = nx;
nc('lat_u')   = ny;
nc('lon_v')   = nx;
nc('lat_v')   = ny;
nc('periods') = np;

% Variables and attributes:
nc{'lon_r'} = ncfloat('lon_r');
nc{'lon_r'}.long_name = ncchar('Longitude at SSH points');

nc{'lat_r'} = ncfloat('lat_r');
nc{'lat_r'}.long_name = ncchar('Latitude at SSH points');

nc{'lon_u'} = ncfloat('lon_u');
nc{'lon_u'}.long_name = ncchar('Longitude at U points');

nc{'lat_u'} = ncfloat('lat_u');
nc{'lat_u'}.long_name = ncchar('Latitude at U points');

nc{'lon_v'} = ncfloat('lon_v');
nc{'lon_v'}.long_name = ncchar('Longitude at V points');

nc{'lat_v'} = ncfloat('lat_v');
nc{'lat_v'}.long_name = ncchar('Latitude at V points');

nc{'periods'} = ncfloat('periods');
nc{'periods'}.long_name = ncchar('Tide periods');

nc{'h'} = ncfloat('lat_r', 'lon_r');
nc{'h'}.long_name = ncchar('Topography');

nc{'ssh_r'} = ncfloat('periods', 'lat_r', 'lon_r');
nc{'ssh_r'}.long_name = ncchar('Elevation real part');

nc{'ssh_i'} = ncfloat('periods', 'lat_r', 'lon_r');
nc{'ssh_i'}.long_name = ncchar('Elevation imaginary part');

nc{'u_r'} = ncfloat('periods', 'lat_u', 'lon_u');
nc{'u_r'}.long_name = ncchar('U-transport component real part');

nc{'u_i'} = ncfloat('periods', 'lat_u', 'lon_u');
nc{'u_i'}.long_name = ncchar('U-transport component imaginary part');

nc{'v_r'} = ncfloat('periods', 'lat_v', 'lon_v');
nc{'v_r'}.long_name = ncchar('V-transport component real part');

nc{'v_i'} = ncfloat('periods', 'lat_v', 'lon_v');
nc{'v_i'}.long_name = ncchar('V-transport component imaginary part');

endef(nc)
close(nc)

% fill file:
nc=netcdf(fname,'w');
nc{'lon_r'}(:) = use(gfile,'lon_z','ny',1);
nc{'lat_r'}(:) = use(gfile,'lat_z','nx',1);
nc{'lon_u'}(:) = use(gfile,'lon_u','ny',1);
nc{'lat_u'}(:) = use(gfile,'lat_u','nx',1);
nc{'lon_v'}(:) = use(gfile,'lon_v','ny',1);
nc{'lat_v'}(:) = use(gfile,'lat_v','nx',1);
nc{'h'}(:)     = use(gfile,'hz')';
nc{'periods'}(:) = periods;

% apply mask:
mr = use(gfile,'mz'); mr=repmat(mr,[1 1 np]); mr=permute(mr,[3 1 2]);
mu = use(gfile,'mu'); mu=repmat(mu,[1 1 np]); mu=permute(mu,[3 1 2]);
mv = use(gfile,'mv'); mv=repmat(mv,[1 1 np]); mv=permute(mv,[3 1 2]);

ssh_r = use(hfile,'hRe'); ssh_r(mr==0)=nan;
ssh_i = use(hfile,'hIm'); ssh_i(mr==0)=nan;
u_r   = use(ufile,'URe'); u_r(mu==0)=nan;
u_i   = use(ufile,'UIm'); u_i(mu==0)=nan;
v_r   = use(ufile,'VRe'); v_r(mv==0)=nan;
v_i   = use(ufile,'VIm'); v_i(mv==0)=nan;

nc{'ssh_r'}(:) = permute(ssh_r,[1 3 2]);
nc{'ssh_i'}(:) = permute(ssh_i,[1 3 2]);
nc{'u_r'}(:)   = permute(u_r,  [1 3 2]);
nc{'u_i'}(:)   = permute(u_i,  [1 3 2]);
nc{'v_r'}(:)   = permute(v_r,  [1 3 2]);
nc{'v_i'}(:)   = permute(v_i,  [1 3 2]);
close(nc)
