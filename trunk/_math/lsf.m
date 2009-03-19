function [tidestruc,xout] = lsf(t,f,tide,output,fopen_opt)
%LSF   Harmonic analysis of time series using Least Squares Fit
%   Returns amplitudes (C) and phases (pha) of the harmonic components
%   of series, Ci*cos(2*pi*t/Ti-phai).
%   For imaginary series, the amplitudes and phases of the real and
%   imaginary part is converted in ellipse parameters (semi-major and
%   minor axis, inclination and phase angle).
%
%   Syntax:
%      [TIDESTRUC,XOUT] = LSF(T,F,P,OUT,OPT)
%
%   Inputs:
%      T     Time in the series (hours), or interval
%      F     Series, real or imaginary
%      P     Array of periods, like [12.42,12.00,12.66], or tidal
%            names, like ['M2','S2','N2'], if Pawlowicz' file
%            t_constituents.mat (from T_TIDE package) is in path
%      OUT   Save (fid or filename)/show results [ {1} 0 <filename> ]
%      OPT    Fopen permissions [ 'w' ]
%
%   Output:
%      TIDESTRUC   Similar to T_TIDE output, is a structure to be used
%                  by t_predic (from T_TIDE)
%      XOUT        Reconstructed series C(i)*cos(2*pi*t/T(i)-pha(i))
%
%   Requirements:
%      When using imaginary series, ap2ep (Zhigang Xu) is required
%      to convert amplitudes and phase to ellipses parameters.
%      It is available at:
%      http://woodshole.er.usgs.gov/operations/sea-mat/
%      When using tidal names instead of periods, t_constituents.mat
%      (Rich Pawlowicz) must be in path. It is available at:
%      http://www2.ocgy.ubc.ca/~rich/
%
%   Example:
%      % f is real
%      t=0:24*10;
%      A1 = 1;    Phi1 = 30; T1 = 12;
%      A2 = 2;    Phi2 = 80; T2 = 12.42060;
%      A3 = 0.5;  Phi3 = 0;  T3 = 20;
%
%      y1 = A1*cos(2*pi*t/T1 - Phi1*pi/180);
%      y2 = A2*cos(2*pi*t/T2 - Phi2*pi/180);
%      y3 = A3*cos(2*pi*t/T3 - Phi3*pi/180);
%      y  = y1+y2+y3;
%
%      [tidestruc,xout]=lsf(t,y,[12 12.4]);
%      figure
%      subplot(2,1,1)
%      plot(t,y,t,xout,'r--');
%
%      [tidestruc,xout]=lsf(t,y,[12 12.4 20]);
%      subplot(2,1,2)
%      plot(t,y,t,xout,'r--');
%
%
%      % f is imag
%      t=0:24*30;
%      u=cos(2*pi*t/12-30*pi/180);
%      v=cos(2*pi*t/12);
%      f=u+sqrt(-1)*v;
%      [tidestruc,xout]=lsf(t,f,['M2';'S2']);
%      figure
%      subplot(2,1,1)
%      plot(t,real(f),t,real(xout),'r--'); title('u')
%      subplot(2,1,2)
%      plot(t,imag(f),t,imag(xout),'r--'); title('v')
%
%   MMA 31-7-2002, martinho@fis.ua.pt
%
%   See also FSA, NAME2FREQ

%   Department of Physics
%   University of Aveiro, Portugal

%   18-07-2003 - Deal imaginary series (ellipses)

tidestruc = [];
xout      = [];

if nargin < 5
  fopen_opt='w';
end
if nargin < 4
  output=1;
end
if nargin < 3
  error('## t, f and tide are needed ...');
end

if ~ isstr(tide)
   T=tide;
else
  for i=1:size(tide,1)
    T(i)=1/name2freq(tide(i,:),0);
    if isnan(T(i))
      return
    end
  end
end
w=1./T;
w=reshape(w,length(w),1);

if size(t)==1
  % consider t the interval
  t=t*[0:length(f)-1];
end

t=reshape(t,1,length(t));
f=reshape(f,1,length(f));
if ~isequal(length(t),length(f))
  error('# t and f must be vectors and have the same length');
  return
