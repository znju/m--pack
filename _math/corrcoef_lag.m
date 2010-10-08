function [correl,lag,pp]=corrcoef_lag(x,y)

N=length(x)*2-3;
correl = zeros(1,N);
lag    = zeros(1,N);
pp     = zeros(1,N);
n=0;
for i=2:length(x)
  [tmp,p]=corrcoef(x(end-i+1:end),y(1:i));
  n=n+1;
  correl(n) = tmp(1,2);
  lag(n)    = length(x)-i;
  pp(n)     = p(1,2);
end

for i=2:length(x)-1
  [tmp,p]=corrcoef(x(1:end-i+1),y(i:end));
  n=n+1;
  correl(n) = tmp(1,2);
  lag(n)    = -i+1;
  pp(n)     = p(1,2);
end
