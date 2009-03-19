function data=pop_transp(files,x_,y_,varargin)
%POP_TRANSP   POP transport across vertical section
%
%   Syntax:
%      DATA = POP_TRANSP(FILES,X,Y,VARARGIN)
%
%   Inputs:
%      FILES   POP files with vars U, V, SSH (3 files)
%      X,Y   Lon x lat path
%      VARARGIN:
%        quiet, if 0 some messagens may be printed (default=0)
%        halfdxi, if 1, first cell dx will be divided by 2 (default=1)
%        halfdxe, if 1, last cell dx will be divided by 2 (default=1)
%        save, output save name, if 0, no save is done (the default)
%        ang, angles of the lon x lat path, if not provided is is
%        computed by GET_ANGLE
%
%   Outputs:
%    DATA   Structure with many fields, the transport is in field Tr
%           which is a 2-D array with total, total positive and
%           total negative transports in the 1st, 2nd and 3rd columns
%
%   See also OCCAM_TRANSPIJ
%
%   MMA 28-08-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

savename=0;
ang=[];
quiet=0;
halfdxi=1;
halfdxe=1;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'quiet'),   quiet   = vin{i+1};
  elseif isequal(vin{i},'halfdxi'), halfdxi = vin{i+1};
  elseif isequal(vin{i},'halfdxe'), halfdxe = vin{i+1};
  elseif isequal(vin{i},'save'),    savename = vin{i+1};
  elseif isequal(vin{i},'ang'),     ang      = vin{i+1};
  end
end

if ~iscell(files)
  disp(':: file u, v and ssh needed')
  return
end

fnameU=files{1};
fnameV=files{2};
fnameZ=files{3};

x_=x_(:)';
y_=y_(:)';

% about angle:
if isempty(ang)
  Lon=x_(:)';
  Lat=y_(:)';
  lonu=(Lon(:,1:end-1)+Lon(:,2:end))/2;
  latu=(Lat(:,1:end-1)+Lat(:,2:end))/2;

  ang=get_angle(latu,lonu);
end

% calc dz (without ssh):
Ze=use(files{1},'w_dep');
Z=diff(Ze);
dZ=repmat(Z,1,length(x_));

% calc dx:
[X,xtmp] = ll_dx(x_,y_);
dX=repmat(X,size(Z,1),1);

ang=repmat(ang,length(Z),1);

data.dX=dX;
data.ang=ang;
data.x=x_;
data.y=y_;
data.Tr=[];
for i=1:1%length(files)
  %fname=files{i};

  u   = pop_slicell(fnameU,'U',x_,y_,1)*0.01;
  v   = pop_slicell(fnameV,'V',x_,y_,1)*0.01;
  ssh = pop_slicell(fnameZ,'SSH',x_,y_,1);

  % add ssh to dz:
  ssh(isnan(ssh))=0;
  dZ(1,:)=dZ(1,:)+ssh;

  % calc V:
  V=-u.*sin(ang)+v.*cos(ang);

  % transport:
  [T,Tpos,Tneg,t,tpos,tneg]=calc_transp(dX,dZ,V);
  if ~quiet
    fprintf(1,'%6.2f %6.2f %6.2f\n',[T,Tpos,Tneg]/1E6);
  end
  data.Tr(i,:)=[T,Tpos,Tneg]/1E6;

  data.dZ=dZ;
  data.u{i} = u;
  data.v{i} = v;
  data.V{i} = V;
  %data.file{i}=fname;
  data.T{i}    = T;
  data.Tpos{i} = Tpos;
  data.Tneg{i} = Tneg;
  data.t{i}    = t;
  data.tpos{i} = tpos;
  data.tneg{i} = tneg;
end

% add xx and zz to data:
z=use(files{1},'depth_t');
zz=repmat(z,1,length(x_));

xx=(xtmp(2:end)+xtmp(1:end-1))/2;
xx=repmat(xx,size(zz,1),1);

data.xx=xx;
data.zz=zz;

% add occam depth at slice:
[X,Y,Z,h,Ze]=pop_slicell(fnameU,'hu',x_,y_); h(isnan(h))=0;
data.h=h;

if savename
  save(savename,'data')
end
