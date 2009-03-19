function [x,y,X,Y,xfilenumber,yfilenumber,do_xyLabels]=N_setxy(fname,varname,n,s)
%N_setxy
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% retrieves x and y to use in plots; also tries to guess ranges
% Add 20-9-2004: scale and offset for d1x, x and y

% n = 0 --> single value
% n = 1 --> vector, 1-D case
% n = 2 --> matrix, 2-D case
% n > 2 --> do nothing
% n < 0 --> empty variable, do nothing

global H

if ~(n==1 | n==2)
  x           = [];
  y           = [];
  X           = [];
  Y           = [];
  xfilenumber = [];
  yfilenumber = [];
  do_xyLabels = 0;
  return
end

if n==2

  if get(H.xycb,'value')
    % get x varname:
    [xvarname,filenumber] = N_getvarname(H.x);
    X    = xvarname{1};
    xfilenumber = filenumber{1};
    evalc('xfname = H.files{xfilenumber};','xfname=[];');
    if isempty(xfname)
      disp(['## error loading file number ',num2str(xfilenumber),' : nfiles= ',num2str(length(H.files))]);
      return
    end

    % get y varname:
    [yvarname,filenumber] = N_getvarname(H.y);
    Y    = yvarname{1};
    yfilenumber = filenumber{1};
    evalc('yfname = H.files{yfilenumber};','yfname=[];');
    if isempty(yfname)
      disp(['## error loading file number ',num2str(yfilenumber),' : nfiles= ',num2str(length(H.files))]);
      return
    end

  else
    X=[];
    Y=[];
    xfilenumber=[];
    yfilenumber=[];
  end

  if get(H.xycb,'value') % use x and y
    if ~get(H.xyrcb,'value') % if range not checked, try to find appropriate:
      rangex1='1:1';rangex2='1:1';rangex3='1:1';rangex4='1:1';
      rangey1='1:1';rangey2='1:1';rangey3='1:1';rangey4='1:1';

      ndx = n_vararraydim(xfname,X);
      ndy = n_vararraydim(yfname,Y);
      dx  = n_varsize(xfname,X);
      dy  = n_varsize(yfname,Y);
      dv  = n_varsize(fname,varname);

      if ndx >= 1 & ndy >= 1
        % find witch dim to use
        i  = find(dx > 1);
        ii = find(dy > 1);
        for ax=1:length(i)
          I=i(ax);
          d_x=dx(I); I=num2str(I);
          ix  = find(dv == d_x); ix=num2str(ix);
          evalc(['rangex',I,'=N_getRange(',ix,');'],'');
        end
        for ay=1:length(ii)
          I=ii(ay);
          d_y=dy(I); I=num2str(I);
          iy  = find(dv == d_y); iy=num2str(iy);
          evalc(['rangey',I,'=N_getRange(',iy,');'],'');
        end
      end

      % show dim vals and load var:
      set(H.xrange,'string',['(',rangex1,',',rangex2,',',rangex3,',',rangex4,')']);
      x=N_getVar(xfname,X,rangex1,rangex2,rangex3,rangex4);

      set(H.yrange,'string',['(',rangey1,',',rangey2,',',rangey3,',',rangey4,')']);
      y=N_getVar(yfname,Y,rangey1,rangey2,rangey3,rangey4);
    else
      rangex=get(H.xrange,'string');
      x=N_getVar(xfname,X,rangex);

      rangey=get(H.yrange,'string');
      y=N_getVar(yfname,Y,rangey);
    end

  end % if get(H.xycb,'value')

  evalc('x=squeeze(x);','x=[]');
  evalc('y=squeeze(y);','x=[]');
  if isempty(x) | isempty(y)
%    x=1:size(v,2);
%    y=1:size(v,1);
    x=1:s(2);
    y=1:s(1);
    do_xyLabels=0;
  else
    do_xyLabels=1;
  end


  % apply scale and ofset:
  [scale,offset] = N_setVarScale('x','get');
  x = x*scale+offset;

  [scale,offset] = N_setVarScale('y','get');
  y = y*scale+offset;

end % if n == 2




if n == 1

  if get(H.d1xcb,'value')
     % get x varname:
    [xvarname,filenumber] = N_getvarname(H.d1x);
    X    = xvarname{1};
    xfilenumber = filenumber{1};
    evalc('xfname = H.files{xfilenumber};','xfname=[];');
    if isempty(xfname)
      disp(['## error loading file number ',num2str(xfilenumber),' : nfiles= ',num2str(length(H.files))]);
      return
    end
  else
    X=[];
    xfilenumber=[];
  end

  if get(H.d1xcb,'value') % use x
    if ~get(H.d1xrangecb,'value') % if range not checked, try to find appropriate:

      rangex1='1:1';rangex2='1:1';rangex3='1:1';rangex4='1:1';

      ndx = n_vararraydim(xfname,X);
      dx  = n_varsize(xfname,X);
      dv  = n_varsize(fname,varname);

      if ndx >= 1
        % find witch dim to use
        i  = find(dx > 1);
        for ax=1:length(i)
          I=i(ax);
          d_x=dx(I); I=num2str(I);
          ix  = find(dv == d_x); ix=num2str(ix);
          evalc(['rangex',I,'=N_getRange(',ix,');'],'');
        end
      end

      % show dim vals and load var:
      set(H.d1xrange,'string',['(',rangex1,',',rangex2,',',rangex3,',',rangex4,')']);
      x=N_getVar(xfname,X,rangex1,rangex2,rangex3,rangex4);
    else
      rangex=get(H.d1xrange,'string');
      x=N_getVar(xfname,X,rangex);
    end

  end % if get(H.d1xcb,'value')

  evalc('x=squeeze(x);','x=[]');
  if isempty(x)
%    x=1:length(v);
    x=1:max(s);
    do_xyLabels=0;
  else
    do_xyLabels=1;
  end

  Y=[];
  y=[];
  yfilenumber=[];

  % apply scale and ofset:
  [scale,offset] = N_setVarScale('d1x','get');
  x = x*scale+offset;
end %  if n == 1
