function ll(wildcards)
%LL   List directory as the ls -l command on UNIX
%
%   Syntax:
%      LL(WILDCARDS)
%
%   Input:
%      WILDCARDS
%
%   Example:
%      ll ../*
%
%   MMA 2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 1
  wildcards ='';
end
if isequal(computer,'PCWIN')
  eval(['! dir ',wildcards])
else
  eval(['ls -l ',wildcards]);
end
