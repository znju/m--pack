function N_filevars(N)
%N_filevars
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% creates menus of variables

global H

evalc('fname=H.files{N};','fname=[]');
if isempty(fname)
  return
end

H.fname=fname;
H.fnamen=N; % file number (to use in N_axLabel)

% check the new file menu:
set(findobj(gcf,'tag','menu_files'),'checked','off');
set(H.menu_files_(N),'checked','on');

% hide main menus:
set(H.menu_ED,'visible','off'); set(H.menu_ED_,'visible','off');
set(H.menu_0D,'visible','off'); set(H.menu_0D_,'visible','off');
set(H.menu_1D,'visible','off'); set(H.menu_1D_,'visible','off');
set(H.menu_2D,'visible','off'); set(H.menu_2D_,'visible','off');
set(H.menu_3D,'visible','off'); set(H.menu_3D_,'visible','off');
set(H.menu_4D,'visible','off'); set(H.menu_4D_,'visible','off');

% hide all other submenus:
set(findobj('tag','menu_var'),'visible','off');

% show variables of new file:
nc=netcdf(fname);
vv=var(nc);
nvars=length(vv);

for i=1:nvars
  Name=name(vv{i});
  conte=0;
  cont0=0;
  cont1=0;
  cont2=0;
  cont3=0;
  cont4=0;

  n = n_varndims(fname,Name);

  if n == -1
    set(H.menu_ED,'visible','on');
    set(H.menu_ED_,'visible','on');
    conte=conte+1;
    cb=['N_use(''ED'',','''',Name,''',',num2str(N),')'];
    H.menu_menu0(N,conte)=uimenu(H.menu_ED,'label',Name,'callBack',cb,'tag','menu_var');
  end
  
  if n == 0
    set(H.menu_0D,'visible','on');
    set(H.menu_0D_,'visible','on');
    cont0=cont0+1;
    cb=['N_use(''0D'',','''',Name,''',',num2str(N),')'];
    H.menu_menu0(N,cont0)=uimenu(H.menu_0D,'label',Name,'callBack',cb,'tag','menu_var');
  end
  if n == 1
    set(H.menu_1D,'visible','on');
    set(H.menu_1D_,'visible','on');
    cont1=cont1+1;
    cb=['N_use(''1D'',','''',Name,''',',num2str(N),')'];
    H.menu_menu1(N,cont1)=uimenu(H.menu_1D,'label',Name,'callBack',cb,'tag','menu_var');
  end
  if n == 2
    set(H.menu_2D,'visible','on');
    set(H.menu_2D_,'visible','on');
    cont2=cont2+1;
    cb=['N_use(''2D'',','''',Name,''',',num2str(N),')'];
    H.menu_menu2(N,cont2)=uimenu(H.menu_2D,'label',Name,'callBack',cb,'tag','menu_var');
  end
  if n == 3
    set(H.menu_3D,'visible','on');
    set(H.menu_3D_,'visible','on');
    cont3=cont3+1;
    cb=['N_use(''3D'',','''',Name,''',',num2str(N),')'];
    H.menu_menu3(N,cont3)=uimenu(H.menu_3D,'label',Name,'callBack',cb,'tag','menu_var');
  end
  if n == 4
    set(H.menu_4D,'visible','on');
    set(H.menu_4D_,'visible','on');
    cont4=cont4+1;
    cb=['N_use(''4D'',','''',Name,''',',num2str(N),')'];
    H.menu_menu4(N,cont4)=uimenu(H.menu_4D,'label',Name,'callBack',cb,'tag','menu_var');
  end

end

nc=close(nc);
