function b_smooth(fname,hmin,hmax,Rlim,Rcut,Rw,cvals,plt)
%B_SMOOTH   Smooth ROMS bathymetry
%
%   Syntax:
%   B_SMOOTH(GRD,HMIN,HMAX,RMAX,RCUT,RW,CVALS,CVALS,PLT)
%
%   Inputs:
%      GRD    Grid filename
%      HMIN   Minimum depth, defult=5
%      HMAX   Maximum depth, defualt=inf
%      RLIM   Maximum R factor, default=0.2
%      RCUT   Reference value, should be 0 < RCUT < RLIM; the lowest
%             this value the lowest is the accuracy, by default is
%             0.9*RLIM
%      RW     Directional weights, changing this parameter allows the
%             isolines of depth to move in the NSEW directions; by
%             default is [3 3 3 3] ([N S E W]), If you want to keep shelf
%             width in esatern coasts, should increase the W component
%             of RW; a good value is to increase 10%, so RW=[3 3 3 3.3]
%             Anyway, better test the results and choose a good RW
%             (something like 2 or 3 may be ok)
%      CVALS  Levels to plot Contour values ([200 1000])
%      PLT    Each 1000 steps is done a contour of h at CVALS,
%             default=0 (no intermediate plots)
%
%   Example:
%      b_smooth('roms_grd.nc')
%
%   MMA 12-2006, martinho@fis.ua.pt
%
%   See also ADD_HRAW

% Department of Physics
% University of Aveiro, Portugal

if nargin<8
  plt=0;
end

if nargin<7
  cvals=[200 1000];
end

if nargin <6
   Rw=[3 3 3 3];
end

if nargin < 4
  Rlim = 0.2% final max r
end

if nargin < 5
  Rcut = Rlim*.9; % used inside smooth: r(r< Rcut)= 0;
end

if nargin < 3
  hmax = inf;
end

if nargin <2
   hmin=5;
end

% ------------------------------------- load data:
nc=netcdf(fname);
  h=nc{'hr'}(:);
  if isempty(h)
     h=nc{'h'}(:);
  end
  hraw=h;
  x=nc{'lon_rho'}(:);
  y=nc{'lat_rho'}(:);
  mask=nc{'mask_rho'}(:);
close(nc);

% ----------------------------- set hmin amd hmax:
h(h<hmin)=hmin;
h(h>hmax)=hmax;

% ------------------- calc first r and start loop:
[xr,yr,r]=calc_r(h,x,y);

if plt
  figure;
  rall=r; rall(end+1,:)=r(end,:); rall(:,end+1)=rall(:,end);
  rall(rall<Rlim)=nan;
  pc=pcolor(rall); shading flat, colormap(flipud(gray))
  hold on
  [cs,ch]=contour(h,cvals,'b');
  contour(hraw,cvals,'r--');
end

n=0;
R=[];
while 1
  n=n+1;
  h=smooth_once(h,r,Rcut,Rw);
  r=calc_r(h);

  R(n)=max(r(:));
  fprintf(1,' ## r parameter at step %3d  r = %7.6f\n',n,R(n));

  if plt
    if mod(n,1000)==0 | max(r(:)) <= Rlim
      rall=r; rall(end+1,:)=r(end,:); rall(:,end+1)=rall(:,end); rall(rall<Rlim)=nan;
      set(pc,'cdata',rall);
      delete(ch);
      [cs,ch]=contour(h,cvals,'b');
      drawnow
    end
  end

  if max(r(:)) <= Rlim, break,end
end


% ----------------------------------- plot output:
figure
contour(x,y,h,cvals,'r'); hold  on ,
contour(x,y,hraw,cvals,'k')
contour(x,y,mask,[.5 .5])


figure
pcolor(zero2nan(h-hraw))
shading flat, colorbar
title('h-hraw')

figure, plot(R)
title('R max')

% ------------------------------ store the result:
nc=netcdf(fname,'w');
  nc{'h'}(:)=h;
close(nc)
fprintf(1,'\n:: new bathymetry stored\n')



function h=smooth_once(h,r,Rcut,Rw)
h0=h;
r(r<Rcut)= 0;
r0=r;

r=.5*(r(1:end-1,:)+r(2:end,:));
r=.5*(r(:,1:end-1)+r(:,2:end));

RwN = Rw(1);
RwS = Rw(2);
RwE = Rw(3);
RwW = Rw(4);

