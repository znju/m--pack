function result = echoload(self,in)
%   ECHOLOAD method for class slice
%   RESULT = ECHOLOAD(OBJECT,NEWSTATUS)
%   Gives or sets the echo_load status(0/1) of the slice object

% MMA, martinho@fis.ua.pt
% 21-07-2005

result = self;

if nargin == 2
  if ismember(in,[0 1])
    result = set(self,'echo_load',in);
  else
    disp([':: ',mfilename,' : use 0 or 1']);
    return
  end
else
  result = get(self,'echo_load');
end
