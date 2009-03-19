function S2_update_zi(in)

global HANDLES ETC

set(HANDLES.depths,'value',1); % cos a greater value than number of next val can be selected

if nargin == 1
  set(HANDLES.radio_nz,'value',0);
  set(HANDLES.radio_zr,'value',0);
  if isequal(in,'nz');
    set(HANDLES.radio_nz,'value',1)
  elseif isequal(in,'z_r');
    set(HANDLES.radio_zr,'value',1)
  end
end

isnz=get(HANDLES.radio_nz,'value');
iszr=get(HANDLES.radio_zr,'value');

z_r=ETC.new.current_zr0;
zmax=ETC.new.current_zmax;
zmin=ETC.new.current_zmin;

if isempty(z_r) | isempty(zmax) | isempty(zmin)
  return
end

if iszr
  z=flipud(z_r');
  z(1)=zmax;
  z(end)=zmin;
  z(1)=ceil(z(1));
  z(end)=floor(z(end));
  z=round(z);
  for i=2:length(z)
    if z(i) < z(i-1)
      z(i)=z(i-1);
    end
  end
  set(HANDLES.depths,'string',num2str(z));
elseif isnz
  n=str2num(get(HANDLES.nz,'string'));
  if ~isnumber(n,1)
    n=1;
    set(HANDLES.nz,'string',n)
  end
  zmax=ceil(zmax);
  zmin=floor(zmin);
  z=linspace(zmax,zmin,n);
  z=round(z');
  set(HANDLES.depths,'string',num2str(z)); 
end