W = r.^RwW;
E = r.^RwE;
N = r.^RwN;
S = r.^RwS;
C = 1;
s=W+E+N+S+C;

h(2:end-1,2:end-1) = 1./s.*(                         ...
                            W.*h(2:end-1,1:end-2) +  ...
                            E.*h(2:end-1,3:end  ) +  ...
                            N.*h(3:end  ,2:end-1) +  ...
                            S.*h(1:end-2,2:end-1) +  ...
                            C.*h(2:end-1,2:end-1)    ...
                           );

% smooth boundary points (may be a problem!!):
n=1;

% W
rr=r0(1:end-1,1); if any(rr), rr=maf(rr,[1 1 1 1 1])';end
W = rr.^n;
E = rr.^n;
N = rr.^n;
S = rr.^n;
C = 1;
s=C+E+N+S;
h(2:end-1,1) = 1./s.*(                  ...
                      C.*h(2:end-1,1) + ...
                      E.*h(2:end-1,2) + ...
                      N.*h(3:end  ,1) + ...
                      S.*h(1:end-2,1)   ...
                     );

% E
rr=r0(1:end-1,end); if any(rr), rr=maf(rr,[1 1 1 1 1])';end
W = rr.^n;
E = rr.^n;
N = rr.^n;
S = rr.^n;
C = 1;
s=C+W+N+S;
h(2:end-1,end) = 1./s.*(                      ...
                        C.*h(2:end-1,end  ) + ...
                        W.*h(2:end-1,end-1) + ...
                        N.*h(3:end  ,end  ) + ...
                        S.*h(1:end-2,end  )   ...
                       );

% S
rr=r0(1,1:end-1); if any(rr), rr=maf(rr,[1 1 1 1 1]);end
W = rr.^n;
E = rr.^n;
N = rr.^n;
S = rr.^n;
C = 1;
s=C+W+E+N;
h(1,2:end-1)=1./s.*(                  ...
                    C.*h(1,2:end-1) + ...
                    W.*h(1,1:end-2) + ...
                    E.*h(1,3:end  ) + ...
                    N.*h(2,2:end-1)   ...
                   );

% N
rr=r0(end,1:end-1); if any(rr), rr=maf(rr,[1 1 1 1 1]);end
W = rr.^n;
E = rr.^n;
N = rr.^n;
S = rr.^n;
C = 1;
s=C+W+E+S;
h(end,2:end-1)=1./s.*(                      ...
                      C.*h(end  ,2:end-1) + ...
                      W.*h(end  ,1:end-2) + ...
                      E.*h(end  ,3:end  ) + ...
                      S.*h(end-1,2:end-1)   ...
                     );

% smooth at corners:
a=1; b=r0(1,2);       c=r0(2,1);       h(1,1)     = 1/(a+b+c) *( a*h(1,1)     + b*h(1,2)       + c*h(2,1)       );
a=1; b=r0(end,2);     c=r0(end-1,1);   h(end,1)   = 1/(a+b+c) *( a*h(end,1)   + b*h(end,2)     + c*h(end-1,1)   );
a=1; b=r0(end,end-1); c=r0(end-1,end); h(end,end) = 1/(a+b+c) *( a*h(end,end) + b*h(end,end-1) + c*h(end-1,end) );
a=1; b=r0(1,end-1);   c=r0(2,end);     h(1,end)   = 1/(a+b+c) *( a*h(1,end)   + b*h(1,end-1)   + c*h(2,end)     );


function varargout=calc_r(h,x,y)
[M,N]=size(h); m=M-1; n=N-1;
if nargout==3
  x=.25*( x(1:m,1:n) + x(2:M,1:n) + x(1:m,2:N) + x(2:M,2:N) );
  y=.25*( y(1:m,1:n) + y(2:M,1:n) + y(1:m,2:N) + y(2:M,2:N) );
end
rx = abs(h(2:M,:)-h(1:m,:))./(h(2:M,:)+h(1:m,:));
ry = abs(h(:,2:N)-h(:,1:n))./(h(:,2:N)+h(:,1:n));
r=max( max(rx(:,1:n),rx(:,2:N)), max( ry(1:m,:),ry(2:M,:)) );

if nargout==3
  varargout{1}=x;
  varargout{2}=y;
  varargout{3}=r;
else
  varargout{1}=r;
end
