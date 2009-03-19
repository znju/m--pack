function S2_disp_pos

global HANDLES

cp=get(HANDLES.grid_axes,'currentpoint');
cp=cp(1,1:2);

% check if is inside axes:
xl = get(HANDLES.grid_axes,'xlim');
yl = get(HANDLES.grid_axes,'ylim');
a=[xl yl];
if cp(1) > a(1) & cp(1) < a(2) & cp(2) > a(3) & cp(2) < a(4)
  cp=sprintf('%8.4f x %8.4f',cp);
  set(HANDLES.pos,'string',cp)
else
  set(HANDLES.pos,'string','');
end
