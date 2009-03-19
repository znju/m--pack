function R_staselect(method)

% method = mouse or edit

global H

evalc('fname=H.ROMS.sta.fname','fname=[]');
if isempty(fname);
  return
end


htxt = H.ROMS.sta.selectinfo;
seln = H.ROMS.sta.selectn;

% load x,y:
if n_varexist(fname,'lon_rho');
  xsta = use(fname,'lon_rho');
elseif n_varexist(fname,'x_rho');
  xsta = use(fname,'x_rho');
else
  xsta = use(fname,'lon');
end
if n_varexist(fname,'lat_rho');
  ysta = use(fname,'lat_rho');
elseif n_varexist(fname,'y_rho');
  ysta = use(fname,'y_rho');
else
  ysta = use(fname,'lat');
end

% also load depth to show:
if n_varexist(fname,'h')
  depth = use(fname,'h');
else
  depth=NaN;
end

% it looks like roms2+ sets positions over mask as 1e35, so convert to nan:
xsta(xsta == 1e35) = nan;
ysta(ysta == 1e35) = nan;


% ------------------------------ select with mouse:
if isequal(method,'mouse')
  while 1
    [x,y] = m_input(1);

    if ~isempty(x)
      dist = (xsta-x).^2 + (ysta-y).^2;
      [i,j] = find(dist == min(min(dist)));
      evalc('set(H.ROMS.sta.tmp_point,''color'',[.5 .5 .5]);','');
      H.ROMS.sta.tmp_point = plot(xsta(i,j), ysta(i,j),'ro');
      % show info:
      if isnan(depth)
        str = sprintf('sta: %g x %g',i,j);
      else
        str = sprintf('sta: %g x %g, h = %6.2f',i,j,depth(i,j));
      end
      set(htxt,'string',str);

      % show at selected n:
      str = sprintf('%g x %g',i,j);
      set(seln,'string',str);
    else
      break;
    end
  end
end


% ------------------------------ edit to select:
if isequal(method,'edit')
  % allow to write i x j or simply i j:
  str = get(seln,'string');
  if isempty(str2num(str));
    s=str2num(cell2mat(explode(str,'x')));
  else
    s=str2num(str);
  end
  i = s(1);
  j = s(2);

  if ~isempty(i) & ~isempty(j)
    evalc('set(H.ROMS.sta.tmp_point,''color'',[.5 .5 .5]);','');
    evalc('xx = xsta(i,j); yy = ysta(i,j);','xx=[];');
    if ~isempty(xx)
      H.ROMS.sta.tmp_point = plot(xx, yy,'ro');
      % show info:
      str = sprintf('sta: %g x %g, h = %6.2f',i,j,depth(i,j));
      set(htxt,'string',str);
    else
      set(seln,'string','sta #');
    end
  else
    set(seln,'string','sta #');
  end

end
