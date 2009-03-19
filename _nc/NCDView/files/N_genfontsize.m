function N_genfontsize(where,what)
%N_genfontsize
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% generates fontsize menus

global H

evalc(['is=ishandle(',where,');'],'is=0;');
if ~is
  return
end

for n=4:20
  cb=['N_setfontsize(''''',what,''''',',num2str(n),')'];
  str=[where,'_(',num2str(n),')=uimenu(',where,',''label'',''',num2str(n),''',''callback'',''',cb,''',''tag'',''menu_fontsize_',what,''')'];
  evalc(str,'');
end

%---------------------------------------------------------------------
% set the checked one:

if isequal(what,'ax')
  fs=get(findobj(gcf,'type','axes'),'fontsize');
elseif isequal(what,'edit')
  fs=get(findobj(gcf,'type','uicontrol','style','edit'),'fontsize');
elseif isequal(what,'push')
  fs=get(findobj(gcf,'type','uicontrol','style','pushbutton'),'fontsize');
elseif isequal(what,'text')
  fs=get(findobj(gcf,'type','uicontrol','style','text'),'fontsize');  
end
evalc('fs=fs{1};','fs=fs(1)');

% find menu with this number
objTag=['menu_fontsize_',what];
obj=findobj(gcf,'tag',objTag,'label',num2str(fs));
set(obj,'checked','on');
