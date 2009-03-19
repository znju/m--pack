function S_release_slevels(where)
%function S_release_slevels(where)
%Release s-levels in a  vertical slice or time serie
%Input: where, 'i', vertical slice for one longitude
%              'j',                        latitude
%              't', time serie
%uses global vars ETC.release_t1, time index for slices
%                 ETC.release_t2, used in z_r display at time serie
%                 see S_settings.m to change default values
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global  FGRID FSTA ETC

S_pointer

is_i=0;
is_j=0;
is_t=0;
switch where
  case 'i'
    is_i=1;
  case 'j'
    is_j=1;
  case 't'
    is_t=1;
  otherwise
    return
end 

%--------------------------------------------------------------------|
% time to use in slices:                                             |
%time=1;   % start time, first time index                            |
time=ETC.release_t1; % edit S_settings.m                             |
                                                                     %
% time to see data in time evolution                                 |
%t2=1;  % time2                                                      |
t2=ETC.release_t2;   % edit S_settings.m                             |
%--------------------------------------------------------------------|

% station location:

if isempty(FGRID.name)
  errordlg('No grid loaded','missing...','modal');
  return
end

if isempty(FSTA.i)
    errordlg('No station Selected','missing...','modal');
    return
end

S_pointer('watch');

x=get(FSTA.selected,'xdata');
y=get(FSTA.selected,'ydata');

x=x(end);
y=y(end); % last selected is the current one.

lon=S_get_ncvar(FGRID.name,'longitude');
lat=S_get_ncvar(FGRID.name,'latitude');

dist=(x-lon).^2+(y-lat).^2;
[i,j]=find(dist==min(min(dist)));
%plot(lon(i,j),lat(i,j),'r*')

%---------------------------------------------------------------------

% load vars:

if is_j
  x=lon(i,:);
  x_pos=lon(i,j);

  % bathymetry and mask:
  IJK=[0 i nan nan];
  h=-S_get_ncvar(FGRID.name,'bathymetry',IJK);
  h_pos=h(j);
  mask=S_get_ncvar(FGRID.name,'mask',IJK);

  ssh_ind=[0 i];

elseif is_i
  x=lat(:,j);
  x_pos=lat(i,j);

  % bathymetry and mask:
  IJK=[j 0 nan nan];
  h=-S_get_ncvar(FGRID.name,'bathymetry',IJK);
  h_pos=h(i);
  mask=S_get_ncvar(FGRID.name,'mask',IJK);

  ssh_ind=[j 0];

elseif is_t % same position, but evolution in time
  % bathymetry:
  IJK=[j i nan nan];
  h_pos=-S_get_ncvar(FGRID.name,'bathymetry',IJK);

  % time:
  t=S_get_ncvar(FSTA.name,'time');
  t=t/86400; % days

  % ssh at all times (like time, above):
  IJK=[FSTA.i nan];
  zeta=S_get_ncvar(FSTA.name,'ssh',IJK);
end
  
%  ssh:  [at time index "time" (defined above)]
% if roms_his, all ssh line(column) is plotted

IJK=[FSTA.i nan time]; 
ssh_pos=S_get_ncvar(FSTA.name,'ssh',IJK);

if isequal(FSTA.type,'his') & ~isequal(where,'t')
  IJK=[ssh_ind nan time];
  ssh=S_get_ncvar(FSTA.name,'ssh',IJK);
  linestyle='-';
else
  ssh=repmat(ssh_pos,size(x)); % use zeta of station to all cut !!
  linestyle='--';
end

%---------------------------------------------------------------------
figure;
set(gcf,'numbertitle','off','name','Vertical Levels');

if ~is_t
  plot(x,h,'b'); 
  hold on
  plot(x,h.*zero2nan(mask,1),'color','r','LineWidth',4)

  plot([x_pos x_pos],[h_pos ssh_pos],'r'); % station position, or closest
  plot(x, ssh,'linestyle',linestyle);
  plot(x_pos,ssh_pos,'k+');
  
  [lim]=ylim;
  ylim([lim(1) lim(2)+max(abs(h))/20]);
else
  plot(t,repmat(h_pos,size(t)),'b');
  hold on
  plot(t,zeta,'r');
end  

title(['sta: ',FSTA.name,' [ ',int2str(FSTA.i(1)),' x ',int2str(FSTA.i(2)),' ]'],'interpreter','none');
xlabel(['grid: ',FGRID.name,' [ ',int2str(j),' x ',int2str(i),' ]'],'interpreter','none');
ylabel(datestr(now))
%---------------------------------------------------------------------

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


hc = min(hmin,Tcline);
if ~is_t
  % get station depth:
    h_sta=-h;
  % set zeta:
    zeta=ssh;

  z=s_levels(h_sta,theta_s,theta_b,hc,N,zeta);
  z=squeeze(z);
  plot(x,z,'k');

else
  h_sta=-h_pos;
  zeta=zeta;
  z=s_levels(h_sta,theta_s,theta_b,hc,N,zeta);
  z=squeeze(z);
  plot(t,z,'k');

  % time2 (see above):
  plot([t(t2) t(t2)],[h_pos zeta(t2)+.1*(zeta(t2)-h_pos)],'b-.');
  text(t(t2),zeta(t2)+.1*(zeta(t2)-h_pos),['itime= ',num2str(t2)]);
end

%---------------------------------------------------------------------

% plot some values: level, depth, ssh, bathy
if is_j
  for n=1:N
    text(x(1),z(1,n),int2str(n));         % level
    text(x(j),z(j,n),num2str(z(j,n)));    % depth
  end                                     %
  text(x(j),ssh_pos,num2str(ssh_pos));    % ssh
  text(x(j),h_pos,num2str(h_pos));        % bathy
elseif is_i
  for n=1:N
    text(x(1),z(1,n),int2str(n));         % level
    text(x(i),z(i,n),num2str(z(i,n)));    % depth
  end                                     %
  text(x(i),ssh_pos,num2str(ssh_pos));    % ssh
  text(x(i),h_pos,num2str(h_pos));        % bathy
elseif is_t
  for n=1:N
    text(t(1),z(1,n),int2str(n));         % level
    text(t(t2),z(t2,n),num2str(z(t2,n))); % depth
  end                                     %
  text(t(t2),zeta(t2),num2str(zeta(t2))); % ssh
  text(t(t2),h_pos,num2str(h_pos));       % bathy
end


% legend:
if is_t
  s0=['itime   = ',num2str(t2)];
else
  s0=['itime   = ',num2str(time)];
end  
s1=['theta_s = ',num2str(theta_s)];
s2=['theta_b = ',num2str(theta_b)];
s3=['Tcline  = ',num2str(Tcline)];
s4=['hmin    = ',num2str(hmin)];
str=strvcat(s0,s1,s2,s3,s4);
n=plot(nan,'w');
legend(n,str,0);
lc=get(legend,'children');
if ~isempty(lc)
  set(lc(end),'interpreter','none','fontname','courier');
end

S_pointer
