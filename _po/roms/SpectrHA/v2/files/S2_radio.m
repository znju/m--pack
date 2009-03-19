function S2_radio(in)

global HANDLES ETC

set(HANDLES.depths,'value',1); % cos a greater value than number of next val can be selected

set(HANDLES.radio_nz,'value',0);
set(HANDLES.radio_zr,'value',0);

if isequal(in,'nz');
  set(HANDLES.radio_nz,'value',1)

  zmax=get(HANDLES.zmax,'string'); zmax=-str2num(zmax);
  zmin=get(HANDLES.zmin,'string'); zmin=-str2num(zmin);
  n=get(HANDLES.nz,'string'); n=str2num(n);
  if ~isnumber(n,1)
    n=1;
    set(HANDLES.nz,'string',n)
  end

  zmax=ceil(zmax);
  zmin=floor(zmin);
  z=linspace(zmax,zmin,n);
  z=round(z');
  set(HANDLES.depths,'string',num2str(z));
%%%%%%%%%%  ETC.nz=z;
elseif isequal(in,'z_r')
  set(HANDLES.radio_zr,'value',1)

  set(HANDLES.depths,'string',ETC.z_r0);
end
