function S2_update_z
% Update values of zmin, zmax, deptha...
%Finds zmin, zmax and z_r at t=0

global HANDLES ETC FGRID FSTA

S_pointer('watch');

%---------------------------------------------------------------------
% get zmax, zmin and z_r:
%---------------------------------------------------------------------
if isempty(FGRID.name) | isempty(FSTA.i)
  S_pointer
  return
end

% find hmin:
  if isempty(FGRID.hmin)
    H=S_get_ncvar(FGRID.name,'bathymetry');
    hmin=min(min(H));
    FGRID.hmin=hmin;
  else
    hmin=FGRID.hmin;
  end

% get theta_s, theta_b and Tcline:
  theta_s=S_get_ncvar(FSTA.name,'theta_s');
  theta_b=S_get_ncvar(FSTA.name,'theta_b');
  Tcline=S_get_ncvar(FSTA.name,'Tcline');
% get N levels:
  N=FSTA.nlevels;

% get h_sta:
   IJK=[FSTA.i nan nan];
   h_sta=S_get_ncvar(FSTA.name,'bathymetry',IJK);

% get ssh:
  IJK=[FSTA.i nan];
  zeta=S_get_ncvar(FSTA.name,'ssh',IJK);
hc = min(hmin,Tcline);
z=s_levels(h_sta,theta_s,theta_b,hc,N,zeta);
zmin=max(z(:,1));
zmax=min(z(:,end));
z_r=z(1,:);

%---------------------------------------------------------------------
% update depts:
%---------------------------------------------------------------------
ETC.new.current_zr0=-z_r;
ETC.new.current_zmax=-zmax;
ETC.new.current_zmin=-zmin;

set(HANDLES.zmax,'string',-zmax);
set(HANDLES.zmin,'string',-zmin);

S2_update_zi;

%-----
S_pointer


