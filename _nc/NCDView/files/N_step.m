function N_step(ax)
%N_step
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% called by > and <, step back or forward in some dimension

global H

%start:
dim1_ = get(H.dim1,'string'); dim1n_=str2num(dim1_);
dim2_ = get(H.dim2,'string'); dim2n_=str2num(dim2_);
dim3_ = get(H.dim3,'string'); dim3n_=str2num(dim3_);
dim4_ = get(H.dim4,'string'); dim4n_=str2num(dim4_);

%end:
dim1 = get(H.dim1e,'string'); dim1n=str2num(dim1);
dim2 = get(H.dim2e,'string'); dim2n=str2num(dim2);
dim3 = get(H.dim3e,'string'); dim3n=str2num(dim3);
dim4 = get(H.dim4e,'string'); dim4n=str2num(dim4);

%step:
stepi =  get(H.stepi,'string'); stepi=str2num(stepi);
stepj =  get(H.stepj,'string'); stepj=str2num(stepj);
stepk =  get(H.stepk,'string'); stepk=str2num(stepk);
stepl =  get(H.stepl,'string'); stepl=str2num(stepl);

%max 
maxi = get(H.dim1s,'string'); maxi=str2num(maxi);
maxj = get(H.dim2s,'string'); maxj=str2num(maxj);
maxk = get(H.dim3s,'string'); maxk=str2num(maxk);
maxl = get(H.dim4s,'string'); maxl=str2num(maxl);

%----------------------------- I
if isequal(ax,'I')
  if ~isequal(dim1n_,dim1n)
    set(H.dim1e,'string',dim1_);
  else
    if dim1n_+stepi > maxi
      set(H.dim1, 'string',num2str(1));
      set(H.dim1e,'string',num2str(1));
    else
      set(H.dim1, 'string',num2str(dim1n_+stepi));
      set(H.dim1e,'string',num2str(dim1n_+stepi));
    end
  end
end
%---------------------- I back:
if isequal(ax,'bI')
  if ~isequal(dim1n_,dim1n)
    set(H.dim1,'string',dim1);
  else
    if dim1n-stepi < 1
      set(H.dim1, 'string',num2str(maxi));
      set(H.dim1e,'string',num2str(maxi));
    else
      set(H.dim1, 'string',num2str(dim1n-stepi));
      set(H.dim1e,'string',num2str(dim1n-stepi));
    end
  end
end



%----------------------------- J
if isequal(ax,'J')
  if ~isequal(dim2n_,dim2n)
    set(H.dim2e,'string',dim2_);
  else
    if dim2n_+stepj > maxj
      set(H.dim2, 'string',num2str(1));
      set(H.dim2e,'string',num2str(1));
    else
      set(H.dim2, 'string',num2str(dim2n_+stepj));
      set(H.dim2e,'string',num2str(dim2n_+stepj));
    end
  end
end
%---------------------- J back:
if isequal(ax,'bJ')
  if ~isequal(dim2n_,dim2n)
    set(H.dim2,'string',dim2);
  else
    if dim2n-stepj < 1
      set(H.dim2, 'string',num2str(maxj));
      set(H.dim2e,'string',num2str(maxj));
    else
      set(H.dim2, 'string',num2str(dim2n-stepj));
      set(H.dim2e,'string',num2str(dim2n-stepj));
    end
  end
end

%----------------------------- K
if isequal(ax,'K')
  if ~isequal(dim3n_,dim3n)
    set(H.dim3e,'string',dim3_);
  else
    if dim3n_+stepk > maxk
      set(H.dim3, 'string',num2str(1));
      set(H.dim3e,'string',num2str(1));
    else
      set(H.dim3, 'string',num2str(dim3n_+stepk));
      set(H.dim3e,'string',num2str(dim3n_+stepk));
    end
  end
end
%---------------------- K back:
if isequal(ax,'bK')
  if ~isequal(dim3n_,dim3n)
    set(H.dim3,'string',dim3);
  else
    if dim3n-stepk < 1
      set(H.dim3, 'string',num2str(maxk));
      set(H.dim3e,'string',num2str(maxk));
    else
      set(H.dim3, 'string',num2str(dim3n-stepk));
      set(H.dim3e,'string',num2str(dim3n-stepk));
    end
  end
end

%----------------------------- L
if isequal(ax,'L')
  if ~isequal(dim4n_,dim4n)
    set(H.dim4e,'string',dim4_);
  else
    if dim4n_+stepl > maxl
      set(H.dim4, 'string',num2str(1));
      set(H.dim4e,'string',num2str(1));
    else
      set(H.dim4, 'string',num2str(dim4n_+stepl));
      set(H.dim4e,'string',num2str(dim4n_+stepl));
    end
  end
end
%---------------------- L back:
if isequal(ax,'bL')
  if ~isequal(dim4n_,dim4n)
    set(H.dim4,'string',dim4);
  else
    if dim4n-stepl < 1
      set(H.dim4, 'string',num2str(maxl));
      set(H.dim4e,'string',num2str(maxl));
    else
      set(H.dim4, 'string',num2str(dim4n-stepl));
      set(H.dim4e,'string',num2str(dim4n-stepl));
    end
  end
end

N_disp


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
