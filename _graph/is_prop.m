function res=isprop(handle,prop)
%ISPROP   Check handle property
%
%   Syntax:
%      RES = ISPROP(HANDLE,PROP)
%
%   Inputs:
%      HANDLE   Handle to check
%      PROP     Property to find
%
%   Output:
%      RES   0 or 1
%
%   Example:
%      p=plot(1:10);
%      res=isprop(p,'Color')
%
%   MMA 13-8-2003, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

res=0;
if ~ishandle(handle)
  return
end
s=get(handle);
if isfield(s,prop)
  res=1;
end
