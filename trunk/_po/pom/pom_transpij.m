function data = pom_transpij(files,type,ind,varargin)
%POM_TRANSPIJ   POM transport across fixed index vertical section
%
%   Syntax:
%      DATA = POM_TRANSPIJ(FILES,TYPE,IND,VARARGIN)
%
%   Inputs:
%      FILES   POM output list of files (cell) of just one file str
%      TYPE    Slice type, x or y
%      IND     Slice indice
%      VARARGIN:
%         quiet, if 0 some messagens may be printed (default=0)
%
%   Outputs:
%      DATA   Structure with many fields, the transport is in field Tr
%             which is a 2-D array with total, total positive and
%             total negative transports in the 1st, 2nd and 3rd columns
%
%   See also OCCAM_TRANSPIJ
%
%   MMA 09-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

quiet=0;
vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'quiet'),   quiet   = vin{i+1};
  end
end

if ~iscell(files), files={files}; end

atuv=1; % else depth and zeta of cell centre is used

grd=files{1};
if strcmpi(type,'x')
  uv_name  = 'u';
  dim_name = 'x';
  if atuv
    [x,y,h,m] = pom_grid(grd,'u','nomask',1);
  else
    [x,y,h,m] = pom_grid(grd,'r');
  end
  indMax=n_dim(grd,dim_name);
  if ind==indMax, ind=ind-1; end
  x=x(:,ind);
  y=y(:,ind);
  h=h(:,ind);
  m=m(:,ind);
elseif strcmpi(type,'y')
  uv_name  = 'v';
  dim_name = 'y';
  if atuv
    [x,y,h,m] = pom_grid(grd,'v','nomask',1);
  else
    [x,y,h,m] = pom_grid(grd,'r');
  end
  indMax=n_dim(grd,dim_name);
  if ind==indMax, ind=ind-1; end
  x=x(ind,:);
  y=y(ind,:);
  h=h(ind,:);
  m=m(ind,:);
end

N=n_dim(files{1},uv_name,'z'); N=N-1;

% calc dx:
[dx,xtmp]=ll_dx(x,y,'halfdxi',0,'halfdxe',0);
dx=repmat(dx(:)',[N 1]);

mask=repmat(m(:)',[N 1]);

z  = use(grd,'z');
zz = use(grd,'zz');

Tr=[];
for i=1:length(files)
  % calc dz:
  ssh = use(files{i},'elb');
  if atuv
    if     strcmpi(type,'x'), ssh=rho2u_2d(ssh); ssh=ssh(:,ind);
    elseif strcmpi(type,'y'), ssh=rho2v_2d(ssh); ssh=ssh(ind,:);
    end
  else
    if     strcmpi(type,'x'), ssh=ssh(:,ind);
    elseif strcmpi(type,'y'), ssh=ssh(ind,:);
    end
  end
  [zr,zw]=pom_s_levels(zz,z,h,ssh);

  zw=squeeze(zw)'; ztmp=zw;
  dz=-diff(zw);

  % get vel:
  v=use(files{i},uv_name,dim_name,ind+1); v=v(1:end-1,:).*mask;

  [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,v);
  if ~quiet
    fprintf(1,'%6.2f %6.2f %6.2f\n',[T,Tpos,Tneg]/1E6);
  end
  Tr(i,:)=[T,Tpos,Tneg]/1E6;

  data.t{i}    = t;
  data.tpos{i} = tpos;
  data.tneg{i} = tneg;
end
data.Tr = Tr;

% add zz:
zz=ztmp;

% add xx:
xx=(xtmp(2:end)+xtmp(1:end-1))/2;
xx=repmat(xx,size(zz,1),1);

data.zz=zz;
data.xx=xx;
