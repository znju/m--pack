function D=hycom_densp(f,month)

if nargin<2
  ntimes=n_dim(f,'month');
  for t=1:ntimes
    fprintf(1,'calc densp time=%d of %d\n',t,ntimes)
    T = use(f,'temp','month',t);
    S = use(f,'salt','month',t);
    if t==1
      D=zeros([ntimes size(T)]);
    end
    d = sw_dens0(S,T); d=d-1000;
    D(t,:,:,:)=d;
  end

else
  T = use(f,'temp','month',month);
  S = use(f,'salt','month',month);
  D = sw_dens0(S,T); D=D-1000;
end
