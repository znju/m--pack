function  tag=gentag(self,label)
%   GENTAG method for class slice
%   Creates tags for the several displayed objects

% MMA, martinho@fis.ua.pt
% 21-07-2005

out = get(self,'slice_info');
type    = out.type;
i       = out.ind;
t       = out.time;
varname = out.var;
dim     = out.dim;
is2d    = out.is2d;
is3d    = out.is3d;
isi     = out.isi;
isj     = out.isj;
ishoriz = out.ishoriz;

if isempty(i), i = 1; end % this can be done in subsref, but just in case...
if isempty(t), t = 1; end

h_contVals  = get(self,'bathy_cvals');
[tts,ttb,hc,N] = get(self,'scoord');

if nargin == 1
  label = '';
end

bottom    = get(self,'bottom_label');
zeta      = get(self,'zeta_label');
bathy     = get(self,'bathy_label');
bathyc    = get(self,'bathy_labelc');
mask      = get(self,'mask_label');
border    = get(self,'border_label');
cl        = get(self,'coastline_label');
theSlice  = get(self,'slice_label');
slice_cb  = get(self,'slice_labelcb');
labels    = get(self,'labels_label');
cbar      = get(self,'slice_colorbar_label');
fig       = get(self,'figure_label');
ax        = get(self,'axes_label');

switch label
  case {fig}
    tag = sprintf('label=%s',label);
  case {ax}
    % include dim, cos it is helpful in hold on/off, see runslice
    tag = sprintf('label=%s:dim=%s',label,dim);
  case {bottom}
    % bottom changes with ind and slice type
    tag = sprintf('label=%s:type=%s:ind=%g',label,type,i);
  case {zeta}
    % zeta changes with type, ind and time
    tag = sprintf('label=%s:type=%s:ind=%g:time=%g',label,type,i,t);
  case {bathy}
    % bathy does not change
    tag = sprintf('label=%s',label);
  case {bathyc}
    % bathy contours change with contour vals
    tag = sprintf('label=%s:vals=%s',label,num2str(h_contVals));
  case {mask}
    % mask changes with dim (if type not horiz) with i  and type if 2d
    if ~ishoriz
      tag = sprintf('label=%s:dim=%s',label,dim);
    elseif ishoriz
      tag = sprintf('label=%s',label);
    elseif is2d
      tag = sprintf('label=%s:type=%s:ind=%g',label,type,i);
    else
      tag = sprintf('label=%s',label);
    end
  case {border}
    % region border never changes
    tag = sprintf('label=%s',label);
  case {cl}
    tag = sprintf('label=%s',label);
  case {cbar}
    tag = sprintf('label=%s',label);

  case {theSlice}
    % let me think slice changes with i, t, variable, slice type and dim
    % (it may not change with i, like zeta, etc)
    % it may also change if changing scoord (dim shal be the last entry- this is used in showslice)
    tag = sprintf('label=%s:type=%s:ind=%g:time=%g:variable=%s:sparams=%g %g %g %g:dim=%s',label,type,i,t,varname,tts,ttb,hc,N,dim);
  case {slice_cb}
    tag = sprintf('label=%s',label);
  case {labels}
    % labels change with i, t and variable, and type
    tag = sprintf('label=%s:type=%s:ind=%g:time=%g:variable=%s',label,type,i,t,varname); 
  otherwise
    tag ='';
end
