function [T,Tpos,Tneg,t,tpos,tneg] = calc_transp(dx,dz,v)
%CALC_TRANSP   Transport across area
%
%   Syntax:
%      [T,TPOS,TNEG,T2,TPOS2,TNEG2] = CALC_TRANSP(DX,DZ,V)
%
%   Inputs:
%      DX,DZ   Distances, Ai=DXi*DZi
%      V       Speed of currents across area
%
%   Outputs:
%      T,TPOS,TNEG   Total, total positive and total negative transport
%      T2,TPOS2,TNEG2   Transports for each area, if DX,DZ and V are
%                       1,2-D arrays, ie, T=sum(T2(:)), ...
%
%   MMA 06-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

A=dz.*dx;

vpos=v;
vneg=v;
vpos(vpos<0)=0;
vneg(vneg>0)=0;

t    = A.*v;
tpos = A.*vpos;
tneg = A.*vneg;

t(isnan(t))       = 0;
tpos(isnan(tpos)) = 0;
tneg(isnan(tneg)) = 0;

T    = sum(t(:));
Tpos = sum(tpos(:));
Tneg = sum(tneg(:));

% keep NaNs in t:
m=double(~isnan(v));
t(isnan(v))=nan;
tpos(isnan(v))=nan;
tneg(isnan(v))=nan;
