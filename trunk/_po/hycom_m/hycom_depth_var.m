function [xg,yg,h,problems]=hycom_depth_var(f,vname,lev,time)

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
elseif isequal(vname,'densmean')
  D=squeeze(mean(hycom_densp(f)));
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

if 0
  D=flipdim(D,1);
  z3d=flipdim(z3d,1);
  h=get_depth_var(D,z3d,lev);
  problems=0;
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
    problems=look_for_problems(iM);
    [i,j]=find(problems);
    disp('fixing...')
    for n=1:length(i)
      d(1:end-1,i(n),j(n))=inf;
      d(end,i(n),j(n))=-inf;
    end
    disp('...done')

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

if find(problems)
  hh=h;
  i=problems==1;
  h(i)=griddata(xg(~i),yg(~i),h(~i),xg(i),yg(i));
end

function problems=look_for_problems(iM)
  [n,eta,xi]=size(iM);
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
        %iM(:,i,j), d(:,i,j), pause
      end
    end
  end
  fprintf(1,'... found %d problems\n',length(find(problems)));

