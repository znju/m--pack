function R_mvfltindex(what)

% called by > and <, step back or forward in some dimension

global H

dimi    = H.ROMS.flt.dimi;
dimstep = H.ROMS.flt.dimstep;
dime    = H.ROMS.flt.dime;
dims    = H.ROMS.flt.dims;

%start:
dim1_ = get(dimi,'string'); dim1n_=str2num(dim1_);

%end:
dim1 = get(dime,'string'); dim1n=str2num(dim1);

%step:
stepi =  get(dimstep,'string'); stepi=str2num(stepi);

%max:
maxi = get(dims,'string'); maxi=str2num(maxi);

%----------------------------- index forward
if isequal(what,'f')
  if ~isequal(dim1n_,dim1n)
    set(dime,'string',dim1_);
  else
    if dim1n_+stepi > maxi
      set(dimi, 'string',num2str(1));
      set(dime,'string',num2str(1));
    else
      set(dimi, 'string',num2str(dim1n_+stepi));
      set(dime,'string',num2str(dim1n_+stepi));
    end
  end
end
%----------------------  back:
if isequal(what,'b')
  if ~isequal(dim1n_,dim1n)
    set(dimi, 'string',dim1);
  else
    if dim1n-stepi < 1
      set(dimi, 'string',num2str(maxi));
      set(dime, 'string',num2str(maxi));
    else
      set(dimi, 'string',num2str(dim1n-stepi));
      set(dime, 'string',num2str(dim1n-stepi));
    end
  end
end

%------------------------------------------------------- init and end
% reset init index:
if isequal(what,'init')
  set(dimi,'string',1);
end

% reset final index:
if isequal(what,'end')
  set(dime,'string',maxi);
end

% ---------------------------------------------------- check edited values:
% start:
if isequal(what,'checkinit')
  if dim1n_ <= 0 | dim1n_ > maxi
    set(dimi,'string',1);
  end
end

% step:
if isequal(what,'checkstep')
  if stepi > maxi
    set(dimstep,'string',1);
  end
end

% end:
if isequal(what,'checkend')
  if dim1n < dim1n_  | dim1n > dim1n_
    set(dime,'string',maxi);
  end
end

% plot if dispcb is checked:
if get(H.ROMS.flt.dispcb,'value')
  R_dispflt;
end


return

%%%%%%%%%%%%%%%%%
% auto advance index: ( menu: misc--> auto >< )
evalc('loop   = H.advancei.loop;',  'loop   = 1;');
evalc('pause_ = H.advancei.pause;', 'pause_ = 0;');
evalc('vali   = H.advancei.i;',     'vali   = 0;');
evalc('valj   = H.advancei.j;',     'valj   = 0;');
evalc('valk   = H.advancei.k;',     'valk   = 0;');
evalc('vall   = H.advancei.l;',     'vall   = 0;');

%--------------------------- I, bI
if isequal(ax,'I')  & vali
  if ~ (dim1n_+stepi > maxi)
    drawnow
    eval(['pause(',pause_,')']);
    N_step('I')
  end
end

if isequal(ax,'bI')  & vali
  if ~ (dim1n-stepi < 1)
    drawnow
    eval(['pause(',pause_,')']);
    N_step('bI')
  end
end

%--------------------------- J, bJ
if isequal(ax,'J')  & valj
  if ~ (dim2n_+stepj > maxj)
    drawnow
    eval(['pause(',pause_,')']);
    N_step('J')
  end
end

if isequal(ax,'bJ')  & valj
  if ~ (dim2n-stepj < 1)
    drawnow
    eval(['pause(',pause_,')']);
    N_step('bJ')
  end
end

%--------------------------- K, bK
if isequal(ax,'K')  & valk
  if ~ (dim3n_+stepk > maxk)
    drawnow
    eval(['pause(',pause_,')']);
    N_step('K')
  end
end

if isequal(ax,'bK')  & valk
  if ~ (dim3n-stepk < 1)
    drawnow
    eval(['pause(',pause_,')']);
    N_step('bK')
  end
end

%--------------------------- L, bL
if isequal(ax,'L')  & vall
  if ~ (dim4n_+stepl > maxl)
    drawnow
    eval(['pause(',pause_,')']);
    N_step('L')
  end
end

if isequal(ax,'bL')  & vall
  if ~ (dim4n-stepl < 1)
    drawnow
    eval(['pause(',pause_,')']);
    N_step('bL')
  end
end
