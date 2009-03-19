function u=maf(v,w,type)
%MAF   Moving average filter
%   Produces centered or advanced filtered series.
%
%   Syntax:
%      V = MAF(VI,W,TYPE)
%
%   Inputs:
%      VI     Series to filter
%      W      Filter window
%      TYPE   The way filter is applied [ {'centered'} 'advanced' ]
%
%   Output:
%      V   Filtered series
%
%   Example:
%      t = 0:.1:4*pi;
%      v = sin(0:.1:4*pi)+rand(1,length(t));
%      w = [1 1 1 1 1];
%      u = maf(v,w);
%      plot(v); hold on
%      plot(u,'r')
%      u2 = maf(v,w,'advanced');
%      plot(u2,'g')
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also M_SMOOTH, SMOOTH_R

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 3
  type = 'centered';
end

b=length(w);
n=length(v);

v=reshape(v,1,n);
w=reshape(w,1,b);

if isequal(type,'centered')
  % then b must be odd
  if mod(b,2) ~= 1
    disp('## centered maf need odd W...');
    u=[];
    return
  end

  c=floor(b/2);
  for i=1:n
    v1 = max(1,i-c);
    v2 = min(n,i+c);

    i1 = c+1 -(i-v1);
    i2 = c+1 +(v2-i);

    W = w(i1:i2);
    V = v(v1:v2);
    C = 1/sum(W);
    u(i) = C*sum(W.*V);
  end
end

if isequal(type,'advanced')
  for i=1:n
    v1 = max(1,i-b+1);
    v2 = i;

    i1 = b-min(b,i)+1;

    W = w(i1:end);
    V = v(v1:v2);
    C = 1/sum(W);
    u(i) = C*sum(W.*V);
  end
end

types={'centered','advanced'};
if ~ismember(type,types)
  disp('## type not recognised...');
  u=[];
  return
end
