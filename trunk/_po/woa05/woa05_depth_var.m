function [xg,yg,h,problems]=woa05_depth_var(files,vname,lev,time,lims)
%function [xg,yg,h]=woa05_depth_var(files,vname,lev,time,lims)
%
%inputs:
%   files: {ftemp,fsalt,flandsea} if vname = 'dens'
%   or {ftemp,flandsea} for vname='temperature'
%   or {fsalt,flandsea} for vname='salinity'
%
%
% lims: lon_min lon_max lat_min lat_max, se definido so esta regiao
%       sera tida em  conta!!

if nargin<5
  lims=0;
end

if length(files)==2
  [ft,fls]=unpack(files);
elseif length(files)==3
  [ft,fs,fls]=unpack(files);
end

% load grid vars:
[xg,yg,hg,mg,m3g] = woa05_grid(fls,ft);
[n,eta,xi]=size(m3g);

if ~isequal(lims,0)
  [lon1,lon2,lat1,lat2]=unpack(lims);
  [i1,j1]=find(xg>=lon1  & yg>=lat1); i1=i1(1); j1=j1(1);
  [i2,j2]=find(xg<=lon2  & yg<=lat2); i2=i2(end); j2=j2(end);

  xg=xg(i1:i2,j1:j2);
  yg=yg(i1:i2,j1:j2);
  hg=hg(i1:i2,j1:j2);
end

% load var:
if isequal(vname,'dens')
  D=woa05_densp(ft,fs,time);
else
  D=use(ft,vname,'T',time);
end
%D(D==fastmode(D))=inf;

% get z3d:
depth=use(ft,'Z'); N=length(depth);
z3d=repmat(depth,[1 eta xi]);

% find increase direction with depth: --------------------------------
[i,j]=find(mg==1);
for n=1:length(i)
  if length(find(m3g(:,i(n),j(n))>0))>=N/2 %% 2 may lead to bad results !!!
    break
  end
end
dtmp = D(:,i(n), j(n));
ztmp = z3d(:,i(n), j(n));
i=m3g(:,i(n), j(n))==1;
dtmp=dtmp(i);
ztmp=ztmp(i);

INV=1;
if dtmp(end)-dtmp(1) <0
  INV=0;
end
% --------------------------------------------------------------------

if INV
  D(m3g==0)=inf;
  D=flipdim(D,1);
  z3d=flipdim(z3d,1);
else
  D(m3g==0)=-inf;
end

if ~isequal(lims,0)
  D=D(:,i1:i2,j1:j2);
  z3d=z3d(:,i1:i2,j1:j2);
  [eta,xi]=size(xg);
end

if 0
  D=flipdim(D,1);
  z3d=flipdim(z3d,1);
  h=get_depth_var(D,z3d,lev);
else % same as:
  d=zeros([N+2,eta xi]);
  d(1,:,:)=inf;
  d(end,:,:)=-inf;
  d(2:end-1,:,:)=D;

  i=d>lev;
  iM = i(2:end,:,:) - i(1:end-1,:,:);
  iM(2:end+1,:,:) = iM;
  iM(1,:,:) = zeros(size(iM(1,:,:)));
  iM = logical(iM);

  if 1 % ATTEMPT TO FIX ==============================================
  disp('looking for problems...');
  problems=zeros(eta,xi);
  for i=1:size(iM,2)
    for j=1:size(iM,3)
      L=length(find(iM(:,i,j)));
      %if L~=1, L,i,j, d(:,i,j), iM(:,i,j), plot(squeeze(d(:,i,j))), pause, end
      if L~=1
        %b=find(squeeze(iM(:,i,j)));
        %iM(b(2:end),i,j)=0;
        problems(i,j)=1;
        %iM(:,i,j), pause
      end
    end
  end
  fprintf(1,'... found %d problems\n',length(find(problems)));
  if find(problems)
    fprintf(1,'... fixing...\n')
    for i=1:size(problems,1)
      for j=2:size(problems,2)
        if problems(i,j)
          % aqui deveria somar apenas os items que nao apresentassem problemas !!!
          % para ja considero que nenhum a volta apresenta
          % alem disso deveria verificar q nao estou na fronteira, ie, existe i+1, i-1, etc
          D(:,i,j)=(D(:,i-1,j-1)+D(:,i-1,j)+D(:,i-1,j+1)+...
                    D(:,i  ,j-1)           +D(:,i  ,j+1)+...
                    D(:,i+1,j-1)+D(:,i+1,j)+D(:,i+1,j+1))/8;
        end
      end
    end
    fprintf(1,'... done\n')
  end

  d=zeros([N+2,eta xi]);
  d(1,:,:)=inf;
  d(end,:,:)=-inf;
  d(2:end-1,:,:)=D;

  i=d>lev;
  iM = i(2:end,:,:) - i(1:end-1,:,:);
  iM(2:end+1,:,:) = iM;
  iM(1,:,:) = zeros(size(iM(1,:,:)));
  iM = logical(iM);
  end % ATTEMPT TO FIX ===============================================

  i=d < lev;
  im = i(1:end-1,:,:) - i(2:end,:,:);
  im(end+1,:,:) = zeros(size(iM(1,:,:)));
  im = logical(im);

  vUp   = reshape(d(iM), eta, xi);
  vDown = reshape(d(im), eta, xi);
  coefUp   = (vUp-lev)./(vUp-vDown);
  coefDown = (lev-vDown)./(vUp-vDown);

  Z=z3d;
  Z(2:end+1,:,:) = z3d;
  Z(1,:,:)       = repmat(nan,eta,xi);
  Z(end+1,:,:)   = repmat(nan,eta,xi);

  ZUp   = reshape(Z(iM),eta,xi);
  ZDown = reshape(Z(im),eta,xi);
  h = coefUp.*ZDown + coefDown.*ZUp;
end