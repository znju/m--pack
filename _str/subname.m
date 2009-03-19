function out = subname(str,lmax,add,where)
%SUBNAME   Get part of string
%   Truncates string at the beginning or end, adding an extra string.
%
%   Syntax:
%      OUT = SUBNAME(STR,LMAX,ADD,WHERE)
%
%   Inputs:
%      STR     Initial string
%      LMAX    Maximum length  of string [ 40 ]
%      ADD     String to add at the beginning [ '...' ]
%      WHERE   Insert ADD at the beginning or end [ {0} | 1 ]
%
%   Output:
%      OUT   Part of NAME or NAME  if length(NAME) <= LMAX,
%            with maximum length = LMAX
%
%    Examples:
%       str = '/home/user/filename.xpto'
%       subname(str,10);      % '...me/user'
%       subname(str,15,'+',1) % '/home/user/fil+'
%
%   MMA 31-5-2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   20-09-2005 - Added input argument WHERE

out = [];

if nargin < 4
  where = 0; % beginning
end
if nargin < 3
  add='...';
end
if nargin < 2
  lmax=40;
end
if nargin ==  0
  disp('# argument str is required...')
  return
end

l    = length(str);
ladd = length(add);

if l > lmax
  if where % at end
    str = [str(1:lmax-ladd),add];
  else
    str = [add,str(ladd+1:lmax)];
  end
end
out = str;
