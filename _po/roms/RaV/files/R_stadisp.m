function R_disp

global H

% --------------------------------------------------------------------
% get fname:
% --------------------------------------------------------------------
% get the sta file:
evalc('fname=H.ROMS.sta.fname','fname=[]');

if isempty(fname);
  return
end

% --------------------------------------------------------------------
% get type of slice:
% --------------------------------------------------------------------
% can be:
%   1- simple time series, at s-level or depth
%   2- time series with vertical profile
%   3- only vertical profile (t=const)

isv = get(H.ROMS.sta.vprofile,'value');
ist = get(H.ROMS.sta.tprofile,'value');

isk = 0;
isz = 0;
% check s-level or depth:
if ~isv
  isk   = get(H.ROMS.grid.kcb,   'value');  K   = str2num(get(H.ROMS.grid.k,   'string'));
  isz   = get(H.ROMS.grid.zcb,   'value');  Z   = str2num(get(H.ROMS.grid.z,   'string'));

  if isk
    if ~isnumber(K,1), errordlg(['bad s-level !!'],'bad input data','modal'); return, end
  end
  if isz
    if ~isnumber(Z,1), errordlg(['bad depth !!'],  'bad input data','modal'); return, end
  end
end

if ~isv & ~ist % then must be z or k
  if ~isk & ~isz
     errordlg(['s-level or depth must be selected !!'],  'bad input data','modal');
     return
  end
end

% --------------------------------------------------------------------
% get station number:
% --------------------------------------------------------------------

str = get(H.ROMS.sta.selectn,'string');
tmp = explode(str,'x');
ista = str2num(tmp{1});
jsta = str2num(tmp{2});

isstation = 0;
if n_dimexist(fname,'station') | n_dimexist(fname,'stanum')
  isstation = 1;
end

% --------------------------------------------------------------------
% get time:
% --------------------------------------------------------------------
itime = str2num(get(H.ROMS.sta.tindex,'string'));
[time_name, time_scale, time_offset] = R_vars(fname,'time'); tvar = time_name;
nc=netcdf(fname);
ot = nc{time_name}(itime);
ot = ot * time_scale + time_offset;
ot = ot/86400;
nc=close(nc);

% --------------------------------------------------------------------
% get varname
% --------------------------------------------------------------------
% get varname:
vars  = get(H.ROMS.sta.variable,'string');
vari = get(H.ROMS.sta.variable,'value');
varname = vars{vari};

% check if varname exists in file:
if isequal(varname,'none')
   return
end
if ~isequal(varname,'currents') & ~isequal(varname,'uvbar')
  if ~n_varexist(fname,varname)
    errordlg(['Variable ',varname,' not found in file'],'missing variable','modal');
    return
  end
end

% --------------------------------------------------------------------
% check if need to  open new fig:
% --------------------------------------------------------------------
% - open if none exist yet or if new fig checkbox is selected:
% find last output fig:
figs    = get(0,'children');
outputs = findobj(figs,'tag','rcdv_output');
% get new fig checkbox value:
new = get(H.ROMS.his.newfig,'value');
if new | isempty(outputs)
  figure('tag','rcdv_output');
elseif ~isempty(outputs)
  last = outputs(1);
  figure(last);
end

% --------------------------------------------------------------------
% check if hold on:
% --------------------------------------------------------------------
theHold = H.ROMS.his.hold;
is_hold=get(theHold,'value');
if ~is_hold
  clf
  set(gcf,'userdata',[]);
else
  % if hold and in case the bathy and several lines are plotted
  % with plot_border3d, beter just remove what would be repeated:
  eval('d3 = H.ROMS.plot3d;','');
  eval('delete(d3.bottom);',  '');
  eval('delete(d3.top);',     '');
  eval('delete(d3.corners);', '');
  eval('delete(d3.mask);',    '');
  eval('delete(d3.contour);', '');
  eval('delete(d3.surfh);',   '');
  
  % turns off previous possible lighting
  delete(findobj(gca,'type','light'))
  
  % verify that previous plot has same dim, 2-d or 3-d:
  info = get(gca,'userdata');
  eval('old_dim = info.dim;','old_dim = [];');
  if (isequal(old_dim,'2d') & is3d) | (isequal(old_dim,'3d') & is2d)
    clf
    set(gcf,'userdata',[]);
  end
  
  % verify than if 2d, the old plot has same type:

  % for stations:
  type = '2d'; %  this was added here for stations, but is not in use...
  is2d = 1;

  eval('old_type = info.type;','old_type = type;');
  if is2d & ~isequal(old_type,type)
    clf
    set(gcf,'userdata',[]);
  end
  
  % get also the rate and keep old objetcs to avoid them to be scaled later again by rate:
  eval('rate = info.rate;','rate = 1;');
  old_objs = findobj(gca);
end
hold on


% --------------------------------------------------------------------
% get data
% --------------------------------------------------------------------
set(H.fig,'pointer','watch');

