function r = rver
%RVER   Matlab release number
%   Returns the matlab release number (# from the version string R#).
%   For Releases with version R#, # is returned, for the case Ryyyx,
%   returned yyyy.n, where n is the character indice (for a is 1).
%
%   Examples:
%      % R14:
%      rever %--> 14
%      % R2006b
%      rver %--> 2006.2
%
%   MMA 27-9-2005, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   18-05-2007 - Deal with cases like R2006x

v=version;
ir=find(v=='R');
ie=find(v==')');
r=str2num(v(ir+1:ie-1));

if isempty(r)
  r=v(ir+1:ie-1);
  r=str2num(r(1:end-1))+ (double(r(end))-double('a')+1)/10;
end
