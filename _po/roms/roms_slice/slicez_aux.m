function [v,mask]=v_at_z(Z,v,zi)
[N,M,L]=size(v);

z = repmat(nan,[N+2 M L]);
z(2:end-1,:,:)=Z;
z(1,:,:) = -inf;
z(end,:,:) = inf;

% find z indices with depth above z:
i=z > zi;
iM = i(2:end,:,:) - i(1:end-1,:,:);
iM(2:end+1,:,:) = iM;
iM(1,:,:) = zeros(size(iM(1,:,:)));
iM = logical(iM);

% find z indices with zi under z:
i=z < zi;
im = i(1:end-1,:,:) - i(2:end,:,:);
im(end+1,:,:) = zeros(size(iM(1,:,:)));
im = logical(im);

% get interpolation coefficients:
zUp   = reshape(z(iM),M,L);
zDown = reshape(z(im),M,L);
coefUp   = (zUp-zi)./(zUp-zDown);
coefDown = (zi-zDown)./(zUp-zDown);

% z not needed anymore:
z=repmat(zi,M,L);

v(2:end+1,:,:) = v;
v(1,:,:)       = repmat(nan,M,L);
v(end+1,:,:)   = repmat(nan,M,L);

vUp   = reshape(v(iM),M,L);
vDown = reshape(v(im),M,L);
v = coefUp.*vDown + coefDown.*vUp;
mask=~isnan(v);
