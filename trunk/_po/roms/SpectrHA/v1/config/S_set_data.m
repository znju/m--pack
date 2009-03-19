function [x,field,level,interval]=S_set_data
%function [x,field,level,interval]=S_set_data
%Retrieves data to be plotted or analised
%also performs interpolation in case of using a choosed depth
%instead of s-level
%Outout: x, time serie
%        field, current field   
%        level, s-level or depth
%        interval, data sampling interval
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES FLOAD FSTA FGRID

%=====================================================================
% loaded mat file:
%=====================================================================
if ~S_isstation
  if isempty(FLOAD.name)
    errordlg('No serie loaded','missing...','modal');
    x=[];
    field=[];
    level='';
    interval=[];
    return
  else
    if ~S_isserie & FLOAD.dim ==1
      errordlg('Loaded mat file contains 1D data, select serie instead of ellipse','wrong selection',',modal');
      x=[];
      field=[];
      level='';
      interval=[];
      return
    elseif S_isserie & FLOAD.dim ~=1
      errordlg('Loaded mat file contains 2D data, select ellipse instead of serie','wrong selection',',modal');
      x=[];
      field=[];
      level='';
      interval=[];
      return
    end
    x=FLOAD.serie;
    field='not available';
    level='none';
    interval=FLOAD.interval;
  end
end

%=====================================================================
% station:
%=====================================================================  

isdepth=get(HANDLES.zcheck,'value');

if S_isstation
  if isempty(FSTA.i)
    errordlg('No station Selected','missing...','modal');
    x=[];
    field=[];
    level='';
    interval=[];
    return
  end    
  
  variable=get(HANDLES.vars,'value');
  Level=get(HANDLES.vlevels,'value');
  level=['s=',int2str(Level)];
  interval=FSTA.interval;
  
  if S_isserie        
    switch variable
      case 1
        field='ssh';
      case 2
        field='vel_uBar';
      case 3
        field='vel_vBar';
      case 4
        field='vel_u';
      case 5
        field='vel_v';
    end

  else % ellipse
    switch variable
      case 1
        field='uvBar';
        field1='vel_uBar';
        field2='vel_vBar';
      case 2
        field='uv';
        field1='vel_u';
        field2='vel_v';
    end
  end

  if ~isdepth
    IJK=[FSTA.i Level];
    if S_isserie
      x=S_get_ncvar(FSTA.name,field,IJK);
    else
      u=S_get_ncvar(FSTA.name,field1,IJK);
      v=S_get_ncvar(FSTA.name,field2,IJK);
      if isequal(size(u),size(v))
        x=u+i*v;
      else
        x=[];
      end
      if isreal(x) % v=0
        x=[];
      end 
    end
  end

end

%---------------------------------------------------------------------
% interp at desired depth:
%---------------------------------------------------------------------
% to use depths instead of s-level

if S_isstation & isdepth

  if isequal(field,'ssh') | isequal(field,'vel_uBar') | isequal(field,'vel_vBar') | isequal(field,'uvBar')
    errordlg('choose another field... depth cant be used','wrong field','modaal');
    x=[];
    field=[];
    level='';
    interval=[];
    return
  end

  depth=str2num(get(HANDLES.zlevel,'string'));
  if isempty(depth) | isnan(depth) | ~isequal(length(depth),1)
    errordlg('invalid depth...','wrong value','modal');
    set(HANDLES.zlevel,'string','z');
    x=[];
    field=[];
    level='';
    interval=[];
    return
  end

% find hmin:
  if isempty(FGRID.hmin)
    if isempty(FGRID.name)
      errordlg('grid must be loaded to find hmin...','missing...','modal');
      x=[];
      field=[];
      level='';
      interval=[];
      return
    end
    h=S_get_ncvar(FGRID.name,'bathymetry');
    hmin=min(min(h));
    FGRID.hmin=hmin;
  else
    hmin=FGRID.hmin;
  end

% get station depth:
  IJK=[FSTA.i nan];
  h_sta=S_get_ncvar(FSTA.name,'bathy_sta',IJK);

% get theta_s, theta_b and Tcline:
  theta_s=S_get_ncvar(FSTA.name,'theta_s');
  theta_b=S_get_ncvar(FSTA.name,'theta_b');
  Tcline=S_get_ncvar(FSTA.name,'Tcline');

% get N levels:
  N=FSTA.nlevels;

% get zeta (ssh) time serie:
  IJK=[FSTA.i nan];
  zeta=S_get_ncvar(FSTA.name,'ssh',IJK);

% interp data at desired level:
  depth = -depth;
  X=repmat(nan,length(zeta),1);

% get x at all levels and time
  IJK=[FSTA.i 0];
  if S_isserie
    xx=repmat(nan,[length(zeta) 1 N]);
    xx=S_get_ncvar(FSTA.name,field,IJK);
  else
    u=S_get_ncvar(FSTA.name,field1,IJK);
    v=S_get_ncvar(FSTA.name,field2,IJK);
    if isequal(size(u),size(v))
      xx=u+sqrt(-1)*v;
    else
      x=[];
      return
    end
    if isreal(xx)
      x=[];
      msgbox('v is null... no analysis will be done','wrong...','modal');
      return
    end
  end 

  hc = min(hmin,Tcline);
  for j=1:length(X)
    z=s_levels(h_sta,theta_s,theta_b,hc,N,zeta(j));
    x=squeeze(xx(j,:,:));
    x=reshape(x,size(z));
    X(j)=interp1(z,x,depth);
  end
  
  x=X;
  level=['z=',num2str(depth)];
  if any(isnan(x))
    warndlg('Warning, NaNs found in series, check release >> s_levels(t=all)','NaNs found','modal');
  end
  if ~S_isserie & isreal(x)
    x=[];
  end
end



