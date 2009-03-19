function [Ind,d] = cyclic_index(time,t,cycle)
%CYCLIC_INDEX   Index arround value in periodic sequence
%
%   Syntax:
%      [I,D] = CYCLIC_INDEX(X,XI,CYCLE)
%
%   Inputs:
%      X   Sequence
%      XI   Value
%      CYCLE    Sequence period
%
%   Outputs:
%      I   Index of of X above and below XI
%      D   XI - X below, X above - XI
%
%   Example:
%     x=15:30:350;
%     xi=5;
%     cycle=365;
%     [i,d] = cyclic_index(x,xi,cycle); % i=[12 1], d=[25 10]
%
%   MMA 16-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

t=mod(t,cycle);
Inds=[length(time) 1:length(time) 1];
Time=[-(cycle-time(end)) time(:)' cycle+time(1)];

i2=find(Time>t);i2=i2(1); i1=i2-1;
I2=Inds(i2);
I1=Inds(i1);

d1=t-Time(i1);
d2=Time(i2)-t;

Ind=[I1 I2];
d  =[d1 d2];