if isstation
  str = ['''station'',ista'];
else
  str = ['''xi'',ista,''eta'',jsta'];
end

if ist
  str = [str,',''time'',itime'];
end

if ~isv
  if isk
    str = [str,',''s'',K'];
  elseif isz
    str = [str,',''z'',Z'];
  end
end

str = [str,',''show'',0'];
eval(['[t,z,v,x,y] = roms_ts(fname,varname,',str,');']);
v(v>1e10)=nan;

% filter:
% nof ilter if vprofile at fixed time...
if length(t) > 1
  isf    = get(H.ROMS.sta.filtercb,'value');
  isfadd = get(H.ROMS.sta.filteradd,'value');
  if isf
    % get T:
    T = get(H.ROMS.sta.filterT,'string'); T = str2num(T);
    if ~isnumber(T,1)
      errordlg(['bad filter T !!'],'bad input data','modal'); 
      return
    end
    vf = roms_tsf(t,z,v,'T',T,'show',0);
  end

else
  isf = 0;
end

set(H.fig,'pointer','arrow');
% --------------------------------------------------------------------
% plot:
% --------------------------------------------------------------------
vcomp = n_vardimexist(fname,varname,'s_rho') | n_vardimexist(fname,varname,'s_w');

% ----------------------------------------------------------- profile at itime
if  ist &  isv & vcomp

  pl = plot(v,z);
  if isf
    if isfadd
      hold on
      plot(vf,z,'r');
    else
      delete(pl);
      plot(vf,z);
    end
  end
  grid on

  % labels: title
   if isstation
      label = sprintf('%s profile, itime = %g, station = %g',varname,itime,ista);
    else
      label = sprintf('%s profile, itime = %g, ixi = %g, ieta = %g',varname,itime,ista,jsta);
    end
    title(label,'interpreter','none');

    % labels: xlabel
    labelx{1} = sprintf('location = %5.2f x %5.2f',x,y);
    labelx{2} = sprintf('time = %5.2f days',t);
    xlabel(labelx,'interpreter','none');

    % labels: ylabel
    ylabel('depth','interpreter','none');

% ------------------------------------------------------------- profile at all times
elseif  isv & vcomp
    % here I must chek if use pcolor, contour or plot:
    % contour:
    if get(H.ROMS.sta.contourcb,'value')
      vv = get(H.ROMS.sta.contourvals,'string'); vv= str2num(vv);
%size(t), size(z), size(v)
      [cs,ch] = contour(t,z,v,vv);
      if isf
        if isfadd
          hold on
          [cs,ch] = contour(t,z,vf,vv);
        else
           delete(ch);
           [cs,ch] = contour(t,z,vf,vv);
        end
      end
      % keep values for clabel:
      H.ROMS.sta.cs = cs;
      H.ROMS.sta.ch = ch;

    % pcolor:
    elseif get(H.ROMS.sta.pcolorcb,'value')
%size(t), size(z), size(v)
      pcolor(t,z,v); shading flat, colorbar
      if ~isf
        pcolor(t,z,v); shading flat, colorbar
      else
        % make no sense add two pcolors !!
        pcolor(t,z,vf); shading flat, colorbar
      end
      % apply caxis:
      if get(H.ROMS.sta.pcolorcaxiscb,'value')
        cax = get(H.ROMS.sta.pcolorcaxis,'string');
        caxis([str2num(cax)]);
      else
        % show current:
        cax = caxis;
        set(H.ROMS.sta.pcolorcaxis,'string',num2str(cax));
      end
    else % then, plot:
%size(t), size(v)
      plot(t,v);
      if isf
        if isfadd
          hold on
          plot(t,vf);
        else
          plot(t,vf)
        end
      end
      grid on
    end

    % labels: title
    if isstation
      label = sprintf('%s profile, station = %g',varname,ista);
    else
      label = sprintf('%s profile, ixi = %g, ieta = %g',varname,ista,jsta);
    end
    title(label,'interpreter','none');

    % labels: xlabel
    labelx{1} = sprintf('location = %5.2f x %5.2f',x,y);
    labelx{2} = sprintf('time = %5.2f to %5.2f days',ot(1,1),ot(end,1));
    xlabel(labelx,'interpreter','none');

    % labels: ylabel
    ylabel('depth','interpreter','none');

% ----------------------------------------------------------------- time series at depth or s-lev
else
  pl = plot(t,v);
  if isf
    if isfadd
      hold on
      plot(t,vf,'r')
    else
      delete(pl);
      plot(t,vf)
    end
  end
  grid on

  % labels: title
  if n_vardimexist(fname,varname,'s_rho') | n_vardimexist(fname,varname,'s_w')
    if isstation
      if isk, label = sprintf('%s time series, station = %g, s-level = %g',varname,ista,K);
      else    label = sprintf('%s time series, station = %g, depth = %g',varname,ista,Z);
      end
    else
      if isk,   label = sprintf('%s time series, ixi = %g, ieta = %g, s-level = %g',varname,ista,jsta,K);
      else      label = sprintf('%s time series, ixi = %g, ieta = %g, depth = %g',varname,ista,jsta,Z);
      end
    end

  else
    if isstation
      if isk, label = sprintf('%s time series, station = %g',varname,ista);
      else    label = sprintf('%s time series, station = %g',varname,ista);
      end
    else
      if isk,   label = sprintf('%s time series, ixi = %g, ieta = %g',varname,ista,jsta);
      else      label = sprintf('%s time series, ixi = %g, ieta = %g',varname,ista,jsta);
      end
    end

  end
  title(label,'interpreter','none');

  % labels: xlabel
  labelx{1} = [tvar, '(days)'];
  labelx{2} = sprintf('location = %5.2f x %5.2f',x,y);
  xlabel(labelx,'interpreter','none');

  % labels: ylabel
  ylabel(varname,'interpreter','none');

end
