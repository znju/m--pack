function result = getfromtag(self,tag,what)
%   GETFROMTAG method for class slice
%   Gives info from figure objects tag

% MMA, martinho@fis.ua.pt
% 21-07-2005

result = [];

if nargin < 3
  disp(':: missing arguments');
  return
end

i = findstr(tag,[':',what,'=']);
if isempty(i)
  return
else
  is=i(1)+1 + length(what)+1;
end

subtag = tag(i+1:end);
i = findstr(subtag,':');
if isempty(i)
  ie = length(tag);
else
  ie = i-1 + length(tag)-length(subtag);
end

evalc('result = tag(is:ie);','result=[];');
if isnumber(str2num(result))
  result = str2num(result);
end
