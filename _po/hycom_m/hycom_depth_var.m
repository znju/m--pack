function [xg,yg,h]=hycom_depth_var(f,vname,lev,time)

% load grid vars:
UVvars = {};
if ismember(vname,UVvars)
  [xg,yg,hg,mg,m3g] = hycom_grid(f,'uv');
else
  [xg,yg,hg,mg,m3g] = hycom_grid(f);
end
[n,eta,xi]=size(m3g);

% load var:
if isequal(vname,'dens')
  D=hycom_densp(f,time);
else
  D=use(f,vname,'month',time);
end
%D(D==fastmode(D))=inf;

% get z3d:
depth=use(f,'depth'); N=length(depth);
z3d=repmat(depth,[1 eta xi]);

% find increase direction with depth: --------------------------------
[i,j]=find(mg==1);
for n=1:length(i)
  if length(m3g(:,i(n),j(n))>0)>=2
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

%for i=1:size(iM,2)
%  for j=1:size(iM,3)
%    L=length(find(iM(:,i,j)));
%    if L~=1, L,i,j, d(:,i,j), iM(:,i,j), pause, end
%  end
%end

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
