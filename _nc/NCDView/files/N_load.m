function N_load
%N_load
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% loads NetCDF files

global H

nc=netcdf('nowrite');

if isempty(nc)
  return
end

fname=name(nc);
nc=close(nc);

% add new file to files global var:
evalc('H.files{end+1}=fname;','H.files{1}=fname;');

% check how many already loaded:
evalc('f=H.files','f=[]');
n=length(f);
set(H.menu_files,'label',['files [',num2str(n),']'])

% add to files menu:
callback=['N_filevars(',num2str(n),')'];
H.menu_files_(n)=uimenu(H.menu_files,'label',['[',num2str(n),'] ',fname],'callBack',callback,'tag','menu_files');

% delete first menu ('none'):
evalc('delete(H.menu_files0)','');

% create variables menus:
N_filevars(n);

% show attributes of fname:
set_fatt(fname);



function set_fatt(file)
  global H
  % get atributes
  nc=netcdf(file);
    a=att(nc);
    M=['#  atributes of --» ',file,'  #'];
    for i=1:length(a)
      b=a{i};
      v_name=name(b);
      v_val=b(:);
      if isnumeric(v_val), v_val=num2str(v_val); end
      M=strvcat(M,[v_name,' --» ', v_val]);
    end
    set(H.varAtt,'string',M);
  nc=close(nc);
return