end

D1=0;
D2=0; % 2D!
if isreal(f)
  D1=1;
else
  D2=1;
  if ~exist('ap2ep','file')
    disp('# ap2ep (Zhigang Xu) is required for imaginary f')
    return
  end
end

%---------------------------------------------------------------------
% calc:
%---------------------------------------------------------------------
if D1
  % Least Squares Fit:
  [C,pha]=do_lsf(t,f,w);
  % xout:
  xout=do_xout(t,C,pha,T);
  % correlation:
  corr=corr_xy(f,xout);
  % tidestruc:
  tidestruc=gen_tidestruc(tide,w,C,pha,corr);
elseif D2
  % Least Squares Fit:
  fu=real(f);
  [Cu,phau]=do_lsf(t,fu,w);
  fv=imag(f);
  [Cv,phav]=do_lsf(t,fv,w);
  C=Cu+sqrt(-1)*Cv;
  pha=phau+sqrt(-1)*phav;
  % xout:
  xoutu=do_xout(t,Cu,phau,T);
  xoutv=do_xout(t,Cv,phav,T);
  xout=xoutu+sqrt(-1)*xoutv;
  % correlation:
  corru=corr_xy(fu,xoutu);
  corrv=corr_xy(fv,xoutv);
  corr=corru+sqrt(-1)*corrv;
  % tidestruc:
  tidestruc=gen_tidestruc(tide,w,C,pha,corr);
end

%---------------------------------------------------------------------
% display:
%---------------------------------------------------------------------
if ~isequal(output,0);
N=length(f);
interval=t(2)-t(1);
if isstr(output)
  fid=fopen(output,fopen_opt);
else
  fid=1;
end
fprintf(fid,'\n');
fprintf(fid,'=====================================================\n');
fprintf(fid,' Least Squares Fit Harmonic Analysis\n');
fprintf(fid,' Date: %s\n',datestr(now));
fprintf(fid,' Serie Length: %d\n',N);
fprintf(fid,' Interval: %2.2f h\n',interval);
fprintf(fid,' Days: %2.2f\n',(N-1)*interval/24);
fprintf(fid,'-------------------------------------------\n');
if D1
  fprintf(fid,'       Period    Amp      Pha\n');
  for j=1:length(T)
    if isempty(tidestruc.name)
      name='    ';
    else
      name=tidestruc.name(j,:);
    end
    fprintf(fid,'%0.4s %8.4f %8.4f %9.4f\n',name, T(j), C(j), pha(j));
  end
elseif D2
  [major,  ecc, inc, phase, w]=ap2ep(real(C), real(pha), imag(C), imag(pha));
  minor=major.*ecc;
  fprintf(fid,'       Period   major    minor    inc        pha\n');
  for j=1:length(T)
    if isempty(tidestruc.name)
      name='    ';
    else
      name=tidestruc.name(j,:);
    end
    fprintf(fid,'%0.4s %8.4f  %7.4f %8.4f %9.4f  %9.4f\n',name, T(j), major(j), minor(j), inc(j), phase(j));
  end
end
fprintf(fid,'\n');
fprintf(fid,' correlation: %s\n',num2str(corr));
fprintf(fid,'=====================================================\n');

end % display

%---------------------------------------------------------------------

function [C,pha]=do_lsf(t,x,w)
lx=length(x);
lw=length(w);
% init arrays:
G=repmat(nan,2*lw,lx);
a=repmat(nan,2*lw,2*lw);
b=repmat(nan,1,2*lw);
C=repmat(nan,1,lw);
pha=repmat(nan,1,lw);
for i=1:lw
  G(i*2-1,:)=cos(2*pi*w(i)*t);
  G(i*2,:)=sin(2*pi*w(i)*t);
end
for i=1:2*lw
 for j=1:2*lw
   a(i,j)=sum(G(j,:).*G(i,:));
 end
 b(i)=sum(x.*G(i,:));
