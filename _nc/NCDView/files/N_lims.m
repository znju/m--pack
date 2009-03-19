function N_lims(what)
%N_lims
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% controls limits and DataAspectRatio buttons

global H

%axes(H.axes);
figure(H.fig);
axes(gca);

if nargin==0
 what=[];
end

%------------------------------------
% for the checkboxes:
if isequal(what,'xcb')
  H.limits.xlim=str2num(get(H.xlim,'string'));
elseif isequal(what,'ycb')
  H.limits.ylim=str2num(get(H.ylim,'string'));
elseif isequal(what,'zcb')
  H.limits.zlim=str2num(get(H.zlim,'string'));
elseif isequal(what,'arcb')
  H.limits.dar=str2num(get(H.ar,'string'));
end
%-----------------------------------

ax=axis;

% set current values:
if isequal(what,'set')
  % xlim and ylim:
  set(H.xlim,'string',num2str([ax(1) ax(2)]));
  set(H.ylim,'string',num2str([ax(3) ax(4)]));

  % zlim:
  if length(ax) > 4
    set(H.zlim,'string',num2str([ax(5) ax(6)]));
  else
    set(H.zlim,'string',num2str([0 1]));
  end

  % DataAspectRatio:
  set(H.ar,'string',num2str(get(gca,'DataAspectRatio')));

else
% update values:

  xl = str2num(get(H.xlim,'string'));
  yl = str2num(get(H.ylim,'string'));
  zl = str2num(get(H.zlim,'string'));
  ar = str2num(get(H.ar,  'string'));


  if isnumber(xl,2) & isnumber(yl,2) & isnumber(yl,2) & (isequal(what,'x') | isequal(what,'y') | isequal(what,'z'))
    if length(ax) > 4
      str=['axis([',num2str(xl),' ', num2str(yl),' ',num2str(zl),'])'];
    else
      str=['axis([',num2str(xl),' ', num2str(yl),'])'];
    end
   evalc(str,'');
  elseif isequal(what,'ar') & isnumber(ar,3)
    set(gca,'DataAspectRatio',ar);
  else
    N_lims('set');
  end
end
