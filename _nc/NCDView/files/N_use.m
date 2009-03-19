function N_use(type,varname,filenumber)
%N_use
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% loads variable

global H

fname=H.files{filenumber};

%H.fname=fname;
%H.fnamen=filenumber;

% check if var exist:
ok = n_varexist(fname,varname);
if ~ok
  disp(['## error: variable ',varname,' do not exist in file ',fname]);
  return
end

set_att(varname,fname);

%--------------------
%set info
str=[varname,'(',num2str(filenumber),')'];
set(H.varInfo,'string',str);

%----------------------- check for scale and offset:
[scale,offset] = n_varscale(fname,varname);

if ~isempty(scale)
  set(H.varMult,'string',scale);
else
  set(H.varMult,'string',1);
end
H.varMult_current=get(H.varMult,'string'); % to use by N_checkeditvals

if ~isempty(offset)
  set(H.varOffset,'string',offset);
else
  set(H.varOffset,'string',0);
end
H.varOffset_current=get(H.varOffset,'string'); % to use by N_checkeditvals

% set dims:
nc=netcdf(fname);

  dim1=size(nc{varname},1);
  dim2=size(nc{varname},2);
  dim3=size(nc{varname},3);
  dim4=size(nc{varname},4);

  set(H.dim1s,'string',num2str(dim1));
  set(H.dim2s,'string',num2str(dim2));
  set(H.dim3s,'string',num2str(dim3));
  set(H.dim4s,'string',num2str(dim4));

  set(H.dim1e,'string',num2str(dim1));
  set(H.dim2e,'string',num2str(dim2));
  set(H.dim3e,'string',num2str(dim3));
  set(H.dim4e,'string',num2str(dim4));

  set(H.dim1,'string',num2str(1));
  set(H.dim2,'string',num2str(1));
  set(H.dim3,'string',num2str(1));
  set(H.dim4,'string',num2str(1));

  switch type
    case '0D' % show val:
      var=nc{varname}(:);
      set(H.varInfo1,'string',num2str(var));
    otherwise % show size:
      set(H.varInfo1,'string',num2str(size(nc{varname})));
  end

  if ~all(size(nc{varname})) %  zeros on size
    set(H.varInfo1,'string','EMPTY');
  end

nc=close(nc);

% plotOnLoad:
plotOnLoad = get(H.plotOnLoad,'value');

if plotOnLoad
  N_disp;
end


function set_att(varname,fname)
global H
% get atributes
nc=netcdf(fname);
  var=nc{varname};
  a=att(var);
  M=['#  atributes of --» ',varname,'  #'];
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
