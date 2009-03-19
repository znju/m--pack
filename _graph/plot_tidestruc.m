function handles = plot_tidestruc(tidestruc,i,scale,pos,options,type);
%PLOT_TIDESTRUC   Plot ellipses from LSF or T_TIDE output
%
%   Syntax:
%      HANDLES = PLOT_TIDESTRUC(TIDESTRUC,I,SCALE,POS,OPTIONS)
%
%   Inputs:
%      TIDESTRUC   LSF and T_TIDE output
%      I           Ellipse (indice or name) to plot [ j i:k {<all available>} ]
%      SCALE       Scale to apply (in major and minor) [ 1 ]
%      POS         Center of ellipse [ <x y> <x y z> {<0 0>} ]
%      OPTIONS     Plot options [ 'b' ]
%      TYPE        Way phase is shown [ {1} 2 3 ]
%
%    Output:
%       HANDLES   Handles for plotted objects
%
%   Comment:
%      POS, OPTIONS and TYPE enter directly in function PLOT_ELLIPSE.
%      T_TIDE is a Rich Pawlowicz's Matlab toolbox available at
%      http://www2.ocgy.ubc.ca/~rich/
%
%   Examples:
%     tidestruc.tidecon=[2   0 -1 0 30 0  20  0;
%                        1.5 0  1 0 90 0 -20  0];
%     tidestruc.name=['M2';'S2'];
%     figure
%     subplot(2,2,1)
%     h=plot_tidestruc(tidestruc); axis equal
%     subplot(2,2,2)
%     hh=plot_tidestruc(tidestruc,2,2,[10 -10],'r',2); axis equal
%     subplot(2,2,3)
%     plot_tidestruc(tidestruc,1,1,[0 0],'k',3); axis equal
%     subplot(2,2,4)
%     plot_tidestruc(tidestruc,1,1,[0 0 10],'r',3);
%     hold on, axis equal
%     plot_tidestruc(tidestruc,2,1,[0 0 13],'b--',3);
%
%   MMA 17-2-2003, martinho@fis.ua.pt
%
%   See also LSF, PLOT_ELLIPSE

%   Department of physics
%   University of Aveiro

if nargin < 6
   type=1;
end
if nargin < 5
  options='b';
end
if nargin < 4
  pos=[0 0];
end
if nargin < 3
  scale=1;
end
if nargin < 2
  plot_all=1;
  i=[];
else
  plot_all=0;
end

major = tidestruc.tidecon(:,1);
minor = tidestruc.tidecon(:,3);
inc   = tidestruc.tidecon(:,5);
phase = tidestruc.tidecon(:,7);
if isfield(tidestruc,'name')
  name = tidestruc.name;
else
  name='';
end

if isempty(name) & ~isnumeric(i)
   warning('tidestruc.name is empty... use integer I')
end

ji=[];
je=[];
if plot_all
  ji=1;
  je=length(major);
else
  if isnumeric(i)
    if i <= length(major)
      ji=i(1);
      je=i(end);
    end
  elseif isstr(i)
    for n=1:size(name,1)
      if isequal(lower(i),lower(name(n,:)))
        ji=n;
        je=n;
        break
      end
    end
  end
end

if isempty(ji)
  return
end

h=ishold;
cont=0;
for j=ji:je
  cont=cont+1;
  handles(cont)=plot_ellipse(major(j)*scale,minor(j)*scale,inc(j),phase(j),pos,options,type);
  hold on
end

if h~=1
   hold off
end
