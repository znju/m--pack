function handle = auto_color(axis,handle)
%AUTO_COLOR   Set different colors to axis handles
%
%   Syntax:
%      HANDLE = AUTO_COLOR(AXIS,HANDLE)
%
%   Inputs:
%      AXIS     Object's axis [ <current> ]
%      HANDLE   Object's handle [ <all but the first> ]
%
%   Output:
%      HANDLE   Object's handle or affected handles if input argument
%               handle is not specified
%   Example:
%      h1=plot(1:10); hold on
%      plot(2:15,'r*')
%      pcolor(rand(3))
%      h=auto_color;
%      h=auto_color(gca,h1);
%
%   MMA 2003, martinho@fis.ua.pt
%
%   See also ISPROP

%   Department of physics
%   University of Aveiro

if nargin == 0
    axis=gca;
end
H=get(axis,'children');
if length(H) > 1
  if nargin ~= 2
    handle=H(1:end-1);
  end
else
    return
end

bg=get(axis,'Color');
if isprop(H(1),'Color')
  c1=get(H(1),'Color');
else
  c1=bg;
end

obj=[];
cont=0;
for i=1:length(handle)
  if isprop(handle(i),'Color')
    cont=cont+1;
    obj(cont)=handle(i);
    again=1;
    while again
      c=rand(1,3);
      if (any(abs(c-c1) > .7) | abs(c-c1) > .4 ) & (any(abs(c-bg) > .7) | abs(c-bg) > .4 )
        set(handle(i),'color',c);
        again=0;
      end
    end
  end
end

handle=obj;

function res=isprop(handle,prop)
res=0;
if ~ishandle(handle)
  return
end
s=get(handle);
if isfield(s,prop)
  res=1;
end
