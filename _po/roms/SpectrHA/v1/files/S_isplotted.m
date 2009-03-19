function is=S_isplotted(varargin)
%function is=S_isplotted(varargin)
%controls what is in plot related with global variable ETC.plotted
%can be: "series", "ellipse", "fsa" or "LeastSquares"
%ex:is=S_isplotted('series','ellipse'); using Logical or
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global ETC

if nargin==0
  disp('"series", "ellipse", "fsa" or "LeastSquares"')
  is=[];
  disp(['# current plot is: ',ETC.plotted]);
  return
end

for i=1:length(varargin)
  is(i)=isequal(ETC.plotted,varargin{i});
end

is=any(is);

