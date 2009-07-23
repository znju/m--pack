function [I,J,W]=interp_coefs(lon1,lat1,lon2,lat2,txt)

if nargin < 5
  txt='...';
end

%pcolor(lon1,lat1,nan*lon1)
%hold on
%plot(lon1(1,1),lat1(1,1),'r*')
%
%plot(lon2,lat2,'.')


[i,j]=find_nearest(lon1,lat1,min(lon2(:)), min(lat2(:)));
[k,l]=find_nearest(lon1,lat1,max(lon2(:)), max(lat2(:)));

%plot(lon1(i,j),lat1(i,j),'r*')
%plot(lon1(k,l),lat1(k,l),'k*')

[A,B]=size(lon1);
I=min(i,k); K=max(i,k);
J=min(j,l); L=max(j,l);

I=max(1,I-1);
J=max(1,J-1);
K=min(A,K+1);
L=min(B,L+1);

lon1=lon1(I:K,J:L);
lat1=lat1(I:K,J:L);
[A,B]=size(lon1);
I0=I;
J0=J;

%figure
%pcolor(lon1,lat1,nan*lon1)
%hold on

%plot(lon2,lat2,'.')

[eta,xi]=size(lon2);
I=zeros([4,eta,xi]);
J=zeros([4,eta,xi]);
W=zeros([4,eta,xi]);
c=progress('init',['processing interp coefs ' txt]);
for j=1:eta
  c=progress(c,j/eta);
  for i=1:xi
    found=0;

    for a=1:A-1
      for b=1:B-1
        x=[lon1(a,b) lon1(a,b+1) lon1(a+1,b+1) lon1(a+1,b)];
        y=[lat1(a,b) lat1(a,b+1) lat1(a+1,b+1) lat1(a+1,b)];
        if inpolygon(lon2(j,i),lat2(j,i),x,y)
%x
%y
          found=1;
          I(:,j,i)=[a a a+1 a+1];
          J(:,j,i)=[b b+1 b+1 b];
          W(1,j,i)=( lon1(a+1,b+1)-lon2(j,i))*( lat1(a+1,b+1)-lat2(j,i));
          W(2,j,i)=(-lon1(a+1,b)  +lon2(j,i))*( lat1(a+1,b)  -lat2(j,i));
          W(3,j,i)=(-lon1(a,b)    +lon2(j,i))*(-lat1(a,b)    +lat2(j,i));
          W(4,j,i)=( lon1(a,b+1)  -lon2(j,i))*(-lat1(a,b+1)  +lat2(j,i));

%          plot(x,y,'r-x')
%          plot(lon2(j,i),lat2(j,i),'ro')
%          W(:,j,i), pause
          break
        end
      end
      if found, break; end
    end

  end
end

I=I+I0-1;
J=J+J0-1;
W=abs(W);