end
X=b/a;
for i=1:lw
  C(i)=sqrt(X(2*i-1)^2+X(2*i)^2);
  B=X(2*i);
  A=X(2*i-1);
  pha(i)=atan3(B,A);
end


function teta=atan3(y,x)
%ATAN3   Inverse tangent [0:360[
%   Is the same as atan2(x,y)*180/pi, but with positive output.
%
%   Syntax:
%      TETA = ATAN3(Y,X)
%
%   Inputs:
%      Y, X   Same as in atan2
%
%   Output:
%      TETA   Angle (deg)
%
%   MMA 13-1-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

teta=atan2(y,x)*180/pi;
I=find(teta<0);
teta(I)=teta(I)+360;


function xout=do_xout(t,C,pha,T);
xout=zeros(size(t));
for i=1:length(T)
 xout=xout+C(i)*cos(2*pi*t/T(i)-pha(i)*pi/180);
end


function r=corr_xy(x,y)
%CORR_XY   Correlation coefficient between two series
%   Computes the correlation coefficient between two series.
%
%   Syntax:
%      R = CORR_XY(X,Y)
%
%   Inputs:
%      X, Y   Series
%
%   Output:
%      R   Correlation coefficient
%
%   Example:
%      x=cos(2*pi*[1:100]/12);
%      y=x+rand(size(x));
%      r=corr_xy(x,y)
%
%   MMA 2-4-2003, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

x=double(x);
y=double(y);
x=x-mean(x);
y=y-mean(y);
r=sum(sum(x.*y))/sqrt(sum(sum(x.*x))*sum(sum(y.*y)));


function tidestruc=gen_tidestruc(tide,w,C,pha,corr)
if isstr(tide)
  tidestruc.name=tide;
else
  tidestruc.name='';
end
tidestruc.freq=w;
tidestruc.corr=corr;
if isreal(C)
  tidecon=[ C;  C;  pha;  zeros(size(pha)) ]';
  tidestruc.tidecon=tidecon;
  tidestruc.C=C;
  tidestruc.pha=pha;
else
  Au=real(C);
  Av=imag(C);
  PHIu=real(pha);
  PHIv=imag(pha);
  [SEMA,  ECC, INC, PHA, w]=ap2ep(Au, PHIu, Av, PHIv);
  fmin=SEMA.*ECC;
  z=zeros(size(fmin));
  tidestruc.tidecon=[SEMA; SEMA; fmin; z; INC; z; PHA; z]';
end


function freq = name2freq(name,display)
%NAME2FREQ   Convert tidal name to frequency
%   This functions searches in the t_tide file t_constituents.mat
%   the tidal frequency for a given tidal constituent name.
%
%   Syntax:
%      FREQ = FREQ2NAME(FREQ,DISPLAY)
%
%   Inputs:
%      NAME      Tidal component name
%      DIAPLAY   Show results [ {0} | 1 ]
%
%   Output:
%      FREQ   Tidal component frequency
%
%   Comment:
%      T_tide file t_constituents.mat must be in path.
%      T_tide is a Rich Pawlowicz's Matlab toolbox available at
%      http://www2.ocgy.ubc.ca/~rich/
%
%   Example:
%      freq=name2freq('M2',1)
%
%   MMA 29-9-2002, martinho@fis.ua.pt
%
%   See also FREQ2NAME

%   Department of Physics
%   University of Aveiro, Portugal

freq = NaN;

if nargin == 1
    display=0;
end

if exist('t_constituents.mat') ~= 2
  disp(':: t_constituents.mat not found (can be found in t_tide package)');
  freq=NaN;
  return
else
  load t_constituents
end

NAME=const.name;
FREQ=const.freq;

L=min(length(name),4);

for i=1:length(FREQ)
  if strcmpi(NAME(i,1:L),name)
    ii=i;
  end
end

if exist('ii')
  freq=FREQ(ii);
else
  disp([':: tidal name ',name,' not found'])
end

if display
  T = 1/freq;
  disp(['# freq of ',name,' = ',sprintf('%13.10f',freq)]);
  disp(['# T of ',name,' = ',sprintf('%13.10f',T)]);
end
