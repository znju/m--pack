function T=synodic(names)
%SYNODIC   Synodic period of tidal components
%   Returns a matrice of sinodic periods for all pairs of
%   given tidal names, according to Rayleigh criterion.
%
%   Syntax:
%      S = SYNODIC(NAMES)
%
%   Input:
%      NAMES   Cell array of tidal names, by default is
%              {'m2','s2','n2','k2','k1','o1','p1','q1'}
%
%   Output:
%      S   Matrice NxN of periods (days)
%
%   Example:
%      s=synodic;
%
%   MMA 4-12-2006, martinho@fis.ua.pt
%
%   See also NAME2FREQ, GET_COMP

% Department of Physics
% University of Aveiro, Portugal

if nargin==0
  names={'m2','s2','n2','k2','k1','o1','p1','q1'};
end

for i=1:length(names)
  for j=1:length(names)
    t1=1/name2freq(names{i});
    t2=1/name2freq(names{j});

    if i==j
      T(i,j)=nan;
    else
      n=t1/(t1-t2);
      T(i,j)=n*t1/24;
    end
  end
end
T=abs(T);
